clear
%figure
% kont = [0; 2; 5; 3; 1; -1; 7; 2];
% B = Bezier(kont);
% B.plot(100)
% B.plotwithder(100, 10)

% figure
kont2 = [0, 0; 2, 1; 3, -2; 5, 3];
B2 = Bezier(kont2);
% B2.plot(100)
B2.plotwithder()

kontder0 = B2.dercontrol(0);
kontder1 = B2.dercontrol(1);
kontder2 = B2.dercontrol(2);

assert(all(all(kontder0 == kont2)), 'der0 does not work.');

Bder2 = Bezier(kontder2);
t = 0:1/10:1;
der2vals = Bder2.val(t);
der2vals_alt = B2.der(t, 2);
assert(max(max(abs(der2vals-der2vals_alt))) < 1e-14, 'Two ways of calculating derivatives do not match.');

BE = B2.elevate(3);
t = 0:0.05:1;
v1 = BE.val(t);
v2 = B2.val(t);
assert(max(max(abs(v1 - v2))) < 1e-14, 'Elevate is not equal to original.')

clf
B2.plot();
s = B2.subdivide(0.4, 2);
s.plot()
% figure
% kont3 = [0, 0, 4; 5, -6, 1; 2, -2, -2; 6, 3, 8];
% B3 = Bezier(kont3);
% B3.plotwithder(100, 10)