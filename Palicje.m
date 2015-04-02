(* Mathematica Raw Program *)
BeginPackage["Palicje`"]

(* Paličje je podano z množico vozlišč in množico povezav
   Vozlisca  = {{0, 0}, {1, 0}, {3/2, Sqrt[3]/2}, {1/2, Sqrt[3]/2}}
   Povezave =  {{2, 4}, {1, 3, 4}, {2, 4}, {1, 2, 3}} *)

(* Paličje je obremenjeno v vozliščih. Obremenitve so dane s seznamom
   Obremenitve = {{3, {0, -F0}}}
   Obremenitve[[i,1]] pove kateri vozel je obremenjen,
   Obremenitve[[i,2]] pa s kakšno silo na vsaki komponenti. *)

(* Paličje je podprto s podporami. Struktura je podobna strukturi Obremenitve.
   Drsna podpora je dana s silo, ki ima eno komponento enako nič.
   FiksnePodpore = {{1, {Fpx[1], Fpy[1]}}}
   PremicnePodpore = {{2, {0, Fpy[2]}}}
   Podpore = Join[FiksnePodpore, PremicnePodpore] *)

(* ******** DEFINICIJE ********* *)

NarisiVozlisca::usage = "Nariše vozlišča dana s seznamom koordinat"
NarisiPaliceIzVozlisca::usage = "Nariše vse palice iz danega vozlišča";
NarisiPalice::usage = "Nariše vse palice iz danih vozlišč";
NarisiPalicje::usage = "Nariše celotno paličje podano z vozlišči in povezavami";
NarisiBarvnePalice::usage = "Nariše barve palice";
NarisiBarvnePaliceIzVozlisca::usage = "Nariše pobarvane palice iz vozlišča i";
NarisiBarvnoPalicje::usage = "Nariše barvno paličje z legendo";

EnotskiVektor::usage = "Vrne enotski vektor med tocko1 in tocko2";
SileNaVozlisce::usage = "Vrne vsoto vseh sil na vozlišče, po kompomentah.";
DodajObremenitve::usage = "Doda nove sile med vse sile. Funkcija spremeni drugi argument.";
GenerirajEnacbe::usage = "Vrne sistem ravnovesnih enačb za vsa vozlišča, upoštevajoč obremenitve, podpore in notranje sile";
GenerirajNeznanke::usage = "Vrne seznam vseh uporabljenih neznank, sestavljen iz sil v palicah in podpor.";
F::usage = "Neznanka, uporabljena za notranje sile.";

Dolzine::usage = "Vrne dolzine med vozlišči v obliki d[i, j]";
GenerirajY::usage = "Vrne Yougove module palic Y[i, j] nastavljene na konst";
GenerirajS::usage = "Vrne preseke palic S[i,j] nastavljene na konst";
GenerirajK::usage = "Vrne prožnostne koeficinte palic k[i, j]. Y in S sta lahko konstanti ali pa Y[i, j], S[i, j]";
GenerirajVezi::usage = "Generira energijski funckijonal z vezmi";
GenerirajEnergijsko::usage = "Generira energijski funckijonal z vezmi";
GenerirajNeznankePomiki::usage = "Generira neznanke za minimizacijo pomikov.";
px::usage = "Neznanka za premike v x smeri";
py::usage = "Neznanka za premike v y smeri";

ResiPalicje::usage = "Resi palicje. Za togo palicje izracuna sile, za elastično pa pomike";

(* errors *)
Palicje::VozliscaPovezaveLength = "Dolžine seznamov vozlišč in povezav so različne! (`1` != `2`)";
Palicje::VozlisceNeObstaja = "Ne morem dostopati do `1`-tega vozlisca. `1` ni na intervalu [1, `2`]";

Begin["Private`"]

(* ******** PATTERNS ********** *)
$VFP = {{_, _} .. }; (* vozlisca format pattern *)
$PFP = {{___} .. };
$OFP = {{_, {_, _}} .. }; (* obremenitve format pattern *)
$RFP = {{_Rule .. }}; (* resitev format pattern *)

(* ******** RISANJE ********** *)

CheckInvalidVozliscaPovezave[Vozlisca:$VFP, Povezave:$PFP, i_Integer:Null] :=  (
  If[i == Null || 1 <= i <= Length[Vozlisca], Null,
    Message[Palicje::VozlisceNeObstaja, i, Length[Vozlisca]]; Return[True]];
  If[Length[Vozlisca] == Length[Povezave], Null,
    Message[Palicje::VozliscaPovezaveLength, Length[Vozlisca], Length[Povezave]]; Return[True]];
  False (* return value *)
)

(* Funkcija  NarisiVozlisca nariše vozlišča podana s seznamom koordinat*)
NarisiVozlisca[Vozlisca:$VFP] := Graphics[{
  PointSize[Medium],
  Table[Point[Vozlisca[[k]]], {k, Length[Vozlisca]}],
  Table[
    Text[Style[k, Medium], Vozlisca[[k]], {0, 2}],
      {k, Length[Vozlisca]}]
}];

(* Funkcija nariše vozlišča palice iz i-tega vozlišča. *)
NarisiPaliceIzVozlisca[i_Integer, Vozlisca:$VFP, Povezave:$PFP] := Module[
  {vozlisce, sosednja}, (* lokalne spremenljivke *)

  If[CheckInvalidVozliscaPovezave[Vozlisca, Povezave, i], Return[$Failed]];

  vozlisce = Vozlisca[[i]];
 sosednja = Table[Vozlisca[[j]], {j, Povezave[[i]]}];
  Graphics[
    Table[Line[{vozlisce, sosed}], {sosed, sosednja}] (* return value *)
  ]
]
(* Nariše vse palice *)
NarisiPalice[Vozlisca:$VFP, Povezave:$PFP] :=
  Table[NarisiPaliceIzVozlisca[i, Vozlisca, Povezave], {i, Length[Vozlisca]}]

(* Funkcija nariše paličje, združi točke in povezave *)
NarisiPalicje[Vozlisca:$VFP, Povezave:$PFP] :=
  Show[NarisiVozlisca[Vozlisca], NarisiPalice[Vozlisca, Povezave]]

(* funkcija ki naredi funkcijo za barvanje palic *)
NarediFunkcijoBarvanja[minF_?NumericQ, maxF_?NumericQ] := Function[f, (f - minF) / (maxF - minF) / 3]
NarisiBarvnePaliceIzVozlisca[i_Integer, Vozlisca:$VFP, Povezave:$PFP, Sile_, barva_Function] := Module[
  {vozlisce, sosednja, sile}, (* lokalne spremenljivke *)

  If[CheckInvalidVozliscaPovezave[Vozlisca, Povezave, i], Return[$Failed]];

  vozlisce = Vozlisca[[i]];
  sosednja = Table[Vozlisca[[j]], {j, Povezave[[i]]}];
  Graphics[
    Table[{
      Hue[barva[ Sile @@ Sort[{i, j} ]]],
      Thick,
      Line[{vozlisce, Vozlisca[[j]]}]},
        {j, Povezave[[i]]}] (* return value *)
  ]
]
NarisiBarvnePalice[Vozlisca:$VFP, Povezave:$PFP, Sile_, barva_Function] :=
  Table[
    NarisiBarvnePaliceIzVozlisca[i, Vozlisca, Povezave, Sile, barva],
      {i, Length[Vozlisca]}] (* return value *)

NarisiPaleto[minF_?NumericQ, maxF_?NumericQ] := Module[
  {x0, y0, x1, y1, dx, nx, y2}, (* lokalne spremenljivke *)

  x0 = 0; y0 = -1/4; x1 = 1; y1 = y0 + 1/8; nx = 100;
  dx = (x1 - x0)/nx; y2 = y0 - 1/20;

  Show[Table[Graphics[{
      Hue[i/(3 nx)],
      Rectangle[{x0 + i dx, y0}, {x0 + (i + 1) dx, y1}]
    }], {i, nx}],
    Table[Graphics[
      Text[
        Style[N[Round[minF + (maxF - minF) s, 1/20]], Medium],
        {s, y2}, {0, 0}
      ]
    ], {s, 0, 1, 0.2}]
  ] (* return value *)
]

