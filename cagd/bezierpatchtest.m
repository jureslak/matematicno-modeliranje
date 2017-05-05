B = [2 5 -1 0; 
    1 3 -4 NaN;
    0 0 NaN NaN;
    1 NaN NaN NaN];
T = [0 0; 5 1; 3 3];

P = BezierPatch(B);
P1 = [0 0];
P2 = [1 1];
P3 = [4 2];
x = [1 0];
y = [0 1];

u1 = Barycentric.ofPoint(P1, T);
v1 = P.decastejau(u1);
u2 = Barycentric.ofPoint(P2, T);
v2 = P.decastejau(u2);
u3 = Barycentric.ofPoint(P3, T);
v3 = P.decastejau(u3);

U = [u2; u2; u2];
vb2 = P.blossom(U);
assert(abs(v2-vb2) < eps, 'Blossom does not generalize decastejau.')

P.der(u2, Barycentric.ofVector(x, T), 1)
assert(abs(v2-P.der(u2, zeros(0, 3), 0)) < eps, 'der does not generalize decastejau.')
assert(abs(P.der(u2, [], 5)) < eps, 'high derivatives must be 0.')