clear
%figure
%kont = [0; 2; 5; 3; 1; -1; 7; 2];
%B = Bezier(kont);
%B.plot(100)

figure
kont2 = [0, 0; 2, 1; 3, -2; 5, 3];
B2 = Bezier(kont2);
B2.plot(100)
B2.plotwithder()

kontder0 = B2.dercontrol(0);
kontder1 = B2.dercontrol(1);
kontder2 = B2.dercontrol(2);

if any(any(kontder0 ~= kont2)), error('der0 does not work.'), end

Bder2 = Bezier(kontder2);
t = 0:1/10:1;
der2vals = Bder2.val(t);
der2vals_alt = B2.der(t, 2);
if norm(der2vals-der2vals_alt, 'inf') > 1e-13, error('Two ways of calculating derivatives do not match.'), end


%figure
%kont3 = [0, 0, 4; 5, -6, 1; 2, -2, -2; 6, 3, 8];
%B3 = Bezier(kont3);
%B3.plot(100)