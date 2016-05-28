function [rhs] = make_rhs(J, theta, lambda, levo, desno, prev, told, dt)
% returns matrix for the theta method for solving the heat equation
if nargin < 3
    error('Supply at least seven arguments!')
end

rhs = zeros(J-1, 1);
for j = 2:J-2
    rhs(j) = (1-theta)*lambda*(prev(j-1) + prev(j+1)) + ...
             (1 - 2*(1-theta)*lambda) * prev(j);
end
rhs(1) = (1-theta)*lambda*(levo(told) + prev(2)) + ...
         (1 - 2*(1-theta)*lambda) * prev(1) + ...
         theta*lambda*levo(told+dt);
rhs(J-1) = (1-theta)*lambda*(prev(J-2) + desno(told)) + ...
           (1 - 2*(1-theta)*lambda) * prev(J-1) + ...
           theta*lambda*desno(told+dt);
end