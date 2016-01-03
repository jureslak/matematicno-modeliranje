% Class representing Newton basis on n points
% @author = Jure Slak <jure.slak@gmail.com>
% @date = 2.1.2016

classdef NewtonBasis < PolynomialBasis
  % class representing Newton basis
  properties
    n    % number of points
    points    % points
  end
  methods
    function obj = NewtonBasis(pts), obj@PolynomialBasis(pts); end

    function DD = divided_differences(obj, values)
        % Returns matrix of divided differences for
        % given interpolation values.
        % If any points are repeated, the appropriate derivatives are
        % expected as values instead.
        % Example:
        % points = [0 0 0 1 1 2]
        % values = [f(0) f'(0) f''(0) f(1) f'(1) f(2)]
        X = obj.points;
        Y = values;
        DD = zeros(obj.n);
        fj = 1;
        for j=1:obj.n
            px = X(1) - 1;
            for i=1:(obj.n-j+1)
                if X(i) == X(i+j-1)
                    if X(i) ~= px % this x is the first x for which we must take the derivative
                        DD(i,j) = Y(i+j-1) / fj;    % check (j-1)-th derivative at Y(i+j-1)
                    else
                        DD(i,j) = DD(i-1,j);    % this calculation was already done, just copy it
                    end
                else
                    DD(i,j) = (DD(i,j-1) - DD(i+1,j-1)) / (X(i) - X(i+j-1));
                end
                px = X(i);
            end
            fj = fj * j;   % next factorial
        end
    end

    function p = get_kth_basis(obj, k)
        % returns k-th basis polynomial
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s', k, n, mat2str(obj.points));
        end
        p = [1];
        for i=1:k-1
            p = conv(p, [1, -obj.points(i)]);
        end
    end

    function p = interpolate(obj, values)
        % return interpolation polynomial written in this basis
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        DD = obj.divided_differences(values);
        p = DD(1, :);
    end

    function y = evaluate(obj, coef, x)
        % evaluate polynomial written in this basis with coefficients coef
        % in point (or vector) x
        if nargin ~= 3
            error('Three arguments are required, %d given.', nargin);
        end
        if length(coef) ~= obj.n
            error('Coefficient array too short, expected %d, got %d, coef=%s',...
                  obj.n, length(coef), mat2str(coef));
        end
        y = coef(end) * ones(size(x));
        for i = obj.n-1:-1:1
          y = y .* (x-obj.points(i)) + coef(i);
        end
    end

    function disp(obj)
        % display this object
        fprintf(1, 'Newton basis on points = %s', mat2str(obj.points));
    end
  end
end

% vim: set ft=matlab:
