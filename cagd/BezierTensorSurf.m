classdef BezierTensorSurf
    % Represents bezier tensor surface.
    properties
        Bx
        By
        Bz
        m
        n
    end

    methods
        function obj = BezierTensorSurf(Bx, By, Bz)
            % B = seznam koordinat po tockah
            assert(ismatrix(Bx), 'Bx is not a matrix!');
            assert(ismatrix(By), 'By is not a matrix!');
            assert(ismatrix(Bz), 'Bz is not a matrix!');
            obj.Bx = Bx;
            [obj.n, obj.m] = size(Bx);
            [ay, by] = size(By);
            assert(ay == obj.n, 'By not of compatible size with Bx.');
            assert(by == obj.m, 'By not of compatible size with Bx.');
            obj.By = By;
            [az, bz] = size(Bz);
            assert(az == obj.n, 'Bz not of compatible size with Bx.');
            assert(bz == obj.m, 'Bz not of compatible size with Bx.');
            obj.Bz = Bz;
            obj.n = obj.n - 1;
            obj.m = obj.m - 1;
        end
        function [bx, by, bz] = val(self, u, v)
            assert(nargin == 3, 'Supply values for patameters u and v.');
            assert(isvector(u), 'u must be a vector.');
            assert(isvector(v), 'v must be a vector.');
            if nargout < 3, error('There are 3 output args.'), end
            M = length(u);
            N = length(v);
            bx = zeros(N, M);
            by = zeros(N, M);
            bz = zeros(N, M);
            for vj = 1:N
                % fiksen v s kontrolnimi tockami kont
                V = v(vj);
                kont = zeros(self.m+1,  3);
                for i = 1:self.m+1
                    B = Bezier([self.Bx(:, i) self.By(:, i) self.Bz(:, i)]);
                    kont(i, :) = B.val(V);
                end
                B = Bezier(kont);
                vals = B.val(u);
                bx(vj, :) = vals(:, 1);
                by(vj, :) = vals(:, 2);
                bz(vj, :) = vals(:, 3);
            end
        end
        function plot(self, nu, nv)
             % plots bezier surface using n^2 equally spaced points
            if nargin == 2, nv = nu; end
            if nargin < 3,  nu = 50; nv = 50; end
            assert(nu >= 2, 'Not enough points in u direction to plot the curve.');
            assert(nv >= 2, 'Not enough points in v direction to plot the curve.');
            u = linspace(0, 1, nu);
            v = linspace(0, 1, nv);
            hold on
%             c = mesh(self.Bx, self.By, self.Bz);
%             set(c, 'FaceColor', 'none')
%             set(c, 'EdgeColor', 'k')
            [X, Y, Z] = self.val(u, v);
            surf(X, Y, Z)
        end
    end
    methods(Static)
        function BS = LSQ(m, n, P, u, v)
            % approximates points P at parameters u, v with a Bezier
            % surface of degreee m in u and n in v
            [K, d] = size(P);
            assert(d == 3, 'Only in 3D, got %d', d);
            assert(isvector(u), 'u must be a vector.');
            assert(isvector(v), 'v must be a vector.');
            assert(length(u) == K, 'u must be a vector of length %d, got %d.', K, length(u));
            assert(length(v) == K, 'v must be a vector of length %d, got %d.', K, length(v));
            assert(m <= K, 'Degree in u direction must be less than number of points, got m = %d, K = %d', m, K);
            assert(n <= K, 'Degree in u direction must be less than number of points, got m = %d, K = %d', n, K);

            M = zeros(K, (m+1)*(n+1));
            % polnimo po stolpcih
            for i = 1:m+1
                for j = 1:n+1
                    ku = zeros(m+1, 1); ku(i) = 1;
                    kv = zeros(n+1, 1); kv(j) = 1;
                    bu = Bezier(ku).val(u);
                    bv = Bezier(kv).val(v);
                    M(:, (i-1)*(n+1) + j) = bu .* bv;
                end
            end
            Bx = M \ P(:, 1);
            By = M \ P(:, 2);
            Bz = M \ P(:, 3);

            Bx = reshape(Bx, [n+1, m+1]);
            By = reshape(By, [n+1, m+1]);
            Bz = reshape(Bz, [n+1, m+1]);
            BS = BezierTensorSurf(Bx, By, Bz);
        end
    end
end

