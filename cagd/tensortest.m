clear
close all
Bx = [
    0 3 5 6;
    1 4 5 7;
    0 3 5 6
    ];
By = [
    -1 -2 -1 -2;
    1 2 1 2;
    5 5 6 5
    ];
Bz = [
    0 -2 0 -5;
    3 6 3 2;
    0 4 2 3
    ];
u = 0:0.1:1;
v = 0:0.1:1;
%u = 0.3;
%v = 0.6;

[u, v] = deal(linspace(0, 1, 50));
BS = BezierTensorSurf(Bx, By, Bz);
[X, Y, Z] = BS.val(u, v);
%BS.plot()

[n, m] = size(Bx);
X = reshape(X, [numel(X), 1]);
Y = reshape(Y, [numel(Y), 1]);
Z = reshape(Z, [numel(Z), 1]);
BLSQ = BezierTensorSurf.LSQ(m, n, [X Y Z], X, Y);