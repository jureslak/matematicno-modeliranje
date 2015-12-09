(* Mathematica Raw Program *)
BeginPackage["Nosilec`"]

d4x::usage = "d4w[ww, t, k, dx, nx, order] vrne aproksimacijo za 4. odvod ww po x v točki k dx reda order."

DobiSistem::usage = "DobiSistem[ww, t, nx, q] vrne sistem NDE za enačbo w_xxxx + w_tt = q z nx \
točkami diskretizacije."
DobiSistemRedek::usage = "DobiSistemRedek[nx, q, t] vrne redek sistem {b, A}, \
za enačbo nosilca z nx delilnimi točkami in desno stranjo q[x, t]. t je \
spremeljivka, ki bo nastopala v vrnjenem delu pri b."

DobiZacetnePogoje::usage = "DobiZacetnePogoje[ww, t, nx, g, h] vrne začetne pogoje w[x, 0] = g[x], \
w_t[x, 0] = h[x]."

ResiNosilec::usage = "ResiNosilec[q, g, h, nx, tmax] vrne rešitev enačbe nosilca z desno stranjo \
q, začetnimi pogoji g in h in nx točkami diskretizacije do časa tmax."
ResiNosilecRedek::usage = "ResiNosilecRedek[q, g, h, nx, tmax] vrne rešitev enačbe nosilca z desno stranjo \
q, začetnimi pogoji g in h in nx točkami diskretizacije do časa tmax s pomočjo redkega sistema."
ResiNosilecDiagTX::usage = "ResiNosilecDiagTX[T, X, g, h, nx, tmax, limit=nx-1] vrne rešitev enačbe nosilca z desno stranjo \
q = T*X, začetnimi pogoji g in h in nx točkami diskretizacije do časa tmax s pomočjo \
diagonalizacije sistema. Če je podan limit se upošteva le prvih limit lastnih vrednosti, sicer se \
vse."

DobiNosilec::usage = "DobiNosilec[resitev, nx, t] vrne seznam {x, y} tock na nosilcu ob casu t."

Begin["Private`"]

(* ***** PATTERNS ***** *)
$N = _?NumericQ

(* ***** IMPLEMENTATION ***** *)

d4x[ww_, t_, k:$N, nx:$N, order:$N:2] := Module[
  {dx = 1/nx},

  If[order == 2,
    If[1 <= k <= nx - 1,
      (ww[k - 2][t] - 4 ww[k - 1][t] + 6 ww[k][t] - 4 ww[k + 1][t] + ww[k + 2][t]) / dx^4,
      0],
  (* else *)
    If[1 <= k <= nx - 1,
      (-1/6 ww[k - 3][t] + 2 ww[k - 2][t] - 13/2 ww[k - 1][t] + 28/3 ww[k][t] - 13/2 ww[k + 1][t] + 2 ww[k + 2][t] - 1/6 ww[k + 3][t])/dx^4,
      If[k == 0,
        (28/3 ww[k][t] - 111/2 ww[k + 1][t] + 142 ww[k + 2][t] - 1219/6 ww[k + 3][t] + 176 ww[k + 4][t] - 185/2 ww[k + 5][t] + 82/3 ww[k + 6][t] - 7/2 ww[k + 7][t])/dx^4,
        -(28/3 ww[k][t] - 111/2 ww[k - 1][t] + 142 ww[k - 2][t] - 1219/6 ww[k - 3][t] + 176 ww[k - 4][t] - 185/2 ww[k - 5][t] + 82/3 ww[k - 6][t] - 7/2 ww[k - 7][t])/dx^4
      ]
    ]
  ]
]

ProstiRobniPogojiRule[ww_, t_, nx_] :=
  {ww[0][t] -> 0, ww[nx][t] -> 0,
   ww[-1][t] -> -ww[1][t], ww[nx+1][t] -> -ww[nx-1][t],
   ww[-2][t] -> -ww[2][t], ww[nx+2][t] -> -ww[nx-2][t]}


DobiSistem[ww_, t_, nx:$N, q_Function, order:$N:2] := Module[
  {deq = d4x[ww, t, k, nx, order] + ww[k]''[t] == q[k/nx, t], rule}, (

  rule = ProstiRobniPogojiRule[ww, t, nx];

  Table[deq /. {k -> i}, {i, 1, nx-1}] /. rule (* return value *)
)]

