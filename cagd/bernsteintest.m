B = Bernstein();
std = B.ber2std([1 0 0 0 0])
ber = B.std2ber([0 0 0 0 1 -1 2])
Bz = Bezier(ber');
Bz.plot()