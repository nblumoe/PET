(* Name: "FLUIDS`"  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package calculates fluid properties *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["FLUIDS`"]


RTlnf::usage = "RTlnf[species, p, t] calculates the RTln(fugacity)-term for pure fluids at P and T.
<species> may be: h2o, co2, o2, h2, co, ch4, s2.
The following options are available with -RTlnf-:\n
Name                value                  meaning\n
RTlnfReturnValue -> RTlnf (default)        calculate RTln(fugacity) of pure fluid species
                    Fugacity               calculate fugacity of pure fluid species
                    FugacityCoefficient    calculate fugacity coefficient of pure fluid species
                    Volume                 calculate volume of pure fluid species (cm^3/mol)
RTlnfModel ->       HaarEtAl84             Haar et al. (1984) EOS for H2O (default for Berman data set)
                    HollandPowell91        Holland & Powell (1991), Contrib Mineral Petrol 109: 265-273
                                           (default for Holland & Powell data set)
                    KerrickJacobs81        Kerrick & Jacobs (1981), Am J Sci 281:735-767
                    Holloway77             Holloway, (1977), In: Thermodynamics in Geology (ed. D. Fraser),
                                           see Connolly & Cesare (1993), J metamorphic Geol 11: p.380\n
Summary of EOS-models available for various pure fluids:
H2O: HaarEtAl84      (default for Berman data set)
     HollandPowell91 (default for HP data set)
     KerrickJacobs81
     Holloway77
CO2: KerrickJacobs81 (default for Berman data set)
     HollandPowell91 (default for HP data set)
     Holloway77
H2:  HollandPowell91 (default for Berman and HP data set)
     Holloway77
O2:  HollandPowell91 (default for Berman and HP data set)
     Holloway77
CO:  HollandPowell91
CH4: HollandPowell91
S2:  RTlnf = RTlnP\n
Example 1: RTlnf[h2o, 5000, 800]
ReturnValue: 51551.3
Example 2: RTlnf[h2o, 5000, 800, RTlnfReturnValue -> Fugacity, RTlnfModel -> KerrickJacobs81]
ReturnValue: 2319.93
Called from: User, -G-.
Package name: FLUIDS.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

FluidActivity::usage = "FluidActivity[species, p, t, x] calculates activities in H2O-CO2 or H2O-H2 fluids at P, T and X.
<species> may be h2o, co2 or h2.
The following options are available with -FluidActivity-:\n
Name                        value                     meaning\n
FluidSystem ->              H2OCO2 (default)          activities in H2O-CO2 fluids
                            H2OH2                     activities in H2O-H2 fluids
FluidActivityModel ->       KerrickJacobs81           activities in H2O-CO2 fluids according to
                                                      Kerrick & Jacobs (1981), Am J Sci 281:735-767
                                                      (default for Berman data set)
                            Holloway77                activities in H2O-CO2 or H2O-H2 fluids according to
                                                      Holloway, (1977), In: Thermodynamics in Geology (ed. D. Fraser),
                                                      see Connolly & Cesare (1993), J metamorphic Geol 11: p.380
                            PowellHolland85           activities in H2O-CO2 fluids according to
                                                      Powell & Holland (1985), J metamorphic Geol 3:327-342
                                                      (default for HP data set)
FluidActivityReturnValue -> FluidActivity (default)   calculate activity of species i in the fluid
                            FluidActivityCoefficient  calculate activity coefficient of species i in the fluid\n
Example 1: FluidActivity[co2, 5000, 800, 0.5]
ReturnValue: 0.580246
Example 2: FluidActivity[h2o, 5000, 800, 0.2, FluidSystem->H2OH2]
ReturnValue: 0.421589
Called from: User, -Activity-.
Package name: FLUIDS.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."


Begin["`Private`"]

Off[FindRoot::lstol];

(* ---------------------   Haar et al. (1984) equation of state ------------------------------- *)
Psat[t_] := Block[{a, w, wsq, v, ff = 0, i, ps},
   (* P-saturation of H2O according to Haar et al. (1984): subroutine of -WHAAR2- . Transformed from the original Fortran-code as used by TWEEQ
      supplied by De Capitani, Basel *)
   a = {-7.8889166, 2.5514255, -6.716169, 33.239495, -105.38479, 174.35319, -148.39348, 48.631602};
   If[t < 314, ps = Exp[6.3573118 - 8858.843/T + 607.56335/(T ** 0.6)],
     v = t/647.25; w = Abs[1.0 - v]; wsq = Sqrt[w];
     For[i = 1, i <= 8, i++, ff = ff + a[[i]]*w; w = w*wsq];
     ps = 220.93*Exp[ff/v];
     ];
   Return[ps]
]

Cubic[B_, C_, D_] := Block[{X1 = 0, X2 = 0, X2I = 0, X3 = 0, Q, P, R, PI = 3.14159263538979, PHI3, FF},
   (* solve cubic equation: subroutine of -WHAAR2- . Transformed from the original Fortran-code as used by TWEEQ *)
   If[C == 0 && D == 0, X1 = -B; Return[{X1, X2, X2I, X3}]];
   Q = ((2.*B*B*B)/(27.) - (B*C)/(3.) + D)/2.;
   P = (3.*C - B*B)/(9.);
   FF = Abs[P];
   R = Sqrt[FF];
   FF = R*Q;
   If[FF < 0,  R = -R];
   FF = Q/(R*R*R);
   If[P > 0, PHI3 = Log[FF + Sqrt[FF*FF + 1.]]/3.;
	     X1 = -R*(Exp[PHI3] - Exp[-PHI3]) - B/(3.);
	     X2I = 1,
             If[Q*Q + P*P*P > 0, PHI3 = Log[FF + Sqrt[FF*FF - 1.]]/3.;
				 X1 = -R*(Exp[PHI3] + Exp[-PHI3]) - B/(3.);
				 X2I = 1,
          			 PHI3 = ArcTan[Sqrt[1. - FF*FF]/FF]/3.;
				 X1 = -2.*R*Cos[PHI3] - B/(3.);
				 X2 = 2.*R*Cos[PI/3. - PHI3] - B/(3.);
				 X2I = 0.0;
				 X3 = 2.*R*Cos[PI/3. + PHI3] - B/(3.);
				 ];
	     ];
   Return[{X1, X2, X2I, X3}]
]

WHAAR2[P_, T_,flag_] := (* Haar et al. (1984) equation of state for H2O as used by TWEEQ. Transformed from the original Fortran-code, supplied by De Capitani, Basel *)
   Block[{i, ii, TAUI, ERMI, GI, KI, LI, CI, RHOI, TTTI, ALPI, BETI, R, RT, 
   GREF, T0, B, BB, PS, ARK, BRK, RR, OFT, BUK, CUK, DUK, X1, X2, X2I, X3, VOL, RH, RHN, RH2, Y, ER,
   Y3, ALY, BETY, F1, F2, PR, DPR, S, DEL, RHOI2,TAU, QHEX, Q10, X, AA, TR, W, AID, GH2O},
   GI = {-.53062968529023*10^4, .22744901424408*10^5, .78779333020687*10^4, -.69830527374994*10^3, 
        .17863832875422*10^6, -.39514731563338*10^6, .33803884280753*10^6, -.13855050202703*10^6, 
        -.25637436613260*10^7, .48212575981415*10^7, -.34183016969660*10^7, .12223156417448*10^7,
        .11797433655832*10^8, -.21734810110373*10^8, .10829952168620*10^8, -.25441998064049*10^7, 
        -.31377774947767*10^8, .52911910757704*10^8, -.13802577177877*10^8, -.25109914369001*10^7,
        .46561826115608*10^8, -.72752773275387*10^8, .41774246148294*10^7, .14016358244614*10^8,
        -.31555231392127*10^8, .47929666384584*10^8, .40912664781209*10^7, -.13626369388386*10^8,
        .69625220862664*10^7, -.10834900096447*10^8, -.22722827401688*10^7, .38365486000660*10^7,
        .68833257944332*10^5, .21757245522644*10^6, -.26627944829770*10^5, -.70730418082074*10^6,
        -.225*10^1, -1.68*10^1, .055*10^1, -93.0*10^1};
   KI = {1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 9, 9, 9, 9, 3, 3, 1, 5, 2, 2, 2, 4};
   LI = {1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 1, 2, 4, 6, 0, 3, 3, 3, 0, 2, 0, 0};
   CI = {.19730271018*10^2, .209662681977*10^2, -.483429455355*10^0, .605743189245*10^1, 22.56023885*10^0,
        -9.87532442*10^0, -.43135538513*10^1, .458155781*10^0, -.47754901883*10^-1, .41238460633*10^-2,
        -.27929052852*10^-3, .14481695261*10^-4, -.56473658748*10^-6, .16200446*10^-7, -.3303822796*10^-9,
        .451916067368*10^-11, -.370734122708*10^-13, .137546068238*10^-15};
   RHOI = {0.319*10^0, 0.310*10^0, 0.310*10^0, 1.550*10^0};
   TTTI = {640.0*10^0, 640.0*10^0, 641.6*10^0, 270.0*10^0};
   ALPI = {34.0*10^0, 40.0*10^0, 30.0*10^0, 1050.0*10^0};
   BETI = {2.0*10^4, 2.0*10^4, 4.0*10^4, 25.0*10^0};
   R = 4.6152*10^0;
   RT = R*T;
   GREF = -54955.2356146119409*10^0;
   T0 = 647.073*10^0;
   TAUI = Table[0, {i, 0 + 1, 6 + 1}];
   TAUI[[0 + 1]] = 1.*10^0;
   TAUI[[1 + 1]] = T/T0;
   For[i = 2 + 1, i <= 6 + 1, i++,  TAUI[[i]] = TAUI[[i - 1]]*TAUI[[1 + 1]]];
   B = -0.3540782*10^0*Log[TAUI[[1 + 1]]] + 0.7478629*10^0 + 
        0.007159876*10^0/TAUI[[3 + 1]] - 0.003528426*10^0/TAUI[[5 + 1]];
   BB = 1.1278334*10^0 - 0.5944001*10^0/TAUI[[1 + 1]] - 
        5.010996*10^0/TAUI[[2 + 1]] + 0.63684256*10^0/TAUI[[4 + 1]];

   PS = 220.55*10^0;
   If[T <= 647.25*10^0,  PS = Psat[T]];
   ARK = 1.279186*10^8 - 2.241415*10^4*T;
   BRK = 1.428062*10^1 + 6.092237*10^-4*T;
   RR = 8.31441*10^0;
   OFT = ARK/(P*Sqrt[T]);
   BUK = -10*10^0*RR*T/P;
   CUK = OFT - BRK*BRK + BRK*BUK;
   DUK = -BRK*OFT;
   {X1, X2, X2I, X3} = Cubic[BUK, CUK, DUK]; (* contains  V(H2O) in cm^3 *)
   If[X2I != 0.0*10^0, VOL = X1, 
     If[P < PS, VOL = Max[{X1, X2, X3}], VOL = Min[{X1, X2, X3}]]];
   If[VOL <= 0.0*10^0, RHN = 1.9*10^0, RHN = 1*10^0/VOL*18.0152*10^0];

   If[flag == 1, Return[VOL]]; (* return volume in cm^3/mol if flag=1  *)
   If[flag == 2, Return[0]];
   
   For[ii = 1, ii <= 100, ii++,
      RH = RHN; 
      If[RH <= 0.1*10^-8, RH = 1*10^-8]; 
      If[RH > 1.9*10^0, RH = 1.9*10^0];
      RH2 = RH*RH; Y = RH*B/4.*10^0; ER = Exp[-RH]; Y3 = (1*10^0 - Y)^3;
      ALY = 11.*10^0*Y; BETY = 44.33333333333333*10^0*Y*Y; 
      F1 = (1.*10^0 + ALY + BETY)/Y3; F2 = 4.*10^0*Y*(BB/B - 3.5*10^0);
      ERMI = Table[0, {i, 0 + 1, 9 + 1}];
      ERMI[[0 + 1]] = 1*10^0;
      ERMI[[1 + 1]] = 1*10^0 - ER;
      For[i = 2 + 1, i <= 10, i++, ERMI[[i]] = ERMI[[i - 1]]*ERMI[[1 + 1]]];
      PR = 0.0*10^0; DPR = 0.0*10^0;
      For[i = 1, i <= 36, i++,  S = GI[[i]]/TAUI[[LI[[i]] + 1]]*ERMI[[KI[[i]]]]; 
         PR = PR + S; 
         DPR = DPR + (2*10^0 + RH*(KI[[i]]*ER - 1*10^0)/ERMI[[1 + 1]])*S];
      For[i = 1, i <= 4, i++,  
         DEL = RH/RHOI[[i]] - 1.0*10^0;
	 RHOI2 = RHOI[[i]]*RHOI[[i]];
         TAU = T/TTTI[[i]] - 1.0*10^0;
         QHEX = (-ALPI[[i]]*DEL^(LI[[i + 36]]) - BETI[[i]]*TAU*TAU);
         If[QHEX > -150.0*10^0, 
           Q10 = GI[[i + 36]]*DEL^LI[[i + 36]]*Exp[-ALPI[[i]]*DEL^LI[[i + 36]] - BETI[[i]]*TAU*TAU], 
           Q10 = 0.0*10^0];
	 QM = LI[[i + 36]]/DEL - KI[[i + 36]]*ALPI[[i]]*DEL^(KI[[i + 36]] - 1);
	 S = Q10*QM*RH2/RHOI[[i]];
	 PR = PR + S;
	 DPR = DPR + S*(2.0*10^0/RH + QM/RHOI[[i]]) - RH2/RHOI2*Q10*(LI[[i + 36]]/DEL/DEL + 
               KI[[i + 36]]*(KI[[i + 36]] - 1)*ALPI[[i]]*DEL^(KI[[i + 36]] - 2));
	 ];
      PR = RH*(RH*ER*PR + RT*(F1 + F2));
      DPR = RH*ER*DPR + RT*((1*10^0 + 2*10^0*ALY + 3*10^0*BETY)/Y3 + 3*10^0*Y*F1/(1*10^0 - Y) + 2*10^0*F2);
      If[DPR <= 0.0*10^0, If[P <= PS, RHN = RHN*0.95*10^0, RHN = RHN*1.05*10^0], 
        If[DPR < 0.01*10^0, DPR = 0.01*10^0]; S = (P - PR)/DPR; 
        If[Abs[G] > 0.1*10^0, S = 0.1*10^0*S/Abs[S]]; RHN = RH + S;
        ];
      DP = Abs[1.0*10^0 - PR/P];
      DR = Abs[1.0*10^0 - RHN/RH];
      If[DP <= 1*10^-5 && DR <= 1*10^-5, Break[]];
      ];
   RH = RHN;
   Y = RH*B/(4.*10^0);
   X = 1*10^0 - Y;
   ER = Exp[-RH];
   ERMI[[0 + 1]] = 1*10^0;
   ERMI[[1 + 1]] = 1*10^0 - ER;
   For[i = 2 + 1, i <= 10, i++, ERMI[[i]] = ERMI[[i - 1]]*ERMI[[1 + 1]]];
   AA = RT*(-Log[X] - 43.33333333333333*10^0/X + 28.16666666666667*10^0/X/X + 4*10^0*Y*(BB/B - 3.5*10^0) +
        15.16666666666667*10^0 + Log[RH*RT/1.01325*10^0]);    
   For[i = 1, i <= 36, i++,  AA = AA + GI[[i]]/KI[[i]]/TAUI[[LI[[i]] + 1]]*ERMI[[KI[[i]] + 1]]];    
   For[i = 1, i <= 4, i++, DEL = RH/RHOI[[i]] - 1.0*10^0;
      TAU = T/TTTI[[i]] - 1.0*10^0;
      QHEX = (-ALPI[[i]]*DEL^KI[[i + 36]] - BETI[[i]]*TAU*TAU);
      If[QHEX > -150.0*10^0, AA = AA + GI[[i + 36]]*DEL^LI[[i + 36]]*Exp[QHEX]]];    
   TR = T/(1.0*10^2);
   W = TR^(-3);
   AID = 1.*10^0 + (CI[[1]]/TR + CI[[2]])*Log[TR];
   For[i = 3, i <= 18, i++, AID = AID + CI[[i]]*W; W = W*TR];    
   AA = AA - RT*AID;
   GH2O = ((AA + P/RH)*1.80152*10^0 - GREF - 306685.5925*10^0);
   Return[GH2O];
]

(* ----------------   Kerrick & Jacobs (1981) equation of state ----------------------------------  *)
VmixKJ[p_,t_,par_] := Block[{R=83.143,bm,cm,dm,em,am,ym,v,V},
   (* Volume of H2O, CO2 or H2O-CO2 mixtures at P and T according to Kerrick & Jacobs (1981) in cm^3 *)
   {bm,cm,dm,em} = par;	
   am = cm + dm/v + em/v^2; ym = bm/(4v);
   V = FindRoot[R t (1 + ym + ym^2 - ym^3)/(v(1 - ym)^3) - am/(t^0.5 v(v+bm)) - p == 0, {v,15,17}, MaxIterations -> 50];        
   Return[Re[V[[1,2]]]]   ]
   
RTlnfKJ[species_,p_?NumericQ,t_?NumericQ,x_,flag_] := Block[{R=83.143,Vm,X1,X2,b1,b2,bm,ccross,dcross,ecross,c1,d1,e1,c2,d2,e2,cm,dm,em,am,ym,Zm,lnfk,b,c,d,e},
   (* RTlnf according to Kerrick & Jacobs (1981), Am J Sci 281:735-767: 1 = H2O, 2 = CO2 *)
   b1 = 29; b2 = 58; 
   c1 = (290.78 - (0.30276 t) + (1.4774 10^-4 t^2)) 10^6;
   d1 = (-8374 + (19.437 t) - (8.148 10^-3 t^2)) 10^6;
   e1 = (76600 - (133.9 t) + (0.1071 t^2)) 10^6;
   c2 = (28.31 + (0.10721 t) - (8.81 10^-6 t^2)) 10^6;
   d2 = (9380 - (8.53 t) + (1.189 10^-3 t^2)) 10^6;
   e2 = (-368654 + (715.9 t) + (0.1534 t^2)) 10^6;	
   ccross = (c1 c2)^0.5; dcross = (d1 d2)^0.5; ecross = (e1 e2)^0.5;	
   If[ToString[species] == "h2o", X1 = x; X2 = 1 - X1; b = b1; c = c1; d = d1; e = e1];
   If[ToString[species] == "co2", X2 = x; X1 = 1 - X2; b = b2; c = c2; d = d2; e = e2];	
   bm = b1 X1 + b2 X2;
   cm = c1 X1^2 + c2 X2^2 + 2X1 X2 ccross;
   dm = d1 X1^2 + d2 X2^2 + 2X1 X2 dcross;
   em = e1 X1^2 + e2 X2^2 + 2X1 X2 ecross;
   Vm = VmixKJ[p,t,{bm,cm,dm,em}];
   If[flag == 1, Return[Vm]];	(* return volume in cm^3/mol if flag=1  *)	
   ym = bm/(4 Vm); am = cm + dm/Vm + em/Vm^2; 
   Zm = (p Vm)/(R t);
   If[ToString[species] == "co2", X1 = x; X2 = 1 - X1]; (* reverse mole fractions for CO2 to use same lnfk equation *)	
   lnfk = (4ym-3ym^2)/((1-ym)^2) + (b/bm)(4ym-2ym^2)/((1-ym)^3)
	   - (2c X1+2X2 ccross)/(R t^1.5 bm)(Log[(Vm+bm)/Vm])
	   - (cm b)/(R t^1.5 bm(Vm+bm)) + (((cm b)/(R t^1.5 bm^2))Log[(Vm+bm)/Vm])
	   - (2d X1+2 X2 dcross+dm)/(R t^1.5 bm Vm)
	   + (2d X1+2 X2 dcross+dm)/(R t^1.5 bm^2)(Log[(Vm+bm)/Vm])
	   + (b dm)/(R t^1.5 Vm bm(Vm+bm)) + (2b dm)/(R t^1.5 bm^2(Vm+bm))
	   - (2b dm)/(R t^1.5 bm^3) (Log[(Vm+bm)/Vm])
	   - (2e X1+2X2 ecross+2em)/(R t^1.5 2bm Vm^2)
	   + (2e X1+2X2 ecross+2em)/(R t^1.5 bm^2 Vm)
	   - (2e X1+2X2 ecross+2em)/(R t^1.5 bm^3)(Log[(Vm+bm)/Vm])
	   + (em b)/(R t^1.5 2bm Vm^2(Vm+bm)) - (3em b)/(R t^1.5 2bm^2 Vm(Vm+bm)) 
	   + (3em b)/(R t^1.5 bm^4)(Log[(Vm+bm)/Vm]) - (3 em b)/(R t^1.5 bm^3(Vm+bm)) - Log[Zm];
   Return[(R/10)*t(lnfk+Log[p])]     
]

(* ----------------   Holloway (1977) equation of state ------------------------------------------------  *)
VolH[p_,t_,a_,b_] :=  (* Holloway (1977): explicit solution of RK for volume *) 
     Block[{v,r=83.143},
     v = ((r*t)/(3*p) - (-(r^2*t^2)/(9*p^2) + (-b^2 + a/(p*t^(1/2)) - (b*r*t)/p)/3)/
     	 ((a*b)/(2*p*t^(1/2)) + (r^3*t^3)/(27*p^3) - (r*t*(-b^2 + a/(p*t^(1/2)) - (b*r*t)/p))/(6*p) + 
     	 ((-(r^2*t^2)/(9*p^2) + (-b^2 + a/(p*t^(1/2)) - (b*r*t)/p)/3)^3 + 
     	 ((a*b)/(2*p*t^(1/2)) + (r^3*t^3)/(27*p^3) - 
     	 (r*t*(-b^2 + a/(p*t^(1/2)) - (b*r*t)/p))/(6*p))^2)^(1/2))^(1/3) + 
     	 ((a*b)/(2*p*t^(1/2)) + (r^3*t^3)/(27*p^3) - (r*t*(-b^2 + a/(p*t^(1/2)) - (b*r*t)/p))/(6*p) + 
     	 ((-(r^2*t^2)/(9*p^2) + (-b^2 + a/(p*t^(1/2)) - (b*r*t)/p)/3)^3 + 
     	 ((a*b)/(2*p*t^(1/2)) + (r^3*t^3)/(27*p^3) - (r*t*(-b^2 + a/(p*t^(1/2)) - (b*r*t)/p))/(6*p))^
     	 2)^(1/2))^(1/3));
     Return[N[v]]   ]

VmixH[species_,p_,t_,x_] := Block[{r=83.143,res,x1,x2,a1=0,b1=0,a2=0,b2=0,across,amix,bmix,v,tkrit,pkrit},
	(* Volume from the RK of Holloway (1977) in cm^3; x1 = H2O, x2 = CO2, H2 or O2 *)
	If[ToString[species] == "h2o", (* Holloway, 1977, In: Thermodynamics in Geology (ed. D. Fraser), p. 174 *)
	  b1 = 14.6;
	  If[t >= 738, a1 = (166.8 10^6-193080(t-273.15)+186.4(t-273.15)^2-0.071288(t-273.15)^3)1.01325,                  	
	    	       a1 = -0.22894 10^8+0.5188369 10^6 (t)-0.67665 10^3 (t)^2+0.28623 (t)^3] (* a(H2O), Connolly & Cesare, 1993 *)	    	
       	  ];
	If[ToString[species] == "co2", (* Holloway, 1977  *)
	  a2 = (73.03 10^6-71400(t-273.15)+21.57(t-273.15)^2)1.01325; 
          b2 = 29.7;
          ];
	If[ToString[species] == "h2",
	  a2 = 2.82 10^5;	(* a(H2), Connolly & Cesare, 1993 *)
	  b2 = 15.7699;		(* b(H2), Connolly & Cesare, 1993 *)  
	  ];
	If[ToString[species] == "o2", (* a, b from critical data  *)
	  tkrit = 154.6; pkrit = 50.5;
	  a2 = (r^2 tkrit^2.5)/(9(2^(1/3)-1)pkrit);
	  b2 = (2^(1/3)-1)r tkrit/(3pkrit);
	  ];	  
	across = (a1 a2)^0.5;
	amix = a1 x1^2 + a2 x2^2 + 2 x1 x2 across;
	bmix = b1 x1 + b2 x2;           
   	v =  Re[VolH[p,t,amix,bmix]];
   	Return[{v,amix,bmix,a1,b1,a2,b2,across}]]

RTlnfH[species_,p_,t_,x_,flag_] := Block[{x1,x2,r=83.143,res,vm,am,bm,ai,bi,a1,b1,a2,b2,across,lnfkm,dummy},
   (* RTlnf from the RK of Holloway (1977) ; x1 = H2O, x2 = CO2, H2 or O2 *)
   If[ToString[species] == "h2o", x1 = x; x2 = 1 - x1; ai = a1; bi = b1];
   If[ToString[species] == "co2" || ToString[species] == "h2" || ToString[species] == "o2", 
     x2 = x; x1 = 1 - x2; ai = a2; bi = b2];  
   {vm,am,bm,a1,b1,a2,b2,across} = VmixH[species,p,t,x2];   
   If[flag==1, Return[vm]];	(* return volume in cm^3/mol if flag=1  *)
   If[ToString[species] == "co2" || ToString[species] == "h2" || ToString[species] == "o2", x1 = x; x2 = 1- x1];
   lnfkm = Log[vm/(vm-bm)]+bi/(vm-bm)-(2ai x1+2across x2)/(bm r t^1.5)Log[(vm+bm)/vm]+
	   (am bi)/(bm^2 r t^1.5)(Log[(vm+bm)/vm]-bm/(vm+bm))-Log[(p vm)/(r t)];  
   Return[(r/10)*t(lnfkm+Log[p])]
]

(* ----------------   Holland & Powell (1991) CORK-equation of state ------------------------------------------------  *)

Vh2oHP[p_,t_,flag_] := Block[{r=8.3143 10^-3,b,ao,a1,a2,a3,a4,a5,a6,a7,a8,a9,c,d,e,po,vmrk,vmrk1,vmrk2,vmrk3,a,pp=p/1000,vvir=0,psat},
	(* Volume of H2O according to Holland & Powell (1991): explicit solution to eq. A.1  *) 
	{b,ao,a1,a2,a3,a4,a5,a6,a7,a8,a9,c,d,e,po} = 
	  {1.465,1113.4,-0.88517,4.53 10^-3,-1.3183 10^-5,-0.22291,-3.8022 10^-4,1.7791 10^-7,
	   5.8487,-2.137 10^-2,6.8133 10^-5,1.9853 10^-3,-8.909 10^-2,8.0331 10^-2,2};
	psat = 1000(-13.627 10^-3+7.29395 10^-7 t^2 - 2.34622 10^-9 t^3 + 4.83607 10^-15 t^5);
	If[flag == 1, a = ao + a4(t-673) + a5(t-673)^2 + a6(t-673)^3];  (* T > 673 K, fluid phase *)
	If[flag == 2, (* T < 673 K, gaseous phase  *)
	  If[t <= 673, a = ao + a7(673-t) + a8(673-t)^2 + a9(673-t)^3];
	  If[t > 673 && t <= 695, a = ao + a1(673-t) + a2(673-t)^2 + a3(673-t)^3];
	  ];
	If[flag == 3, (* T < 695 K, dense phase  *) a = ao + a1(673-t) + a2(673-t)^2 + a3(673-t)^3];
	If[pp > po, vvir = N[c(pp-po)+d(pp-po)^(1/2)+e(pp-po)^(1/4)]];
	If[t > 673, (* explicit solution to eq. A.1  *)
	  vmrk = N[((r*t)/(3*pp) - (-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)/
     	 ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp) + 
     	 ((-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)^3 + 
     	 ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - 
     	 (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp))^2)^(1/2))^(1/3) + 
     	 ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp) + 
     	 ((-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)^3 + 
     	 ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp))^
     	 2)^(1/2))^(1/3))];	
	  ];
	If[t <= 673,
	  vmrk1 = N[((r*t)/(3*pp) - (-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)/
     	 	  ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp) + 
     	 	  ((-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)^3 + 
     	 	  ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - 
     	 	  (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp))^2)^(1/2))^(1/3) + 
     	 	  ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp) + 
     	 	  ((-(r^2*t^2)/(9*pp^2) + (-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp)/3)^3 + 
     	 	  ((a*b)/(2*pp*t^(1/2)) + (r^3*t^3)/(27*pp^3) - (r*t*(-b^2 + a/(pp*t^(1/2)) - (b*r*t)/pp))/(6*pp))^
     	 	  2)^(1/2))^(1/3))];	
	 vmrk2 = N[(0.3333333333333333*r*t)/pp + ((0.2099868416491455 + 0.3637078786572403*I)*(3.*a*pp*t^(1/2) - 
	 	  3.*b^2*pp^2*t - 3.*b*pp*r*t^2 - 1.*r^2*t^3))/(pp*t^(1/2)*(27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 
		  9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) - 1.*b*r*t^(3/2)) + (4.*(3.*a*pp*t^(1/2) - 3.*b^2*pp^2*t -
		  3.*b*pp*r*t^2 - 1.*r^2*t^3)^3 + (27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) -
		  1.*b*r*t^(3/2)))^2)^(1/2))^(1/3)) + ((-0.13228342099735 + 0.2291216061664337*I)*(27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 
		  9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) - 1.*b*r*t^(3/2)) + (4.*(3.*a*pp*t^(1/2) - 3.*b^2*pp^2*t - 3.*b*pp*r*t^2 - 
		  1.*r^2*t^3)^3 + (27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) -
	 	  1.*b*r*t^(3/2)))^2)^(1/2))^(1/3))/(pp*t^(1/2))];
	   vmrk3 = N[(0.3333333333333333*r*t)/pp + ((0.2099868416491455 - 0.3637078786572403*I)*(3.*a*pp*t^(1/2) - 3.*b^2*pp^2*t -
		   3.*b*pp*r*t^2 - 1.*r^2*t^3))/(pp*t^(1/2)*(27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) -
	 	   1.*b*r*t^(3/2)) + (4.*(3.*a*pp*t^(1/2) - 3.*b^2*pp^2*t - 3.*b*pp*r*t^2 - 1.*r^2*t^3)^3 + 
         	  (27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) - 1.*b*r*t^(3/2)))^2)^(1/2))^(1/3)) + 
  		  ((-0.13228342099735 - 0.2291216061664337*I)*(27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) - 1.*b*r*t^(3/2)) + 
         	  (4.*(3.*a*pp*t^(1/2) - 3.*b^2*pp^2*t - 3.*b*pp*r*t^2 - 1.*r^2*t^3)^3 + (27.*a*b*pp^2*t + 2.*r^3*t^(9/2) - 
         	   9.*pp*r*t^2*(a - 1.*b^2*pp*t^(1/2) - 1.*b*r*t^(3/2)))^2)^(1/2))^(1/3))/(pp*t^(1/2))];
		If[flag == 1, vmrk = vmrk1]; 
		If[flag == 2, vmrk = Max[{Re[vmrk1],Re[vmrk2],Re[vmrk3]}]]; 
		If[flag == 3 && p < psat+10^-6, vmrk = Min[{Re[vmrk1],Re[vmrk2],Re[vmrk3]}]]; 
		If[flag == 3 && p > psat, vmrk = vmrk1]; 
		];	                                       
	v = Re[vmrk + vvir];	(* V in J/bar  *)
   	Return[{v,Re[vmrk],a,b,c,d,e,po}]]

