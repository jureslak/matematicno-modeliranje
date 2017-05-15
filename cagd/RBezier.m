classdef RBezier
    properties
        B % control points
        n % n+1 control points
        d % dimension
        w % weights
    end
    methods
        function obj = RBezier(B, w)
            % B = seznam koordinat kontrolnih tock, vrstice so tocke
            assert(ismatrix(B), 'B is not a matrix!');
            assert(isvector(w), 'w is not a vector!');
            obj.B = B;
            [obj.n, obj.d] = size(B);
            obj.n = obj.n - 1;
            assert(length(w) == obj.n + 1, 'Length of w must be %d, got %d.', obj.n+1, length(w));
            if ~iscolumn(w), w = w'; end
            obj.w = w;
        end
        function b = decastejau(self, t)
            % t = value of parameter
            % dim = for which coordinate to create the scheme
            assert(isscalar(t), 't must be a scalar.')
            D = self.B;
            weights = self.w;
            for i = 1:self.n+1
                for j = 1:self.n-i+1
                    nw = (1-t)*weights(j) + t*weights(j+1);
                    D(j, :) = (1-t)*weights(j) /nw * D(j, :) + ...
                              t*weights(j+1) / nw * D(j+1, :);
                    weights(j) = nw;
                end
            end
            b = D(1, :);
        end
        function b = val(self, t)
            % t = vector of values for parameter
            assert(nargin == 2, 'Supply values for patameter t.');
            assert(isvector(t), 't must be a vector.');
            p = length(t);
            b = zeros(p, self.d);
            for j = 1:p
                b(j, :) = self.decastejau(t(j));
            end
        end
        function plot(self, npts)
            % plots bezier curve using n equally spaced points
            if nargin < 2, npts = 100; end
            assert(npts >= 2, 'Not enough points to plot the curve.');
            assert(self.d <= 3, 'Visulazation of curves with dimensions >=4 is left as an exrcise for the user.');
            t = linspace(0, 1, npts);
            b = self.val(t);
            q = self.farin();
            hold on
            if self.d == 1
                plot(t, b);
                plot(0:1/(length(self.B)-1):1, self.B, 'ko-')
                plot(q(:, 1), q(:, 2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4)
            elseif self.d == 2
                plot(b(:, 1), b(:, 2))
                plot(self.B(:, 1), self.B(:, 2), 'ko-')
                plot(q(:, 1), q(:, 2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4)
            elseif self.d == 3
                plot3(b(:,1), b(:, 2), b(:, 3))
                plot3(self.B(:,1), self.B(:,2), self.B(:,3), 'ko-')
                plot3(q(:, 1), q(:, 2), q(:, 3), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4)
                axis vis3d
                view(3)
            end
        end
        function q = farin(self)
            % computes the farin points on the control polygon
            q = zeros(self.n, self.d);
            for i = 1:self.n
                q(i, :) = self.w(i) / (self.w(i+1) + self.w(i)) * self.B(i, :) + ...
                          self.w(i+1) / (self.w(i+1) + self.w(i)) * self.B(i+1, :);
            end
        end
        function BE = elevate(self, k)
            % elevate degree by k
            if nargin < 2, k = 1; end
            assert(k == floor(k), 'k must be an integer, got %s.', k);
            assert(k >= 0, 'k must be nonnegative, got %d.', k);
            BE = self.lift().elevate(k).proj();
        end
        function BL = lift(self)
            % Represent this curve as a polynomial curve in
            % higherdimensional space
            BL = Bezier([bsxfun(@times,self.B,self.w) self.w]);
        end
    end
end
