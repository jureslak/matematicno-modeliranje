classdef Spline
    % Represents a bezier cubic spline
    properties
        curves
        m
    end
    methods
        function self = Spline(curvelist)
            self.curves = curvelist;
            self.m = length(curvelist);
        end
        function plot(self)
            hold on
            for i = 1:self.m
                self.curves{i}.plot()
            end
        end
    end
    methods(Static)
        function u = params(P, alpha)
            % returns alpha parametrization of m points given as rows of P
            if nargin < 2, alpha = 0; end
            assert(isscalar(alpha), 'alpha must be scalar');
            [m, ~] = size(P);
            DP = diff(P);
            u = zeros(m, 1);
            for i = 1:m-1
                u(i+1) = u(i) + norm(DP(i, :), 2)^alpha; 
            end
        end
        function self = quad(u, D)
            % u - division of the interval
            % D - matrix of points given as rows.
            assert(isvector(u), 'u must be a vector.');
            assert(ismatrix(D), 'D must be a matrix.');
            [m, ~] = size(D);
            assert(m >= 3, 'At least 3 points are needed');
            assert(length(u)+1 == m, 'Numer of rows in D must be one more than length(u).');
            m = m - 2;
            du = diff(u);
            b2 = D(1, :);
            curvelist = cell(m, 1);
            for k = 1:m-1
                b0 = b2;
                b1 = D(k+1, :);
                b2 = du(k) / (du(k) + du(k+1)) * D(k+1, :) + du(k+1) / (du(k) + du(k+1)) * D(k+2, :);
                curvelist{k} = Bezier([b0; b1; b2]);
            end
            b0 = b2;
            b1 = D(m+1, :);
            b2 = D(m+2, :);
            curvelist{m} = Bezier([b0; b1; b2]);
            self = Spline(curvelist);
        end
%         function self = cubic(u, D)
%             % u - division of the interval
%             % D - matrix of points given as rows.
%             assert(isvector(u), 'u must be a vector.');
%             assert(ismatrix(D), 'D must be a matrix.');
%             [m, d] = size(D);
%             assert(m >= 4, 'At least 4 points are needed');
%             assert(length(u)+2 == m, 'Numer of rows in D must be two more than length(u).');
%             m = m - 3;
%             
%         end
    end
end