% Class representing Hat basis on n points
% @author = Jure Slak <jure.slak@gmail.com>
% @date = 2.1.2016

classdef HatBasis < AbstractBasis
  properties
    n    % number of points
    points    % points
  end
  methods
    function obj = HatBasis(pts), obj@AbstractBasis(pts); end
    
    function f = get_kth_basis(obj, k)
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s',...
                  k, obj.n, mat2str(obj.points));
        end
        X = obj.points;
        g = @(x) (x - X(k-1)) ./ (X(k) - X(k-1)) .* ((X(k-1) <= x) & (x <= X(k)));
        h = @(x) (X(k+1) - x) ./ (X(k+1) - X(k)) .* ((X(k) <= x) & (x <= X(k+1)));
        if k == 1
            f = h;
        elseif k == obj.n
            f = g;
        else
            f = @(x) g(x) + h(x) - (X(k) == x);
        end
    end
    
    function coef = interpolate(~, values)
        % return interpolation polynomial written in this basis
        if nargin ~= 2
            error('Two arguments are required, %d given.', nargin);
        end
        coef = values;
    end
  end
end