a = (sqrt(3)-1) / sqrt(3);
b = (sqrt(3)+1) / (2*sqrt(3));
c = 1 - (5-sqrt(2))*(7-sqrt(3))/46;
Bx = [
    1 1 b a 0;
    1 1 c 0 nan;
    b c 0 nan nan;
    a 0 nan nan nan;
    0 nan nan nan nan
    ];
By = [
    0 a b 1 1;
    0 c 1 1 nan;
    0 c b nan nan;
    0 a nan nan nan;
    0 nan nan nan nan
    ];
Bz = [
    0 0 0 0 0;
    a c c a nan;
    b 1 b nan nan;
    1 1 nan nan nan;
    1 nan nan nan nan
    ];

ut1 = 4*sqrt(3)*(sqrt(3)-1);
ut2 = 3*sqrt(2);
ut3 = 4;
ut4 = sqrt(2)*(3 + 2*sqrt(2) - sqrt(3))/sqrt(3);
W = [
    ut1 ut2 ut3 ut2 ut1;
    ut2 ut4 ut4 ut2 nan;
    ut3 ut4 ut3 nan nan;
    ut2 ut2 nan nan nan;
    ut1 nan nan nan nan
    ];

B = RBezierPatch(Bx, By, Bz, W);
U = BezierPatch.uniform_mesh(10);
vals = B.val(U);
nn = sum(vals.^2, 2);
err = norm(nn-ones(size(nn)), 'inf');
assert(err < 1e-14, 'Sphere does not have norm 1, but %g away.', err); 
B.plot(10);