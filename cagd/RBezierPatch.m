classdef RBezierPatch
    % Represents a rational bezier patch.
    
    properties
        Bx
        By
        Bz
        n
        W  % weight matrix
    end
    
    methods
        function obj = RBezierPatch(Bx, By, Bz, W)
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
            [aw, bw] = size(W);
            assert(aw == obj.n, 'Bz not of compatible size with Bx.');
            assert(bw == obj.n, 'Bz not of compatible size with Bx.');
            obj.W = W;
            obj.n = obj.n - 1;
        end
    
        function b = val(self, u)
            % U barycentric coordinates of points
            [q, d] = size(u);
            assert(d == 3, 'Only in 3D.');
            assert(norm(sum(u, 2) - ones(q, 1)) < 1e-14, 'Coordinates must be barycentric, error = %g.', norm(sum(u, 2) - ones(q, 1)));
            N = size(u, 1);
            b = zeros(N, 3);
            for i = 1:N
                b(i, 1) = BezierPatch.decastejau(self.Bx.*self.W, u(i, :));
                b(i, 2) = BezierPatch.decastejau(self.By.*self.W, u(i, :));
                b(i, 3) = BezierPatch.decastejau(self.Bz.*self.W, u(i, :));
                b(i, :) = b(i, :) / BezierPatch.decastejau(self.W, u(i, :));
            end
        end
        
        function plot(self, d)
            % d = density of the mesh in one dimension
            if nargin < 2, d = 20; end
            [~, frame] = BezierPatch.uniform_mesh(self.n);
            bx = BezierPatch.flatten(self.Bx);
            by = BezierPatch.flatten(self.By);
            bz = BezierPatch.flatten(self.Bz);
            hold on
            trimesh(frame, bx, by, bz, 'FaceColor', 'none', 'EdgeColor', 'k');
            
            [U, T] = BezierPatch.uniform_mesh(d);
            vals = self.val(U);
            
            trisurf(T, vals(:, 1), vals(:, 2), vals(:, 3));
        end
    end
end