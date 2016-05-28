function [M] = make_matrix(J, theta, lambda)
% returns matrix for the theta method for solving the heat equation
if nargin < 3
    error('Supply at least three arguments!')
end

M = sparse(J-1, J-1);
for j = 2:J-2
    M(j, j) = 1 + 2 * theta * lambda;
    M(j, j-1) = -theta * lambda;
    M(j, j+1) = -theta * lambda;
end

M(1, 1) = 1 + 2 * theta * lambda;
M(J-1, J-1) = 1 + 2 * theta * lambda;
M(1, 2) = -theta * lambda;
M(J-1, J-2) = -theta * lambda;
end