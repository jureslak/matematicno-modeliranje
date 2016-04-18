function [sol, iter] = gauss_seidel(A, b, prec, start)
% returns solution to Ax = b using Gauss Seidel iteration
if nargin < 3, error('Specify at least 3 arguments.'), end
if nargin == 3, start = zeros(length(b), 1); end;

sol = start;
L = tril(A);
U = triu(A, 1);
iter = 0;
n = 1;
while n > prec
    tmp = L \ (b - U*sol);
    n = norm(sol - tmp, 'inf');
    sol = tmp;
    iter = iter + 1;
end

end