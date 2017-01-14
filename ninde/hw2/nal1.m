% Solve 1st task
% ODE given as
% y' = f(x, y), x in [a, b]
% y(a) = y0
% using adaptive CashKarp method.
% Jure Slak

p.f = @(x, y) 2*sin(2*y) + 3*cos(4*x);
p.a = 0;
p.b = 2;
p.y0 = 1;
p.tol = 1e-6;
p.hmin = 0.01;
p.hmax = 0.2;
p.gamma = 0.9;

solck = CashKarp(p.f, p.a, p.b, p.y0, p.tol, p.hmin, p.hmax, p.gamma);
xck = solck(1, :);
yck = solck(2, :);

make_RK4
solrk = RK4.solve(p.f, p.a, p.b, p.y0, p.hmax/2);
xrk = solrk(1, :);
yrk = solrk(2, :);

hold on
plot(xck, yck, '+')
plot(xrk, yrk, 'o')
hold off

fprintf('Approx for y(2) using CK:  %.16f\n', yck(end));
fprintf('Approx for y(2) using RK4: %.16f\n', yrk(end));

% vim: set ft=matlab:
