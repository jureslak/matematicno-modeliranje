% Interface for all polynomial interpolation bases
% @author = Jure Slak <jure.slak@gmail.com>
% @date = 2.1.2016

classdef (Abstract) PolynomialBasis < AbstractBasis
  % abstract base class for interpolation basis
  properties(Abstract)
    points    % points of interpolation
    n    % number of points
  end
  methods (Abstract)
    coef = interpolate(obj, values)    % return interpolation polyomial in this basis
    p = get_kth_basis(obj, k) % get k-th basis polynomial written in standard basis
  end
  methods
    function obj = PolynomialBasis(points), obj@AbstractBasis(points); end

    function p = interpolate_standard(obj, values)
        % return interpolation polynomial in standard basis
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        coef = obj.interpolate(values);
        p = zeros(1, obj.n);
        for i = 1:obj.n
            p = p + coef(i) * PolynomialBasis.leftpadzero(obj.get_kth_basis(i), obj.n);
        end
    end

    function y = evaluate_kth_basis(obj, k, x)
        if nargin ~= 3
            error('Three arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s', k, n, mat2str(obj.points));
        end
        % evaluates k-th basis
        y = polyval(obj.get_kth_basis(k), x);
    end

  end
  methods(Access=protected, Static)
    function x = leftpadzero(x, n)
        % pad x to left with zeros to achieve length n
        x = [zeros(1, n - length(x)) x];
    end
  end
end

% vim: set ft=matlab: