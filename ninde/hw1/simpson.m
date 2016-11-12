function [I]  = simpson(f, a, b, n)
% Approximates integral_a^b f(x) dx using composite simpsons rule made of n
% basic simpson rules.
if nargin < 4, error('Please supply all arguments!'), end
if n < 1, error('Number of subintervals must be >= 1'), end
if n ~= floor(n), error('Number of intervals must be an integer, got %f', n), end
if abs(a-b) < eps, I = 0.0; return, end
if b < a, I = -simpson(f, b, a, n); return, end

% sedaj vemo, da je a < b
x = linspace(a, b, 2*n+1);
fx = f(x);
I = fx(1) + fx(end) + 4*sum(fx(2:2:end-1)) + 2*sum(fx(3:2:end-2));
I = I * (b-a) / 6 / n;

end
