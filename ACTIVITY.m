(* Name: ACTIVITY`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package calculates activity models *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["ACTIVITY`",{"DEFDAT`","G`","FLUIDS`","UTILITY`"}]

GammaSymbolicB::usage = "GammaSymbolicB[c, comp, model] calculates symbolically
RTln(gamma) and Gex. RTln(gamma) is calculated from the derivative of Gex (extensive)
with respect to mole number. <c> is 2 for binaries, 3 for ternaries, etc.,
<comp> is the index of the component under question,
<model> may be 1, 2 or 3 and determines the formalism for Gex to be used:
If model = 1: Gex according to Berman and Brown (1984), eq. (9),
                               Geochim Cosmochim Acta 48: 661-678;
           2: Gex according to Jackson (1989), eq. (6), Am Min 74: 14-17;
           3: Gex according to Meyre et al. (1997), eq. (3),
                               J metamorphic Geol 15: 687-700.\n
Models 1 and 2 are identical, if binary W's are interchanced,
e.g. w[[1, 1, 2]] = w[[2, 1]], etc., ternary w's are identical.
The ReturnValue of -GammaSymbolicB- as shown in the example (without contexts)
is obtained if the function is copied and run in a Mathematica cell.
Example: GammaSymbolicB[2, 1, 1]\n
{2*x[[1]]*x[[2]]*w[[1,1,2]]-2*x[[1]]^2*x[[2]]*w[[1,1,2]]+
 x[[2]]^2*w[[1,2,2]]-2*x[[1]]*x[[2]]^2*w[[1,2,2]],\n 
 x[[1]]^2*x[[2]]*w[[1,1,2]] + x[[1]]*x[[2]]^2*w[[1,2,2]]}\n
This calculates an expression for RTln(gamma) (first element of the return-list)
and for Gex (2nd element of the return-list) for a binary system for
component 1 using the formalism of Berman and Brown (1984).
Called from: User.
Package name: ACTIVITYB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

ExtractSampleDatB::usage = "ExtractSampleDatB[\"mineral_group\", \"sample_file\"]
is a subfunction of -ActivityB- and extracts mole fractions required for activity calculations
(compatible with Berman data-set) from the file \"sample_file\".
<mineral_group> is one out of the following list:
{amph, bt, cal, chl, ctd, cpx, crd, dol, grt, fetiox, kf, opx, ol, plag, sphen, spin, stau, ta, wm, zoep}
(see CalcFormula::usage for more details).
For amph, bt, cpx, grt, opx, plag and wm -ExtractSampleDatB- tries to read data from the file
\"sample_file.cmp\", which must have been created before with Cmp.exe (part of TWEEQ software).
For the other minerals in the list above, -ExtractSampleDatB- reads the data from the file \"sample_file.fu\",
which must have been created before with -CalcFormula- (see CalcFormula::usage for more details).
Example: ExtractSampleDatB[\"grt\", \"hs78b\"]
ReturnValue:  {{0.02539, 0.09338, 0.76913, 0.11211}, {1.,  0.}}
This extracts {{  XCa,     XMg,     XFe,     XMn},   {XAl, XFe3}} of garnet from the file \"hs78b.cmp\".
Called from: User, -ActivityB-.
Package name: ACTIVITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GammaBB::usage = "GammaBB[m, c, w, x] calculates nsRTlny(m) according to Berman & Brown (1984, Geochim Cosmochim Acta 48: 661-678, eq. 22)
(third-degree polynomial asymmetric excess model) for the m-th out of c cations on site s of component j.
<w> is a list of Margules parameters (three indices) as returned by the PET-function -Margules- (see Margules::usage for more details),
<x> is a list of site fractions as defined in the activity model for the phase under question in ACTIVITYBDAT.m.
Examples: see PET_Activity.nb (examples 2a, 2b).
Called from: User, -ActivityB-.
Package name: ACTIVITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

Margules::usage = "Margules[p, t, par, nc] calculates Margules parameters at P (bars)and T (K) according to
the relation: WG = WH - T WS + P WV.
<par> is the set of Margules parameters for site i with <nc> mixing cations and can be extracted from
the file ACTIVITYBDAT.m (see ActivityB::usage fore more details).
The following option is available with -Margules-:\n
Name            Value           Meaning\n
MargulesMode -> WG (default)    calculate WG
                WH              calculate WH
                WS              calculate WS
                WV              calculate WV\n
Example: see example 10 in PET_Activity_B.nb
Called from: User, -Activity-.
Package name: ACTIVITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

MargulesMode::usage = "MargulesMode is an option of -MargulesB-."

ActivityB::usage = "ActivityB[p, t, min, x] calculates the activity of phase components in solutions (TWEEQ / Berman).
<p> is pressure in bars, <t> is temperature in K, <x> is composition (mole(site)-fractions).
See file PET_ACTIVITY_B.nb for examples.
For the following phase components of garnet, biotite, white mica, feldpar and amphibole activity models are available
and real activities are returned by default from -ActivityB-:\n
            <min>
garnet:     alm, py, gr, sp,
biotite:    phl, ann,
white mica: mu,  pa,
feldpar:    ab, an, san, mic, kf
amphibole:  tr, fact, ts, fts, prg, fprg\n
For the following phase components ideal activities are returned by -ActivityB- if a sample file is specified:\n
andr, ma, anth, gl, di, cats, hed, jd, en, enc, enp, fs, clin, fst, fcrd,
crd, fa, fo, zo, zoc, cal, mag, dol, mt, herc, spi, ilm, hem, sph, ta.\n
The following options are available with -ActivityB- (first is default):\n
Name                 Value                 Meaning\n
ActivitySampleFile ->\"None\"                define a sample file from which mineral-chemical data are read
ActivityMode  ->     RealActivity          calculate the real activity if possible (see above)
                     IdealActivity         calculate the ideal activity
                     IdealActivitySymbolic return a symbolic expression for the ideal activity
                     ActivityCoefficient   calculate the activity coefficient (s-sites)
                     DisplayActivityModel  display the activity model for the phase component <min>
ActivityModelGrt ->  GrtBerman             Berman (1990), Am Min 95:328-344
                     GrtHoldaway           Holdaway (2000), Am Min 85: 881-892
                     GrtMukhopadhyay       Mukhopadhyay et al. (1997), Am Min 82:165-181
                     GrtBermanAranovich    Berman & Aranovich (1996), Contrib Mineral Petrol 126:1-24
                     GrtGanguly            Ganguly et al. (1996), Contrib Mineral Petrol 126:137-151
                     GrtDachs              Dachs (1994), Eur J Mineral 6:291-295.
                     GrtLal                Lal(1993), J metamorphic Geol 11:855-866
                     GrtGangulySaxena      Ganguly & Saxena (1984), Am Min 69:88-97
                     GrtNewtonHaselton     Newton & Haselton (1981)
                                           (In: Newton, Navrotsky, Wood (eds),
                                           Thermodynamics of Minerals and Melts),
                                           used for the garnet-phengite-omphacite barometer.\n
ActivityModelBt ->   BtMcMullin            McMullin et al. (1991), Can Mineral 29:889-908.
                     BtBenisek             Benisek et al. (1996), Contrib Mineral Petrol 125:85-99
                                           (uses WFeAl = -29 kJ and WMgAl = 22.8 kJ,
                                           Circone & Navrotsky 1992, Am Mineral 77:
                                           1191-1205); Fe-Mg mixing is assumed ideal)\n
ActivityModelWm  ->  WmChatterjeeFroese    Chatterjee & Froese (1975), Am Min 60:985-993\n
ActivityModelFsp ->  FspFuhrmanLindsley    Fuhrman & Lindsley (1988), Am Min 73: 201-215
                                           (WOrAn and WAnOr exchanged, Wen & Nekvasil 1994,
                                           Comp Geosci 20:1025-1040)
                     FspElkinsGrove        Elkins & Grove (1990), Am Min 75:544-559
                                           (Wv for Ab-Or have been interchanged,
                                           Kroll et al., 1993, CMP 114:510-518)
                     FspLindsleyNekvasil   Lindsley & Nekvasil (1988), EOS 70:506
                     FspNekvasilBurnham    Nekvasil & Burnham (1987), in: Mysen (ed), magmatic processes
                     FspGreenUsdansky      Green & Usdansky (1986), Am Min 71:1100-1108
                     FspGhiorso            Ghiorso (1984), Contrib Mineral Petrol 87:282-296
ActivityModelAmph -> AmphMaederEtAl        Mäder et al. (1994), Can J Earth Sci 31:1134-1145\n
Don't change the defaults of activity-models in PT-calculations with the B88 data-set in order to maintain internal consistency!\n
-ActivityB- reads information required for activity-model calculations from the file ACTIVITYBDAT.m:
The data structure in this file is designed as Mathematica-list with three elements for each mineral group:\n
Element 1: definition of mineral group and activity model (site occupancies):
{\"mineral_group\", {{\"site_1\",{\"site_1_cation_1\",\"site_1_cation_2\",...}},
                   {\"site_2\",{\"site_2_cation_1\",\"site_2_cation_2\",...}},...}}\n
Example for garnet (sites are named \"C\" and \"B\"):\n
{\"grt\", {{\"C\", {\"Ca\", \"Mg\", \"Fe\", \"Mn\"}}, {\"B\", {\"Al\", \"Fe3\"}}}}\n
From this definition it follows that the required site-fractions -ActivityB- needs to know for garnet are:
{{\"XCa\",\"XMg\",\"XFe\",\"XMn\"},{\"XAl\",\"XFe3\"}}
Exactly these data are calculated by -CalcFormula- and read by -ActivityB- from a *.fu file, if the option:
ActivitySampleFile ->\"sample_file\"
has been used. Alternatively, this list can be passed to -ActivityB- as <x> parameter.\n
Element 2: defintion of end-member site occupancies:
{{\"end_member_1\", {{site_1_cations},{site_2_cations},...}},
 {\"end_member_2\", {{site_1_cations},{site_2_cations},...}},...}\n
Example for garnet:\n
{{\"gr\",   {{\"Ca\", \"Ca\", \"Ca\"}}},
 {\"py\",   {{\"Mg\", \"Mg\", \"Mg\"}}},
 {\"alm\",  {{\"Fe\", \"Fe\", \"Fe\"}}},
 {\"sp\",   {{\"Mn\", \"Mn\", \"Mn\"}}},
 {\"andr\", {{\"Ca\", \"Ca\", \"Ca\"}, {\"Fe3\", \"Fe3\"}}}}\n
Remark: For gr, py, alm, sp only mixing on site_C is considered, andr is treated ideal.\n
Element 3: definition of Margules parameters (empty list = {} for ideal mixing):
{
 {\"model_1\",{{site_1_parameters},{site_2_parameters},...}},
 {\"model_2\",{{site_1_parameters},{site_2_parameters},...}},...
}\n
<site_i_parameters> are given as two-element list:
{{square-matrix of Margules parameters},{ternary parameter(s)}}\n
Each element in the square matrix in turn consists of the elements {WH, WS, WV} on a one-site basis.
Example for garnet:
The defintion of the activity model (element 1) shows that site_C cations are: {\"Ca\", \"Mg\", \"Fe\", \"Mn\"}.
Margules parameters for site_C interaction are thus given in a 4 x 4 square matrix (diagonal elements are always 0).
Matrix element 12: {21560/3, 18.79/3, 0.1/3} represents CaMg interaction (transformed by -Margules- to three indices: 112),
Matrix element 21: {69200/3, 18.79/3, 0.1/3} represents MgCa interaction (transformed by -Margules- to three indices: 122) etc.
{
  {\"GrtBerman\", {{
                    {{{0, 0, 0}, {21560/3, 18.79/3, 0.1/3}, {20320/3, 5.08/3, 0.17/3}, {0, 0, 0}},
                    {{69200/3, 18.79/3, 0.1/3}, {0, 0, 0}, {230/3, 0, 0.01/3}, {0, 0, 0}},
                    {{2620/3, 5.08/3, 0.09/3}, {3720/3, 0, 0.06/3}, {0, 0, 0}, {0, 0, 0}},
                    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}},
                    {{{1, 2, 3}, {0, 0, 0}}}
                  }}},
  ...
}
Examples: see PET_Activity_B.nb.
Called from: User, -CalcRea-.
Calls: -LoadActivityData-, -ExtractSampleDatB-, -IdealActivity-, -CalcGammaB-.
Package name: ACTIVITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

ActivitySampleFile::usage = "ActivitySampleFile is an option of -ActivityB- and -ActivityHP-."
ActivityMode::usage = "ActivityMode is an option of -ActivityB- and -ActivityHP-."
ActivityModelGrt::usage = "ActivityModelGrt is an option of -ActivityB-."
ActivityModelBt::usage = "ActivityModelBt is an option of -ActivityB-."
ActivityModelWm::usage = "ActivityModelWm is an option of -ActivityB-."
ActivityModelFsp::usage = "ActivityModelFsp is an option of -ActivityB-."
ActivityModelAmph::usage = "ActivityModelAmph is an option of -ActivityB-."
ActivityMingroup::usage = "ActivityMingroup is an option of -ActivityHP-."

ActivityHP::usage = "ActivityHP[p, t, min, x] calculates the activity of phase components in solutions (THERMOCALC / Holland & Powell).
<p> is pressure in bars, <t> is temperature in K, <x> is composition (mole(site)-fractions):
<x> must be a two-element list of the form:
x = {{x1 = list of site fractions}, {x2 = list of end-member proportions}}
(see file PET_Activity_HP.nb for details and examples).
Activities can be calculated for all mineral groups mentioned in the documentation to the AX-program
of Holland & Powell (except osumilites and scapolites).
The following options are available with -ActivityHP- (first is default):\n
Name                 Value                 Meaning\n
ActivitySampleFile ->\"None\"                define a sample file from which mineral-chemical data are read
ActivityMode  ->     RealActivity          calculate real activities if possible (see above)
                     IdealActivity         return ideal activities for all phase components
                     IdealActivitySymbolic return a symbolic expression for the ideal activity
                     ActivityCoefficient   return the activity coefficient (s-sites)
                     DisplayActivityModel  display the activity model for the phase component <min>
                     SiteFractions         return site fractions (e.g. when order-dependent)
                     Q                     return order parameter (chl, bt, zoi)
ActivityMingroup -> \"None\"                 define the mineral group (required e.g. for ab in either
                                           plagioclase- or K-feldspar solid solutions)\n
-ActivityHP- reads information required for activity-model calculations from the file ACTIVITYHPDAT.m:
The data structure in this file is designed as Mathematica-list with three elements for each mineral group:\n
Element 1: definition of mineral group and activity model (site occupancies):
{\"mineral_group\", {{\"site_1\",{\"site_1_cation_1\",\"site_1_cation_2\",...}},
                   {\"site_2\",{\"site_2_cation_1\",\"site_2_cation_2\",...}},...}}\n
Example for garnet (sites are unlabeled):\n
{\"grt\", {{\"\", {\"Ca\", \"Mg\", \"Fe\", \"Mn\"}}, {\"\", {\"Al\", \"Fe3\"}}}}\n
From this definition it follows that the required site-fractions -ActivityHP- needs to know for garnet are:
{{\"XCa\",\"XMg\",\"XFe\",\"XMn\"},{\"XAl\",\"XFe3\"}}
Exactly these data are calculated by -CalcFormula- and read by -ActivityHP- from a *.fu file, if the option:
ActivitySampleFile ->\"sample_file\"
has been used. Alternatively, this list can be passed to -ActivityHP- as <x> parameter.\n
Element 2: defintion of end-member site occupancies:
{{\"end_member_1\", {{site_1_cations},{site_2_cations},...}},
 {\"end_member_2\", {{site_1_cations},{site_2_cations},...}},...}\n
Example for garnet:\n
{{\"gr\",   {{\"Ca\", \"Ca\", \"Ca\"}}},
 {\"py\",   {{\"Mg\", \"Mg\", \"Mg\"}}},
 {\"alm\",  {{\"Fe\", \"Fe\", \"Fe\"}}},
 {\"sp\",   {{\"Mn\", \"Mn\", \"Mn\"}}},
 {\"andr\", {{\"Ca\", \"Ca\", \"Ca\"}, {\"Fe3\", \"Fe3\"}}}}\n
Element 3: definition of Margules parameters (empty list = {} for ideal mixing):
{
 {square-matrix of Margules parameters (kJ)},
 {optional list with stoichiometries of dependent end-members},
 delta-H of internal ordering reaction
}\n
Elements in the square matrix may consist of the elements {WH, WS, WV}.
Called from: User, -CalcRea-.
Calls: -LoadActivityData-, -ExtractSampleDatHP-, -IdealActivity-, -CalcGammaHP-.
Package name: ACTIVITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

Activity::usage = "See ActivityB::usage (B88 data set compatible) or ActivityHP::usage (HP data set compatible)."
Begin["`Private`"]

(* --------------------------- functions for Berman data set ----------------------------------- *)

GammaSymbolicB[c_, comp_, model_] := 
  Block[{gex = 0, gex1, i, j, k, x, n, q, gexn, gamma, sumn, w},
    Off[Part::partd];
    (* note : model 1 and 2 are identical, if binary W's are interchanced, 
      e.g.
          w[[1, 1, 2]] = w[[2, 1]], etc., ternary w's are identical *)
    
    If[model == 1,(* setup expression for Gex : Berman and Brown, 1984, eq.9 *)
        For[i = 1, i <= (c - 1), i++, For[j = i, j <= c, j++,
            For[k = j, k <= c, k++,
              If[k != i, gex = gex + w[[i, j, k]]x[[i]]x[[j]]x[[k]]
                ]]]];
      ];
    
    If[model == 2,(* 
        setup expression for Gex : 
            Wohl equation expanded according to Jackson, 1989, eq.6 *)
      For[i = 1, i <= (c - 1), i++, 
        For[j = 2, j <= c, j++, 
          If[i < j, 
            gex = gex + x[[i]]x[[j]](x[[i]]w[[j, i]] + x[[j]]w[[i, j]])]]];
      For[i = 1, i <= (c - 2), i++, 
        For[j = 2, j <= (c - 1), j++, 
          For[k = 3, k <= c, k++, 
            If[i < j && j < k, 
              gex = gex + x[[i]]x[[j]]x[[k]]q[[i, j, k]]]]]];
      ];
    
    If[model == 3,(* setup expression for Gex : Meyre et al., 1997, eq.3  *)
        For[i = 1, i <= (c - 1), i++, 
          For[j = i, j <= c, j++, 
            For[k = j, k <= c, k++, 
              If[k != i, 
                If[k == i || k == j || j == i, 
                  gex = gex + w[[i, j, k]]x[[i]]x[[j]]x[[k]]/(x[[i]] + x[[k]]);]]]]];
      ];
    
    gex1 = gex;
    
    sumn = Sum[n[[j]], {j, 1, c}];
    For[i = 1, i <= c, i++, gex = gex /. x[[i]] -> n[[i]]/sumn]; (* 
      replace mole fractions by moles *)
    gexn = gex sumn;				(* symbolic gex for all moles *)
    gamma = D[gexn, n[[comp]]];			(* RTln(gamma) *)
    If[model == 1 || model == 2 || model == 3, 
      gamma = gamma /. {sumn -> 1, n -> x}];
    Return[{gamma, gex1}];
    On[Part::partd];
    ]

LoadActivityData[file_] := LoadActivityData[file] = Get[file]

ExtractSampleDatB[mingroup_, samplefile_] := ExtractSampleDatB[mingroup, samplefile] =
   Block[{fname,r,minpos,x,pos1,pos11,twq,fnamel,ftest,dat,minlist,md,ii,nn,min1,n,l,dat3,jj,dat2,dat1,pos3,act1},

   If[samplefile ==  "None", Return[-1]];
   If[samplefile !=  "None", fname = StringJoin[samplefile, ".fu"]];
   r = Get[fname];
   If[r == $Failed, Print["Error-message from -ActivityB-: Sample-file \"", samplefile , "\" does not exist."];
           	    Print["Use -CalcFormula- to create it."]; Return[-1]];           		    
   pos1=pos11=Position[{"grt","bt","wm","amph","cpx","opx"},mingroup];
   
   If[pos1 != {}, (* read data from *.cmp file for {"grt","bt","wm","plag","amph","cpx","opx"} *)
      pos1 = pos1[[1,1]]; 
     twq = {"GARN","BIOT","MICA","AMPH","CPX ","OPX "}; (* PLAG is exluded here, because CMP.exe usually only produces **** for plag *)
     ftest = OpenRead[fnamel=StringJoin[samplefile, ".cmp"]]; Close[ftest];
      If[ftest == $Failed,
         Print["Error-message from -ActivityB-: File \"", fnamel,"\" does not exist."];
        Print["Use Cmp.Exe to create it."]; Return[-1];
        ];
     dat = ReadList[StringJoin[samplefile, ".cmp"], Character, RecordLists -> True, RecordSeparators -> {"\n", "\r"}];
     minlist = {}; md = {};
     For[ii = 1, ii <= Dimensions[dat][[1]], ii++,
        nn = Dimensions[Position[dat[[ii]], "["]][[1]];
        If[nn == 0, (* lines with data  *)
        min1 = StringJoin[dat[[ii, 1]], dat[[ii, 2]], dat[[ii, 3]], dat[[ii, 4]]];
        minlist = Append[minlist, min1];
        n = Dimensions[Position[dat[[ii - 1]], "["]][[1]]; (* number of data per data line  *)
        l = Dimensions[dat[[ii]]][[1]];
        dat3 = {};
        For[jj = 1, jj <= n, jj++,
      	   dat2 = "";
      	   If[6jj + 5 <= l, dat1 = Take[dat[[ii]], {6jj, 6jj + 5}], 
             dat1 = Take[dat[[ii]], {6jj, 6jj + 4}]];        		    
             If[dat1 == {"*", "*", "*", "*", "*", " "} || dat1 == {"*", "*", "*", "*", "*"},
               dat1 = {"0", ".", "0", "0", "0", " "}; 
               ];                        		         		    
             dat3 = Append[dat3, ToExpression[Last[ Table[dat2 = StringJoin[dat2, dat1[[iii]]], {iii, 1, Dimensions[dat1][[1]]}]]]];
      	   ];
           md = Append[md, dat3]; (* md: mineral data in *.cmp file  *)
           ];
        ];
     pos3 = Position[minlist,twq[[pos1]]];		  
     If[pos3 != {}, md = md[[pos3[[1,1]]]], 
       Print["Error-message from -ActivityB-:"];
       Print["Data for \"",twq[[pos1]],"\" do not appear in file \"",StringJoin[samplefile, ".cmp"],"\"."];
       Return[-1];
       ];
                  
     If[mingroup == "grt",
       minpos = Position[r, ToExpression[mingroup]];
       If[minpos != {}, (* Use data for {"XAl","XFe3"} from *.fu file *)
         If[Dimensions[Dimensions[minpos]][[1]] > 1, minpos = Last[minpos]]; (* take last if there are more  *)
           act1 = Last[r[[2, minpos[[2]]]]][[2]];
         ]; (* end of If[minpos != {}   *)		    
       x = {md,act1[[2,2]]}];
     If[mingroup == "bt",x = {{md[[5]]},{md[[1]],md[[2]],md[[3]],md[[4]]},{md[[6]]}}];		  		  		
     If[mingroup == "wm",x = {{md[[1]],md[[2]],0},{md[[3]],0,0},{md[[4]]}}];		  		  		
     If[mingroup == "plag",x = {{md[[2]],md[[1]],md[[3]]}} ];		  		  		
     If[mingroup == "amph",
       minpos = Position[r, ToExpression[mingroup]];
       If[minpos != {}, (* Use data for {"XAlT1","XSiT1"} from *.fu file *)
         If[Dimensions[Dimensions[minpos]][[1]] > 1, minpos = Last[minpos]]; (* take last if there are more  *)
           act1 = Last[r[[2, minpos[[2]]]]][[2]];
         ]; (* end of If[minpos != {}   *)		    
        x = {{md[[1]],md[[2]],md[[3]]},{md[[9]],md[[10]],md[[11]],md[[12]],0},{md[[13]],md[[14]],md[[15]]},{md[[4]],md[[5]],md[[6]],md[[7]],md[[8]]},{md[[19]]},act1[[2,6]]};
        ];		  		  		
     If[mingroup == "cpx",x = {{md[[4]],md[[5]],md[[6]],0},{md[[3]],md[[1]],md[[2]]}} ];		  		  		
     If[mingroup == "opx",x = {{0,0,md[[4]],md[[3]]},{md[[2]],md[[1]],0}} ];		  		  		
     ]; (* end of If[pos1 != {}, *)

   If[pos1 == {}, (* read data from *.fu file  *)
     minpos = Flatten[Position[r, ToExpression[mingroup]]];
     If[minpos == {}, (* Print["Warning from -ActivityB-: \"", mingroup,"\" does not exist in sample file."]; *)
	Return[-1]];
     x = Last[r[[2, minpos[[2]]]]][[2, 2]];
     ];     
   Return[x];                
]

IdealActivity[am_, so_, x_, flag_] := IdealActivity[am, so, x, flag] =
   Block[{i,aml=am[[2]],sol=so[[2]],ns,j,rm,pos,aid=1,str},
   (* calculate ideal activities for end-members in B88:
      am: activity model, e.g. for grt: {"grt", {{"M2", {"Mg", "Ca", "Fe", "Mn"}}, {"M1", {"Al", "Fe3"}}}}, 
      so: site occupancy of end-member, e.g. for py: {"py", {{"Mg", "Mg", "Mg"}, {"Al", "Al"}}},
      x: site fractions, e.g. for grt: {{0.09338, 0.02539, 0.76913, 0.11211}, {1., 0.}} *)

   For[i = 1, i <= Dimensions[sol][[1]], i++, (* loop over different sites  *)
      ns = Dimensions[sol[[i]]][[1]]; (* site multiplicity of site i *)
      For[j = 1, j <= ns, j++, (* loop over number of cations on site i *)
	 If[Dimensions[sol[[i, j]]] == {},  
      	 (* rm : number of a specific cation of type m on site i *)
           rm = Dimensions[Position[sol[[i]], sol[[i, j]]]][[1]];                           
           pos = Flatten[Position[aml[[i,2]], sol[[i, j]]]];
           If[pos == {}, Continue[]];
           If[flag == 0, aid = aid*(ns/rm)*x[[i,pos]][[1]]];          
           If[flag == 1, 
             str = ToExpression[StringJoin["X",aml[[i,2,pos]],am[[2,i,1]]]];
             aid = aid*(ns/rm)*str];          
	   ];
	 If[Dimensions[sol[[i, j]]] != {},
    	   rm = sol[[i, j, 2]]; exp = sol[[i, j, 3]];
    	   pos = Flatten[Position[aml[[i, 2]], sol[[i, j, 1]]]];
           If[pos == {}, Continue[]];
    	   If[flag == 0, aid = aid*((ns/rm)*x[[i, pos]][[1]])^exp];
    	   If[flag == 1, 
      	     str = ToExpression[StringJoin["X", aml[[i, 2, pos]], am[[2, i, 1]]]];
      	     aid = aid*((ns/rm)*str)^exp];
    	   ];
         ];   
      ];	
   Return[aid];
   ]

GammaBB[m_, c_, w_, x_] := GammaBB[m, c, w, x] = 
   Block[{nrtlny = 0, i, j, k, qm, p = 3},
   (* nsRTlny(m) according to Berman & Brown (1985, eq. 22) : 
      third - degree polynomial asymmetric excess model for the m_th out of c cations on site s 
      of component j. Identical results are calculated with the PET - function -GammaSymbolicB-   *)
    
   For[i = 1, i <= (c - 1), i++,
      For[j = i, j <= c, j++,
         For[k = j, k <= c, k++,
            If[k != i,
              qm = Dimensions[ Position[{i, j, k}, m]][[1]];              
              nrtlny = nrtlny + w[[i, j, k]](qm x[[i]]x[[j]]x[[k]]/x[[m]] + (1 - p)x[[i]]x[[j]]x[[k]] )
            ]]]];
   Return[nrtlny];
   ]

MMargulesB[p_,t_,par_,nc_,ACTIVITY`MargulesMode_] := MMargulesB[p,t,par,nc,ACTIVITY`MargulesMode] = 
Block[{wh,ws,wv,w,c,marg,ter,i,j,k,fak=0.5},
   (* calculate Margules mixing parameters: p: pressure (bars), t: temperature (K),
      par: set of mixing parameters, nc: number of cations c on site i *)    
      
   wh = ws = wv = w = ch = cs = cv = c = Table[0, {i, 1, nc}, {j, 1, nc}, {k, 1, nc}];   

   {marg,ter} = par; (* marg: binary Margules parameters; ter: ternary parameters  *)
      
   For[i = 1, i <= Dimensions[marg][[1]], i++, (* loop over quadratic Margules parameter matrix *)
      For[j = 1, j <= Dimensions[marg[[i]]][[1]], j++,
         If[j >= i, {wh[[i,i,j]],ws[[i,i,j]],wv[[i,i,j]]} = marg[[i,j]]]; (* transform to three indices *)
         If[j < i, {wh[[j,i,i]],ws[[j,i,i]],wv[[j,i,i]]} = marg[[i,j]]];      
         ];  
      ];
   For[i = 1, i <= Dimensions[ter][[1]], i++, (* loop over ternary parameter(s) *)
      {ch[[ter[[i,1,1]],ter[[i,1,2]],ter[[i,1,3]]]],cs[[ter[[i,1,1]],ter[[i,1,2]],ter[[i,1,3]]]],
       cv[[ter[[i,1,1]],ter[[i,1,2]],ter[[i,1,3]]]]} = ter[[i,2]];
      ];     
      
   If[ACTIVITY`MargulesMode == ACTIVITY`WG, w = (wh - t ws + p wv); c = (ch - t cs + p cv)];
   If[ACTIVITY`MargulesMode == ACTIVITY`WH, w = wh];
   If[ACTIVITY`MargulesMode == ACTIVITY`WS, w = ws];
   If[ACTIVITY`MargulesMode == ACTIVITY`WV, w = wv];

   (* calculate ternary interaction parameters *)
   For[i = 1, i <= nc - 2, i++, 
      For[j = 1, j <= nc - 1, j++, 
         For[k = 1, k <= nc, k++, 
            If[j > i && k > j, 
              w[[i, j, k]] = fak(w[[i, i, j]] + w[[i, j, j]] + w[[i, i, k]] + 
                             w[[i, k, k]] + w[[j, j, k]] + w[[j, k, k]]) - c[[i, j, k]];
              ]]]];
   Return[w];
]
Options[MargulesB] = {ACTIVITY`MargulesMode->ACTIVITY`WG};
MargulesB[p_, t_, par_, nc_, opts___] := Block[{opt = {ACTIVITY`MargulesMode},i,n = Dimensions[{opts}][[1]]}, 
      For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
         Print["Unknown option ", {opts}[[i, 1]], " in -MargulesB-"];
         Print["Known option is: ", opt]; Return[-1]]];
MMargulesB[p, t, par, nc, ACTIVITY`MargulesMode /. {opts} /. Options[MargulesB]]];

CalcGammaB[p_,t_,am_,so_,marg_,mf_] := CalcGammaB[p,t,am,so,marg,mf] = 
   Block[{mingroup=am[[1]],aml=am[[2]],i,sol=so[[2]],j,jj,m,c,x,rtlny,y=1,yy,w,r=8.3143,dim},
   (* calculate activity coefficient: p: Pressure (bar), t: Temperature (K), 
      am: activity model, e.g. for grt: {"grt", {{"C", {"Ca", "Mg", "Fe", "Mn"}}}, 
      so: site occupancy of end-member, e.g. for py: {"py", {{"Mg", "Mg", "Mg"}}}, 
      marg: margules parameters; mf: mole fractions *)

   For[i = 1, i <= Dimensions[sol][[1]], i++, 			(* loop over different sites i *)
      yy = 1;
      For[j = 1, j <= Dimensions[sol[[i]]][[1]], j++,  		(* loop over different cations on site i  *)  
         m = Flatten[Position[aml[[i,2]],sol[[i,j]]]][[1]]; 	(* find which is the m-th component  *)
         c = Dimensions[aml[[i,2]]][[1]]; 			(* number of cations c on site i *)
         x = mf[[i]];						(* mole fractions on site i  *)			
         If[marg[[i]] != {}, w = MargulesB[p, t, marg[[i]], c]; 
           rtlny = GammaBB[m,c,w,x]; (* RTlny for the m-th out of c cations on site i  *)
           yy = Exp[rtlny/(r t)];
           ];
	 y = y*yy;
         ];
      ];
   Return[y];
]

AActivityB[p_,t_,min_,mf_,ACTIVITY`ActivityMode_,ACTIVITY`ActivityModelGrt_,ACTIVITY`ActivityModelBt_,ACTIVITY`ActivityModelWm_,
  ACTIVITY`ActivityModelFsp_,ACTIVITY`ActivityModelAmph_,ACTIVITY`ActivitySampleFile_] :=
   Block[{dat,fname="ACTIVITYBDAT.m",mingroup,x,xan,pos1,pos2,pos3,am,so,aid,y=1,marg,i,j,fak=1,mode=ACTIVITY`ActivityMode,model="Ideal",
   optmode = {ACTIVITY`RealActivity, ACTIVITY`IdealActivity,ACTIVITY`IdealActivitySymbolic ,ACTIVITY`ActivityCoefficient,ACTIVITY`DisplayActivityModel},
   optgrt = {ACTIVITY`GrtHoldaway, ACTIVITY`GrtMukhopadhyay, 
             ACTIVITY`GrtBermanAranovich, ACTIVITY`GrtGanguly, ACTIVITY`GrtDachs, ACTIVITY`GrtLal,
             ACTIVITY`GrtBerman, ACTIVITY`GrtGangulySaxena, ACTIVITY`GrtNewtonHaselton},
   optbt = {ACTIVITY`BtMcMullin, ACTIVITY`BtBenisek},
   optwm = {ACTIVITY`WmChatterjeeFroese,ACTIVITY`WmEugsterEtAl},
   optfsp = {ACTIVITY`FspElkinsGrove, ACTIVITY`FspFuhrmanLindsley, ACTIVITY`FspGhiorso, 
             ACTIVITY`FspGreenUsdansky, ACTIVITY`FspLindsleyNekvasil, ACTIVITY`FspNekvasilBurnham},
   optamph = {ACTIVITY`AmphMaederEtAl}
   },
   
  If[Intersection[{ACTIVITY`ActivityMode}, optmode] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityMode, "\" for option \"ActivityMode\""];
      Print["Allowed values are: ", optmode]; Return[-1]];
    If[Intersection[{ACTIVITY`ActivityModelGrt}, optgrt] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityModelGrt, "\" for option \"ActivityModelGrt\""];
      Print["Allowed values are: ", optgrt]; Return[-1]];
    If[Intersection[{ACTIVITY`ActivityModelBt}, optbt] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityModelBt, "\" for option \"ActivityModelBt\""];
      Print["Allowed values are: ", optbt]; Return[-1]];
    If[Intersection[{ACTIVITY`ActivityModelWm}, optwm] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityModelWm, "\" for option \"ActivityModelWm\""];
      Print["Allowed values are: ", optwm]; Return[-1]];
    If[Intersection[{ACTIVITY`ActivityModelFsp}, optfsp] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityModelFsp, "\" for option \"ActivityModelFsp\""];
      Print["Allowed values are: ", optfsp]; Return[-1]];
    If[Intersection[{ACTIVITY`ActivityModelAmph}, optamph] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityModelAmph, "\" for option \"ActivityModelAmph\""];
      Print["Allowed values are: ", optamph]; Return[-1]];

   dat = LoadActivityData[fname]; (* load activity-data set *)
   mingroup = MinDat[min]; (* mineral group to which the phase component min belongs to *)
   If[mingroup == -1, (* input error *)
     Print["Error-message from -ActivityB-: Input error: phase component \"", min, "\" does not exist."];
     Return[-1]]; 
   mingroup = mingroup[[1,4]];	(* mineral group to which the phase component min belongs *)
   If[mingroup == "fluid",
     If[ToString[min] == "h2o" || ToString[min] == "co2" ||ToString[min] == "h2",
       If[mf == 1 && ToString[Options[DG`CalcRea][[1]]] != "CalcReaMode -> TXCO2" || 
          mf == 1 && ToString[Options[DG`CalcRea][[1]]] != "CalcReaMode -> TXH2", Return[{FluidActivity[min,p,t,mf],StringJoin["a(",ToString[min],")=1"]}]];
       Return[{FluidActivity[min,p,t,mf],StringJoin["a(",ToString[min],")=",ToString[{Options[FluidActivity][[2]],Options[FluidActivity][[3]]}]]}];
       ];
     Return[{mf,StringJoin["a(",ToString[min],")=",ToString[mf]]}];        
     ];   

   If[mingroup != "", 
     pos1 = Flatten[Position[dat,mingroup]][[1]]; (* find position of correct parameters for mineral group in question *)
     pos2 = Flatten[Position[dat[[pos1,2]],ToString[min]]][[1]]; (* find position of end-member site occupancies *)
     am = dat[[pos1,1]]; 	(* am: activity model: e.g. for grt: {{"C", {"Ca", "Mg", "Fe", "Mn"}}}  *)
     so = dat[[pos1,2,pos2]]; 	(* so: site occupancy of end-member: e.g. for py: {"py", {{"Mg", "Mg", "Mg"}}} *) 
     marg = dat[[pos1,3]];	(* marg: Margules parameters *)
     ];  
   (* ------------- display activity model(s)  ----------------   *)
   If[mode == ACTIVITY`DisplayActivityModel,
     If[marg == {}, 
       Print["Ideal activity-model for ",mingroup,": aid(",so[[1]],") = ",N[IdealActivity[am,so,x,1]]]];
     If[marg != {}, 
       Print["Activity-model for: ",mingroup," (one-site basis). Number ",pos1," in data file."];
       Print["Ideal activity: aid(",so[[1]],") = ",N[IdealActivity[am,so,x,1]]];
       For[i=1,i<=Dimensions[marg][[1]],i++, (* loop over different activity models *)
          Print["___________________________________"];
          Print["Activity-model ",i,": ",marg[[i,1]]];
          For[j=1,j<=Dimensions[marg[[i,2]]][[1]],j++, (* loop over different sites *)
             If[marg[[i,2,j]] == {}, Print["Site ",j," {name, occupancy}: ",am[[2,j]]," Ideal"]];
             If[marg[[i,2,j]] != {},
               Print["Site ",j," {name, occupancy}: ",am[[2,j]]," NonIdeal"];
               Print["Margules parameters displayed as square-matrix: ",am[[2,j,2]]," x ",am[[2,j,2]]];
               Print["Each matrix-element is {WH, WS, WV} on a one-site basis. Units: J, bar, mol."];
               Print[MatrixForm[N[marg[[i,2,j,1]]]]];
               Print["Ternary parameter(s): ",marg[[i,2,j,2]]];
               ]]]];       
     Return[];     
     ];

  (* -------- define mole fractions --------  *)
   If[ACTIVITY`ActivitySampleFile != "None", (* read mole fractions from sample-file *) 
     x = ExtractSampleDatB[mingroup, ACTIVITY`ActivitySampleFile];If[x == -1, Return[{1,StringJoin["a(",ToString[min],")=1"]}]]
     ];    
   If[ACTIVITY`ActivitySampleFile == "None", (* mole fractions are given as input *) 
     If[Head[mf] == List, x = mf]; (* accept mole fractions as input *) 
     If[Head[mf] == Integer || Head[mf] == Real || Head[mf] == Symbol, (* return input-activity unchanged *)
       Return[{mf,StringJoin["a(",ToString[min],")=",ToString[mf]]}]]; 
     ];    
      
   (* --------  set the desired activity-model  ----------  *)
   If[mingroup == "grt", If[ToString[min] != "andr", model = ToString[ACTIVITY`ActivityModelGrt]]]; (* grt end-members, except andr *)
   If[mingroup == "bt", model = ToString[ACTIVITY`ActivityModelBt]];
   If[mingroup == "wm", If[ToString[min] != "ma", model = ToString[ACTIVITY`ActivityModelWm]]]; (* wm end-members, except ma *)
   If[mingroup == "plag" || mingroup == "kf", model = ToString[ACTIVITY`ActivityModelFsp]; (* faktor for a(id) in feldspars *)    
     If[ToString[min] == "ab" && model == "FspFuhrmanLindsley" || ToString[min] == "ab" && model == "FspGreenUsdansky", fak = 1-xan^2];
     If[ToString[min] == "abl" && model == "FspFuhrmanLindsley" || ToString[min] == "abl" && model == "FspGreenUsdansky", fak = 1-xan^2];
     If[ToString[min] == "abh" && model == "FspFuhrmanLindsley" || ToString[min] == "abh" && model == "FspGreenUsdansky", fak = 1-xan^2];
     If[ToString[min] == "an" && model == "FspFuhrmanLindsley" || ToString[min] == "an" && model == "FspGreenUsdansky", fak = (1+xan)^2/4];
     If[ToString[min] == "san" && model == "FspFuhrmanLindsley" || ToString[min] == "san" && model == "FspGreenUsdansky", fak = 1-xan^2];
     If[ToString[min] == "mic" && model == "FspFuhrmanLindsley" || ToString[min] == "mic" && model == "FspGreenUsdansky", fak = 1-xan^2];
     If[ToString[min] == "kf" && model == "FspFuhrmanLindsley" || ToString[min] == "kf" && model == "FspGreenUsdansky", fak = 1-xan^2];     
     ];
   If[mingroup == "amph", If[ToString[min] != "anth" && ToString[min] != "gl",model = ToString[ACTIVITY`ActivityModelAmph]]]; (* amph end-members, except anth, gl *)

   (* --------  display ideal-activity expression symbolically --------  *)
  
 If[mode == ACTIVITY`IdealActivitySymbolic, 	
     aid = fak*IdealActivity[am,so,x,1];	(* calculate ideal activity symbolically *)
     Return[StringJoin["aid(",ToString[min],")=",ToString[InputForm[aid]]]];
     ];  
   If[mingroup == "plag" || mingroup == "kf", xan = x[[1,2]]]; (* calculates fak for feldspars *)

   aid = fak*IdealActivity[am,so,x,0];		(* calculate ideal activity; fak is only relevant for feldspars *)
   If[mode == ACTIVITY`IdealActivity, model = "Ideal"; Return[{aid,StringJoin["a(",ToString[min],")=",model]}]];  
   
   (* --------  calculate gamma  ----------  *)
   If[model != "Ideal" && marg != {}, 		
     pos3 = Flatten[Position[marg,model]];	(* position of desired activity model parameters *)   
     marg = marg[[pos3[[1]],2]];		(* Margules parameters of desired model  *)
     y = CalcGammaB[p,t,am,so,marg,x];  	(* calculate gamma  *)
     ];

   If[mode == ACTIVITY`RealActivity, Return[{aid*y,StringJoin["a(",ToString[min],")=",model]}]];
   If[mode == ACTIVITY`ActivityCoefficient,Return[{y,StringJoin["y(",ToString[min],")=",model]}]];
]
Options[ActivityB] = {ACTIVITY`ActivityMode->ACTIVITY`RealActivity,
		     ACTIVITY`ActivityModelGrt -> ACTIVITY`GrtBerman,
		     ACTIVITY`ActivityModelBt->ACTIVITY`BtMcMullin,
		     ACTIVITY`ActivityModelWm -> ACTIVITY`WmChatterjeeFroese,
		     ACTIVITY`ActivityModelFsp -> ACTIVITY`FspFuhrmanLindsley,
		     ACTIVITY`ActivityModelAmph ->ACTIVITY`AmphMaederEtAl,
		     ACTIVITY`ActivitySampleFile ->"None"};
ActivityB[p_, t_, min_, mf_, opts___] :=
    Block[{opt = {ACTIVITY`ActivityMode,ACTIVITY`ActivityModelGrt,ACTIVITY`ActivityModelBt,ACTIVITY`ActivityModelWm,ACTIVITY`ActivityModelFsp,
    ACTIVITY`ActivityModelAmph,ACTIVITY`ActivitySampleFile},i,n = Dimensions[{opts}][[1]]}, 
    For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
       Print["Unknown option \"", {opts}[[i, 1]], "\" in -ActivityB-"];
       Print["Known option is: ", opt]; Return[-1]]];
AActivityB[p, t, min, mf, 
	 ACTIVITY`ActivityMode /. {opts} /. Options[ActivityB],
	 ACTIVITY`ActivityModelGrt /. {opts} /. Options[ActivityB],
	 ACTIVITY`ActivityModelBt /. {opts} /. Options[ActivityB],
	 ACTIVITY`ActivityModelWm /. {opts} /. Options[ActivityB],
	 ACTIVITY`ActivityModelFsp /. {opts} /. Options[ActivityB],
	 ACTIVITY`ActivityModelAmph /. {opts} /. Options[ActivityB],	 
	 ACTIVITY`ActivitySampleFile /. {opts} /. Options[ActivityB]]	 
	 ];

(* --------------------------- functions for Holland & Powell data set ----------------------------------- *)

Findq[min_, t_, dat_] := Block[{r=8.3143,nn,dn,schranke=10^-6,gv,gn,i=0,a,b,c,y,m,n,x,fe3,ti},
    (* Sub-function of OrderDisorderHP: computes numerically q in the o/d-model of biotite *)
    Off[Greater::nord];Off[Less::nord]; 
    {a,b,c,m,n,x,y,fe3,ti} = dat; nn = 0.0001; dn = 0.01;
    gv = a+b nn+c x+m n r t Log[((1-x+1/3 nn)((2/3 nn)+(x)(1-y-fe3-2ti)))/((x-1/3 nn)((1-2/3 nn-y-fe3-ti)+(-x)(1-y-fe3-2ti)))];      
    
    Label[start];
    i++;    
    nn = nn + dn;
    gn = a+b nn+c x+m n r t Log[((1-x+1/3 nn)((2/3 nn)+(x)(1-y-fe3-2ti)))/((x-1/3 nn)((1-2/3 nn-y-fe3-ti)+(-x)(1-y-fe3-2ti)))];    
    If[Head[gv] == Real && Head[gn] == Complex, dn = -dn/2];
    If[Head[gv] == Complex && Head[gn] == Complex, dn = dn/2];
    If[gv < 0 || gn < 0, If[gv > gn, dn = -dn]];
    If[gv > 0 || gn > 0, If[gv < gn, dn = -dn]];
    If[gv > 0 && gn < 0, dn = dn/2];
    If[gv < 0 && gn > 0, dn = dn/2];    
    If[Abs[gv - gn] < schranke, Return[N[nn]];];
    gv = gn;
    If[i == 200, Return[N[nn]]];
    Goto[start];
    On[Greater::nord];On[Less::nord]; 
    ]

OrderDisorderHP[p_?NumberQ,t_?NumberQ,min_,marg_?ListQ,dh_?NumberQ,xx1_?ListQ,yy_?ListQ] := Block[{r=8.3143,a,b,c,d,e,f,y,x,g,n,nn,q2,q,x1=xx1,x2,ti,fe3,
   wao,wab,wbo,m,xam1,xbm1,xam2,xbm2,rtlnky,kd,dg,qmax,pphl,pann,peas,pobi},
     
   If[ToString[min] == "afchl" || ToString[min] == "clin" || ToString[min] == "ames" || ToString[min] == "daph",
     (* o/d in chlorites: Holland et al. (1988): Eu J Mineral 10: 395-406 *)
     a = dh+2marg[[1,2]]-marg[[1,3]];
     b = marg[[1,3]]-2marg[[1,2]]-2marg[[2,3]];
     c = marg[[2,3]]-marg[[1,2]];
     d = marg[[2,3]]+marg[[1,2]]+2marg[[1,4]]-marg[[1,4]]-marg[[3,4]]; e = -d;
     {y,x} = yy; (* y = XAl(T2), x = Fe/(Fe+Mg) *)   	
     If[y <= 0.5, q2 = y-10^-6, q2 = 1-y-10^-6];	(* q2: right limit to which function is defined  *)
     If[y < 0.52, n = FindRoot[a + 2b nn + 2c y + 6/5d x + 6/5e x y + r t Log[((1-y+nn)(y+nn))/((1-y-nn)(y-nn))] == 0,{nn,q2},MaxIterations->100][[1,2]]];
     If[y >= 0.52, n = 1-y]; (* Holland et al. (1988), p. 405  *)
     q = 2n;
     ];
     
     
   If[ToString[min] == "cz" || ToString[min] == "ep" || ToString[min] == "fep",
     m = n = 1; {wao,wab,wbo} = {marg[[1,2]],marg[[1,3]],marg[[2,3]]};
     {x} = yy;    		(* Fe3/(Fe3+Al(VI)-1): bulk Fe3/(Fe3+Al) on M13 (disregarding M2) *)
     a = dh + (m+n)wao - n wab;								
     b = 2/(m+n)(-(m^2) wao + m n(wab-wao-wbo) - (n^2) wbo);
     c = m(wbo-wao-wab) + n(wbo-wao+wab);
     xam1 = 1 - x + n/(m+n) q;	(* XAl(M1)  *)
     xbm1 = x - n/(m+n) q;	(* XFe3(M1) *)
     xam2 = 1 - x - m/(m+n) q;	(* XAl(M3)  *)
     xbm2 = x + m/(m+n) q;	(* XFe3(M3) *)
     kd = (xam1 xbm2)/(xbm1 xam2);
     If[x <= n/(m + n), q2 = (m + n)x/n, q2 = (m + n)(1 - x)/m];(* right limit to which function is defined *)
     q = Chop[FindRoot[a + b q + c x + m n r t Log[kd] == 0,{q,q2-10^-6},MaxIterations->100][[1,2]]]; 
     ];

   If[ToString[min] == "phl" || ToString[min] == "ann" || ToString[min] == "east",
     {wao,wab,wbo} = {marg[[1,4]],marg[[1,2]],marg[[2,4]]};
     {y,x,fe3,ti} = yy;  (* y = XAl(M1); x = Fe/(Fe+Mg); a = Mg (phl), b = Fe (ann) *)
     m = 2; n = 1;		(* see Powell & Holland (1999), p.10 *)				
     a = dh + (m+n)wao - n wab;								
     b = 2/(m+n)(-(m^2) wao + m n(wab-wao-wbo) - (n^2) wbo);
     c = m(wbo-wao-wab) + n(wbo-wao+wab);
     xbm2 = (0 + 2/3 q) + (0 + x)(1 - y - fe3 - 2ti);			(* XFeM1: R. Powell, pers. comm. 2003 *)
     xam2 = (1 - 2/3 q - y - fe3 - ti) + (0 - x)(1 - y - fe3 - 2ti);	(* XMgM1 *)
     xbm1 = 0 + x - 1/3 q;						(* XFeM2 *)
     xam1 = 1 - x + 1/3 q;						(* XMgM2 *)     
     kd = (xam1 xbm2)/(xbm1 xam2);
     (* q = Chop[FindRoot[a + b q + c x + m n r t Log[kd] == 0,{q, 0.00001},MaxIterations->100][[1,2]]];
        FindRoot does not work properly for bt, the self-written function Findq is used instead *) 
     q = Findq[min, t, {a, b, c, m, n, x, y, fe3, ti}];
     x1 = {xx1[[1]],{xam2,xbm2,y},{xam1,xbm1},xx1[[4]]};	
     (* x1: {{"XKA"},{"XMgM1","XFeM1","XAlM1"},{"XMgM2","XFeM2"},{"XSiT1","XAlT1"}}  *)          
     pphl = (1 - 2/3 q - y - fe3 - ti) + (0 - x)(1 - y - fe3 - 2ti);
     pann = (0 + x - 1/3 q);
     peas = y;
     pobi = (0 - x)(0 + y + fe3 + ti) + (0 + q);
     x2 = {pphl,pann,peas,pobi};     
     ];
   Return[q]; 
]

CalcGammaHP[p_, t_, min_, group_, x1_, mf_, mmarg_, so_, nem_] := (* CalcGammaHP[p, t, min, group, x1, mf, mmarg, so, nem] = *)
   Block[{y=1,mff=mf,xx1=x1,x,soo=so,dh,file="ACTIVITYHPDAT.m",pos,marg,ld,nli,m1,m2,i,j,koef,bin,rtlny=0,i1,i2,r=8.3143,dqf=0,v=0,vsum,q={},n,m,fe3,ti},
   (* p: pressure in bars; t: temperature in K; min: phase-component code; group: mineral group of phase-component (e.g. "grt");
      x1: {site-fractions} e.g. {{"XMg","XCa","XFe","XMn"},{"XAl","XFe3"}} for grt;
      mf: proportions of end-members, e.g.{"XPy","XGr","XAlm","XSp","XAndr"} for grt;
      mmarg: activity model parameters: {{quadratic matrix with Margules parameters}, 
      	     				 {list with stoichiometries for dependent end-members},
      	     				 delta-H of order/disorder intracrystalline reaction};
      so: site occupancies of end-member: e.g. for py: {"py", {{"Mg", "Mg", "Mg"}, {"Al", "Al"}}};
      nem: number representing the position of the end-member, e.g. 1 for py, because py is the 1st appearing
           in the list of garnet end-members (see ACTIVITYHP.DAT)
   *)
      	     				
   (* special cases: cpx, plag, kf  *)
   If[group == "cpx", (* x1: {{"M2", {"Ca", "Na", "Mg"}}, {"M1", {"Al", "Fe3", "Mg", "Fe"}}} *)  
     If[x1[[1,2]] > 0.3 && x1[[1,2]] < 0.7, (* P2/n omphacite *)
       If[ToString[min] == "jd", If[x1[[2,1]] > x1[[1,2]], soo = {"jd", {{"Na"}, {""}}}, soo = {"jd", {{""},{"Al"}}} ]];
       If[ToString[min] == "acm", soo = {"acm",  {{""},{"Fe3"}}} ];
       If[ToString[min] == "di", If[x1[[2,3]] > x1[[1,1]], soo = {"di", {{"Ca"}, {""}}}, soo = {"di", {{""},{"Mg"}}} ]];
       If[ToString[min] == "hed",If[x1[[2,4]] > x1[[1,1]], soo = {"hed",{{"Ca"}, {""}}}, soo = {"hed",{{""},{"Fe"}}} ]];
       Return[{y,xx1,soo,q}]; (* return y=1 for omphacite *)
       ]; 
     ];
   If[group == "plag",  If[ToString[min] == "an", dqf = (6.01 - 0.0035*t)*1000]]; (* DQF-term for plag: C1- region *)
   If[group == "plag2", If[ToString[min] == "ab", dqf = (1.04 - 0.0039*t)*1000]]; (* DQF-term for plag: I1- region *)
   If[ToString[min] == "pa" && group == "wm", dqf = (1.42 +0.4p/1000)*1000]; (* DQF-term for pa *)
   If[ToString[min] == "mu" && group == "wm2", dqf = (-3.28)*1000]; (* DQF-term for mu *)
        
   (* setup parameters and matrices *)
   (* marg: quadratic matrix with Margules parameters; ld : set of linear dependencies; dh: delta-H of d/o reaction, v: van Laar model parameters *)
   If[group != "wm3", {marg, ld, dh} = mmarg];
   If[group == "wm3", {marg, ld, dh, v} = mmarg];
   nli = Dimensions[marg][[1]]; (* number of lin. independent end members *)    If[nem > nli && ld == {}, Return[{1,xx1,soo,q}]];
   m1 = Join[IdentityMatrix[nli], ld];
   m2 = Table[{0, 0}, {i, 1, nli}, {j, 1, nli}]; (* matrix with coefficients for RTlny - equation  *)
   koef = m1[[nem]]; (* corresponding row from this matrix for desired end-member  *)

   (* setup m2-matrix: contains coefficients for bracket-terms in RTlny-equation  *)
   For[i = 1, i <= nli, i++,
      For[j = 1, j <= nli, j++,
         If[Dimensions[marg[[i,j]]] != {}, marg[[i,j]] = marg[[i,j,1]]-t*marg[[i,j,2]]+(p-1)/1000*marg[[i,j,3]]];
         If[j > i,
           m2[[i, j, 1]] = koef[[i]]; 
           m2[[i, j, 2]] = koef[[j]]]]];

   marg = marg*1000; dh = dh*1000; v = v*1000; 
         
   (* order/disorder phase: chl *)
   If[ToString[min] == "afchl" || ToString[min] == "clin" || ToString[min] == "ames" || ToString[min] == "daph",
     {y,x} = mff; (* y = XAl(T2), x = Fe/(Fe+Mg) *)            
     q = OrderDisorderHP[p,t,min,marg,dh,xx1,mff];     
     xx1 = {{1-x,x},{(1-y+(q/2))(1-x),y-(q/2),(1-y+(q/2))x},{(1-y-(q/2))(1-x),y+(q/2)},xx1[[4]],{1-y,y}};
     (* xx1: {{"XMgM23","XFeM23"},{"XMgM1","XAlM1","XFeM1"},{"XMgM4","XAlM4"},{"XOH"},{"XSiT2","XAlT2"}} *)
     mff = {1-y-(q/2),2(q/2)-2/5x(3-y),y-(q/2),2/5 x(3-y)}; (* mff: proportions afchl, clin, ames, daph  *) 
   ];
   
   (* order/disorder phase: zoep *)
   If[ToString[min] == "cz" || ToString[min] == "ep" || ToString[min] == "fep",
     {x} = mff;    (* Fe3/(Fe3+Al(VI)-1): bulk Fe3/(Fe3+Al) on M13 (disregarding M2) *)
     q = OrderDisorderHP[p,t,min,marg,dh,xx1,mff];     
     n = m = 1;
     xx1 = {xx1[[1]],{1-x+n/(m+n)q,x-n/(m+n)q},{1-x-m/(m+n)q,x+m/(m+n)q}};
     (* xx1: {{"XCaM2"},{"XAlM1","XFe3M1"},{"XAlM3","XFe3M3"}}  *)
     mff = {1-x-m/(m+n)q,q,x-n/(m+n)q}; (* mff: proportions cz, ep, fep  *)        
   ];

   (* order/disorder phase: bt *)
   If[ToString[min] == "phl" || ToString[min] == "ann" || ToString[min] == "east",
     {y,x,fe3,ti} = mff;  (* y = XAl(M1); x = Fe/(Fe+Mg); fe3 = Fe(3+), ti = Ti; a = Mg (phl), b = Fe (ann) *)
     q = OrderDisorderHP[p,t,min,marg,dh,xx1,mff];     
     xx1 = {xx1[[1]],{(1-2/3 q-y-fe3-ti)+(-x)(1-y-fe3-2ti),(2/3 q)+(x)(1-y-fe3-2ti),y},{1-x+1/3 q,x-1/3 q},xx1[[4]]};	
     (* xx1: {{"XKA"},{"XMgM1","XFeM1","XAlM1"},{"XMgM2","XFeM2"},{"XSiT1","XAlT1"}}  *)               
     mff = {(1-2/3 q-y-fe3-ti)+(-x)(1-y-fe3-2ti),(x-1/3 q),y,(-x)(y+fe3+ti)+(q)};  (* mff: proportions phl, ann, eas, obi  *)    
   ];
                         
   (* calculate RTlny according to symmetric formalism (including asymmetric extension by van Laar model for wm)  *)
   If[group != "kf",
     If[group == "wm3", vsum = Sum[v[[i]]mff[[i]],{i,1,nli}]];
     If[nli > 2, bin = Binom[nli, 2], bin = {{1,2}}];    
     For[i = 1, i <= Dimensions[bin][[1]], i++, 
        i1 = bin[[i, 1]]; i2 = bin[[i, 2]];
	If[group == "wm3", rtlny = rtlny - (m2[[i1, i2, 1]] - mff[[i1]]v[[i1]]/vsum)
	  			   (m2[[i1, i2, 2]] - mff[[i2]]v[[i2]]/vsum)(2v[[nem]]/(v[[i1]]+v[[i2]]))marg[[i1, i2]]];
        If[group != "wm3", rtlny = rtlny - (m2[[i1, i2, 1]] - mff[[i1]])(m2[[i1, i2, 2]] - mff[[i2]])marg[[i1, i2]]];
        ];
     ];
   If[group == "kf", (* special case: kf; asymmetric subregular *)
     If[ToString[min] == "ab",  rtlny = (marg[[1,2]]+2(marg[[2,1]]-marg[[1,2]])mff[[1]])mff[[2]]^2];
     If[ToString[min] == "san", rtlny = (marg[[2,1]]+2(marg[[1,2]]-marg[[2,1]])mff[[2]])mff[[1]]^2];
     ];
                
   Return[{Exp[(rtlny+dqf)/(r*t)],xx1,soo,q}];
]

ExtractSampleDatHP[mingroup_, samplefile_] := Block[{fname,r,minpos,x1,x2,testset1,testset2},

   If[samplefile ==  "None", Return[-1]];
   If[samplefile !=  "None", fname = StringJoin[samplefile, ".fu"]];
   r = Get[fname];
   If[r == $Failed, Print["Error-message from -ActivityHP-: Sample-file \"", samplefile , "\" does not exist."];
           	    Print["Use -CalcFormula- to create it."]; Return[{-1,-1}]];           		                         
   testset1 = Position[r,"HP31"]; testset2 = Position[r,"HP32"];
   If[testset1 == {} && testset2 == {}, 
     Print["Error-message from -ActivityHP-: wrong data set."]; 
     Print["Use -CalcFormula- again and choose HP-data set before."]; Return[{-1,-1}]];
   minpos = Flatten[Position[r, ToExpression[mingroup]]];
   If[minpos == {}, Return[{-1,-1}]];
   {x1,x2} = {Last[r[[2, minpos[[2]]]]][[2, 2]],Last[r[[2, minpos[[2]]]]][[2, 4]]};
   Return[{x1,x2}];                
]


AActivityHP[p_,t_,min_,mf_,ACTIVITY`ActivityMode_,ACTIVITY`ActivitySampleFile_,ACTIVITY`ActivityMingroup_] :=
   Block[{dat,minn=min,fname="ACTIVITYHPDAT.m",mingroup=ACTIVITY`ActivityMingroup,x,x1,x2,pos1,pos2,am,em,so,marg,aid,y=1,i,j,mode=ACTIVITY`ActivityMode,model="HP",model1,q,
   optmode = {ACTIVITY`RealActivity, ACTIVITY`IdealActivity,ACTIVITY`IdealActivitySymbolic,ACTIVITY`ActivityCoefficient,ACTIVITY`DisplayActivityModel,ACTIVITY`SiteFractions,ACTIVITY`Q}},
   
  If[Intersection[{ACTIVITY`ActivityMode}, optmode] == {}, 
      Print["wrong value \"", ACTIVITY`ActivityMode, "\" for option \"ActivityMode\""];
      Print["Allowed values are: ", optmode]; Return[-1]];

   dat = LoadActivityData[fname]; (* load activity-data set *)
  
   If[mingroup == "None",
     mingroup = MinDat[minn]; (* mineral group to which the phase component min belongs to *)
     If[mingroup == -1, (* input error *)
       Print["Error-message from -ActivityHP-: Input error: phase component \"", minn, "\" does not exist."];
       Return[-1]]; 
     mingroup = mingroup[[1,4]];	(* mineral group to which the phase component min belongs *)
     ];
     
   If[mingroup == "fluid",
     If[ToString[min] == "h2o" || ToString[min] == "co2" ||ToString[min] == "h2",
       If[ToString[Options[DG`CalcRea][[1]]] == "CalcReaMode -> TXCO2" || ToString[Options[DG`CalcRea][[1]]] == "CalcReaMode -> TXH2",          
         Return[{FluidActivity[min,p,t,mf],StringJoin["a(",ToString[min],")=",ToString[{Options[FluidActivity][[2]],Options[FluidActivity][[3]]}]]}];
         ];     
       ];
     Return[{mf,StringJoin["a(",ToString[min],")=",ToString[mf]]}];        
     ];   

   (* -------- define mole fractions --------  *)
   If[mode == ACTIVITY`RealActivity || mode == ACTIVITY`IdealActivity || mode == ACTIVITY`IdealActivitySymbolic 
      || mode == ACTIVITY`ActivityCoefficient || mode == ACTIVITY`SiteFractions || mode == ACTIVITY`Q,
     If[ACTIVITY`ActivitySampleFile != "None", (* read mole fractions from sample-file *) 
       {x1,x2} = ExtractSampleDatHP[mingroup, ACTIVITY`ActivitySampleFile];If[x1 == -1, Return[{1,StringJoin["a(",ToString[minn],")=1"]}]]
       ];    
     If[ACTIVITY`ActivitySampleFile == "None", (* mole fractions are given as input *) 
       If[Head[mf] == List, {x1,x2} = mf]; (* accept mole fractions as input *) 
       If[Head[mf] == Integer || Head[mf] == Real || Head[mf] == Symbol, (* return input-activity unchanged *)
         Return[{mf,StringJoin["a(",ToString[minn],")=",ToString[mf]]}]]; 
       ];    

     If[mingroup == "cpx", If[x1[[1,2]] >= 0.7, (* Na in cpx >= 0.7: C2/c sodic cpx *) mingroup = "cpx2"]];
     If[mingroup == "amph", 
       If[x1[[2,2]] > 0.5,  (* XNaM4 > 0.5: sodic amph *) mingroup = "amph2"];
       If[x1[[2,1]] < 0.3 && x1[[2,2]] < 0.3,  (* XCaM4 and XNaM4 < 0.3: Fe-Mg amph *) mingroup = "amph3"]];
     If[mingroup == "wm", 
       If[x1[[1,3]] > 0.5,  (* XCaA > 0.5: margarite *) mingroup = "wm1"];
       If[x1[[1,2]] > 0.5,  (* XNaA > 0.5: paragonite *) mingroup = "wm2"];
       ];   
     If[mingroup == "plag",If[x1[[1,2]] > 0.5, mingroup = "plag2"];
       If[ToString[minn] == "abl" || ToString[minn] == "abh", minn = "ab"]];
     If[mingroup == "kf", If[ToString[minn] == "mic", minn = "san"]];
     ];
 
   If[mingroup != "",     
     If[mingroup == "wm", If[ToString[Options[Dataset][[1, 2]]] == "HP32", mingroup = "wm3"]];   
     pos1 = Flatten[Position[dat,mingroup]][[1]]; (* find position of correct parameters for mineral group in question *)
     pos2 = Flatten[Position[dat[[pos1,2]],ToString[minn]]][[1]]; (* find position of end-member site occupancies *)
     am = dat[[pos1,1]]; 	(* am: activity model: e.g. for grt: {"grt", {{"M2", {"Mg", "Ca", "Fe", "Mn"}}, {"M1", {"Al", "Fe3"}}}}  *)
     so = dat[[pos1,2,pos2]]; 	(* so: site occupancy of end-member: e.g. for py: {"py", {{"Mg", "Mg", "Mg"}, {"Al", "Al"}}} *) 
     marg = dat[[pos1,3]];	(* marg: Margules parameters: e.g. {{{0,1,0,30},{0,0,1,28},{0,0,0,30},{0,0,0,0}},{},0} *)
     If[marg == {}, model = "Ideal"];
     ];  

     model = StringJoin[am[[1]],model]; model1 = ToUpperCase[StringTake[model,{1}]];
     model = StringTake[model,{2,StringLength[model]}];
     model = StringJoin[model1,model];

   (* ------------- display activity model  ----------------   *)
   If[mode == ACTIVITY`DisplayActivityModel,   
     {am,em,marg} = dat[[pos1]];
     em = Transpose[em][[1]];
     Print["Activity-model for: ",mingroup,". Number ",pos1," in data file."];
     Print[am[[2]]]; Print[];
     Print["Ideal activity for: aid(",so[[1]],") = ",N[IdealActivity[am,so,x,1]]];
     Print["There are ",Dimensions[em][[1]]," end-members: ",em];
     If[marg != {}, 
       Print["Symmetric formalism Margules parameters (kJ):"];
       Print["Data displayed as ",em," x ",em," square matrix."];
       Print[MatrixForm[marg[[1]]]];
       If[marg[[3]] != 0, Print["delta-H of ordering reaction (kJ): ",marg[[3]]]];
       If[mingroup == "wm3", Print["Asymmetry parameters (van Laar): ",marg[[4]]]];
       ];              
     Return[];     
     ];

   (* --------  display ideal-activity expression symbolically --------  *)
   If[mode == ACTIVITY`IdealActivitySymbolic,	
     aid = IdealActivity[am,so,x1,1];	(* calculate ideal activity symbolically *)
     Return[StringJoin["aid(",ToString[minn],")=",ToString[InputForm[N[aid]]]]];
     ];  

   (* --------  calculate gamma  ----------  *)
   If[marg != {}, 		
     {y,x1,so,q} = CalcGammaHP[p,t,minn,mingroup,x1,x2,marg,so,pos2];  	(* calculate gamma  *)
     ];
 
   aid = IdealActivity[am,so,x1,0];		(* calculate ideal activity *)   

   If[mode == ACTIVITY`Q, Return[{q,StringJoin["q(",ToString[minn],")=",model]}]];  
   If[mode == ACTIVITY`SiteFractions, Return[{am,x1}]];  
   If[mode == ACTIVITY`IdealActivity, model = "Ideal"; Return[{aid,StringJoin["a(",ToString[minn],")=",model]}]];  
   If[mode == ACTIVITY`RealActivity, Return[{aid*y,StringJoin["a(",ToString[minn],")=",model]}]];
   If[mode == ACTIVITY`ActivityCoefficient,Return[{y,StringJoin["y(",ToString[minn],")=",model]}]];
]
Options[ActivityHP] = {ACTIVITY`ActivityMode->ACTIVITY`RealActivity,
		     ACTIVITY`ActivitySampleFile ->"None",ACTIVITY`ActivityMingroup ->"None"};
ActivityHP[p_, t_, min_, mf_, opts___] :=
    Block[{opt = {ACTIVITY`ActivityMode,ACTIVITY`ActivitySampleFile,ACTIVITY`ActivityMingroup},i,n = Dimensions[{opts}][[1]]}, 
    For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
       Print["Unknown option \"", {opts}[[i, 1]], "\" in -Activity-"];
       Print["Known option is: ", opt]; Return[-1]]];
AActivityHP[p, t, min, mf, 
	 ACTIVITY`ActivityMode /. {opts} /. Options[ActivityHP],
	 ACTIVITY`ActivitySampleFile /. {opts} /. Options[ActivityHP],
	 ACTIVITY`ActivityMingroup /. {opts} /. Options[ActivityHP]]	 
	 ];


End[]
                     
EndPackage[]