(* ::Package:: *)

(* problem -(pu')' + qu = f, u(a) = c0, u(b) = c1, n-1 tock *)
Clear[a, b, n]

del[i_] := a + (b-a) i / n; 
hat[l_,c_,r_] := Function[x, Piecewise[{{0, x< l},{(x-l)/(c-l), x < c}, {(r-x)/(r-c), x < r}, {0, True}}]]
h[i_] := If[i==0, hat[del[0], del[0], del[1]],
          If[i==n, hat[del[n-1], del[n], del[n]],
                    hat[del[i-1], del[i], del[i+1]]]]

k11[i_] := Integrate[p[x] h[i-1]'[x]^2 + q[x] h[i-1][x]^2, {x, del[i-1], del[i]}, Assumptions->a < b]
k22[i_] := Integrate[p[x] h[i-1]'[x]^2 + q[x] h[i-1][x]^2, {x, del[i-1], del[i]}, Assumptions->a < b]
k12[i_] := Integrate[p[x] h[i-1]'[x]h[i]'[x] + q[x] h[i-1][x]h[i][x], {x, del[i-1], del[i]}, Assumptions->a < b]
k21[i_] := k12[i]

aa[i_, j_] := If[j == i, k22[i] + k11[i+1], 
              If[Or[j == i+1, j==i-1], k12[i], 0]]
f1[i_] := Integrate[f[x] h[i-1][x], {x, del[i-1], del[i]}]
f2[i_] := Integrate[f[x] h[i][x], {x, del[i-1], del[i]}]
bb[i_] := f1[i+1] + f2[i]


(* test *)
Clear[a, b, n]

p[x_] := p0
q[x_] := q0
f[x_] := f0+g0 x

FullSimplify[k11[i], Assumptions->2< i < n-1 && a < b]
FullSimplify[k12[i], Assumptions->2< i < n-1 && a < b]
FullSimplify[k22[i], Assumptions->2< i < n-1 && a < b]
FullSimplify[f1[i], Assumptions->2< i < n-1 && a < b]
FullSimplify[f2[i], Assumptions->2< i < n-1 && a < b]

h[1]
a = 0; b = 10; n = 5;
Plot[Table[h[i][x], {i, 0, n}], {x, a-5, b+5}]



Clear[a, b, n, h, f1]
izr = ((a-b) ((a-b) g0 (-2+3 i)-3 (f0+a g0) n))/(6 n^2);
Collect[izr = izr /. {b -> a+n h},h] /.{g0->f1} // ToMatlab


Clear[c0, c1, p0, q0]
u[x_] := c0 h[0][x] + c1 h[n][x] + Sum[alfa[i] h[i][x],{i,1,n-1}]

Integrate[u[x] h[1][x], {x, -Infinity, Infinity}]
Integrate[u[x] h[2][x], {x, -Infinity, Infinity}]
Integrate[u[x] h[3][x], {x, -Infinity, Infinity}]
Integrate[u[x] h[n-2][x], {x, -Infinity, Infinity}]
Integrate[u[x] h[n-1][x], {x, -Infinity, Infinity}]
Integrate[u[x] h[n][x], {x, -Infinity, Infinity}]


<<ToMatlab`


Clear[a, b, p, q, f,u]
p[x_] := 3
q[x_] := 7
f[x_] := 1-4x
a = 0;
b = 5;
c0 = -2;
c1 = 3;
eq = D[-(p[x] u'[x]), x] +q[x] u[x] == f[x];
eq
res = DSolveValue[{eq, u[a] == c0, u[b] == c1}, u, x] // FullSimplify;
r = res[x] // FullSimplify
r // ToMatlab
Plot[res[x], {x, 0, 5}, PlotRange->All]



Clear[u,x,t]
res = u /. First @ NDSolve[{D[u[t,x],t] == 1/4 D[u[t,x],{x,2}], u[0, x] == x Cos[Pi/2 x], u[t, 0] == t^2, u[t, 3] == -t}, u, {x, 0, 3}, {t, 0, 1}]
Plot3D[res[t, x],{t,0,1}, {x, 0, 3}]
Plot[res[0, x],{x,0,3}, PlotRange->{-4, 2}]
Plot[res[0.5, x],{x,0,3}, PlotRange->{-4, 2}]
Plot[res[1, x],{x,0,3}, PlotRange->{-4, 2}]



