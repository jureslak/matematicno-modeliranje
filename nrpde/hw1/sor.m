function [sol, iter] = sor(A, b, omega, prec, start)
% returns solution to Ax = b using SOR iteration
if nargin < 4, error('Specify at least 4 arguments.'), end
if nargin == 4, start = zeros(size(b)); end;

sol = start;
D = diag(diag(A));
L = tril(A, -1);
U = triu(A, 1);
M = D + omega*L;
N = omega*U + (omega-1)*D;
iter = 0;
n = 1;
while n > prec
    tmp = sol;
    sol = M \ (omega*b - N*sol);
    n = norm(sol - tmp, 'inf');
    iter = iter + 1;
end

end
