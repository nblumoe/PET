(* Name: DG`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package calculates equilibrium data of mineral reactions *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["DG`",{"G`","DEFDAT`","UTILITY`","FLUIDS`","FORMEL`","ACTIVITY`"}]

Dgr::usage = "Dgr[rea, P (bar), T (K), file] calculates the delta-G of a reaction (P-T diagram).
ReturnValue: {delta-G of the reaction <rea> at P and T in J, {{reaction},{activities used}}}.
<rea> can be produced with -MakeRea- (see MakeRea::usage for more details).
<file> is the name of the file from which mole fractions may be read for activity calculations.
Example:
phases = {gr, an, ky, qz}; 
rea = MakeRea[phases];          
Dgr[rea[[1]], 10000, 800, \"None\"]
ReturnValue: {1906.65, {{-3. an, 1. gr, 2. ky, 1. qz}, {a(an)=1, a(gr)=1, a(ky)=1, a(qz)=1}}}
Analogous functions are -DgrXC-, -DgrXH- and -DgrO- for calculating delta-G(R) of T-X(CO2), T-X(H2) logf(O2)-T equilibria.
Called from: -CalcRea-.
Calls: -G-, -Activity-.
Package name: DG.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

CalcRea::usage = "CalcRea[rea] calculates equilibrium data of reactions.
<rea> is produced with -MakeRea- (see examples in PET_CalcRea.nb and MakeRea::usage).
The following options are available with -CalcRea-:\n
Name           value                 meaning\n
CalcReaMode -> PT (default)          P-T diagram (find equilibrium-T's of a reaction for given P's)
               TP                    P-T diagram (find equilibrium-P's of a reaction for given T's (in C))
               TXCO2                 T-X(CO2) diagram (find equilibrium-T's of a reaction for given X(CO2)'s and P)
               TXH2                  T-X(H2) diagram (find equilibrium-T's of a reaction for given X(H2)'s and P)
               TXH2logfO2            as TXH2, but convert calculated T-X(H2) data to corresponding logf(O2)-T data
               logfO2T               logf(O2)-T diagram (find equilibrium-logf(O2)'s of a reaction for given T's and P)
CalcReaMin ->  1000 (default)        Minimum value at which calculation starts:
                                                   in PT-mode: P(min) in bars
                                                   in TP-mode: T(min) in Celsius
                                                   in TXCO2-mode: X(CO2)min
                                                   in TXH2-mode: X(H2)min
                                                   in TXH2logfO2-mode: X(H2)min
                                                   in logfO2T-mode: T(min) in Celsius
CalcReaMax ->  10000 (default)       Maximum value in calculation: in PT-mode: P(max) in bars
                                                   in TP-mode: T(max) in Celsius
                                                   in TXCO2-mode: X(CO2)max
                                                   in TXH2-mode: X(H2)max
                                                   in TXH2logfO2-mode: X(H2)max
                                                   in logfO2T-mode: T(max) in Celsius
Steps ->       10 (default)          number of steps between minimum and maximum value (including both) in the calculation
Screen ->      ScreenYes (default)   print equilibrium data to the screen during calculation
               ScreenNo              don't print equilibrium data to the screen during calculation
SampleFile -> \"None\" (default)       define a sample file to be used in the calculation
OutputFile -> \"None\" (default)       define an output file to which calculated data are written\n
If a sample file is specified, -CalcRea- uses the PET-function -Activity- to calculate activities
of phase components for that sample (see Activity::usage for more details).
For equilibria with flat slopes, -CalcRea- in PT-mode may not find a solution in the range Pmin < P < Pmax.
Use the option CalcReaMode -> TP in this case.
Data are saved to the file \"OutputFile.ptx\", if an output-file is specified.
Data may be plotted with -PlotRea- and intersections of reactions may be calculated with -CalcReaIntersection-.
ReturnValue:
{{{{reaction stoichiometry},{activities used},{list of P-T data}}},{info on dataset and sample file}}
Example:
phases = {mu, qz, san, ky, h2o};
rea = MakeRea[phases]
result = CalcRea[rea]
ReturnValue:
{{{{-1 mu, -1 qz, 1 h2o, 1 ky, 1 san},{a(mu)=1, a(qz)=1, a(h2o)=1, a(ky)=1, a(san)=1},
{{601.111,1000.},{642.39,2000.},{673.724,3000.},{701.018,4000.},{725.864,5000.},
{748.972,6000.},{770.734,7000.},{791.396,8000.},{811.126,9000.},{830.045,10000.}}}},
{Dataset -> B,SampleFile->None}}
For further examples see PET_CalcRea.nb.
Called from: User.
Calls: -Dgr-, -Activity-, -SaveRea-.
Package name: DG.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

CalcReaMode::usage = "CalcReaMode is an option of -CalcRea-."
CalcReaMin::usage = "CalcReaMin is an option of -CalcRea-."
CalcReaMax::usage = "CalcReaMax is an option of -CalcRea-."
Steps::usage = "Steps is an option of -CalcRea-."
Screen::usage = "Screen is an option of -CalcRea- and -CalcReaP-."
SampleFile::usage = "SampleFile is an option of -CalcRea- and -CalcReaP-."
OutputFile::usage = "OutputFile is an option of -CalcRea- and -CalcReaP-."

Begin["`Private`"]

Dgr[rea_, p_, t_, file_] := Block[{r=8.3143,n,ak,k,m,gr=0,i,rtlnk=0,rtlnf=0,al={},alist={},x=1},
       
   If[Dimensions[Dimensions[rea]][[1]] == 1, (* no activity list appended *)
     n = Dimensions[rea][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,        
        If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", 
          {ak[[i]],al} = ActivityHP[p,t,rea[[i, 2]],x,ActivitySampleFile -> file];
          ];
        gr = gr + rea[[i, 1]](G[rea[[i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
      Return[{gr, {rea,alist}}]
      ];

   If[Dimensions[Dimensions[rea]][[1]] == 2, (* activity list appended: use these numbers *)
     n = Dimensions[rea[[1]]][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,
        If[Head[rea[[2, i]]] == Integer || Head[rea[[2, i]]] == Real, x = rea[[2, i]];
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", 
            {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];  
          ];
        If[rea[[2, i]] == "am",
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", 
            {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],1,ActivitySampleFile -> file]];          
          ];        
        gr = gr + rea[[1, i, 1]](G[rea[[1, i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea[[1]],alist}}]  
     ];        
]

DgrXC[rea_, p_, t_, file_, xc_] := Block[{r=8.3143,n,ak,k,m,gr=0,i,rtlnk=0,rtlnf=0,al,alist={},x,pos1,pos2},
    
   pos1 = Position[rea,ToExpression["h2o"]]; pos2 = Position[rea,ToExpression["co2"]];
   If[pos1 == {} && pos2 == {}, Print["Error-message from -CalcRea-: No T-X(CO2) equilibrium."];Return[{-1,""}]];
   
   If[Dimensions[Dimensions[rea]][[1]] == 1, (* no activity list appended *)
     n = Dimensions[rea][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++, x = 1;
        If[rea[[i, 2]] == ToExpression["h2o"], x = 1-xc];
        If[rea[[i, 2]] == ToExpression["co2"], x = xc];
        If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        gr = gr + rea[[i, 1]](G[rea[[i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea,alist}}]
     ];

   If[Dimensions[Dimensions[rea]][[1]] == 2, (* activity list appended: use these numbers *)
     n = Dimensions[rea[[1]]][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,
        If[Head[rea[[2, i]]] == Integer || Head[rea[[2, i]]] == Real, x = rea[[2, i]];
          If[rea[[1, i, 2]] == ToExpression["h2o"], x = 1-xc];
          If[rea[[1, i, 2]] == ToExpression["co2"], x = xc];
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];          
          ];
        If[rea[[2, i]] == "am", 
          If[rea[[1, i, 2]] == ToExpression["h2o"], x = 1-xc];
          If[rea[[1, i, 2]] == ToExpression["co2"], x = xc];          
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];          
          ];        
        gr = gr + rea[[1, i, 1]](G[rea[[1, i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea[[1]],alist}}]
     ];        
]

DgrXH[rea_, p_, t_, file_, xh_] := Block[{r=8.3143,n,ak,k,m,gr=0,i,rtlnk=0,rtlnf=0,al,alist={},x,pos1,pos2},
    
   pos1 = Position[rea,ToExpression["h2o"]]; pos2 = Position[rea,ToExpression["h2"]];
   If[pos1 == {} && pos2 == {}, Print["Error-message from -CalcRea-: No T-X(H2) equilibrium."];Return[{-1,""}]];
   
   If[Dimensions[Dimensions[rea]][[1]] == 1, (* no activity list appended *)
     n = Dimensions[rea][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++, x = 1;
        If[rea[[i, 2]] == ToExpression["h2o"], x = 1-xh];
        If[rea[[i, 2]] == ToExpression["h2"], x = xh];
        If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        gr = gr + rea[[i, 1]](G[rea[[i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea,alist}}]
     ];

   If[Dimensions[Dimensions[rea]][[1]] == 2, (* activity list appended: use these numbers *)
     n = Dimensions[rea[[1]]][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,
        If[Head[rea[[2, i]]] == Integer || Head[rea[[2, i]]] == Real, x = rea[[2, i]];
          If[rea[[1, i, 2]] == ToExpression["h2o"], x = 1-xh];
          If[rea[[1, i, 2]] == ToExpression["h2"], x = xh];
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          ];
        If[rea[[2, i]] == "am", 
          If[rea[[1, i, 2]] == ToExpression["h2o"], x = 1-xh];
          If[rea[[1, i, 2]] == ToExpression["h2"], x = xh];          
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];          
          ];        
        gr = gr + rea[[1, i, 1]](G[rea[[1, i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea[[1]],alist}}]
     ];        
]

DgrO[rea_, p_, t_, file_] := Block[{r=8.3143,n,ak,k,m,gr=0,i,rtlnk=0,rtlnf=0,al,alist={},x=1,rtlnfo2=0,sko2,pos1},

   pos1 = Position[rea,ToExpression["o2"]]; 
   If[pos1 == {}, Print["Error-message from -CalcRea-: No logf(O2)-T equilibrium."];Return[{-1,""}]];
    
   If[Dimensions[Dimensions[rea]][[1]] == 1, (* no activity list appended *)
     n = Dimensions[rea][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,
        If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[i, 2]],x,ActivitySampleFile -> file]];
        If[ToString[rea[[i, 2]]] == "o2", sko2 = rea[[i, 1]]; rtlnfo2 = sko2*RTlnf[rea[[i, 2]],p,t]];
        gr = gr + rea[[i, 1]](G[rea[[i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr-rtlnfo2,{rea,alist},sko2}]
     ];

   If[Dimensions[Dimensions[rea]][[1]] == 2, (* activity list appended: use these numbers *)
     n = Dimensions[rea[[1]]][[1]];
     ak = Table[1, {i, 1, n}];    
     For[i=1,i<=n, i++,
        If[Head[rea[[2, i]]] == Integer || Head[rea[[2, i]]] == Real, x = rea[[2, i]];
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> "None"]];
          If[ToString[rea[[1, i, 2]]] == "o2", sko2 = rea[[1, i, 1]]; rtlnfo2 = sko2*RTlnf[rea[[1, i, 2]],p,t]];          
          ];
        If[rea[[2, i]] == "am", 
          If[ToString[Options[Dataset][[1, 2]]] == "B88", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "G97", {ak[[i]],al} = ActivityB[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];
          If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32", {ak[[i]],al} = ActivityHP[p,t,rea[[1, i, 2]],x,ActivitySampleFile -> file]];          
          If[ToString[rea[[1, i, 2]]] == "o2", sko2 = rea[[1, i, 1]]; rtlnfo2 = sko2*RTlnf[rea[[1, i, 2]],p,t]];                  
          ];        
        gr = gr + rea[[1, i, 1]](G[rea[[1, i, 2]], p, t] + r t Log[ak[[i]]]);
        alist = Append[alist,al];
        ]; 
     Return[{gr, {rea[[1]],alist},sko2}]
     ];        
]

XH2ToLogfO2[p_,t_,xh2_] := Block[{res,fh2opur,fh2pur,ah2o,ah2,fh2o,fh2,kdiss,g,logfo2,logfh2o,logfh2},

	fh2opur = RTlnf[ToExpression["h2o"],p,t,RTlnfReturnValue->Fugacity,RTlnfModel->Holloway77]; 
	fh2pur = RTlnf[ToExpression["h2"],p,t,RTlnfReturnValue->Fugacity,RTlnfModel->Holloway77]; 
	ah2o = FluidActivity[ToExpression["h2o"],p,t,1-xh2,FluidSystem->H2OH2]; 
	ah2 = FluidActivity[ToExpression["h2o"],p,t,xh2,FluidSystem->H2OH2];  
	fh2o = fh2opur ah2o; fh2 = fh2pur ah2;
	logfh2o = N[Log[fh2o]/Log[10]]; logfh2 = N[Log[fh2]/Log[10]];
	g = G[ToExpression["h2"],p,t]+0.5 G[ToExpression["o2"],p,t] - G[ToExpression["h2o"],p,t];
	kdiss = Exp[-g/(8.3143 t)];
	logfo2 = N[Log[((kdiss fh2o)/fh2)^2]/Log[10]];
	Return[N[logfo2]]]


CCalcRea[rea_,DG`CalcReaMode_,DG`CalcReaMin_,DG`CalcReaMax_,DG`Steps_,DG`Screen_,DG`SampleFile_,DG`OutputFile_,DG`PinTX_] := 
	Block[{real=rea,nreal,neq=DG`Steps,eqdat,m,p,p1=5000,p2=7000,pl,i,ii,j,k,min,res,t,t1=800,t2=900,tl,check,al,
	fnamel=DG`SampleFile,x,xl,x1,x2,sko2,dgro,r=8.3143,rtlnfo2,f,f1=-5,f2=-40,d1,d2,stepsize,
	opt={DG`ScreenYes,DG`ScreenNo},opt2={DG`PT,DG`TP,DG`TXCO2,DG`TXH2,DG`TXH2logfO2,DG`logfO2T}},
	
	Off[FindRoot::lstol];
	If[DG`Steps <= 1, Return["Error-message from -CalcRea-: Number of steps must be > 1."]];
   	nreal = Dimensions[rea][[1]];
	stepsize = N[Abs[DG`CalcReaMax-DG`CalcReaMin]/(neq-1)];
	eqdat = Table[0,{ii,1,nreal},{j,1,neq},{k,1,2}];
        If[Intersection[{DG`CalcReaMode}, opt2] == {}, 
          Print["wrong value \"", DG`CalcReaMode, "\" for option \"CalcReaMode\""];
          Print["Allowed values are: ", opt2]; Return[-1]];
        If[Intersection[{DG`Screen}, opt] == {}, 
          Print["wrong value \"", DG`Screen, "\" for option \"Screen\""];
          Print["Allowed values are: ", opt]; Return[-1]];

	If[DG`CalcReaMode == DG`PT || DG`CalcReaMode == DG`TP,
	  If[ToString[Options[Dataset][[1, 2]]] == "B88",
	    SetOptions[FluidActivity, FluidActivityModel -> KerrickJacobs81]];
	  If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32",
  	    SetOptions[FluidActivity, FluidActivityModel -> PowellHolland85]];
	  ];

	If[DG`CalcReaMode == DG`PT, (* PT mode: find equilibrium T for given P  *)
	  If[DG`CalcReaMin < 0., Return["Value for \"CalcReaMin\" out of reasonable range (negative pressure)."]];
	  If[DG`CalcReaMax < 0., Return["Value for \"CalcReaMax\" out of reasonable range (negative pressure)."]];
 	  For[ii=1,ii<=nreal,ii++, (* loop over reactions  *)
	     pl = DG`CalcReaMin; 
	     Print["calculating PT data of the reaction:"]; Print[real[[ii]]];
	     {check,al} = Dgr[real[[ii]],pl,t1,fnamel];
	     If[check == -1, Return[]];	      
	     For[j=1,j<=neq,j++, (* loop over pressure-interval  *)
	        eqdat[[ii,j,1]] = FindRoot[Dgr[real[[ii]],pl,t,fnamel][[1]] == 0,{t,t1,t2},MaxIterations -> 100,AccuracyGoal -> 3][[1,2]]-273.15;
	        eqdat[[ii,j,2]] = pl;
	        If[DG`Screen == DG`ScreenYes, Print[eqdat[[ii,j,2]]," ",eqdat[[ii,j,1]] ]];
	        pl = pl + stepsize;
	        ];
	     ]; 	
	  ];

	If[DG`CalcReaMode == DG`TP, (* TP mode: find equilibrium P for given T  *)
	  If[DG`CalcReaMin < 0., Return["Value for \"CalcReaMin\" out of reasonable range (negative temperature)."]];
	  If[DG`CalcReaMax < 0., Return["Value for \"CalcReaMax\" out of reasonable range (negative temperature)."]];
	  For[ii=1,ii<=nreal,ii++, (* loop over reactions  *)
	     tl = DG`CalcReaMin+273.15; 
	     Print["calculating PT data of the reaction:"]; Print[real[[ii]]];	     
	     {check,al} = Dgr[real[[ii]],p1,tl,fnamel];
	     If[check == -1, Return[]];	      	        
	     For[j=1,j<=neq,j++, (* loop over temperature-interval  *)
	        eqdat[[ii,j,2]] = FindRoot[Dgr[real[[ii]],p,tl,fnamel][[1]] == 0,{p,p1,p2},MaxIterations -> 100,AccuracyGoal -> 3][[1,2]];
	        eqdat[[ii,j,1]] = tl-273.15;
	        If[DG`Screen == DG`ScreenYes, Print[eqdat[[ii,j,2]]," ",eqdat[[ii,j,1]] ]];
	        tl = tl + stepsize;
	        ];	        
	     ]; 	
	  ];

	If[DG`CalcReaMode == DG`TXCO2, (* T-X(CO2) mode: find equilibrium T for given X(CO2) and P *)
	  If[DG`CalcReaMin < 0. || DG`CalcReaMin > 1., Return["Value for \"CalcReaMin\" out of reasonable range (0 < CalcReaMin < 1)."]];
	  If[DG`CalcReaMax < 0. || DG`CalcReaMax > 1., Return["Value for \"CalcReaMax\" out of reasonable range (0 < CalcReaMax < 1)."]];
	  
	  If[ToString[Options[Dataset][[1, 2]]] == "B88",
  	    SetOptions[FluidActivity, FluidActivityModel -> KerrickJacobs81,FluidSystem -> H2OCO2]];
	  If[ToString[Options[Dataset][[1, 2]]] == "HP31" || ToString[Options[Dataset][[1, 2]]] == "HP32",
  	    SetOptions[FluidActivity, FluidActivityModel -> PowellHolland85,FluidSystem -> H2OCO2]];
	  For[ii=1,ii<=nreal,ii++, (* loop over reactions  *)	     
	     xl = DG`CalcReaMin;
	     Print["calculating T-X(CO2) data at ",DG`PinTX," bar of the reaction:"]; Print[real[[ii]]];	     
	     {check,al} = DgrXC[real[[ii]],DG`PinTX,t1,fnamel,xl];
	     If[check == -1, Return[]];	      
	     For[j=1,j<=neq,j++, (* loop over X(CO2)-interval  *)
	        eqdat[[ii,j,2]] = FindRoot[DgrXC[real[[ii]],DG`PinTX,t,fnamel,xl][[1]] == 0,{t,t1,t2},MaxIterations -> 100,AccuracyGoal -> 3][[1,2]]-273.15;
	        eqdat[[ii,j,1]] = xl;
	        If[DG`Screen == DG`ScreenYes, Print[eqdat[[ii,j,2]]," ",eqdat[[ii,j,1]] ]];
	        xl = xl + stepsize;
	        ];	     
	     ]; 	
	  ];

	If[DG`CalcReaMode == DG`TXH2 || DG`CalcReaMode == DG`TXH2logfO2, (* T-X(H2) mode: find equilibrium T for given X(H2) and P *)
	  If[DG`CalcReaMin < 0. || DG`CalcReaMin > 1., Return["Value for \"CalcReaMin\" out of reasonable range (0 < CalcReaMin < 1)."]];
	  If[DG`CalcReaMax < 0. || DG`CalcReaMax > 1., Return["Value for \"CalcReaMax\" out of reasonable range (0 < CalcReaMax < 1)."]];
	  SetOptions[FluidActivity, FluidActivityModel -> Holloway77,FluidSystem -> H2OH2];
	  For[ii=1,ii<=nreal,ii++, (* loop over reactions  *)	     
	     xl = DG`CalcReaMin;
	     If[DG`CalcReaMode == DG`TXH2, Print["calculating T-X(H2) data at ",DG`PinTX," bar of the reaction:"]; Print[real[[ii]]]];
	     If[DG`CalcReaMode == DG`TXH2logfO2, Print["calculating logf(O2)-T data at ",DG`PinTX," bar of the reaction:"]; Print[real[[ii]]]];
	     {check,al} = DgrXH[real[[ii]],DG`PinTX,t1,fnamel,xl];
	     If[check == -1, Return[]];	      
	     For[j=1,j<=neq,j++, (* loop over X(H2)-interval  *)
	        eqdat[[ii,j,2]] = FindRoot[DgrXH[real[[ii]],DG`PinTX,t,fnamel,xl][[1]] == 0,{t,t1,t2},MaxIterations -> 100,AccuracyGoal -> 3][[1,2]]-273.15;
	        If[DG`CalcReaMode == DG`TXH2, eqdat[[ii,j,1]] = xl];
	        If[DG`CalcReaMode == DG`TXH2logfO2, 
	          d1 = eqdat[[ii,j,2]]; d2 = XH2ToLogfO2[DG`PinTX,eqdat[[ii,j,2]]+273.15,xl];
		  eqdat[[ii,j,1]] = d1; eqdat[[ii,j,2]] = d2];	        
	        If[DG`Screen == DG`ScreenYes, Print[eqdat[[ii,j,2]]," ",eqdat[[ii,j,1]] ]];
	        xl = xl + stepsize;
	        ];	     
	     ]; 	
	  ];

	If[DG`CalcReaMode == DG`logfO2T, (* logfO2-T mode: find equilibrium logfO2 for given T and P *)
	  If[DG`CalcReaMin < 0., Return["Value for \"CalcReaMin\" out of reasonable range (negative temperature)."]];
	  If[DG`CalcReaMax < 0., Return["Value for \"CalcReaMax\" out of reasonable range (negative temperature)."]];
	  For[ii=1,ii<=nreal,ii++, (* loop over reactions  *)	     
	     tl = DG`CalcReaMin+273.15; 
	     Print["calculating logfO2-T data at ",DG`PinTX," bar of the reaction:"]; Print[real[[ii]]];	     
	     {check,al,sko2} = DgrO[real[[ii]],DG`PinTX,t1,fnamel];
	     If[check == -1, Return[]];
	     For[j=1,j<=neq,j++, (* loop over T-interval  *)
		{dgro,al,sko2} = DgrO[real[[ii]],DG`PinTX,tl,fnamel]; 	        
	        rtlnfo2 = N[sko2 r tl f Log[10]];	        
		eqdat[[ii,j,2]] = FindRoot[dgro + rtlnfo2 == 0,{f,f1,f2},MaxIterations -> 100][[1,2]];
	        eqdat[[ii,j,1]] = tl-273.15;
	        If[DG`Screen == DG`ScreenYes, Print[eqdat[[ii,j,2]]," ",eqdat[[ii,j,1]] ]];
	        tl = tl + stepsize;
	        ];	     
	     ]; 	
	  ];

	  For[ii=1,ii<=nreal,ii++, (* reformating output  *)
  	     real[[ii]] = {real[[ii]],ToString[al[[2]]],ToExpression[ToString[NumberForm[eqdat[[ii]],{10,3}]]]};
	     ];

	  If[DG`CalcReaMode == DG`PT || DG`CalcReaMode == DG`TP || DG`CalcReaMode == DG`logfO2T,
	    real = {real,{ToString[Options[Dataset][[1]]],StringJoin["SampleFile->", fnamel]}}];
	  If[DG`CalcReaMode == DG`TXCO2 || DG`CalcReaMode == DG`TXH2 || DG`CalcReaMode == DG`TXH2logfO2,
	    real = {real,{ToString[Options[Dataset][[1]]],StringJoin["SampleFile->", fnamel],StringJoin["PinTX->", ToString[DG`PinTX]]}}];

	If[DG`OutputFile != "None", SaveRea[real,StringJoin[DG`OutputFile,".ptx"]];
	  Print["Equilibrium data have been stored in the file ",StringJoin[DG`OutputFile,".ptx"],"."]];
	On[FindRoot::lstol];
	Return[real]
]
Options[CalcRea] = {DG`CalcReaMode->DG`PT,
		    DG`CalcReaMin->1000,
		    DG`CalcReaMax->10000,
		    DG`Steps->10,
		    DG`Screen->DG`ScreenYes,
		    DG`SampleFile->"None",
		    DG`OutputFile->"None",
		    DG`PinTX->5000};
CalcRea[rea_,opts___] := Block[{opt={DG`CalcReaMode,DG`CalcReaMin,DG`CalcReaMax,DG`Steps,DG`Screen,DG`SampleFile,DG`OutputFile,DG`PinTX},
	i,n=Dimensions[{opts}][[1]],pos},
	For[i=1,i<=n,i++, (* check options  *)
	   pos = Position[opt,{opts}[[i,1]]];		 
	   If[pos == {}, Print["Unknown option \"",{opts}[[i,1]],"\" in -CalcRea-"];
	   		 Print["Known options are: ",opt];Return[]];
	   If[pos != {}, 
	     If[ToString[{opts}[[i,1]]] == "CalcReaMode" || ToString[{opts}[[i,1]]] == "CalcReaMin" || ToString[{opts}[[i,1]]] == "CalcReaMax"
	     				    || ToString[{opts}[[i,1]]] == "Steps",
	       SetOptions[CalcRea, opt[[pos[[1,1]]]] ->{opts}[[i,2]]]];
	     ];	   		 
	   ];
	CCalcRea[rea,DG`CalcReaMode/.{opts}/.Options[CalcRea],DG`CalcReaMin/.{opts}/.Options[CalcRea],DG`CalcReaMax/.{opts}/.Options[CalcRea],
	DG`Steps/.{opts}/.Options[CalcRea],DG`Screen/.{opts}/.Options[CalcRea],
	DG`SampleFile/.{opts}/.Options[CalcRea],DG`OutputFile/.{opts}/.Options[CalcRea],
	DG`PinTX/.{opts}/.Options[CalcRea]
	]];

End[]
                     
EndPackage[]