clear
set(0, 'defaultLineLineWidth', 1.5)

f = @(x) x .* sin(x);
df = @(x) sin(x) + x .* cos(x);

x1 = [pi/3, pi/3, 2*pi/3, 2*pi/3, 4*pi/3, 4*pi/3, 5*pi/3, 5*pi/3];
x2 = [pi/5, pi/5, 3*pi/5, 3*pi/5, 7*pi/5, 7*pi/5, 9*pi/5, 9*pi/5];
y1 = zeros(size(x1));
y2 = zeros(size(x2));

for i = 1:length(x1)/2
    y1(2*i-1) = f(x1(2*i-1));
    y1(2*i) = df(x1(2*i));
    y2(2*i-1) = f(x2(2*i-1));
    y2(2*i) = df(x2(2*i));
end

N1 = NewtonBasis(x1);
coefp = N1.interpolate(y1);

N2 = NewtonBasis(x2);
coefq = N2.interpolate(y2);

x = 0:0.01:2*pi;
fx = f(x);
px = N1.evaluate(coefp, x);
qx = N2.evaluate(coefq, x);

odd = 1:2:length(x1);
plot(x, fx, x, px, x, qx, ...
     x1(odd), y1(odd), 'ro', x2(odd), y2(odd), 'yo');
legend('f', 'p', 'q');

errp = norm(fx - px, 'inf')
errq = norm(fx - qx, 'inf')
 
% vim: set ft=matlab: