function [sol, iter] = jacobi(A, b, prec, start, maxiter)
% returns solution to Ax = b using Jacobi iteration
if nargin < 3, error('Specify at least 3 arguments.'), end
if nargin == 3, start = zeros(length(b), 1); end;
if nargin <= 4, maxiter = 10000; end

sol = start;
D = diag(diag(A).^-1);  % dont make it full! (1 ./ x) does that
b = D*b;
T = D*(A - diag(diag(A)));
iter = 0;
for iter = 0:maxiter
    tmp = sol;
    sol = b - T*sol;
    n = norm(sol - tmp, 'inf');
    if n < prec, return, end
end

warning('Jacobi reached maximum number of iterations (%d)', maxiter);

end