RTlnfh2oHP[p_,t_,flag1_] := Block[{r=8.3143 10^-3,psat,flag,pp=p/1000,po,dummy,vmrk,a,b,c,d,e,z,lnfkvir=0,fk,fk1,fk2,fk3},
	psat = 1000(-13.627 10^-3+7.29395 10^-7 t^2 - 2.34622 10^-9 t^3 + 4.83607 10^-15 t^5);
	If[t > 673, flag = 1];						(* T > 695 K, fluid phase	*)
	If[t <= 673 && p < psat, flag = 2];		(* T <= 695 K, P < P(sat), gaseous phase *)
	If[t <= 673 && p > psat, flag = 3];		(* T <= 695 K, P > P(sat), gaseous and dense phase *)
	If[flag == 1 || flag == 2,
	  {dummy,vmrk,a,b,c,d,e,po} = Vh2oHP[p,t,flag];
	  z = pp vmrk/(r t);
	  If[pp > po, 
	    lnfkvir = ((c*p^2)/2000 - c*p*po + ((p - 1000*po)^(1/2)*((2*d*p)/3 - (2000*d*po)/3))/(10*10^(1/2)) + 
  			      ((p - 1000*po)^(1/4)*((4*e*p)/5 - 800*e*po))/10^(3/4)-(-500*c*po^2))/(1000r t)];
	  fk = z-1-Log[z-(b pp)/(r t)]-(a/(b r t^1.5))Log[1+((b pp)/(r t))/z]+lnfkvir;
	  ];   	  
	If[flag == 3,
	  pp = psat/1000;
	  {dummy,vmrk,a,b,c,d,e,po} = Vh2oHP[psat,t,2];	(* gaseous phase *)	
	  z = pp vmrk/(r t);
	  fk = z-1-Log[z-(b pp)/(r t)]-(a/(b r t^1.5))Log[1+((b pp)/(r t))/z];
	  fk1 = fk;
	  {dummy,vmrk,a,b,c,d,e,po} = Vh2oHP[psat,t,3];	(* dense phase *)	
	  z = pp vmrk/(r t);
	  fk = z-1-Log[z-(b pp)/(r t)]-(a/(b r t^1.5))Log[1+((b pp)/(r t))/z];
	  fk2 = fk;
	  pp = p/1000;
	  {dummy,vmrk,a,b,c,d,e,po} = Vh2oHP[p,t,3];	(* fluid phase *)	
	  z = pp vmrk/(r t);
	  If[pp > po, 
	    lnfkvir = ((c*p^2)/2000 - c*p*po + ((p - 1000*po)^(1/2)*((2*d*p)/3 - (2000*d*po)/3))/(10*10^(1/2)) + 
  			      ((p - 1000*po)^(1/4)*((4*e*p)/5 - 800*e*po))/10^(3/4)-(-500*c*po^2))/(1000r t)];
	  fk = z-1-Log[z-(b pp)/(r t)]-(a/(b r t^1.5))Log[1+((b pp)/(r t))/z]+lnfkvir;
	  fk3 = fk;
	  fk = fk1 - fk2 + fk3;
	  ];
	If[flag1 == 1, Return[10vmrk]]; (* return volume in cm^3/mol if flag=1  *)
   	Return[1000*r*t*(fk+Log[p])];
]

