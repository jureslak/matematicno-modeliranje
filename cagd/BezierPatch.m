classdef BezierPatch
    properties
        Bx
        By
        Bz
        n
    end
    
    methods
        function obj = BezierPatch(Bx, By, Bz)
            % B = seznam koordinat po tockah
            assert(ismatrix(Bx), 'Bx is not a matrix!');
            assert(ismatrix(By), 'By is not a matrix!');
            assert(ismatrix(Bz), 'Bz is not a matrix!');
            obj.Bx = Bx;
            [obj.n, m] = size(Bx);
            assert(obj.n == m, 'Matrix must be square');
            [ay, by] = size(By);
            assert(ay == obj.n, 'By not of compatible size with Bx.');
            assert(by == obj.n, 'By not of compatible size with Bx.');
            obj.By = By;
            [az, bz] = size(Bz);
            assert(az == obj.n, 'Bz not of compatible size with Bx.');
            assert(bz == obj.n, 'Bz not of compatible size with Bx.');
            obj.Bz = Bz;
            obj.n = obj.n - 1;
        end
    
        function b = val(self, u)
            % U barycentric coordinates of points
            [q, d] = size(u);
            assert(d == 3, 'Only in 3D.');
            assert(norm(sum(u, 2) - ones(q, 1)) < 1e-15, 'Coordinates must be barycentric, error = %g.', norm(sum(u, 2) - ones(q, 1)));
            N = size(u, 1);
            b = zeros(N, 3);
            for i = 1:N
                b(i, 1) = self.decastejau(self.Bx, u(i, :));
                b(i, 2) = self.decastejau(self.By, u(i, :));
                b(i, 3) = self.decastejau(self.Bz, u(i, :));
            end
        end
        
        function plot(self, d)
            % d = density of the mesh in one dimension
            if nargin < 2, d = 20; end
            [~, frame] = self.uniform_mesh(self.n);
            bx = self.flatten(self.Bx);
            by = self.flatten(self.By);
            bz = self.flatten(self.Bz);
            hold on
            trimesh(frame, bx, by, bz, 'FaceColor', 'none', 'EdgeColor', 'k');
            
            [U, T] = self.uniform_mesh(d);
            vals = self.val(U);
            
            trisurf(T, vals(:, 1), vals(:, 2), vals(:, 3));
        end
    end
    
    methods(Static)
        function b = decastejau(B, u)
            % returns value of polynomial given by B at point u
            [n, m] = size(B);
            assert(n == m, 'B must be square, got %d x %d.', n, m);
            n = n - 1;
            assert(length(u) == 3, 'Only in 3D.');
            assert(abs(sum(u) - 1) < 1e-15, 'Coordinates must be barycentric, error = %g', abs(sum(u) - 1));
            for r = 1:n
                for i = 1:n-r+1
                    for j = 1:n-i+1
                        B(i, j) = u(1) * B(i, j) + u(2) * B(i, j+1) + u(3) * B(i+1, j);
                    end
                end
            end
            b = B(1, 1);
        end
        function b = blossom(B, u)
            [n, m] = size(B);
            assert(n == m, 'B must be square, got %d x %d.', n, m);
            n = n - 1;
            [q, d] = size(u);
            assert(d == 3, 'Only in 3D.');
            % assert(norm(sum(u, 2) - ones(q, 1)) < eps, 'Coordinates must be barycentric.');
            assert(q == self.n, 'Blossom must have n point parameters.');
            for r = 1:n
                for i = 1:n-r+1
                    for j = 1:n-i+1
                        B(i, j) = u(r, 1) * B(i, j) + u(r, 2) * B(i, j+1) + u(r, 3) * B(i+1, j);
                    end
                end
            end
            b = B(1, 1);
        end
        function b = der(B, u, dir, r)
            % Returns derivative of B at point u.
            [n, m] = size(B);
            assert(n == m, 'B must be square, got %d x %d.', n, m);
            n = n - 1;
            if nargin < 4, r = 1; end
            assert(r == floor(r), 'r must be an integer, got %s.', r);
            assert(r >= 0, 'r must be in [0, inf), got %d.', r);
            if r > self.n, b = 0; return; end
            assert(length(u) == 3, 'Point has %d components, expected %d.', length(u), 3);
            assert(abs(sum(u) - 1) < eps, 'Point coordinates must be barycentric.');
            [p, q] = size(dir);
            assert(q == 3, 'Only in 3D.');
            assert(norm(sum(dir, 2)) < eps, 'Vector coordinates must be barycentric.');
            assert(p == r, 'Number of directions (%d) must be equal to degree of the derivative (%d).', p, r);
            U = [dir; repmat(u, n-r, 1)];
            b = factorial(n) / factorial(n-r) * self.blossom(B, U);
        end
        function [U, T] = uniform_mesh(d)
            % Returns uniform triangle grid on n points.
            % 1  2  3  4
            % 5  6  7
            % 8  9
            % 10
            N = d*(d+1)/2;
            U = zeros(N, 3);
            T = zeros(d*d, 3);
            t = 1;
            c = 1;
            for i = 0:d
                for j = 0:(d-i)
                    k = d - i - j;
                    U(c, :) = [k/d, j/d, i/d];
                    if 0 < i
                        T(t, :) = [c-d+i-2 c-d+i-1 c];
                        t = t + 1;
                        if j < d-i
                            T(t, :) = [c-d+i-1 c c+1];
                            t = t + 1;
                        end
                    end
                    c = c + 1;
                end
            end
        end
        function f = flatten(s)
            f = reshape(s, [numel(s), 1]);
            f(isnan(f)) = [];
        end
    end
end

