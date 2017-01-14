function sol = CashKarp(f, a, b, y0, tol, hmin, hmax, gamma)
% Solves an ODE using adaptive Cash-Karp method.
if (nargin < 8), error('Supply all arguments.'), end

if (hmin >= hmax), error('hmin is not smaller than hmax, hmin = %f, hmax = %f', hmin, hmax), end
if ((b-a)*hmin < 0), error('Value of a+h does not go towards b. a = %g, b = %g, h = %g.', a, b, h), end
if (~isvector(y0)), error('y0 is not a vector.'), end
if (~iscolumn(y0)), y0 = y0'; end
sfx = size(f(a, y0));
sy = size(y0);
d = sy(1);
if (sfx(1) ~= d || sfx(2) > 1), error('Expected f to be a vector function of dimension %d, but got %s.', d, mat2str(sfx)), end

x = a;
y = y0;
h = hmax;
sol = [x; y];
make_CK;
while 1
    K = ck.solver.getk(f, x, y, h);
    R = abs(h*K*(ck.gam5 - ck.gam4));
    if R < tol || h <= hmin
        if (h <= hmin), warning('Minimal step %g reached, error = %g.', hmin, R), end
        x = x + h;
        y = y + h * K * ck.gam5;
        sol = [sol, [x; y]];
    end
    h = min(hmax, max(hmin, gamma*h*(tol / R)^(1/5)));
    if h > b
        break
    elseif x + h > b
        h = b - x;
        if h < hmin
            break
        end
    end
end

end