Vco2HP[species_,p_,t_] := Block[{r=8.3143 10^-3,pp=p/1000,ao,a1,bo,co,c1,do,d1,a,b,c,d,tc,pc,v},
	(* Volume of CO2, CH4, CO and H2 according to Holland & Powell (1991): eq. 7a in cm^3/mol *) 
	{ao,a1,bo,co,c1,do,d1} = {5.45963 10^-5,-8.6392 10^-6,9.18301 10^-4,-3.30558 10^-5,2.30524 10^-6, 6.93054 10^-7,-8.38293 10^-8};	
	If[ToString[species] == "co2", {pc,tc}={0.0738,304.2}];
	If[ToString[species] == "ch4", {pc,tc}={0.046,190.6}];
	If[ToString[species] == "co",  {pc,tc}={0.035,132.9}];
	If[ToString[species] == "h2",  {pc,tc}={0.0211,41.2}];
	If[ToString[species] == "o2",  {pc,tc}={0.0505,154.6}];
	a = ao tc^(5/2)/pc + a1 tc^(3/2)/pc t;
	b = bo tc/pc;
	c = co tc/(pc^(3/2)) + c1/(pc^(3/2)) t;
	d = do tc/pc^2 + d1/pc^2 t;
	v = r t/pp + b - (a r t^0.5)/((r t+b pp)(r t+2b pp)) + c pp^(1/2) + d pp;
	Return[N[10v]];
]

