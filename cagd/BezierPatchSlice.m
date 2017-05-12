classdef BezierPatchSlice
    properties
        B
        n
    end
    
    methods
        function obj = BezierPatchSlice(B)
            % n+1 x n+1 matrika katere koeficinet na mestu (i, j),
            % j <= n+2-i, doloca koeficient polinoma z indeksom
            % (n+2-i-j, j-1, i-1)
            [q, m] = size(B);
            assert(q == m, 'Matrix B must be square')
            obj.n = q - 1;
            obj.B = B;
        end
        function b = decastejau(self, u)
            % returns value of polynomial given by B at point u
            assert(length(u) == 3, 'Only in 3D.');
            assert(abs(sum(u) - 1) < eps, 'Coordinates must be barycentric.');
            C = self.B;
            for r = 1:self.n
                for i = 1:self.n-r+1
                    for j = 1:self.n-i+1
                        C(i, j) = u(1) * C(i, j) + u(2) * C(i, j+1) + u(3) * C(i+1, j);
                    end
                end
            end
            b = C(1, 1);
        end
        function b = blossom(self, u)
            [q, d] = size(u);
            assert(d == 3, 'Only in 3D.');
            % assert(norm(sum(u, 2) - ones(q, 1)) < eps, 'Coordinates must be barycentric.');
            assert(q == self.n, 'Blossom must have n point parameters.');
            C = self.B;
            for r = 1:self.n
                for i = 1:self.n-r+1
                    for j = 1:self.n-i+1
                        C(i, j) = u(r, 1) * C(i, j) + u(r, 2) * C(i, j+1) + u(r, 3) * C(i+1, j);
                    end
                end
            end
            b = C(1, 1);
        end
        function b = der(self, u, dir, r)
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
            U = [dir; repmat(u, self.n-r, 1)];
            b = factorial(self.n) / factorial(self.n-r) * self.blossom(U);
        end
    end
end

