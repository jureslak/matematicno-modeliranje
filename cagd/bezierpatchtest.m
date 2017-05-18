clear
close all
Bx = [ 0 2 6 8.1; 1 3 7 NaN; 2.6 5 NaN NaN; 4 NaN NaN NaN ];
By = [ 0 1 0 -1; 2 2.4 3 NaN; 4 3 NaN NaN; 5 NaN NaN NaN ]; 
Bz = [ -2 1 -2 0; 5.6 -2 3 NaN; 0 5 NaN NaN; 3 NaN NaN NaN ];

B = BezierPatch(Bx, By, Bz);
P = [1/9 1/23 1-1/9-1/23];
b = B.val(P)
v = [-2 3 -1];
BezierPatch.der(B.Bx, P, [v; v], 2)
BezierPatch.der(B.By, P, [v; v], 2)
BezierPatch.der(B.Bz, P, [v; v], 2)


[U, T] = BezierPatch.uniform_mesh(5);
% TRI = [
%     1 2 5;
%     2 5 6;
%     2 3 6;
%     3 6 7;
%     3 4 7;
%     5 6 8;
%     6 8 9;
%     6 7 9;
%     8 9 10;
% ]
B.plot(4)