RTlnfco2HP[species_,p_,t_,flag_] := Block[{r=8.3143 10^-3,pp=p/1000,ao,a1,bo,co,c1,do,d1,a,b,c,d,tc,pc,f},
	(* RTlnf of CO2, CH4, CO and H2 according to Holland & Powell (1991): eq. 8  *) 
	If[flag == 1, Return[Vco2HP[species,p,t]]]; (* return volume in cm^3/mol if flag=1  *)
	{ao,a1,bo,co,c1,do,d1} = {5.45963 10^-5,-8.6392 10^-6,9.18301 10^-4,-3.30558 10^-5,2.30524 10^-6, 6.93054 10^-7,-8.38293 10^-8};	
	If[ToString[species] == "co2", {pc,tc}={0.0738,304.2}];
	If[ToString[species] == "ch4", {pc,tc}={0.046,190.6}];
	If[ToString[species] == "co",  {pc,tc}={0.035,132.9}];
	If[ToString[species] == "h2",  {pc,tc}={0.0211,41.2}];
	If[ToString[species] == "o2",  {pc,tc}={0.0505,154.6}];
	a = ao tc^(5/2)/pc + a1 tc^(3/2)/pc t;
	b = bo tc/pc;
	c = co tc/(pc^(3/2)) + c1/(pc^(3/2)) t;
	d = do tc/pc^2 + d1/pc^2 t;
	f = (r t Log[1000 pp] + b pp + a/(b t^0.5)(Log[r t+b pp]-Log[r t + 2b pp])+2/3c pp pp^0.5+d/2pp^2);
	Return[N[1000f]];
]