NarisiBarvnoPalicje[Vozlisca:$VFP, Povezave:$PFP, Sile:$RFP, MinF_:Null, MaxF_:Null] := Module[
  {paleta, barva, vrednostiSil, sile, minF, maxF, notranjeSile}, (* lokalne spremenljivke *)

  If[CheckInvalidVozliscaPovezave[Vozlisca, Povezave, i], Return[$Failed]];

  notranjeSile = Cases[Sile, HoldPattern[Rule[_F, _]], 2]; (* Hold ker mathcamo Rule *)
  vrednostiSil = notranjeSile /. {F -> sile, Rule -> Set}; (* nastavimo sile[i, j] in dobimo vse vrednosti *)
  minF = If[NumericQ[MinF], MinF, Min[vrednostiSil]];
  maxF = If[NumericQ[MaxF], MaxF, Max[vrednostiSil]];
  barva = NarediFunkcijoBarvanja[minF, maxF];
  paleta = NarisiPaleto[minF, maxF];
  Show[NarisiVozlisca[Vozlisca], NarisiBarvnePalice[Vozlisca, Povezave, sile, barva], paleta]
]

(* ******** STATIKA ********** *)

(* Funkcija razdeli silo v palici na kompenento v x in y smeri, vrne enotski vektor med dvema
   točkama *)
EnotskiVektor[tocka1_List, tocka2_List] := (tocka2 - tocka1) / Norm[tocka2 - tocka1]

(* Funkcija vrne vsoto sil na vozlišče i v x in y smeri *)
SileNaVozlisce[i_, Vozlisca:$VFP, Povezave:$PFP] := Module[
  {sosedi, tocka}, (* lokalne spremenljivke *)

  sosedi = Povezave[[i]];
  tocka = Vozlisca[[i]];
  Sum[F @@ Sort[{i, j}] * EnotskiVektor[tocka, Vozlisca[[j]]],
    {j, sosedi}] (* return value *)
]

(* Funkcija doda obremenitve za vozlišča k notranjim silam, kjer obremenitev obstaja.
   Deluje za obremenitve in tudi podpore, kjer podamo neznane sile po komponentah. *)
SetAttributes[DodajObremenitve, HoldAll] (* da lahko modifyamo spremenljivke *)
DodajObremenitve[noveSile_, vseSile_] := Module[
  {idx, sila}, (* lokalne spremenljivke *)

  Do[
    {idx, sila} = obremenitev;
    vseSile[[idx]] += sila;,
      {obremenitev, noveSile}]
]

(* Generira in vrne enacbe za paličje *)
GenerirajEnacbe[Vozlisca:$VFP, Povezave:$PFP, Podpore:$OFP, Obremenitve:$OFP] := Module[
  {Sistem, SileVozlisca}, (* lokalne spremenljivke *)

  SileVozlisca = Table[SileNaVozlisce[i, Vozlisca, Povezave], {i, 1, Length[Vozlisca]}];
  DodajObremenitve[Obremenitve, SileVozlisca];
  DodajObremenitve[Podpore, SileVozlisca];
  Flatten[  (* return value *)
    Table[
      Thread[SileVozlisca[[i]] == 0],
        {i, Length[Vozlisca]}]
  ]
]

