function [sol, iter] = jacobi(A, b, prec, start)
% returns solution to Ax = b using Jacobi iteration
if nargin < 3, error('Specify at least 3 arguments.'), end
if nargin == 3, start = zeros(length(b), 1); end;

sol = start;
D = diag(diag(A).^-1);  % dont make it full! (1 ./ x) does that
b = D*b;
T = D*(A - diag(diag(A)));
iter = 0;
n = 1;
while n > prec
    tmp = sol;
    sol = b - T*sol;
    n = norm(sol - tmp, 'inf');
    iter = iter + 1;
end

end