Ah2oco2PH[species_,p_,t_,x_] := Block[{xco2,xh2o,wh2o,wco2,r=8.3143,yh2o},
	(* y(H2O) and y(CO2) according to Powell & Holland (1985), p. 332  *)
	wh2o = (8.3 - 0.007 t + 0.26 p/1000)1000;
	wco2 = (17.8 - 0.014 t + 0.38 p/1000)1000;
	If[ToString[species] == "h2o", xh2o = x; xco2=1-xh2o;
	  yh2o = Exp[((wh2o+2(wco2-wh2o)xh2o)xco2^2)/(r t)];
	  Return[yh2o]];
	If[ToString[species] == "co2", xco2 = x; xh2o=1-xco2;
	  yco2 = Exp[((wco2+2(wh2o-wco2)xco2)xh2o^2)/(r t)];
	  Return[yco2]];
]


(* ----------------   Main functions: RTlnf and FluidActivity ------------------------------------------------  *)
    
RRTlnf[species_,p_,t_,FLUIDS`RTlnfReturnValue_,FLUIDS`RTlnfModel_] := RRTlnf[species,p,t,FLUIDS`RTlnfReturnValue,FLUIDS`RTlnfModel] = 
   (* RTlnf for fluids *)
   Block[{rtlnf=0,return,r=8.3143,flag1=0,flag2=0,model=FLUIDS`RTlnfModel,
   opt1 = {FLUIDS`RTlnf,FLUIDS`Fugacity,FLUIDS`FugacityCoefficient,FLUIDS`Volume},
   opt2 = {FLUIDS`HollandPowell91,FLUIDS`HaarEtAl84,FLUIDS`KerrickJacobs81,FLUIDS`Holloway77}},
   If[Intersection[{FLUIDS`RTlnfReturnValue}, opt1] == {}, 
      Print["wrong value \"", FLUIDS`RTlnfReturnValue, "\" for option \"RTlnfReturnValue\""];
      Print["Allowed values are: ", opt1]; Return[-1]];
   If[Intersection[{FLUIDS`RTlnfModel}, opt2] == {}, 
      Print["wrong value \"", FLUIDS`RTlnfModel, "\" for option \"RTlnfModel\""];
      Print["Allowed values are: ", opt2]; Return[-1]];
    
   rtlnf = r*t*Log[p]; (* return RTlnP for all gases except H2O, CO2, H2, O2: S2 *)
   If[FLUIDS`RTlnfReturnValue == FLUIDS`Volume, flag1 = 1; flag2 = 2];
   If[ToString[species] == "h2o", 
     If[model == FLUIDS`HollandPowell91, rtlnf = RTlnfh2oHP[p,t,flag1]];     
     If[model == FLUIDS`HaarEtAl84, rtlnf = WHAAR2[p, t, flag1] - WHAAR2[1, t, flag2]];
     If[model == FLUIDS`KerrickJacobs81, rtlnf = RTlnfKJ[species,p,t,1,flag1]];     
     If[model == FLUIDS`Holloway77, rtlnf = RTlnfH[species,p,t,1,flag1]];     
     ];   
   If[ToString[species] == "co2",
     If[model == FLUIDS`HaarEtAl84, model = FLUIDS`KerrickJacobs81]; (* no Haar et al. (1984) model for CO2: use Kerrick & Jacobs *)
     If[model == FLUIDS`HollandPowell91, rtlnf = RTlnfco2HP[species,p,t,flag1]];     
     If[model == FLUIDS`KerrickJacobs81, rtlnf = RTlnfKJ[species,p,t,1,flag1]];     
     If[model == FLUIDS`Holloway77, rtlnf = RTlnfH[species,p,t,1,flag1]];     
     ];   
   If[ToString[species] == "h2" || ToString[species] == "o2", 
     If[model == FLUIDS`HaarEtAl84, model = FLUIDS`HollandPowell91]; (* no Haar et al. (1984) model for H2 or O2: use Holland & Powell *)
     If[model == FLUIDS`HollandPowell91, rtlnf = RTlnfco2HP[species,p,t,flag1]];     
     If[model == FLUIDS`Holloway77, rtlnf = RTlnfH[species,p,t,1,flag1]];
     ]; 
   If[ToString[species] == "co" || ToString[species] == "ch4", 
     rtlnf = RTlnfco2HP[species,p,t,flag1]]; 
   
   return = rtlnf;
      
   If[FLUIDS`RTlnfReturnValue == FLUIDS`Fugacity, return=Exp[rtlnf/(r*t)]];
   If[FLUIDS`RTlnfReturnValue == FLUIDS`FugacityCoefficient, return=Exp[rtlnf/(r*t)]/p];   
   Return[return]
]
Options[RTlnf] = {FLUIDS`RTlnfReturnValue -> FLUIDS`RTlnf,
		     FLUIDS`RTlnfModel -> FLUIDS`HaarEtAl84};
