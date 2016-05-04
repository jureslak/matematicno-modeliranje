function [sol, iter] = gauss_seidel(A, b, prec, start, maxiter)
% returns solution to Ax = b using Gauss Seidel iteration
if nargin < 3, error('Specify at least 3 arguments.'), end
if nargin == 3, start = zeros(length(b), 1); end;
if nargin <= 4, maxiter = 10000; end

sol = start;
L = tril(A);
U = triu(A, 1);
iter = 0;
for iter = 0:maxiter
    tmp = sol;
    sol = L \ (b - U*sol);
    n = norm(sol - tmp, 'inf');
    if n < prec, return, end
end

warning('Gauss Seidel reached maximum number of iterations (%d)', maxiter);

end
