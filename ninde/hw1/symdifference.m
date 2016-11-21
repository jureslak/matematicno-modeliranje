function [D, DD] = symdifference(f, x1, h)
% Approximate derivative Df and D^2f in point x1 using symmetric difference 
% in points x1-h, x1+h.
if nargin < 3, error('Please supply all arguments!'), end

f0 = f(x1 - h);
f1 = f(x1);
f2 = f(x1 + h);
D = (f2 - f0) / (2*h);
DD = (f0 - 2*f1 + f2) / (h^2);
end