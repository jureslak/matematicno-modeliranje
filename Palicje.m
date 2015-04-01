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
NarisiPaliceIzVozlisca::iBounds = "`1` out of range [1, `2`]";
NarisiPaliceIzVozlisca::povezaveBounds = "Lengths of Vozlisca and Povezave differ! (`1` != `2`)";
NarisiPalice::usage = "Nariše vse palice iz danih vozlišč";
NarisiPalicje::usage = "Nariše celotno paličje podano z vozlišči in povezavami";

EnotskiVektor::usage = "Vrne enotski vektor med tocko1 in tocko2";
SileNaVozlisce::usage = "Vrne vsoto vseh sil na vozlišče, po kompomentah.";
DodajObremenitve::usage = "Doda nove sile med vse sile. Funkcija spremeni drugi argument.";
GenerirajEnacbe::usage = "Vrne sistem ravnovesnih enačb za vsa vozlišča, upoštevajoč obremenitve, podpore in notranje sile";
GenerirajNeznanke::usage = "Vrne seznam vseh uporabljenih neznank, sestavljen iz sil v palicah in podpor.";
F::usage = "Neznanka, uporabljena za notranje sile."

Begin["Private`"]

(* ******** RISANJE ********** *)

(* Funkcija  NarisiVozlisca nariše vozlišča podana s seznamom koordinat*)
NarisiVozlisca[Vozlisca_] := Graphics[{
  PointSize[Medium],
  Table[Point[Vozlisca[[k]]], {k, Length[Vozlisca]}],
  Table[
    Text[Style[k, Medium], Vozlisca[[k]], {0, 2}],
      {k, Length[Vozlisca]}]
}];

(* Funkcija nariše vozlišča palice iz i-tega vozlišča. *)
NarisiPaliceIzVozlisca[i_, Vozlisca_, Povezave_] := Module[
  {vozlisce, sosednje}, (* lokalne spremenljivke *)

  (* errors *)
  If[1 <= i <= Length[Vozlisca], Null,
    Message[NarisiPaliceIzVozlisca::iBounds, i, Length[Vozlisca]]; Return[$failed]];
  If[Length[Vozlisca] == Length[Povezave], Null,
    Message[NarisiPaliceIzVozlisca::povezaveBounds, i, Length[Vozlisca]]; Return[$failed]];

  vozlisce = Vozlisca[[i]];
  sosednje = Table[Vozlisca[[j]], {j, Povezave[[i]]}];
  Graphics[
    Table[Line[{vozlisce, sosed}], {sosed, sosednje}] (* return value *)
  ]
]

(* Nariše vse palice *)
NarisiPalice[Vozlisca_, Povezave_] :=
  Table[NarisiPaliceIzVozlisca[i, Vozlisca, Povezave], {i, Length[Vozlisca]}]

(* Funkcija nariše paličje, združi točke in povezave *)
NarisiPalicje[Vozlisca_, Povezave_] :=
  Show[NarisiVozlisca[Vozlisca], NarisiPalice[Vozlisca, Povezave]]

(* ******** STATIKA ********** *)

(* Funkcija razdeli silo v palici na kompenento v x in y smeri, vrne enotski vektor med dvema
   točkama *)
EnotskiVektor[tocka1_, tocka2_] := (tocka2 - tocka1) / Norm[tocka2 - tocka1]

