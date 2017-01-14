% Solve 2nd task
% ODE given as
% y'' = 1/3 y^2 y' - 3xy,  x in [0, 10]
% y(0) = 0
% y'(0) = 1
% using AdamsBashford and Milne method.
% Jure Slak

% y' = z
% z' = 1/3 y^2 z - 3 x y
p.f = @(x, y) [y(2,:); 1/3*y(1,:).^2.*y(2,:) - 3*x.*y(1,:)];
p.a = 0;
p.b = 10;
p.y0 = [0; 1];
p.h = 0.05;

% make_RK4
% solrk = RK4.solve(p.f, p.a, p.b, p.y0, p.h);
% xrk = solrk(1, :);
% yrk = solrk(2, :);

solab = AdamsBashSistem(p.f, p.a, p.b, p.y0, p.h);
xab = solab(1, :);
yab = solab(2, :);

solmi = MilneSistem(p.f, p.a, p.b, p.y0, p.h);
xmi = solmi(1, :);
ymi = solmi(2, :);

hold on
plot(xab, yab)
plot(xmi, ymi)
hold off

fprintf('Approx for y(%d) using AB: %.16f\n', p.b, yab(end));
fprintf('Approx for y(%d) using MI: %.16f\n', p.b, ymi(end));


% vim: set ft=matlab:
