function [I, err] = adapt(f, a, b, delta)
% Approximate integral_a^b f(x) dx using adaptive Simpson's rule.
if nargin < 4, error('Please supply all arguments!'), end
if delta < eps, error('Requested precision too small, got %g', delta), end
if abs(a-b) < eps, I = 0.0; err = eps; return, end
if b < a, [I, err] = adapt(f, a, b, delta); I = -I; return, end

I1 = simpson(f, a, b, 1);
I2 = simpson(f, a, b, 2);

err = abs(I1 - I2);
if err < delta
    I = 1/15 * (16 * I2 - I1);
else
    d = (b-a)/2;
    [I1, err1] = adapt(f, a, a+d, delta/2);
    % spodaj lahko damo napako delta/2, ce zelimo da je metoda
    % paralelizabilna
    [I2, err2] = adapt(f, a+d, b, delta - err1);
    err = err1 + err2;
    I = I1 + I2;
end

end