(* Funkcija pomaga vrne sistem enačb v x in y smeri za
   ravnotežje sil v vozlišču i. Sile označimo z F[i, j], enačbe pa vrnemo
   in so dostopne kot Enacba[i] (če smo rezultat shranili v spr. Enacba *)
SileNaVozlisce[i_, Vozlisca_, Povezave_] := Module[
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
GenerirajEnacbe[Vozlisca_, Povezave_, Obremenitve_, Podpore_] := Module[
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
GenerirajNeznanke[Povezave_, Podpore_] := Module[
  {SilePalic, Neznanke},
  SilePalic = Flatten[
    Table[
      F @@ Sort[{i, j}],
        {i, 1, Length[Povezave]}, {j, Povezave[[i]]}]  (* yup, you can do that *)
  ];

  Neznanke = Join[
    SilePalic,
    Flatten[Table[podpora[[2]], {podpora, Podpore}]]
  ];

  (*Izberemo samo neznanke, saj so lahko nekatere sile že določene s podporami*)
  (* Podpora je lahko tudi poševna.Izbrišemo morebitne podvojene neznanke.*)
  Neznanke = Select[Neznanke, Not[ValueQ[#] || NumberQ[#]] &];
  Neznanke = Union[Neznanke] (* return value *)
]

(* ******** ENERGIJSKO ********** *)

(*

(* Energijska formulacija upogiba *)
GenerirajDol[Vozlisca_, Povezave_, d_]:=Module[{},
    GenDolzine[$i_] := Module[{n, j, sos},  n = Length[Povezave[[$i]]];
     Do[sos = Povezave[[$i, j]]; If[$i < sos,
       d[$i, sos] = Norm[Vozlisca[[$i]] - Vozlisca[[sos]]]; ] ,
        {j, n}];];
           Do[ GenDolzine[i], {i, Length[Povezave]} ];
]

(*Nastavi vse Youngove module palic Y[i,j] na konst*)
GenerirajY[konst_: 200 10^9, Y_: Y, Povezave_: Povezave] :=
 Module[{},
  GenY[$i_] := Module[{n, j, sos}, n = Length[Povezave[[$i]]];
    Do[sos = Povezave[[$i, j]];
     If[$i < sos, Y[$i, sos] = konst;], {j, n}];];
  Do[GenY[i], {i, Length[Povezave]}];]
  (*Nastavi vse preseke palic S[i,j] na konst*)
GenerirajS[konst_: 10^-6, S_: S, Povezave_: Povezave] :=
 Module[{},
  GenS[$i_] := Module[{n, j, sos}, n = Length[Povezave[[$i]]];
    Do[sos = Povezave[[$i, j]];
     If[$i < sos, S[$i, sos] = konst;], {j, n}];];
  Do[GenS[i], {i, Length[Povezave]}];]
(* zgenerira vse prožnostne koeficiente palic k[i, j] *)
GenerirajK[Vozlisca_, Povezave_, Y_, S_, d_, k_]:= Module[{},
    GenK[$i_] := Module[{n, j, sos},  n = Length[Povezave[[$i]]];
     Do[sos = Povezave[[$i, j]]; If[$i < sos,
       k[$i, sos] = Y[$i, sos] * S[$i, sos]/d[$i, sos]; ] ,
           {j, n}];];
           Do[ GenK[i], {i, Length[Povezave]} ];
]


TrojiceToVred[Trojice_, out_]:=Do[out[Trojice[[i, 1]], Trojice[[i, 2]]]=Trojice[[i, 3]], {i, Length[Trojice]}]
SosedSeznamToTroj[Povezave_, vre_:1]:=Module[{razp = {}},
    GenTroj[$i_] := Module[{n}, n = Length[Povezave[[$i]]];
          Do[
               If[$i < Povezave[[$i, j]], AppendTo[razp, {$i, Povezave[[$i, j]], vre}]],
           {j, n}]; ];
      Do[ GenTroj[i], {i, Length[Povezave]} ];
    razp
]


GenerirajEnergijsko[Vozlisca_, Povezave_, Podpore_, Obremenitve_,  Y_, S_] :=
 Module[{k, d}, Energija = 0;
     GenerirajDol[Vozlisca, Povezave, d];
     GenerirajK[Vozlisca, Povezave, Y, S, d, k];
         GenE[$i_] := Module[{n, j, sos},  n = Length[Povezave[[$i]]];
     Do[sos = Povezave[[$i, j]]; If[$i < sos,
       Energija = Energija +  k[$i, sos]/2 *    (Norm[Vozlisca[[$i]] + {px[$i], py[$i]} - Vozlisca[[sos]] - {px[sos], py[sos]}] - d[$i, sos])^2        ], {j, n}]];
       Do[ GenE[i], {i, Length[Povezave]} ];
           GenEObr[$ind_] := Module[{i, sila},
               i =    Obremenitve[[$ind, 1]];
               sila = Obremenitve[[$ind, 2]];
            Energija = Energija - {px[i], py[i]}.sila;
        ];
        Do[GenEObr[i], {i, Length[Obremenitve]}];
        Vezi = {};
        (* Sprehod po podporah in generacija vezi *)
        GenVezi[$i_] := Module[{n},(
            n=Length[Position[{Podpore[[$i,2,1]]},0]];
            If[n == 0,AppendTo[Vezi,px[Podpore[[$i,1]]]== 0]];
            n=Length[Position[{Podpore[[$i,2,2]]},0]];
            If[n == 0,AppendTo[Vezi,py[Podpore[[$i,1]]]== 0]];
        )];
        Do[GenVezi[i], {i, 1, Length[Podpore]}];
        pomiki = Table[{px[i], py[i]}, {i, 1, Length[Vozlisca]}]//Flatten;
        NMinimize[Join[{Energija}, Vezi],  pomiki]
]

*)

End[]
EndPackage[]
