(* Name: DEFDAT`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package declares various PET-functions *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["DEFDAT`"]

Dataset::usage = "Dataset[Dataset-> ...] selects the thermodynamic dataset to be used.\n
The following data sets are available,                loaded with:\n
Berman (1988) J Petrol 29:445-522                     Dataset[Dataset -> B88]
Holland & Powell (1998) J metam Geol 16:309-343       Dataset[Dataset -> HP31], or
                                                      Dataset[Dataset -> HP32]   
Gottschalk (1997) Eur J Mineral 9:175-223             Dataset[Dataset -> G97]\n
See G::usage for more details.
\"31\" or \"32\" following \"HP\" indicates that the thermodynamic data have been
converted from THERMOCALC-versions 3.1 or 3.2 of Holland & Powell respectively. 
When you start PET, a subdirectory \"/work\" is created by default, from which all user-files
(e.g. mineralchemical data files) are read and all files produced by PET are written to.
To create a new subdirectory for that purpose, you can use the option:
WorkDirectory -> \"/directory_name\"
Example: Dataset[Dataset -> B88, WorkDirectory -> \"/sample_xy\"]
This loads PET with the Berman data set and reads/writes all user files from/to the
subdirectory named \"sample_xy\".
Called from: User.
Package name: DEFDAT.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

PET::usage = "This is an alphabetical list of useful PET functions and a short description of their purpose.
Use    FunctionName::usage     for more details.\n
FunctionName         meaning\n
Activity             calculates the activity of phase components in mineral solutions
CalcFormula          calculates mineral formulae
CalcRea              calculates equilibrium data of reactions
CalcReaIntersection  calculates the intersection of reactions
CalcThermoBaro       calculates geothermobarometers
Dataset              defines a thermodynamic data set (Berman, 1988, Gottschalk, 1997, or
                     Holland & Powell, 1998)
Dgr                  calculates delta-G of a reaction as f(P, T, (X))
ExtractSampleDat     extracts mineralchemical data from a sample for use in further calculations
ExtractMinDat        extracts mineralchemical data of a phase (e.g. Al-VI) for plotting purposes
FluidActivity        calculates activities in H2O-CO2 or H2O-H2 fluids at P, T and X.
G                    calculates the G-function of a phase at P and T; optional H, S, V, cp
MakeAnalysisTable    stores mineral chemical analyses in table format
MakeRea              calculates reaction stoichiometries from a list of phase components
MinDat               returns thermodynamic data and chemical composition of a phase
MinList              gives a list of available phases and the abbreviations to be used for them
O2buffers            calculates usual oxygen buffers
PlotRea              plots equilibrium data
RTlnf                calculates the RTln(fugacity)-term for pure fluids at P and T
TransformDatFile     transforms an electron microprobe data file to a PET-readable format
TrianglePlot         plots triangular diagrams of mineral chemical parameters
XYPlot               plots X-Y diagrams of mineral chemical parameters\n
Examples demonstrating the use of these PET-functions may be found in:\n
PET_Activity_B.nb
PET_Activity_HP.nb
PET_CalcFormula.nb
PET_CalcRea.nb
PET_CalcThermobaro.nb
PET_G_Function.nb
PET_Mineralchemical_Plots.nb\n
Package name: DEFDAT.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

$Dataset::usage = "some usage"

Begin["`Private`"]

Off[General::spell]; Off[General::spell1];

DDataset[DEFDAT`Dataset_,DEFDAT`WorkDirectory_] :=  Block[{opt1={Global`B88,Global`HP31,Global`HP32,Global`G97}},
	If[Intersection[{DEFDAT`Dataset},opt1] == {}, Print["wrong value \"",DEFDAT`Dataset,"\" for option \"Dataset\""];
	   Print["Allowed values are: ",opt1];Return[]];
	Off[DeclarePackage::aldec];

	DeclarePackage["ACTIVITY`",{"GammaSymbolicB","LoadActivityData","ExtractSampleDatB","IdealActivity","GammaBB","MargulesB","CalcGammaB","ActivityB",
	  	"Findq","OrderDisorderHP","CalcGammaHP","ExtractSampleDatHP","ActivityHP","Activity"}];
 	DeclarePackage["FORMEL`",{"CalcFormula"}]; 
	DeclarePackage["G`",{"LoadDataset","MinDat","MinList","GOrdAb","DGordAbDt","CpOrdAb","GOrd","Gl","GLandau","G"}];
        DeclarePackage["DG`",{"Dgr","DgrXC","DgrXH","DgrO","XH2ToLogfO2","CalcRea"}];
	DeclarePackage["FLUIDS`",{"Psat","Cubic","WHAAR2","VmixKJ","RTlnfKJ","VolH","VmixH","RTlnfH","Vh2oHP","RTlnfh2oHP","Vco2HP","RTlnfco2HP","Ah2oco2PH","RTlnf","FluidActivity"}];
	DeclarePackage["GTB`",{"GT1","GT2","GT3","GT4","GT5","GT6","GT7","GT8","GT9","GT10","GT11",
		"GT12","GT13","GT14","GT15","GT16","GT17","GT18","GT19","GT20","GT21","GT22","GT23",
		"GT24","Afs","GT25","GB1","GB2","GB3","GB4","GB5","GB6",
		"GB7","GB8","GB9","GB10","GB11","GB12","GB13","GB14","GB15","GB16","CalcThermoBaro"}]; 
	
	DeclarePackage["UTILITY`",{"O2buffers","SaveRea","GetRea","PlotRea","MakeCompositionMatrix",
		"Binom","MakeRea","SelectRea","CalcReaIntersection","MakeAnalysisTable", 
 		"TransformDatFile","ExtractMinDat","DataSymbols","TrianglePlot","XYPlot"}];
	$Path = Append[$Path,Global`$PetDirectory];
	Off[SetDirectory::cdir];

If[SetDirectory[StringJoin[Global`$PetDirectory, DEFDAT`WorkDirectory]] == $Failed,
   CreateDirectory[StringJoin[Global`$PetDirectory, DEFDAT`WorkDirectory]]; 
  SetDirectory[StringJoin[Global`$PetDirectory, DEFDAT`WorkDirectory]], 
  SetDirectory[StringJoin[Global`$PetDirectory, DEFDAT`WorkDirectory]]];	

On[SetDirectory::cdir]; On[DeclarePackage::aldec];
]
Options[Dataset] = {DEFDAT`Dataset->Global`B88,DEFDAT`WorkDirectory->"\Work"};
Dataset[opts___] := Block[{opt={DEFDAT`Dataset,DEFDAT`WorkDirectory},i,n=Dimensions[{opts}][[1]],pos},
	For[i=1,i<=n,i++,
	   pos = Position[opt,{opts}[[i,1]]];		  
	   If[pos == {}, Print["Unknown option ",{opts}[[i,1]]," in -Dataset-"];
	   		 Print["Known options are: ",opt];Return[]];
	   If[pos != {}, SetOptions[Dataset, opt[[pos[[1,1]]]] ->{opts}[[i,2]]]];	   		 	   					 
	   ];
	DDataset[DEFDAT`Dataset/.{opts}/.Options[Dataset],DEFDAT`WorkDirectory/.{opts}/.Options[Dataset]]
	];

PET[] := Print["Use PET::usage to see a list of all PET functions"]

End[]

EndPackage[]
