f = @(x,y) peaks(x,y);

d = 4;
a = -2;
b = 2;
x = linspace(a, b, d+1);
y = x;

L = LagrangeBasis(x);

[X, Y] = meshgrid(x, y);
A = f(X, Y);

d = 100;
x = linspace(a, b, d+1);
y = x;
[X, Y] = meshgrid(x, y);
V = f(X, Y);
VP = evaluate2d(L, X, Y, A);

avgerr = mean(mean(abs(V-VP)))

hold on
surf(X, Y, V);
surf(X, Y, VP);
hold off