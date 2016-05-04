function [sol, iter] = sor(A, b, omega, prec, start, maxiter)
% returns solution to Ax = b using SOR iteration
if nargin < 4, error('Specify at least 4 arguments.'), end
if nargin == 4, start = zeros(size(b)); end;
if nargin <= 5, maxiter = 10000; end

sol = start;
D = diag(diag(A));
L = tril(A, -1);
U = triu(A, 1);
M = D + omega*L;
N = omega*U + (omega-1)*D;
for iter = 0:maxiter
    tmp = sol;
    sol = M \ (omega*b - N*sol);
    n = norm(sol - tmp, 'inf');
    if n < prec, return, end
end

warning('SOR reached maximum number of iterations (%d)', maxiter);

end

