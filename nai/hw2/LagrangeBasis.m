% Class representing Lagrange basis on n points
% @author = Jure Slak <jure.slak@gmail.com>
% @date = 2.1.2016

classdef LagrangeBasis < PolynomialBasis
  % class representing Lagrangian basis
  properties
    n    % number of points
    points    % points
  end
  methods
    function obj = LagrangeBasis(pts), obj@PolynomialBasis(pts); end

    function p = get_kth_basis(obj, k)
        % returns k-th basis polynomial
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s', k, n, mat2str(obj.points));
        end
        xk = obj.points(k);
        obj.points(k) = [];
        p = [1];
        for pnt = obj.points
            p = conv(p, [1, -pnt]) / (xk - pnt);
        end
    end

    function y = evaluate_kth_basis(obj, k, x)
        % returns value of k-th basis polynomial in point (or vector) x
        if nargin ~= 3
            error('Three arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s', k, n, mat2str(obj.points));
        end
        y = zeros(size(x));
        xk = obj.points(k);
        obj.points(k) = [];
        for i = 1:length(x)
            y(i) = prod(x(i) - obj.points) / prod(xk - obj.points);
        end
    end

    function p = interpolate(~, values)
        % return interpolation polynomial written in this basis
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        p = values;
    end
  end
end

% vim: set ft=matlab:
