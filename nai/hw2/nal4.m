clear
set(0, 'defaultLineLineWidth', 1.5)

f = @(x) cos(2*pi*x)./(1+x);
density = 30;
d = 0:1/density:1;
dot = @(f, g) f(d)*g(d)';

n = 5;
stopls = -1;
stoph = -1;
tol = 0.01;

while true
    pts = 0:(1/n):1;
    h = HatBasis(pts);
    coef = h.interpolate(f(pts));
    coefls = h.least_squares(f, dot);

    x = 0:0.01:1;
    fx = f(x);
    hx = h.evaluate(coef, x);
    lsx = h.evaluate(coefls, x);

    
    errh = norm(fx - hx, 'inf');
    errls = norm(fx - lsx, 'inf');
    if errh < tol && stoph == -1, stoph = n; end 
    if errls < tol && stopls == -1, stopls = n; end
    if errh < tol && errls < tol, break, end
    
    plot(x, fx, x, hx, x, lsx);
    legend('f', 'If', 'Lf');
    
    if n == 5
        errh = errh
        errls = errls
    end
    n = n + 1;
end
stoph
stopls

% vim: set ft=matlab: