function [I] = trapezoid(f, a, b, n)
% Approximates integral_a^b f(x) dx using trapesoid rule on n subintervals
% of equal length.
if nargin < 4, error('Please supply all arguments!'), end
if n < 1, error('Number of subintervals must be >= 1'), end
if n ~= floor(n), error('Number of intervals must be an integer, got %f', n), end
if abs(a-b) < eps, I = 0.0; return, end
if b < a, I = -trapezoid(f, b, a, n); return, end

% sedaj vemo, da je a < b
x = linspace(a, b, n+1);
fx = f(x);
I = fx(1) + fx(end) + 2*sum(fx(2:end-1));
I = I * (b-a) / 2 / n;

end