DobiZacetnePogoje[ww_, t_, nx:$N, g_Function, h_Function] := Module[
  {dx = 1/nx},

  {  (* return value *)
    Table[ww[k][0] == g[k dx], {k, 1, nx - 1}],
    Table[ww[k]'[0] == h[k dx], {k, 1, nx - 1}]
  }
]

ResiNosilec[q_Function, g_Function, h_Function, nx:$N, tmax:$N, order:$N:2] := Module[
  {sistem, pogoji, vars, r},

  sistem = DobiSistem[ww, t, nx, q, order];
  pogoji = DobiZacetnePogoje[ww, t, nx, g, h];
  vars = Table[ww[i], {i, 1, nx - 1}];
  r = NDSolveValue[{sistem, pogoji}, vars, {t, 0, tmax}];

  Join[{0 &}, r, {0 &}] (* return value *)
]

DobiNosilec[resitev_, t:$N] := Module[
  {nx = Length[resitev] - 1},

  Table[{(i-1)/nx, resitev[[i]][t]}, {i, 1, nx+1}]
]

DobiSistemRedek[nx:$N, q_Function, t_] := Module[
  {vars, rhs, rule, ww},

  vars = Table[ww[i][t], {i, 1, nx - 1}];
  rule = ProstiRobniPogojiRule[ww, t, nx];

  (* generiranje redke matrike *)
  rhs = Table[q[i / nx, t] - d4x[ww, t, i, nx] == 0., {i, 1, nx - 1}] /. rule; (* desna stran enačbe w''=Aw+b *)
  CoefficientArrays[rhs, vars] (* return value *)
]

ResiNosilecRedek[q_Function, g_Function, h_Function, nx:$N, tmax:$N] := Module[
  {wlist, b, A, eq, pogoji, r},

  wlist[t_] := Table[ww[i][t], {i, 1, nx - 1}];
  {b, A} = DobiSistemRedek[nx, q, t];
  eq = Thread[wlist''[t] == A.wlist[t] + b];
  pogoji = DobiZacetnePogoje[ww, t, nx, g, h];
  r = NDSolveValue[{eq, pogoji}, Table[ww[i], {i, 1, nx - 1}], {t, 0, tmax}];

  Join[{0 &}, r, {0 &}] (* return value *)
]

ResiNosilecDiag[q_Function, g_Function, h_Function, nx:$N, tmax:$N, limit_:0] := Module[
  {limit2, b, A, L, Q, rSplosna, iVel, iPos, rDiag},

  limit2 = If[limit == 0, nx - 1, limit];

  {b, A} = DobiSistemRedek[nx, Function[{x,t}, q[x]], t];
  {L, Q} = Eigensystem[A, -limit2];

  rSplosna = DSolveValue[{v''[t] == l v[t] + qb, v[0] == qg, v'[0] == qh}, v, t];

  iPos = Table[g[i / nx], {i, 1, nx - 1}];
  iVel = Table[h[i / nx], {i, 1, nx - 1}];

  rDiag = rSplosna /. {l -> L, qb -> (Q.b), qg -> (Q.iPos), qh -> (Q.iVel)};

  {Transpose[Q], rDiag} (* return value *)
]

ResiNosilecDiagTX[T_Function, X_Function, g_Function, h_Function, nx:$N, tmax:$N, limit_:0] := Module[
  {limit2, b, A, L, Q, rSplosna, iVel, iPos, rDiag, bVal},

  limit2 = If[limit == 0, nx - 1, limit];

  {b, A} = DobiSistemRedek[nx, Function[{x,t}, X[x] T[t]], t];
  {L, Q} = Eigensystem[A, -limit2];

  rSplosna = DSolveValue[{v''[t] == l v[t] + bKonst T[t], v[0] == qg, v'[0] == qh}, v, t];

  iPos = Table[g[i / nx], {i, 1, nx - 1}];
  iVel = Table[h[i / nx], {i, 1, nx - 1}];
  bVal = Table[X[i / nx], {i, 1, nx - 1}];

  rDiag = rSplosna /. {l -> L, bKonst -> Q.bVal, qg -> (Q.iPos), qh -> (Q.iVel)};

  {Transpose[Q], rDiag} (* return value *)
]

DobiNosilec[resitev_, t:$N, QT_List] := Module[
  {Y},

  Y = Join[{0}, QT.Re[resitev[t]], {0}];
  Transpose[{Range[0, 1, 1/(Length[Y]-1)], Y}]
]


End[]
EndPackage[]