(* Generira neznanje paličja, da jih lahko uporabimo, pri reševanju zgornjega sistema *)
GenerirajNeznanke[Povezave:$PFP, Podpore:$OFP] := Module[
  {SilePalic, Neznanke}, (* lokalne spremenljivke *)

  ClearAll[F];
  SilePalic = Flatten[
    Table[
      F @@ Sort[{i, j}],
        {i, 1, Length[Povezave]}, {j, Povezave[[i]]}]
  ];

  Neznanke = Join[
    SilePalic,
    Flatten[Table[podpora[[2]], {podpora, Podpore}]]
  ];

  (*Izberemo samo neznanke, saj so lahko nekatere sile že določene s podporami*)
  (* Podpora je lahko tudi poševna. Izbrišemo morebitne podvojene neznanke.*)
  Neznanke = Select[Neznanke, Not[ValueQ[#] || NumberQ[#]] &];
  Neznanke = Union[Neznanke] (* return value *)
]

ResiPalicje[Vozlisca:$VFP, Povezave:$PFP, Podpore:$OFP, Obremenitve:$OFP] := Module[
  {enacbe, neznanke}, (* lokalne spremenljivke *)

  enacbe = GenerirajEnacbe[Vozlisca, Povezave, Podpore, Obremenitve];
  neznanke = GenerirajNeznanke[Povezave, Podpore];
  Solve[enacbe, neznanke] (* return value *)
]

(* ******** ENERGIJSKO ********** *)

(* Energijska formulacija upogiba *)

(* Vrne dolzine palic v obliki d[i, j] *)
Dolzine[Vozlisca:$VFP, Povezave:$PFP]:= Module[
  {d}, (* lokalne spremenljivke *)

  Table[
    d[i, j] = Norm[Vozlisca[[i]] - Vozlisca[[j]]];,
      {i, 1, Length[Povezave]}, {j, Povezave[[i]]}];
  d (* return value *)
]

(* vrne spremenljivko ki ima s[i,j] nastavljene na konst, če obstaja povezava ij.
   Uporabno za preseke in Youngove module *)
GenerirajKonst[Povezave:$PFP, konst_] := Module[
  {x}, (* lokalne spremenljivke *)

  Table[
    x[i, j] = konst;,
      {i, 1, Length[Povezave]}, {j, Povezave[[i]]}];
  x (* return value *)
]

(* generira vse Youngove module enake konst*)
GenerirajY[Povezave:$PFP, konst_: 200 10^9] := GenerirajKonst[Povezave, konst]
(* generira vse preseke enake konst *)
GenerirajS[Povezave:$PFP, konst_: 10^-6] := GenerirajKonst[Povezave, konst]

(* generira vse prožnostne koeficiente palic k[i, j] *)
GenerirajK[Vozlisca:$VFP, Povezave:$PFP, Y_: 200 10^9, S_: 10^-6]:= Module[
  {k, d, y, s}, (* lokalne spremenljivke *)

  d = Dolzine[Vozlisca, Povezave];
  y = If[NumberQ[Y], GenerirajKonst[Povezave, Y], Y];
  s = If[NumberQ[S], GenerirajKonst[Povezave, S], S];

  Table[
    k[i, j] = y[i, j] * s[i, j] / d[i, j];,
      {i, 1, Length[Povezave]}, {j, Povezave[[i]]}];
  k (* return value *)
]

(* Vrne neznanke za pomike vozlišč *)
GenerirajNeznankePomiki[Vozlisca:$VFP] := Flatten[Table[{px[i], py[i]}, {i, 1, Length[Vozlisca]}]]

(* Vrne vezi paličja, ki jih določajo podpore *)
GenerirajVezi[Podpore:$OFP] := Module[
  {vezi}, (* lokalne spremenljivke *)

  vezi = {}; (* podpore se ne premikajo *)
  Do[
    {i, sila} = podp;
    If[!NumberQ[sila[[1]]] || sila[[1]] != 0, AppendTo[vezi, px[i] == 0]];
    If[!NumberQ[sila[[2]]] || sila[[2]] != 0, AppendTo[vezi, py[i] == 0]];,
      {podp, Podpore}];
  vezi (* return value *)
]

(* Vrne energijski funkcional z vezmi *)
GenerirajEnergijsko[Vozlisca:$VFP, Povezave:$PFP, Obremenitve:$OFP, Y_, S_] := Module[
  {k, vi, vj, Energija, i, sila},

  d = Dolzine[Vozlisca, Povezave];
  k = GenerirajK[Vozlisca, Povezave, Y, S];
  ClearAll[px, py];

  Energija = 1/2 * Sum[ (* naš potencial *)
    Sum[
      {vi, vj} = {Vozlisca[[i]], Vozlisca[[j]]};
      k[i, j] / 2 * ( Norm[vi + {px[i], py[i]} - (vj + {px[j], py[j]})] - d[i, j] )^2,
        {j, Povezave[[i]]}],
          {i, 1, Length[Povezave]}];

  Energija -= Sum[ (* zunanje obremenitve *)
    {i, sila} = obr;
    {px[i], py[i]} . sila,
      {obr, Obremenitve}] (* return value *)
]

(* Izracuna pomike paličja *)
ResiPalicje[Vozlisca:$VFP, Povezave:$PFP, Podpore:$OFP, Obremenitve:$OFP, Y_, S_] := Module[
  {enacbe, neznanke}, (* lokalne spremenljivke *)

  If[CheckInvalidVozliscaPovezave[Vozlisca, Povezave, i], Return[$Failed]];

  enacbe = GenerirajEnergijsko[Vozlisca, Povezave, Obremenitve, Y, S];
  vezi = GenerirajVezi[Podpore];
  neznanke = GenerirajNeznankePomiki[Vozlisca];
  NMinimize[{enacbe, vezi}, neznanke] (* return value *)
]

End[]
EndPackage[]
