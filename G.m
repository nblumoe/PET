(* Name: G`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package calculates thermodynamic functions of a phase (G, H, S, V, cp) *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["G`",{"DEFDAT`","FLUIDS`"}]

MinDat::usage = 
"MinDat[min] reads thermodynamic data of the phase <min>.
Mineral abbreviations as returned by MinList[] must be used for proper phase identification.\n
--------------------------------------------------------------------------------------------------
Berman (1988) data set (file THDATB.m):
The data have been transformed from the TWEEQ file \"jan92.rgb\" and have a similar structure.
Data appear as a list for each phase-component, consisting of the elements:\n
{{\"PHASE_COMPONENT_NAME\", abbreviation, \"chemistry\",\"mineral-group (optional, may be empty string)\"},
{ST    (standard state properties), G,  H,  S,  V,  number (units: [J/mol], [J/mol], [J/(mol.K)], [J/bar])},
{C1     (coefficients for cp-term), ko, k1, k2, k3, number},
{V1 (coefficients for volume-term), v3, v4, v1, v2, number}}\n
Additional terms that may appear are:
{C2  (additional cp-coefficients), k4, k5, number, number, number}
{C3 (Maier-Kelly cp-coefficients), ko, k5, k2,     number, number}\n
See G::usage for more details on the form of cp-equation, volume equation, etc.
Special case phases are:
lambda-transitions: ak, crst, hem, kal, lc, mt, ne, qz, try
order/disorder:     ab, dol, geh, kf
(for these phases there appear additional terms labeled T1, T2, T3 and D1, D2;
see TWEEQ documentation for more details on the meaning of these terms).\n
Example for muscovite: MinDat[mu]
{{\"MUSCOVITE\", mu, \"K(1)AL(3)SI(3)O(12)H(2)\",\"wm\"},
{ST, (-5.599784*^6),(-5.97674012*^6), 293.1567, 14.087, 1.},
{C1, 651.48926, (-3873.229), (-1.85232*^7), 2.742469376*^9, 0.},
{V1, 3.35273302, 0., (-0.17169021), 0.00042947, 0.}})\n
--------------------------------------------------------------------------------------------------
Holland & Powell (1998) data set (file THDATHP*.m):
The data have been transformed from the THERMOCALC_3.* file \"th.pd\".
Data appear as a list for each phase-component, consisting of the elements:\n
{{\"PHASE_COMPONENT_NAME\", abbreviation, \"chemistry\",\"mineral-group (optional, may be empty string)\"},
{H [J/mol],  S [J/(mol.K)],  V [J/bar]},
{coefficients for cp-term: a, b, c, d},
{parameters for volume-term: ao, a1}}\n
A fifth term that may appear is for special case phases:
order/disorder- or lambda transition phases:
{T(c0), Smax, Vmax}
aqueous species:
{cpo}
See Holland & Powell (1998) for the meaning of these parameters.
Example for muscovite: MinDat[mu]
{{\"MUSCOVITE\", mu, \"K(1)AL(3)SI(3)O(12)H(2)\",\"wm\"},
{(-5.98419*^6), 292., 14.083},
{756.4, -0.01984, -2.17*^6, -6979.2},
{0.0000596, 490000.}}\n
--------------------------------------------------------------------------------------------------
Gottschalk (1997) data set (file THDATG.m):
The data have been transformed from the file conset-tab.txt (downloaded from http://www.gfz-potsdam.de/pb4/pg1/dataset/).
Data appear as a list for each phase-component, consisting of the elements:\n
{{\"PHASE_COMPONENT_NAME\", abbreviation, \"chemistry\",\"mineral-group (optional, may be empty string)\"},
{H [kJ/mol],  S [J/(mol.K)],  V [1/(MPa.mol)]},
{{coefficients for cp-term: Tmin, Tmax, a, b, c, d, e, f, g},...},
{parameters for volume-term: ao, a1, bo, b1}}\n
See Gottschalk (1997) for the meaning of these parameters.
{{\"MUSCOVITE \", mu, \"K(1)Al(3)Si(3)O(12)H(2)\", \"wm\"},
{-5987.024, 287.199, 140.71},
{{298, 1000, 917.67, -0.08111, 0., -10348., 0., 2.8341*^6, 0.},
 {1000, 1800, 651.49, 0., 0., -3873.2, 0., -1.85232*^7, 2.74247*^9}},
{0.000032, 0., 0.000012, 0.}}\n
Called from: User, -G-, -GB-, -GHP-, -GGot-.
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

MinList::usage = "MinList[] gives an alphabetical list of the available phases
in the thermodynamic data file in the form:
{MINERAL_NAME, abbreviation}.
The abbreviation for each phase (written in lower case) must be used exactly as shown.
Example: {MUSCOVITE, mu}.
Called from: User.
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GOrdAb::usage = "GOrdAb[T(K)] calculates order parameters for albite as f(T) according to
Salje et al (1985): Phys Chem Miner 12:99-107.
Returned is a five-element list:
{F(order), U(order), S(order), q(displacive), q(order)}.
Example: GOrdAb[1000].
{-185.07, -1992.02, -1.80695, 0.575637, 0.20586}.
Called from: -GOrd- (Berman data set).
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

DGordAbDt::usage = "Help-function for -CpOrdAb-."
CpordAb::usage = "CpordAb[T(K)] calculates order-related heat capacity effects for albite as f(T) according to
Salje et al (1985): Phys Chem Miner 12:99-107.
ReturnValue: cp(order).
Example: CpOrdAb[1000].
19.7758.
Called from: -GOrd- (Berman data set).
Calls: -DGOrdAbDt-.
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GOrd::usage = "GOrd[min, P(bar), T(K), {order/disorder parameters}]
calculates order/disorder-related thermodynamic properties (Berman data set).
Special case phases are: ab, dol, geh, kf
Returned is a 7-element list:
{G((dis)order), H((dis)order), S((dis)order), V((dis)order), cp((dis)order), q(displacive for ab), q((dis)order for ab)}.
Parameters are calculated as decribed by Berman (1988): J Petrology 29:445-522, p.451-452
(except albite; parameters calculated according to Salje et al (1985): Phys Chem Miner 12:99-107).
Called from: -GB-.
Calls: -GOrdAb-, -CpOrdAb-.
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

Gl::usage = "help-function for -GB-: calculates G(lambda)
needed to calculate V(lambda) (Berman data set)
from the relationship: V(lambda) = d(G(lambda))/dP."

GLandau::usage = "GLandau[min, P(bar), T(K), {ao, a1, T(c0), Smax, Vmax}]
calculates order/disorder- and lambda transition-related thermodynamic properties
of the phase <min> at P and T (Holland & Powell data set; see Holland & Powell (1998), p.312, for more details).
{ao, a1, T(c0), Smax, Vmax} are volume (first two) and transition-specific parameters.
ReturnValue: {G(Landau), H(Landau), S(Landau), V(Landau), cp(Landau), q(Landau)}.
Example for albite at t = 900 (C) and P = 1 bar: 
GLandau[ab, 1, 900, Flatten[Take[MinDat[ab], {4, 5}]]]
{-2339.38, -3426.21, -3.67092, 0.104341, 0.104341, 33.0332, 0.478991}
Called from: -GHP-.
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

G::usage = "G[min, P(bar), T(K)] calculates thermodynamic functions of a phase.
<min> is the phase abbreviation as returned by MinList[].
The RTlnf-term for fluids is appended (see Fugacity::usage for more details).\n
The following data sets are available,                activated with the function -Dataset-:\n
Berman (1988) J Petrol 29: 445-522                    Dataset[Dataset -> B88]
Holland & Powell (1998) J metam Geol 16:309-343       Dataset[Dataset -> HP31], or
                                                      Dataset[Dataset -> HP32]
Gottschalk (1997) Eur J Mineral 9: 175-223            Dataset[Dataset -> G97]\n
The Berman (1988) data set has been transformed from the TWEEQ-file \"jan92.rgb\".
\"31\" or \"32\" following \"HP\" indicates that the thermodynamic data have been
converted from the file \"th.pd\" of THERMOCALC-versions 3.1 or 3.2 respectively. 
The Gottschalk (1997) data set has been transformed from the file \"conset-tab.txt\"
(downloaded from http://www.gfz-potsdam.de/pb4/pg1/dataset/)
The following option is available with -G-:\n
Name           value           meaning\n
ReturnValue -> G (default)     G = H[1,298] + Int[cp]dT -T (S[1,298] +  Int[cp/T]dT) + Int[V]dP
               H               H(T) = H[1,298] + Int[cp]dT
               S               S(T) = S[1,298] + Int[cp/T]dT
               Vint            Int[V]dP + V(disorder) (Berman data set)
                               Int[V]dP + Int[V(Landau)]dP (Holland & Powell data set)
               V               V(P,T) = V[1,298](1+v1(P-1)+v2(P-1)^2+v3(T-298)+v4(T-298)^2)+V(lambda) (Berman data set)
                               V(P,T) + V(Landau) (Holland & Powell data set)
                               V(P,T) = V[1,298]Exp[a1(T-298)-b1*P] (Gottschalk data set)
               Cp              cp(T) = ko + k1 T^-0.5 + k2 T^-2 + k3 T^-3 + k4 T^-1 + k5 T
                                       + cp(lambda) + cp(disorder) (Berman data set)
                               cp(T) = a + b T + c T^-2 + d T^(-1/2) + cp(Landau) (Holland & Powell data set)
                               cp(T) = a + b T + c T^2 + d T^(-0.5) + e/T + f/T^2 + g/T^3 (Gottschalk data set)\n
See Berman (1988), Holland & Powell (1998) and Gottschalk (1997) for more details
(lambda transitional terms, order/disorder terms, etc.)
Example 1 (Berman data set): G[mu, 5000, 773]
ReturnValue: -6.2343308024*10^6
Example 2 (Berman data set): G[mu, 5000, 773, ReturnValue->Cp]
ReturnValue: 487.117
Called from: -Dgr-, User.
Calls: -MinDat-, -GOrd-, -Gl-, -RTlnf- (Berman data set),
       -GLandau-, -GAqueousSpecies-, -RTlnf- (Holland & Powell data set),
       -GGot- ((Gottschalk data set)).
Package name: G.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

ReturnValue::usage = "ReturnValue is an option of -G-."

Begin["`Private`"]

LoadDataset[file_] := LoadDataset[file] = Get[file]

MinDat[min_] := Block[{minl=min,dat,fname,pos},
	(* read data for the phase "min" from the thermodynamic data file *)
	If[ToString[Options[Dataset][[1, 2]]] == "B88", fname = "THDATB.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "HP31", fname = "THDATHP31.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "HP32", fname = "THDATHP32.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "G97", fname = "THDATG.m"];
	dat = LoadDataset[fname];
	pos = Position[dat,minl];
	If[pos == {}, Return[-1]];
	Return[dat[[pos[[1,1]]]]];
    ]

MinList[] := Block[{dat,fname,i,min,abk},
	(* give a complete list of phases and their abbreviations in the thermodynamic data file "THDAT.m"  *)
	If[ToString[Options[Dataset][[1, 2]]] == "B88", fname = "THDATB.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "HP31", fname = "THDATHP31.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "HP32", fname = "THDATHP32.m"];
	If[ToString[Options[Dataset][[1, 2]]] == "G97", fname = "THDATG.m"];
	dat = Get[fname];
	min = abk = Table[0,{i,1,Dimensions[dat][[1]]}];
	For[i=1,i<=Dimensions[dat][[1]],i++,
	   min[[i]] = dat[[i,1,1]];
	   abk[[i]] = dat[[i,1,2]];
	];
	Return[Sort[Transpose[{min,abk}]]]]

(* --------------------------- functions for Berman data set ----------------------------------- *)

GOrdAb[t_] := Block[{tc=1251,ao=5.479,b=6854,do=-2.171,d1=-3.043,d2=-1.569 10^-3,d3=2.109 10^-6,
	aodo=41.62,tcod=824.1,bod=-9.301 10^3,cod=4.36 10^4,a,d,aod,res,q,qod,hintd,sintd},
	(* Calculate order parameters for albite: Salje et al (1985): Phys Chem Miner 12:99-107  *)
	a=ao(t-tc);
	d = do + d1 t + d2 t^2 + d3 t^3;
	aod=aodo(t-tcod);
	res = FindRoot[{a q + b q^3 + d qod == 0, aod qod + bod qod^3 + cod qod^5 + d q == 0},
		  {q,0.7},{qod,0.99},MaxIterations->50];
	q = res[[1,2]];
	qod = res[[2,2]];
	hintd = -0.5 ao tc q^2 + 0.25 b q^4-0.5 aodo tcod qod^2+.25 bod qod^4+1/6 cod qod^6+
			(do-d2 t^2-2d3 t^3)q qod;
	sintd = -(0.5 ao q^2+0.5 aodo qod^2+(d1+2d2 t+3d3 t^2)q qod);
	Return[{Chop[N[hintd-t sintd]],Chop[N[hintd]],Chop[N[sintd]],N[q],N[qod]}];
]

DGordAbDt[t_] := Block[{d,t1,t2,f1,f2,dt=10^-4},
	(* help-function for "CpOrdAb" *)
	t1 = t+dt;
	t2 = t-dt;
	f1 = GOrdAb[t1][[1]];
	f2 = GOrdAb[t2][[1]];
	d = (f2-f1)/(2dt);
	Return[d]
]

CpOrdAb[t_] := Block[{d,t1,t2,f1,f2,dt=10^-4},
	(* calculate cp(order) for albite from the relation: cp(order)= -T(d2 G(order)/T^2)  *)
	t1 = t+dt;
	t2 = t-dt;
	f1 = DGordAbDt[t1];
	f2 = DGordAbDt[t2];
	d = (f2-f1)/(2dt);
	Return[(-t)d]
]

GOrd[min_,p_,t_,d_] := 
	Block[{td=0,tref,do,d1,d2,d3,d4,d5,d6,cpd=0,hintd=0,sintd=0,vd=0,gd=0,gd1=0,pr=1,q=0,qod=0},
	(* calculate order/disorder related parameters: dol, geh, kf, ab  *)

      	If[min == ToExpression["kf"] || min == ToExpression["dol"] || min == ToExpression["geh"],
	  (* order/disorder: for K-feldspar, dolomite and gehlenite *)
          {td,tref,do,d1,d2,d3,d4,d5,d6} = d;	
          If[t >= tref && t <= td, cpd = do + d1 t^(-0.5)+d2 t^-2+d3 t^-1+d4 t+d5 t^2];
	  If[t >= tref && t <= td,
	    hintd = d3(Log[t]-Log[tref]) - d2(1/t-1/tref) + 2.*d1*(t^0.5-tref^0.5) + 
	            do*(t-tref) + d4/2(t^2-tref^2) + d5/3(t^3-tref^3);
            sintd = -d3(1/t-1/tref) - d2/2(1/t^2-1/tref^2) - (2.*d1)(1/t^0.5-1/tref^0.5) + 
	            d4*(t-tref) + d5/2(t^2-tref^2) + do(Log[t]-Log[tref]);
	    gd = hintd - t sintd;
	    ];
	  If[t > td,
	    hintd = d3(Log[td]-Log[tref]) - d2(1/td-1/tref) + 2.*d1*(td^0.5-tref^0.5) + 
	            do*(td-tref) + d4/2(td^2-tref^2) + d5/3(td^3-tref^3);
	    sintd = -d3(1/td-1/tref) - d2/2(1/td^2-1/tref^2) - (2.*d1)(1/td^0.5-1/tref^0.5) + 
	             d4*(td-tref) + d5/2(td^2-tref^2) + do(Log[td]-Log[tref]);
	    gd1 = (td-t)sintd;
	    gd = hintd - td sintd + gd1;
	    ];
	    If[d6 != 0, vd = hintd/d6 (p-pr)];
	    ];
	If[min == ToExpression["ab"], (* order/disorder: albite *)
	  {gd,hintd,sintd,q,qod} = GOrdAb[t];
          cpd = CpOrdAb[t];
          ];

	Return[{gd,hintd,sintd,vd,cpd,q,qod}];
]

Gl[p_,t_,tl1bar_,tref_,l1_,l2_,k_] := Block[{tlp,td,tlr,cpl,hl,sl,gl=0,tt},
	(* calculate G(lambda) for a-Quarz and cristobalite: needed to calculate V(lambda) from d(G(lambda))/dP  *)
	tlp = tl1bar+k(p-1); td = tl1bar - tlp; tlr = tref-td;	    
	cpl = (tt+td)(l1+l2(tt+td))^2;
	hl = Integrate[cpl,{tt,tlr,t}];    			
	sl = Integrate[cpl/tt,{tt,tlr,t}]; 
	gl = hl - t sl;
	Return[gl];
]

GB[min_,p_,t_,rv_] :=
	Block[{tr=298.15,pr=1,l,dum,h,s,v,pos,pos1,ko=0,k1=0,k2=0,k3=0,k4=0,k5=0,v1=0,v2=0,v3=0,v4=0,tl1bar=0,
	tref=0,l1=0,l2=0,do=0,d1=0,d2=0,d3=0,d4=0,d5=0,d6=0,td=0,tl2=0,ht2=0,
	opt={G`G,G`H,G`S,G`Vint,G`V,G`Cp},hint,sint,vint,vpt,g,tlp,tlr,
	k=0,cpl=0,hintl=0,sintl=0,gl=0,vl=0,ht=0,st=0,
	gd,hintd=0,sintd=0,vd=0,cpd=0,q,qod,hpt,spt,rtlnf=0,
	specials = {"bdy","hem","kal","lc","mt","try","ak","crst","qz","dol","geh","kf","ab","ne","co2","h2o","o2","s2","h2","zrc"}},
	
	l = MinDat[min];
	If[l == -1, Return[-1]]; 
	(* data reading and assignements *)
	{dum,dum,h,s,v,dum} = l[[2]]; 		(* h, s, v:   H, S, V, standard values *)
	pos = Position[specials,ToString[min]];	(* find out if min is a special case phase  *)
	
	If[pos == {}, (* STD, C1, V1: min is a normal phase (exception: gl) *)
	  {dum,ko,k1,k2,k3,dum} = l[[3]];	(* C1: ko, k1, k2, k3: coefficients for cp  *)
	  {dum,v3,v4,v1,v2,dum} = l[[4]];	(* V1: v3, v4, v1, v2: volume parameters	*)
	  If[min == ToExpression["gl"], {{dum,k4,k5,dum,dum,dum}, {dum,v3,v4,v1,v2,dum}} = {l[[4]],l[[5]]} ];
	  ];	
	If[pos != {}, (* special case phases *)
	  pos1 = pos[[1,1]]; 
	  If[pos1 == 1 (* bdy *), {{dum,ko,k1,k2,k3,dum},{dum,tl1bar,tref,l1,l2,ht}} = {l[[3]],l[[4]]} ];
	  If[pos1 >= 2 && pos1 <= 7 (* lambda transitions: C1, V1, T1: hem, kal, lc, mt, try, ak  *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,v3,v4,v1,v2,dum},{dum,tl1bar,tref,l1,l2,ht}} = {l[[3]],l[[4]],l[[5]]}];
	  If[pos1 == 8 || pos1 == 9 (* lambda transitions: C1, V1, T1, T2: crst, qz  *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,v3,v4,v1,v2,dum},{dum,tl1bar,tref,l1,l2,ht},{dum,k,dum,dum,dum,dum}} = {l[[3]],l[[4]],l[[5]],l[[6]]}];
	  If[pos1 >= 10 && pos1 <= 12 (* order/disorder: C1, V1, D1, D2: dol, geh, kf *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,v3,v4,v1,v2,dum},{dum,do,d1,d2,d3,dum},{dum,d4,d5,tref,td,d6}} = {l[[3]],l[[4]],l[[5]],l[[6]]}];
	  If[pos1 == 13 (* order/disorder: C1, V1, D1: ab  *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,v3,v4,v1,v2,dum},{dum,do,d1,d2,d3,dum}} = {l[[3]],l[[4]],l[[5]]}];
	  If[pos1 == 14 (* lambda transition: C1, V1, T1, T3: ne  *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,v3,v4,v1,v2,dum},{dum,tl1bar,tref,l1,l2,ht},{dum,tl2,tref,dum,dum,ht2}} = {l[[3]],l[[4]],l[[5]],l[[6]]}];
	  If[pos1 >= 15 && pos1 <= 17 (* gases: C1, C2: co2, h2o, o2  *), 
	    {{dum,ko,k1,k2,k3,dum},{dum,k4,k5,dum,dum,dum}} = {l[[3]],l[[4]]}];
	  If[pos1 >= 18 && pos1 <= 19 (* gases: C3: s2, h2  *), {dum,ko,k5,k2,dum,dum} = l[[3]]];	  
	  If[pos1 == 20 (* C1: zircon  *), {dum,ko,k1,k2,k3,dum} = l[[3]]];	  
	  ];
	  	
	(* calculation of the G-function *)
	hint = ko(t-tr)+2k1(t^0.5-tr^0.5)-k2(t^-1-tr^-1)-0.5 k3(t^-2-tr^-2)+
               0.5 k5(t^2-tr^2)+k4(Log[t]-Log[tr]);					(* H Integral *)
	sint = ko(Log[t]-Log[tr])-2k1(t^-0.5-tr^-0.5)-0.5 k2(t^-2-tr^-2)-(k3/3)(t^-3-tr^-3)+
               k5(t-tr)-k4(t^-1-tr^-1);							(* S Integral *)
	v1 = v1*10^-5; v2 = v2*10^-8; v3 = v3*10^-5; v4 = v4*10^-5;
	vint = v(v1/2(p-pr)^2+v2/3(p-pr)^3+(p-pr)(1+v3(t-tr)+v4(t-tr)^2)); 		(* V Integral *)
	vpt = v(1+v1(p-pr)+v2(p-pr)^2+v3(t-tr)+v4(t-tr)^2);				(* V as f(P,T) *)

	g = h + hint - t(s+sint) + vint;						(* G as f(P,T)  *)

	If[pos != {}, (* special case phases *)
       	  (* lambda transitions: bdy, hem, kal, lc, mt, try, ak, crst, qz, ne  *) 	  
  	  If[pos1 >= 1 && pos1 <= 9 || pos1 == 14,  	    	          	    
       	    tlp = tl1bar+k(p-1); td = tl1bar - tlp; tlr = tref-td;
     	    If[t <= tlp,
	      cpl = (t+td)(l1+l2(t+td))^2; 
	      hintl = (l2^2*(t^4-tlr^4))/4 + (t-tlr)*td*(l1 + l2*td)^2 + (l2*(t^3-tlr^3)*(2*l1 + 3*l2*td))/3 + 
  	  	      ((t^2-tlr^2)*(l1^2 + 4*l1*l2*td + 3*l2^2*td^2))/2;
	      sintl = (l2^2*(t^3-tlr^3))/3 + (l2*(t^2-tlr^2)*(2*l1 + 3*l2*td))/2 + 
		      (t-tlr)*(l1^2 + 4*l1*l2*td + 3*l2^2*td^2) + (l1^2*td + 2*l1*l2*td^2 + l2^2*td^3)*(Log[t]-Log[tlr]);
	      gl = hintl - t sintl;
	      g = g + gl;
	      If[G`ReturnValue == G`V, (* V(lambda)  *)
  	        vl = (Gl[p+10^-6,t,tl1bar,tref,l1,l2,k]-Gl[p-10^-6,t,tl1bar,tref,l1,l2,k])/(2 10^-6);
  		];
  	      ];
    	    If[t > tlp,
	      hintl = (l2^2*(tlp^4-tlr^4))/4 + (tlp-tlr)*td*(l1 + l2*td)^2 + (l2*(tlp^3-tlr^3)*(2*l1 + 3*l2*td))/3 + 
  	  	      ((tlp^2-tlr^2)*(l1^2 + 4*l1*l2*td + 3*l2^2*td^2))/2;
	      sintl = (l2^2*(tlp^3-tlr^3))/3 + (l2*(tlp^2-tlr^2)*(2*l1 + 3*l2*td))/2 + 
		      (tlp-tlr)*(l1^2 + 4*l1*l2*td + 3*l2^2*td^2) + (l1^2*td + 2*l1*l2*td^2 + l2^2*td^3)*(Log[tlp]-Log[tlr]);
	      If[min == ToExpression["qz"] || min == ToExpression["crst"],
          	gl = hintl - t (sintl);
          	g = g + gl;
          	If[G`ReturnValue == G`V, (* volume *)
    		  If[min == ToExpression["qz"], l = MinDat[ToExpression["qzb"]] ];
    		  If[min == ToExpression["crst"], l = MinDat[ToExpression["crstb"]] ];
	  	  {dum,v3,v4,v1,v2,dum} = l[[4]]; v = l[[2,5]];
		  v1 = v1*10^-5; v2 = v2*10^-8; v3 = v3*10^-5; v4 = v4*10^-5;	  	  
		  vpt = v(1+v1(p-pr)+v2(p-pr)^2+v3(t-tr)+v4(t-tr)^2);	
          	  ];
          	]; 	    
		If[min == ToExpression["try"] || min == ToExpression["mt"] || min == ToExpression["hem"] || 
		  min == ToExpression["ak"] || min == ToExpression["kal"] || min == ToExpression["lc"] || min == ToExpression["ne"],
      	  	  st = ht/tlp;
          	  gl = hintl - tlp (sintl);
    	  	  g = g - (t-tlp)(sintl+st) + gl;
    	  	  If[min == ToExpression["ne"] && t > tl2, (* second lambda-transition of ne *)
	    	    g = g - (t-tl2)ht2/tl2;     	    
    	    	    ];
    	 	  ];         	    
	        ];
	    ];

	  (* order/disorder: for K-feldspar, albite, dolomite and gehlenite *)
	  If[min == ToExpression["ab"] || min == ToExpression["kf"] || min == ToExpression["dol"] || min == ToExpression["geh"],
	    {gd,hintd,sintd,vd,cpd,q,qod} = GOrd[min,p,t,{td,tref,do,d1,d2,d3,d4,d5,d6}];
	    g = g + gd + vd;
	    ];
	  ];
	
	hpt = h + hint + hintl + hintd;				(* H as f(P,T) *)
	spt = s + sint + sintl + sintd;				(* S as f(P,T) *) 
   	cp = ko+k1 t^-0.5+k2 t^-2+k3 t^-3+k4 t^-1+k5 t+cpl+cpd;	(* cp as f(T)  *)

	If[l[[1,4]] == "fluid", rtlnf = RTlnf[min,p,t,RTlnfReturnValue->RTlnf,RTlnfModel -> HaarEtAl84]];
	
	If[rv == G`G,    Return[g+rtlnf]]; (* RTlnf-term for pure fluids appended  *)  
	If[rv == G`H,    Return[hpt]];   
	If[rv == G`S,    Return[spt]];   	
	If[rv == G`Vint, Return[vint+vd]];   
	If[rv == G`V,    Return[vpt+vl+rtlnf/10]]; (* volume in J/bar *) 
	If[rv == G`Cp,   Return[cp]];  
]

(* --------------------------- functions for Holland & Powell data set ----------------------------------- *)

GLandau[min_,p_,t_,par_] := 
	Block[{ao,a1,tco,smax,vmax,tc,q298=0,tr=298.15,h298=0,s298=0,q=0,kappao=a1,kappa,
	cpd=0,vd=0,vintd=0,hexL=0,sexL=0,gd=0,hd=0,sd=0,gland},
	(* calculate order/disorder related contributions to the G-function: see HP98, p.312  *)
	{ao,a1,tco,smax,vmax} = par; 
	tc = tco + vmax/smax p;				(* P-dependence of Tc *)
	q298 = (1-tr/tco)^(1/4); 
	h298 = smax tco (q298^2 -1/3 q298^6);
	s298 = smax q298^2;

	If[t < tc, q = (1-t/tc)^(1/4);
	  kappa = kappao (1-1.5 10^-4 (t-tr));		(* T-dependence of kappa *)
	  cpd = (smax t)/(2 tc^0.5)(tc-t)^(-0.5);	(* cp-disorder *)
	  vd = vmax q298^2 (1+ao (t-tr)-20ao (t^0.5-tr^0.5)); 
	  vintd = 1/3 kappa vd ((1+4p/kappa)^(3/4)-1);
	  hexL = -smax*tc*q^2 + (1/3)tc*smax*q^6;	(* Landau-Enthalpy Term *)
	  sexL = -smax*q^2;				(* Landau-Entropy Term *)
	  hd = h298 + hexL;
	  sd = s298 + sexL;
	  gd = hd - t sd + vintd;
	  ];	  
	If[t >= tc,
	  vd = vmax q298^2 (1+ao (t-tr)-20ao (t^0.5-tr^0.5));
	  kappa = kappao (1-1.5 10^-4 (t-tr));	  
  	  vintd = 1/3 kappa vd ((1+4p/kappa)^(3/4)-1);
	  hd = h298;
	  sd = s298;  	  
	  gd = hd - t sd + vintd;
	  ]; 
	Return[{gd,hd,sd,vintd,vd,cpd,q}];
]

GAqueousSpecies[min_,p_,t_,par_] := Block[{tr=298.15,h,s,v,a,b,c,d,cpo,cps,ao=25.93*10^-5,bo=45.23*10^-6,
	dadt=9.5714*10^-6,roo=0.997,ro,flag,ts,g},
	{h,s,v,a,b,c,d,cpo} = par;
	cps = cpo - tr b;
	If[t < 673, flag = 3, flag = 1];
	ro = 18.015/(10*Vh2o[p,t,flag][[1]]); (* density of H2O at P and T  *)
	If[t < 500, ts = t, ts = 500];
	g = h - t*s + p*v + b(tr*t-(tr^2)/2-(t^2)/2)+cps/(tr*dadt)(ao(t-tr)-bo*p + (t/ts)Log[ro/roo]);
	Return[g];	
]

GHP[min_,p_,t_,rv_] :=
	Block[{opt={G`G,G`H,G`S,G`Vint,G`V,G`Cp},l,h,s,v,a,b,c,d,ao,a1,flag,tco,smax,vmax,cpo,tr=298.15,pr=1,hint,sint,vint=0,
	v1t,kapat,vpt=0,g=0,gd=0,hd=0,sd=0,vintd=0,vd=0,cpd=0,q,rtlnf=0},

	l = MinDat[min];
	If[l == -1, Return[-1]]; 
	
	(* variable assignements  *)
	(* h, s, v: standard enthalpy, -entropy and -volume; a, b, c, d: cp-coefficients; ao, a1: volume parameters *) 
	{{h,s,v},{a,b,c,d},{ao,a1}}= {l[[2]],l[[3]],l[[4]]};
	If[Dimensions[l][[1]] == 5, (* special case phases *)
	  If[Dimensions[l[[5]]][[1]] == 3, flag = 1; {tco,smax,vmax} = l[[5]]];
	  If[Dimensions[l[[5]]][[1]] == 1, flag = 2; {cpo} = l[[5]]];
	  ];

	(* calculation of the G-function *)
	hint = a*(t-tr)+0.5*b(t^2-tr^2)-c(t^-1-tr^-1)+2d(t^0.5-tr^0.5);		(* H Integral *)
	sint = a(Log[t]-Log[tr])+b(t-tr)-0.5c(t^-2-tr^-2)-2d(t^-0.5-tr^-0.5);	(* S Integral *)
	v1t = v(1+ao(t-tr)-20ao(t^0.5-tr^0.5));					(* V (1,T)	*)
	kapat = a1(1-1.5 10^-4(t-tr));						(* kapa (T)	*)
	If[kapat != 0, 
	  vint = v1t kapat/3 ((1+4p/kapat)^(3/4)-1);				(* V Integral 	*)
	  vpt = v1t(1-4p/(kapat+4p))^(1/4)];					(* V as f(P,T)	*)
	g = h + hint - t(s+sint) + vint;					(* G as f(P,T)  *)

	If[flag == 1, (* order/disorder- or lambda-transition phases *)
	  {gd,hd,sd,vintd,vd,cpd,q} = GLandau[min,p,t,{ao,a1,tco,smax,vmax}];
	  g = g + gd;
	  ];
	If[flag == 2, (* aqueous species *)
	  g = GAqueousSpecies[min,p,t,{h,s,v,a,b,c,d,cpo}];
	  ];

	hpt = h + hint + hd;				(* H as f(P,T) *)
	spt = s + sint + sd;				(* S as f(P,T) *) 
   	cp = a + b*t + c*t^-2 + d*t^(-1/2) + cpd;	(* cp as f(T)  *)
	
	If[l[[1,4]] == "fluid", rtlnf = RTlnf[min,p,t,RTlnfReturnValue->RTlnf,RTlnfModel -> HollandPowell91]];

	If[rv == G`G,    Return[g+rtlnf]];   
	If[rv == G`H,    Return[hpt]];   
	If[rv == G`S,    Return[spt]];   	
	If[rv == G`Vint, Return[vint+vintd]];   
	If[rv == G`V,    Return[vpt+vd]];  
	If[rv == G`Cp,   Return[cp]];  
]

(* --------------------------- functions for Gottschalk data set ----------------------------------- *)
GGot[min_,p_,t_,rv_] :=
	Block[{opt={G`G,G`H,G`S,G`Vint,G`V,G`Cp},l,ho,so,vo,go,cp,cp1,tmax,nt,t1,t2,a,b,c,d,e,f,g,st=0,su,vu,hint=0,
	sint=0,cpint=0,vint=0,gpt,mpa,vpt=0,pr=1,mpa2,vu1=0,rtlnf=0},

	l = MinDat[min];
	If[l == -1, Return[-1]]; 
	
	(* variable assignements  *)
	(* {ho,so,vo}: standard enthalpy, -entropy and -volume, cp: cp-coefficients, {a1,a2,b1,b2}: thermal expansion- and compressibility coefficients *) 
	{{ho,so,vo},cp,{a1,a2,b1,b2}}= {l[[2]],l[[3]],l[[4]]};
	ho = ho*1000; vo = vo/10; b1 = b1/10; b2 = b2/10;
	go = ho - 298*so;
	nint = Dimensions[cp][[1]];	(* number of integration intervalls *)
	tmax = cp[[nint,2]];		(* upper T-limit *)
	If[t > tmax, Print["T outside allowed range."]; Return[]];

	su = vu = Table[0,{i,1,nint}]; (* list of transformation entropies: relevant for special case phases following below *)
	If[ToString[min] == "crst", su[[2]] = 2.57; vu[[2]] = 1.29];
	If[ToString[min] == "hem", su[[2]] = 1.95];
	If[ToString[min] == "iron", su[[4]] = 0.92; su[[6]] = 0.76];
	If[ToString[min] == "lrn", su[[2]] = 1.57; vu[[2]] = 7.51];
	If[ToString[min] == "lc", su[[2]] = 1.93];
	If[ToString[min] == "mt", su[[2]] = 2.85];
	If[ToString[min] == "ne", su[[3]] = 0.77];
	If[ToString[min] == "qz", su[[2]] = 0.741; vu[[2]] = 0.17];
	If[ToString[min] == "try", su[[2]] = 0.42; vu[[2]] = 0.29];
	If[ToString[min] == "wo", su[[2]] = 0.201; su[[3]] = 4.14; vu[[3]] = 0.31];
		
	For[i=1,i<=nint,i++, (* loop over number of integration intervalls *)
	   {t1,t2,a,b,c,d,e,f,g} = cp[[i]];
	   If[t >= t1 && t <= t2, nt = i]; (* determine in which intervall T lies *)
	   ];

	If[l[[1,4]] == "fluid", 
	  If[ToString[min] == "h2o" || ToString[min] == "co2", rtlnf = RTlnf[min,p,t,RTlnfReturnValue->RTlnf,RTlnfModel -> KerrickJacobs81]];
	  If[ToString[min] == "o2", rtlnf = RTlnf[min,p,t,RTlnfReturnValue->RTlnf,RTlnfModel -> HollandPowell91]];	  
	  ];

	If[rv == G`G || rv == G`Vint, (* calculate G-function at P and T *)
	  For[i=1,i<=nt,i++, 
	     {t1,t2,a,b,c,d,e,f,g} = cp[[i]];
	     If[i==nt, t2 = t];
	     sint = (-2*g*298^3 - 3*f*298^3*t1 - 6*e*298^3*t1^2 - 12*d*298^3*t1^(5/2) + 2*g*t1^3 + 3*f*298*t1^3 + 6*e*298^2*t1^3 + 12*d*298^(5/2)*t1^3 - 
  		    6*b*298^4*t1^3 - 3*c*298^5*t1^3 + 6*b*298^3*t1^4 + 3*c*298^3*t1^5 - 6*a*298^3*t1^3*Log[298] + 6*a*298^3*t1^3*Log[t1])/(6*298^3*t1^3);
	     st = st + (so + sint + su[[i]])(t2-t1);
	     cpint = cpint + (g*t1^3 + 3*f*t1^3*t2 - 3*g*t1*t2^2 - 6*f*t1^2*t2^2 - 6*e*t1^3*t2^2 + 12*d*t1^(7/2)*t2^2 + 6*a*t1^4*t2^2 + 3*b*t1^5*t2^2 + 
  		     2*c*t1^6*t2^2 - 24*d*t1^3*t2^(5/2) + 2*g*t2^3 + 3*f*t1*t2^3 + 6*e*t1^2*t2^3 + 12*d*t1^(5/2)*t2^3 - 6*a*t1^3*t2^3 - 
  		     6*b*t1^4*t2^3 - 3*c*t1^5*t2^3 + 3*b*t1^3*t2^4 + c*t1^3*t2^5 + 6*e*t1^3*t2^2*Log[t1] - 6*a*t1^3*t2^3*Log[t1] - 
  		     6*e*t1^3*t2^2*Log[t2] + 6*a*t1^3*t2^3*Log[t2])/(6*t1^3*t2^2);
	     vu1 = vu1 + (vu[[i]]/10)(p-1);	     
	     ];
	  If[l[[1,4]] != "fluid", vint = vu1 + (E^(-(b1*pr) + a1*(-298 + t))/b1 - E^(-(b1*p) + a1*(-298 + t))/b1)*vo];
	  gpt = go-st-cpint+vint; (* G-function at P and T *)
	  If[rv == G`G, Return[gpt+rtlnf]];
	  If[rv == G`Vint, Return[vint]];
	  ];

	If[rv == G`H, (* calculate enthalpy at T *)
	  For[i=1,i<=nt,i++, 
	     {t1,t2,a,b,c,d,e,f,g} = cp[[i]];
	     If[i==nt, t2 = t];
	     hint = hint + (-3*g*t1^2 - 6*f*t1^2*t2 + 3*g*t2^2 + 6*f*t1*t2^2 - 12*d*t1^(5/2)*t2^2 - 6*a*t1^3*t2^2 - 3*b*t1^4*t2^2 - 2*c*t1^5*t2^2 + 
	            12*d*t1^2*t2^(5/2) + 6*a*t1^2*t2^3 + 3*b*t1^2*t2^4 + 2*c*t1^2*t2^5 - 6*e*t1^2*t2^2*Log[t1] + 6*e*t1^2*t2^2*Log[t2])/(6*t1^2*t2^2);	     
	     ];
	  Return[ho+hint];
	  ];

	If[rv == G`S, (* calculate entropy at T *)
	  For[i=1,i<=nt,i++, 
	     {t1,t2,a,b,c,d,e,f,g} = cp[[i]];
	     If[i==nt, t2 = t];
	     sint = sint + su[[i]]+(-2*g*t1^3 - 3*f*t1^3*t2 - 6*e*t1^3*t2^2 - 12*d*t1^3*t2^(5/2) + 2*g*t2^3 + 3*f*t1*t2^3 + 6*e*t1^2*t2^3 + 12*d*t1^(5/2)*t2^3 - 
  		    6*b*t1^4*t2^3 - 3*c*t1^5*t2^3 + 6*b*t1^3*t2^4 + 3*c*t1^3*t2^5 - 6*a*t1^3*t2^3*Log[t1] + 6*a*t1^3*t2^3*Log[t2])/(6*t1^3*t2^3);
	     
	     ];
	  Return[so+sint];
	  ];

	If[rv == G`V, (* calculate volume-function at P and T *)
	  vpt = vo*Exp[a1(t-298)-b1*p];	(* V in J/bar *)
	  For[i=1,i<=nt,i++, vpt = vpt + vu[[i]]/10];
	  Return[vpt];
	  ];

	If[rv == G`Cp, (* calculate Cp-function at T *)
	  {t1,t2,a,b,c,d,e,f,g} = cp[[nt]];
	  cp1 = a + b*t + c*t^2 + d/(t^(1/2)) + e/t + f/t^2 + g/t^3;	     
	  Return[cp1];
	  ];
		  	
]


(* --------------------------- main G-function ----------------------------------- *)
GG[min_,p_?NumericQ,t_?NumericQ,G`ReturnValue_] :=
	Block[{opt={G`G,G`H,G`S,G`Vint,G`V,G`Cp},g},

	If[Intersection[{G`ReturnValue},opt] == {}, Print["wrong value \"",G`ReturnValue,"\" for option \"ReturnValue\""];
	   Print["Allowed values are: ",opt];Return[]];
	If[ToString[Options[Dataset][[1, 2]]] == "B88", g = GB[min,p,t,G`ReturnValue]];
	If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32",
	  g = GHP[min,p,t,G`ReturnValue]
	  ];
	If[ToString[Options[Dataset][[1, 2]]] == "G97", g = GGot[min,p,t,G`ReturnValue]];
	Return[g];
]
Options[G] = {G`ReturnValue->G`G};
G[min_,p_,t_,opts___] := Block[{opt={G`ReturnValue},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -G-"];
	   Print["Known option is: ",opt];Return[]]];
	GG[min,p,t,G`ReturnValue/.{opts}/.Options[G]]];



End[]
                     
EndPackage[]
