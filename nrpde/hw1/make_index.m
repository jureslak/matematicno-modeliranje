function [ index ] = make_index(j, k, J, K)
% returns linear index of variable u_jk
index = j + J*(k-1);
end

