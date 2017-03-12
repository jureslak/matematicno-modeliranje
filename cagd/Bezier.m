classdef Bezier
    properties
        B
        n
        d
    end
    methods
        function obj = Bezier(B)
            % B = seznam koordinat kontrolnih tock, vrstice so tocke
            if ~ismatrix(B), error('B is not a matrix!'), end
            obj.B = B;
            [obj.n, obj.d] = size(B);          
            obj.n = obj.n - 1;
        end
        function D = decastejau(self, t, dim)
            % t = value of parameter
            % dim = for which coordinate to create the scheme
            if dim < 0 || dim > self.d, error('dim must be between 1 and %d.', self.d), end
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
            if nargin < 2, error('Supply values for patameter t.'), end
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
            if nargin < 2, error('Supply values for patameter t.'), end
            if r < 0, error('r must be integer in [0, inf)'), end
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
            if r > self.n, bdc = []; return, end
            bdc = self.facdiff(self.B, r, self.n);
        end
        function plot(self, npts)
            % plots bezier curve using n equally spaced points
            if nargin < 2, npts = 100; end
            if npts < 2, error('Not enough points to plot the curve.'), end
            t = linspace(0, 1, npts);
            b = self.val(t);
            hold on
            if self.d == 1
                plot(t, b);
                plot(0:1/(length(self.B)-1):1, self.B, 'ro-')
            elseif self.d == 2
                plot(b(:,1), b(:,2))
                plot(self.B(:,1), self.B(:,2), 'ro-')
            elseif self.d == 3
                plot3(b(:,1), b(:, 2), b(:, 3))
                plot3(self.B(:,1), self.B(:,2), self.B(:,3), 'ro-')
            end
        end
        function plotwithder(self, npts, nder)
            % plots bezier curve using n equally spaced points
            if nargin < 3, nder = 20; end
            if nargin < 2, npts = 100; end
            if npts < 2, error('Not enough points to plot the curve.'), end
            if self.d ~= 2, error('Only for 2D.'), end
            t = linspace(0, 1, npts);
            tder = linspace(0, 1, nder);
            b = self.val(t);
            dB = Bezier(self.dercontrol());
            bder = self.val(tder);
            derval = dB.val(tder);
            plot(b(:,1), b(:,2))
            plot(self.B(:,1), self.B(:,2), 'ro-')
            quiver(bder(:, 1), bder(:, 2), derval(:, 1), derval(:, 2), 'k');
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
    methods(Static)
        function A = facdiff(M, r, n)
            % returns the r-th finite difference of M multiplied by n! / (n-r)!
            A = M;
            for i = n-r+1:n
                A = i * diff(A);
            end
        end
    end
end