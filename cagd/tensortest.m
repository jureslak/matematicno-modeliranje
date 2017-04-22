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

[u, v] = deal(linspace(0, 1, 11));
BS = BezierTensorSurf(Bx, By, Bz);
% setfig 'a1'
% BS.plot(11, 11)
[X, Y, Z] = BS.val(u, v);

[n, m] = size(Bx);
X = reshape(X, [numel(X), 1]);
Y = reshape(Y, [numel(Y), 1]);
Z = reshape(Z, [numel(Z), 1]);
[U, V] = meshgrid(u, v);
U = reshape(U, [numel(U), 1]);
V = reshape(V, [numel(V), 1]);
BLSQ = BezierTensorSurf.LSQ(m, n, [X Y Z], U, V);
% setfig 'a3'
% BLSQ.plot()

[u, v] = deal(linspace(0, 1, 15));
[X, Y, Z] = BS.val(u, v);
[X1, Y1, Z1] = BLSQ.val(u, v);
assert(norm(X-X1, 'inf') < 1e-13, 'LSQ approx. does not coincide with interpolation.')
assert(norm(Y-Y1, 'inf') < 1e-13, 'LSQ approx. does not coincide with interpolation.')
assert(norm(Z-Z1, 'inf') < 1e-13, 'LSQ approx. does not coincide with interpolation.')