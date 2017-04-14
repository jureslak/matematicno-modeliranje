close all
clear
kont = [0 2; 5 3; 1 -1; 7 2];
weight = [1, 1, 1, 1];
t = 0:0.01:1;
RB = RBezier(kont, weight);
x = RB.val(t);
RB.plot()

kont = [0 2; 5 3; 1 -1; 7 2];
B = Bezier(kont);
y = B.val(t);

assert(norm(x-y, 1) < eps, 'RBezier does not generalize Bezier!')
assert(all(all(RB.lift().proj().B == RB.B)), 'Lift and proj are not inverses of each other!')
assert(all(RB.lift().proj().w == RB.w), 'Lift and proj are not inverses of each other!')

figure
kont2 = [0 1 3; -1 2 1; -2 1 0];
w = [2, 1, 1/2];
RB2 = RBezier(kont2, w);
val = RB2.val(1/3);
RB2.plot()

% kroznica
figure
kont3 = [1 0; 1 4; -3 2; -3 -2; 1 -4; 1 0];
w3 = [1 1/5 1/5 1/5 1/5 1];
C = RBezier(kont3, w3);
C.plot()
C.elevate(3).plot()