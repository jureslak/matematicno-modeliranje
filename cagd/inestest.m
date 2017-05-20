kont = [0 0; 2 6; -3 1; 2 -5; 8 0];
b = Bezier(kont);
t = [0 0.65 0.3 0.89 1];
b.val(t);
% b.plot()
% b.dercontrol()

% b.der(t, 0)
b.der(t);
% b.der(t, 2)
% b.der(t, 3)

s = b.subdivide(0.3, 1);
e = b.elevate(1);

u = Spline.params(kont(1:end-1, :), 0.77);
q = Spline.quad(u, kont);

kont2 = [kont; 10 1; 12 4; 13 -6];
u2 = Spline.params(kont2(1:end-2, :), 0.66);
c = Spline.cubic(u2, kont2);

k = [0 0; 1 2; 3 -2; 4 2; 5 1; 7 -2; 9 4];
u = Spline.params(k(1:end-1,:), 0.5);
q = Spline.quad(u, k);

std = Bernstein.ber2std([5 4 -2 8 4 -3 1.5 pi])';
ber = Bernstein.std2ber(std)';

B = [1 2 3; 0 -1 2; 4 7 3; -2 -2 -2; 0 0 7];
w = [0.1 0.2 0.3 0.4 1];
R = RBezier(B, w);
R.val(0:0.1:1);
R.farin();
RE = R.elevate(3);
RE.B

Bx = [1 2; 3 4; 5 6];
By = [-1 -2; -1 -1; 3 2];
Bz = [2 3; -1 4; 6 7];

B = BezierTensorSurf(Bx, By, Bz);
[bx, by, bz] = B.val(0:0.2:1, 0:0.2:1);