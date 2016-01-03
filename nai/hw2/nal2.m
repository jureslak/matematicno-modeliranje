clear
set(0, 'defaultLineLineWidth', 1.5)

x = [0, pi/12, pi/6, pi/2];
f = @sin;

fx = f(x);
p = polyfit(fx, x, 3);

format long
appr = polyval(p, 1/3)
exact = asin(1/3)
err = abs(appr - exact)

xx = 0:0.01:1;
plot(xx, asin(xx), xx, polyval(p, xx), fx, x, 'r.')
legend('asin', 'approx')

% vim: set ft=matlab: