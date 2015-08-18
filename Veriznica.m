(* Mathematica Raw Program *)
BeginPackage["Veriznica`"]

ZveznaVeriznica::usage = "ZveznaVeriznica[a, A, b, B, len] vrne funkcijo zvezne veriznice dolžine \
len med tockama (a, A) in (b, B), a < b.\n\n\
ZveznaVeriznica[T1, T2, len] vrne funkcijo zvezne veriznice dolžine \
len med tockama T1 in T2, T1 je levo od T2"

CasPotovanja::usage = "CasPotovanja[f, x1, x2, v0, g] vrne čas potovanja po funckiji f brez trenja \
od x1 do x2 z začetno hitrostjo v0 in težnim pospeškom g.\n\n\
CasPotovanja[x, y, t1, t2, v0, g] vrne čas potovanja po parametrični krivulji (x[t], y[t]) od t1 \
do t2 z začetno hitrostjo v0 in težnim pospeškom g."

DiskretnaVeriznica::usage = "DiskretnaVeriznica[T1, T2, dolzine, mase] vrne seznam n+1 koordinat \
točk verižnice. T1 mora biti levo od T2 in seznama dolžin in mas morata biti enako dolga.\n\n\
DiskretnaVeriznica[a, A, b, B, dolzine, mase] vrne seznam n+1 koordinat \
točk verižnice. Veljati mora a < b in seznama dolžin in mas morata biti enako dolga."

Brahistokrona::usage = "Brahistokrona[a, A, b, B] vrne parametrizacijo in največjo vrednost\
parametra brahistokrone med točkama (a, A) in (b, B). Veljati mora a < b in A > B.\n\n\
Brahistokrona[T1, T2] je enaka funkcija, samo da sprejme dve točki, T1 = {a, A} in T2 = {b, B}."

TezisceVeriznice::uasge = "TezisceVeriznice[pts, mase] vrne tezisce veriznice s točkami pts in
masami mase. Senam mas mora biti za ena krajši kot seznam točk."

(* errors *)

DiskretnaVeriznica::NapacneDolzine = "Dolžini seznamov dolžin in mas se ne ujemata (`1` != `2`)"
DiskretnaVeriznica::PrekratkaVeriznica = "Veriznica je prekratka, vsota dolzin je `1`, razdalja med \
levim in desnim krajiščem je `2`."
Brahistokrona::abSwap = "Koordinati sta narobe obrnjeni, zamenjaj a in b. (`1` >= `2`)"
Brahistokrona::ABSwap = "Spust ne gre navzdol, A <= B! Prezrcali problem. (`1` <= `2`)"
TezisceVeriznice::NapacneDolzine = "Seznama mas in točk nista pravih dolžin. (`1` != `2` + 1)."

Begin["Private`"]

(* ***** PATTERNS ***** *)
$N = _?NumericQ
$PT = {$N, $N}
$LN = {__?NumericQ}
$LP = {{_, _} .. };

(* ***** IMPLEMENTATION ***** *)

ZveznaVeriznica[a:$N, A:$N, b:$N, B:$N, l:$N] := Module[
  {z0 = 1, z, ro = l/(b - a) Sqrt[1 - ((B - A)/l)^2], v, u, C, D, lama},

  z = FixedPoint[N[ArcSinh[ro * #] ] &, z0, SameTest -> (Abs[#1 - #2] < 10^-6 &)];
  v = ArcTanh[(B - A)/l] + z;
  u = ArcTanh[(B - A)/l] - z;
  C = (b - a)/(v - u);
  D = (a*v - b*u)/(v - u);
  lama = A - C * Cosh[(a - D)/C];
  Function[x, lama + C * Cosh[(x - D)/C]] (* return value *)
]
ZveznaVeriznica[T1:$PT, T2:$PT, l:$N] := ZveznaVeriznica[T1[[1]], T1[[2]], T2[[1]], T2[[2]], l]

CasPotovanja[x_Function, y_Function, t1:$N, t2:$N, v0:$N:0, g:$N:9.81] :=
  NIntegrate[Sqrt[((x'[t]^2) + (y'[t])^2) / (v0^2 + 2 g (y[t1] - y[t]))], {t, t1, t2}]
CasPotovanja[f_Function, x1:$N, x2:$N, v0:$N:0, g:$N:9.81] := CasPotovanja[#&, f, x1, x2, v0, g]

DiskretnaVeriznica[levo:$PT, desno:$PT, dolzine:$LN, mase:$LN] :=  Module[
  {x, y, rez, n = Length[dolzine]},

  If[Length[dolzine] == Length[mase], Null,
    Message[DiskretnaVeriznica::NapacneDolzine, Length[dolzine], Length[mase]]; Return[$Failed]];
  If[Total[dolzine] < Norm[levo - desno],
    Message[DiskretnaVeriznica::PrekratkaVeriznica, Total[dolzine], Norm[levo-desno]]; Return[$Failed]];

  rez = NMinimize[{
      Sum[mase[[i + 1]] * (y[i] + y[i + 1]) / 2, {i, 0, n - 1}], (* expressions *)
      {x[0], y[0]} == levo, {x[n], y[n]} == desno, (* constraints *)
      Table[Norm[{x[i + 1], y[i + 1]} - {x[i], y[i]}] == dolzine[[i + 1]],{i, 0, n - 1} ] (* constraints *)
    },
    Flatten[Table[{x[i], y[i]}, {i, 0, n}], 2] (* variables *)
  ];
  Table[{x[i], y[i]}, {i, 0, n}] /. rez[[2]] (* return value *)
];
DiskretnaVeriznica[a_, A_, b_, B_, dolzine_, mase_] :=  DiskretnaVeriznica[{a, A}, {b, B}, dolzine, mase]

TezisceVeriznice[pts:$LP, mase:$LN] := Module[
  {M = Total[mase]},
  If[Length[pts] == Length[mase] + 1, Null,
    Message[TezisceVeriznice::NapacneDolzine, Length[pts], Length[mase]]; Return[$Failed]];

  Sum[(pts[[i]] + pts[[i + 1]])/2*mase[[i]], {i, 1, Length[mase]}]/M
]

Brahistokrona[a_, A_, b_, B_] := Module[
  {r1, r2, thmax, kk, x, y},

  If[a < b, Null, Message[Brahistokrona::abSwap, a, b]; Return[$Failed]];
  If[A > B, Null, Message[Brahistokrona::ABSwap, A, B]; Return[$Failed]];

  r1 = First[NSolve[1 - Cos[tz] + (B - A)/(b - a)*(tz - Sin[tz]) == 0 && tz > 10^-7, tz, Reals]];
  r2 = FindRoot[(1/2*k^2 (tz - Sin[tz]) == (b - a) /. r1), {k, 1}];

  thmax = tz /. r1;
  kk = k /. r2;

  x[th_] := 1/2*kk^2 (th - Sin[th]) + a;
  y[th_] := -1/2*kk^2 (1 - Cos[th]) + A;

  {{x[#], y[#]} &, thmax} (* return value *)
]
Brahistokrona[T1_, T2_] := Brahistokrona[T1[[1]], T1[[2]], T2[[1]], T2[[2]]]

End[]
EndPackage[]
