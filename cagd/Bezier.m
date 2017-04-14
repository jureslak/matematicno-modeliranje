classdef Bezier
    properties
        B
        n
        d
    end
    methods
        function obj = Bezier(B)
            % B = seznam koordinat kontrolnih tock, vrstice so tocke
            assert(ismatrix(B), 'B is not a matrix!');
            obj.B = B;
            [obj.n, obj.d] = size(B);
            obj.n = obj.n - 1;
        end
        function D = decastejau(self, t, dim)
            % t = value of parameter
            % dim = for which coordinate to create the scheme
            assert(1 <= dim && dim <= self.d, 'dim must be between 1 and %d, got %d.', self.d, dim);
            assert(isscalar(t), 't must be a scalar.')
            D = zeros(self.n, self.n+1);
            for j = 1:self.n+1
                D(j, 1) = self.B(j, dim);
            end
            for i = 2:self.n+1
                for j = 1:self.n-i+2
                    D(j, i) = (1-t)*D(j, i-1) + t*D(j+1, i-1);
                end
            end
        end
        function b = val(self, t)
            % t = vector of values for parameter
            assert(nargin == 2, 'Supply values for patameter t.');
            assert(isvector(t), 't must be a vector.');
            p = length(t);
            b = zeros(p, self.d);
            for j = 1:p
                for i = 1:self.d
                    D = self.decastejau(t(j), i);
                    b(j, i) = D(1, self.n+1);
                end
            end
        end
        function bd = der(self, t, r)
            % returns values of r-th derivatives at times t
            if nargin < 3, r = 1; end
            assert(nargin >= 2, 'Supply values for parameter t.');
            assert(r == floor(r), 'r must be an integer, got %s.', r);
            assert(r >= 0, 'r must be in [0, inf), got %d.', r);
            p = length(t);
            bd = zeros(length(t), self.d);
            if r > self.n, return, end
            for i = 1:p
                bd(i,:) = self.dersingle(t(i), r);
            end
        end
        function bdc = dercontrol(self, r)
            % returns control points fot r-th derivative of a curve
            if nargin < 2, r = 1; end
            assert(r == floor(r), 'r must be an integer, got %s.', r);
            assert(r >= 0, 'r must be in [0, inf), got %d.', r);
            if r > self.n, bdc = []; return, end
            bdc = self.facdiff(self.B, r, self.n);
        end
        function spline = subdivide(self, t, k)
            % returns a spline for 2^k parts of t:(1-t) division
            if nargin < 3, k = 1; end
            assert(isscalar(t), 't must be scalar.');
            assert(0 <= t && t <= 1, 't must be in [0, 1], got %f.', t);
            assert(k == floor(k), 'k must be an integer, got %s.', k);
            assert(k >= 0, 'k must be nonnegative, got %d.', k);
            curvelist = cell(1, 1);
            curvelist{1} = self.B;
            for level = 1:k
                curvelist_new = cell(2^level, 1);
                for j = 1:2^(level-1)
                    left = zeros(self.n+1, self.d);
                    right = zeros(self.n+1, self.d);
                    Subd = Bezier(curvelist{j});
                    for i = 1:self.d
                        D = Subd.decastejau(t, i);
                        left(:, i) = D(1, :);
                        right(:, i) = D(end-self.n:-self.n:self.n-1);
                    end
                    curvelist_new{2*j-1} = left;
                    curvelist_new{2*j} = right;
                end
                curvelist = curvelist_new;
            end
            spline = Spline(curvelist);
        end
        function BE = elevate(self, k)
            % elevate degree by k
            if nargin < 2, k = 1; end
            assert(k == floor(k), 'k must be an integer, got %s.', k);
            assert(k >= 0, 'k must be nonnegative, got %d.', k);
            Be = self.B;
            for i = 1:k
                Be_new = zeros(self.n+i+1, self.d);
                Be_new(1, :) = Be(1, :);
                Be_new(self.n+i+1, :) = Be(self.n+i, :);
                for j = 1:self.n+i-1
                    Be_new(j+1,:) = (1-j/(self.n+i)) * Be(j+1, :) + j/(self.n+i) * Be(j, :);
                end
                Be = Be_new;
            end
            BE = Bezier(Be);
        end
        function plot(self, npts)
            % plots bezier curve using n equally spaced points
            if nargin < 2, npts = 100; end
            assert(npts >= 2, 'Not enough points to plot the curve.');
            assert(self.d <= 3, 'Visulazation of curves with dimensions >=4 is left as an exrcise for the user.');
            t = linspace(0, 1, npts);
            b = self.val(t);
            hold on
            if self.d == 1
                plot(t, b);
                plot(0:1/(length(self.B)-1):1, self.B, 'ko-')
            elseif self.d == 2
                plot(b(:,1), b(:,2))
                plot(self.B(:,1), self.B(:,2), 'ko-')
            elseif self.d == 3
                plot3(b(:,1), b(:, 2), b(:, 3))
                plot3(self.B(:,1), self.B(:,2), self.B(:,3), 'ko-')
                axis vis3d
                view(3)
            end
        end
        function plotwithder(self, npts, nder)
            % plots bezier curve with derivative
            if nargin < 3, nder = 20; end
            if nargin < 2, npts = 100; end
            assert(npts >= 2, 'Not enough points to plot the curve, got %d.', npts);
            assert(self.d <= 3, 'Visulazation of curves with dimensions >=4 is left as an exrcise for the user.');
            t = linspace(0, 1, npts);
            tder = linspace(0, 1, nder);
            b = self.val(t);
            dB = Bezier(self.dercontrol());
            bder = self.val(tder);
            derval = dB.val(tder);
            hold on
            if self.d == 1
                plot(t, b);
                plot(0:1/(length(self.B)-1):1, self.B, 'ro-')
                quiver(tder', bder, ones(size(derval)), derval, 'k')
            elseif self.d == 2
                plot(b(:,1), b(:,2))
                plot(self.B(:,1), self.B(:,2), 'ro-')
                quiver(bder(:, 1), bder(:, 2), derval(:, 1), derval(:, 2), 'k')
            elseif self.d == 3
                plot3(b(:,1), b(:,2), b(:, 3))
                plot3(self.B(:, 1), self.B(:, 2), self.B(:, 3), 'ro-')
                quiver3(bder(:, 1), bder(:, 2), bder(:, 3), derval(:, 1), derval(:, 2), derval(:, 3), 'k')
            end
        end
        function BP  = proj(self)
            % project self into one dimension less and return a rational
            % bezier curve
            assert(self.d >= 1, 'Cannot project a 1D curve.');
            w = self.B(:, end);
            BP = RBezier(bsxfun(@rdivide, self.B(:, 1:end-1), w), w);
        end
    end
    methods(Access=private)
        function bd = dersingle(self, t, r)
            % returns the r-th derivative at a time t
            bd = zeros(self.d, 1);
            for dim = 1:self.d
                D = self.decastejau(t, dim);
                bd(dim) = self.facdiff(D(1:r+1, self.n+1-r), r, self.n);
            end
        end
    end
    methods(Access=private,Static)
        function A = facdiff(M, r, n)
            % returns the r-th finite difference of M multiplied by n! / (n-r)!
            A = M;
            for i = n-r+1:n
                A = i * diff(A);
            end
        end
    end
end
