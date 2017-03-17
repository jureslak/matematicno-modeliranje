clear
%figure
%kont = [0; 2; 5; 3; 1; -1; 7; 2];
%B = Bezier(kont);
%B.plot(100)

% figure
kont2 = [
    0, 0; 
    2, 3; 
    4, 2; 
    5, -1];
B2 = Bezier(kont2);
% B2.plot(100)
% B2.plotwithder()

kontder0 = B2.dercontrol(0);
kontder1 = B2.dercontrol(1);
kontder2 = B2.dercontrol(2);

if any(any(kontder0 ~= kont2)), error('der0 does not work.'), end

Bder2 = Bezier(kontder2);
t = 0:1/10:1;
der2vals = Bder2.val(t);
der2vals_alt = B2.der(t, 2);
assert(norm(der2vals-der2vals_alt, 'inf') < 1e-13, 'Two ways of calculating derivatives do not match.');

blist = B2.subdivide(1/2, 0);
assert(length(blist) == 1, 'Subdivide for 0 returned too many items.');
assert(norm(blist{1} - B2.B) < 1e-16, 'Subdivision for 0 is wrong.');
blist = B2.subdivide(1/2, 2);
% for i = 1:length(blist)
%     bz = Bezier(blist{i});
%     bz.plot();
% end   

BE = B2.elevate(2);
Belevated = Bezier(BE);

eleval = Belevated.val(0:0.1:1);
normval = B2.val(0:0.1:1);
assert(norm(eleval-normval) < 1e15, 'Elevation is wrong');

%figure
%kont3 = [0, 0, 4; 5, -6, 1; 2, -2, -2; 6, 3, 8];
%B3 = Bezier(kont3);
%B3.plot(100)