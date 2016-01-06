% Interface for all interpolation bases
% @author = Jure Slak <jure.slak@gmail.com>
% @date = 2.1.2016

classdef (Abstract) AbstractBasis
  % Interface for all interpolation bases
  properties(Abstract)
    points    % points of interpolation
    n    % number of points
  end
  methods (Abstract)
    coef = interpolate(obj, values) % return interpolation coefficients in this basis
    f = get_kth_basis(obj, k) % get k-th basis function
  end
  methods
    function obj = AbstractBasis(points)
       % constructor
        if nargin ~= 1
            error('Single argument is required, %d given.', nargin);
        end
        obj.points = points;
        obj.n = length(points);
    end
    
    function y = evaluate_kth_basis(obj, k, x)
        if nargin ~= 3
            error('Three arguments are required, %d given.', nargin);
        end
        if ~(1 <= k && k <= obj.n)
            error('Index k=%d is out of range! n = %d, points = %s', k,...
                  obj.n, mat2str(obj.points));
        end
        % evaluates k-th basis
        fk = obj.get_kth_basis(k);
        y = fk(x);
    end

    function y = evaluate(obj, coef, x)
        % evaluate polynomial written in this basis with coefficients
        % coef at point / vector of points x
        if nargin ~= 3
            error('Three arguments are required, %d given.', nargin);
        end
        if length(coef) ~= obj.n
            error('Coefficient array too short, expected %d, got %d, coef=%s',...
                  obj.n, length(coef), mat2str(coef));
        end
        y = 0;
        for i = 1:obj.n
            y = y + coef(i) * obj.evaluate_kth_basis(i, x);
        end
    end
    
    function G = gram_matrix(obj, dot)
        % returns gram matrix for this basis
        G = zeros(obj.n);
        for i = 1:obj.n
            for j = 1:i
                G(i, j) = dot(obj.get_kth_basis(i), obj.get_kth_basis(j));
                G(j, i) = G(i, j);
            end
        end
    end
    
    function coef = least_squares(obj, f, dot, G)
        % return coefficients of the LS approximation
        % with given dot product and possibly Gram matrix
        if nargin == 3
            G = obj.gram_matrix(dot);
        end
        rhs = zeros(1, obj.n);
        for i = 1:obj.n
            rhs(i) = dot(obj.get_kth_basis(i), f);
        end
        coef = rhs / G;
    end

    function disp(obj)
        % display this object
        fprintf(1, 'Basis on points = %s', mat2str(obj.points));
    end
  end
end

% vim: set ft=matlab: