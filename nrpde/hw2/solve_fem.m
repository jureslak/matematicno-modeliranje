function [alfa] = solve_fem(p, n)
% solves 1D boundary value problem
% -(pu')' + qu = f0 + f1 x

% togostna matrika
K = zeros(2);
K(1,1) =  p.p/n.h + p.q*n.h/3;
K(2,2) = K(1,1);
K(1,2) = -p.p/n.h + p.q*n.h/6;
K(2,1) = K(1,2);

A = sparse(n.n-1, n.n-1);
for i = 1:n.n-2
    A(i:i+1, i:i+1) = A(i:i+1, i:i+1) + K;
end
A(1,1) = A(1, 1) + K(2, 2);
A(end, end) = A(end, end) + K(1, 1);

% togostni vektor
ii = (1:n.n);
f = [(p.f0+p.a*p.f1)*n.h/2+p.f1*n.h^2*(3*ii-2)/6
     (p.f0+p.a*p.f1)*n.h/2+p.f1*n.h^2*(3*ii-1)/6]';

rhs = zeros(n.n-1, 1);
for i = 1:n.n-2
    rhs(i:i+1) = rhs(i:i+1) + f(i+1,:)';
end
rhs(1)   = rhs(1)   + f(1, 2)   - p.levi  * K(2, 1);
rhs(end) = rhs(end) + f(end, 1) - p.desni * K(1, 2);

alfa = A \ rhs;
alfa = [p.levi; alfa; p.desni];

end