RTlnf[species_, p_, t_, opts___] :=
    Block[{opt = {FLUIDS`RTlnfReturnValue,FLUIDS`RTlnfModel},i,n = Dimensions[{opts}][[1]]}, 
    For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
       Print["Unknown option ", {opts}[[i, 1]], " in -RTlnf-"];
       Print["Known option is: ", opt]; Return[-1]]];
    RRTlnf[species, p, t, FLUIDS`RTlnfReturnValue /. {opts} /. Options[RTlnf],
	 		  FLUIDS`RTlnfModel /. {opts} /. Options[RTlnf]]	 
];

FFluidActivity[species_,p_,t_,x_,FLUIDS`FluidActivityReturnValue_,FLUIDS`FluidActivityModel_,FLUIDS`FluidSystem_] := 
   Block[{model=FLUIDS`FluidActivityModel,fkpur,fkmix,r=8.3143,a=1,
   opt1 = {FLUIDS`FluidActivity,FLUIDS`FluidActivityCoefficient},
   opt2 = {FLUIDS`PowellHolland85,FLUIDS`KerrickJacobs81,FLUIDS`Holloway77},
   opt3 = {FLUIDS`H2OCO2,FLUIDS`H2OH2}},

   If[Intersection[{FLUIDS`FluidActivityReturnValue}, opt1] == {}, 
      Print["wrong value \"", FLUIDS`FluidActivityReturnValue, "\" for option \"FluidActivityReturnValue\""];
      Print["Allowed values are: ", opt1]; Return[-1]];
   If[Intersection[{FLUIDS`FluidActivityModel}, opt2] == {}, 
      Print["wrong value \"", FLUIDS`FluidActivityModel, "\" for option \"FluidActivityModel\""];
      Print["Allowed values are: ", opt2]; Return[-1]];
   If[Intersection[{FLUIDS`FluidSystem}, opt3] == {}, 
      Print["wrong value \"", FLUIDS`FluidSystem, "\" for option \"FluidSystem\""];
      Print["Allowed values are: ", opt3]; Return[-1]];

   If[ToString[species] == "o2" || ToString[species] == "s2", Return[x]];
   
   If[FLUIDS`FluidSystem == FLUIDS`H2OCO2, (* H2O - CO2 fluid  *)
     If[Intersection[{ToString[species]}, {"h2o","co2"}] == {}, 
       Print["Error-message from -FluidActivity- (wrong species): allowed values are: ", {"h2o","co2"}]; Return[-1]];
     If[model == FLUIDS`KerrickJacobs81,
       fkpur = Exp[RTlnf[species,p,t,RTlnfModel -> KerrickJacobs81]/(r*t)];
       fkmix = Exp[RTlnfKJ[species,p,t,x,0]/(r*t)]];
     If[model == FLUIDS`Holloway77,
       fkpur = Exp[RTlnf[species,p,t,RTlnfModel -> FLUIDS`Holloway77]/(r*t)];
       fkmix = Exp[RTlnfH[species,p,t,x,0]/(r*t)]];       
     If[model == FLUIDS`PowellHolland85,
       fkmix = Ah2oco2PH[species,p,t,x]; fkpur = 1;
       ];       
     ];    
   If[FLUIDS`FluidSystem == FLUIDS`H2OH2, (* H2O - H2 fluid  *)
     If[Intersection[{ToString[species]}, {"h2o","h2"}] == {}, 
       Print["Error-message from -FluidActivity- (wrong species): allowed are: ", {"h2o","h2"}]; Return[-1]];
     fkpur = Exp[RTlnf[species,p,t,RTlnfModel -> FLUIDS`Holloway77]/(r*t)];
     fkmix = Exp[RTlnfH[species,p,t,x,0]/(r*t)];       
     ];    
   If[FLUIDS`FluidActivityReturnValue == FLUIDS`FluidActivity, a = (fkmix/fkpur)*x];
   If[FLUIDS`FluidActivityReturnValue == FLUIDS`FluidActivityCoefficient, a = (fkmix/fkpur)];
   Return[a]
]

Options[FluidActivity] = {FLUIDS`FluidActivityReturnValue -> FLUIDS`FluidActivity,
		          FLUIDS`FluidActivityModel -> FLUIDS`KerrickJacobs81,
		          FLUIDS`FluidSystem -> FLUIDS`H2OCO2};

FluidActivity[species_, p_, t_, x_, opts___] :=
    Block[{opt = {FLUIDS`FluidActivityReturnValue,FLUIDS`FluidActivityModel,FLUIDS`FluidSystem},i,n = Dimensions[{opts}][[1]]}, 
    For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
       Print["Unknown option ", {opts}[[i, 1]], " in -FluidActivity-"];
       Print["Known option is: ", opt]; Return[-1]]];
    FFluidActivity[species, p, t, x, FLUIDS`FluidActivityReturnValue /. {opts} /. Options[FluidActivity],
	 		  FLUIDS`FluidActivityModel /. {opts} /. Options[FluidActivity],
	 		  FLUIDS`FluidSystem /. {opts} /. Options[FluidActivity]]	 
];

On[FindRoot::lstol];

End[]
                     
EndPackage[]

