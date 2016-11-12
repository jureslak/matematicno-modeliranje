function [I] = montecarlo(f, a, b, n)
% Approximates value of integral f on cuboid [a, b] with n tries.
if nargin < 4, error('Please supply all arguments!'), end
if n < 1, error('Number of tries must be >= 1'), end
if n ~= floor(n), error('Number of tries must be an integer, got %f', n), end
if length(a) ~= length(b), error('Endpoints of the cuboid must be of the same dimension.'), end
c = b - a; % dolžine stranic
V = prod(c);  % volume of the cuboid
if V == 0, I = 0; return, end
d = length(a); % dimenzija prostora
S = 0;
for i = 1:n
    S = S + f(a + rand(1, d) .* c);
end
I = S / n * V;
end