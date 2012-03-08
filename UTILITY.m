(* Name: UTILITY`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package contains utility functions of PET  *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)
                        
BeginPackage["UTILITY`",{"DEFDAT`","G`"}]

O2buffers::usage = "O2buffers[P (bar), T (K)]
calculates logfO2 data for oxygen buffers (from emf-data).\n
The following option is available with -O2buffers-:\n
Name      value          meaning\n
Buffer -> NNO (default)  NNO buffer, source A,
Buffer -> QFM            QFM buffer,     900<T(K)<1420, source B,
Buffer -> QFI            QFI buffer,     900<T(K)<1420, source B,
Buffer -> WM             WM buffer,      833<T(K)<1270, source C,
Buffer -> WI             WI buffer,      833<T(K)<1644, source A,
Buffer -> MI             MI buffer,      750<T(K)<833,  source C,
Buffer -> CCO            CCO buffer,     700<T(K)<1760, source A,
Buffer -> WWO            WWO buffer,     700<T(K)<1700, source A,
Buffer -> CuCu2O         Cu-Cu2O buffer, 700<T(K)<1338, source A.\n
Source A: (O'Neill & Pownceby, 1993, Contrib Mineral Petrol 114:296-314).
Source B: (O'Neill, 1987, Am Mineral 72:67-75).
Source C: (O'Neill, 1988, Am Mineral 73:470-486).
ReturnList: {P (bar), T (K), logfO2, buffer}
Example: O2buffers[5000,900,Buffer->QFM]
ReturnValue: {5000, 900, -18.6977, QFM}
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

Buffer::usage = "Buffer is an option of -O2buffers-."

SaveRea::usage = "SaveRea[rea,\"fname\"] saves everything assigned to rea
(e.g. equilibrium data created with -CalcRea-) to the file named \"fname\".
If the file already exists it is overwritten.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GetRea::usage = "GetRea[\"fname\"] reads the contents of the file named \"fname\".
It can be used to assign stored equilibrium data of reaction(s)
to a variable (e.g. to plot them with -PlotRea-).
Example: rea = GetRea[\"test.ptx\"].
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

PlotRea::usage = "PlotRea[result] can be used to plot equilibrium data produced with result = CalcRea[rea]
or result = CalcThermobaro[{gtb1, gtb2, ...}] (see CalcRea::usage for more details how to calculate equilibrium data
and CalcThermobaro::usage how to calculate geothermobarometers).
Data points are connected by default.
The following options are available with -PlotRea-:\n
Name            value                   meaning\n
PlotReaMode ->  0 (default)             plots the data
                other value             supresses plotting
PlotReaStyle -> Automatic (default)     automatic style as in Mathematica built-in option PlotStyle
                your_plot_options       user-defined plot-options\n
Example 1: plot = PlotRea[result].
Example 2 (suppressing of subplots):
p1 = PlotRea[result1,PlotReaMode->1];
p2 = PlotRea[result2,PlotReaMode->1];
p3 = PlotRea[result3,PlotReaMode->1];
plot = Show[p1,p2,p3,DisplayFunction->$DisplayFunction];
Here, you will only see the final plot.
Example 3: Single calculated reactions can be plotted together with: 
plot = PlotRea[Join[result1, result2, result3, ...]]
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

PlotReaMode::usage = "PlotReaMode is an option of -PlotRea-."
PlotReaStyle::usage = "PlotReaStyle is an option of -PlotRea-."

MakeCompositionMatrix::usage = "MakeCompositionMatrix[{list_of_phase_components}]
creates a composition matrix of the phases defined in {list_of_phase_components}
(each column represents the composition of a phase component).
Phase abbreviations as returned by MinList[] must be used.
ReturnValue: {composition_matrix, list_of_chemical_elements},
Example for phases = {mu, qz, san, ky, h2o}.
MakeCompositionMatrix[phases].
{{{3, 0, 1, 2, 0}, {2, 0, 0, 0, 2}, {1, 0, 1, 0, 0}, {12, 2, 8, 5, 1}, {3, 1, 3, 1, 0}},
{\"AL\", \"H\", \"K\", \"O\", \"SI\"}}
Called from: -MakeRea-.
Calls: -MinDat-.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

MakeRea::usage = "MakeRea[{list_of_phase_components}]
calculates for a user-defined list of phase components the reactions that can be
written among them (abbreviations as shown by MinList[] must be used).
The following option is available with -MakeRea-:\n
Name           value          meaning\n
MakeReaMode -> 0 (default)    calculate a set of linearly independent reactions
               1              calculate all possible reactions (search algorithm)
               2              calculate all possible reactions (algorithm of
                              Powell (1990), Contrib Mineral Petrol 106:61-65)\n
Calculating all possible reactions: The search algorithm (MakeReaMode -> 1) works somewhat
slowlier than the algorithm of Powell (1990) (MakeReaMode -> 2), but the latter may not find
all reactions in cases where colinearities exists between phase components.
ReturnValue: {reaction 1, reaction 2,...},
where each reaction is a list of the form: {sc1*pc1, sc2*pc2, sc3*pc3, ...}
(sc = stoichiometric coefficient in the reaction, pc = phase component-abbreviation).\n
Example:
phases = {ann, phl, alm, py, gr, an, qz, sil};
rea = MakeRea[phases]
{{-3. an, 1. gr, 1. qz, 2. sil}, {-1. alm, -1. phl, 1. ann, 1. py}}\n
This returns the GASP-reaction and the grt-bt thermometer as linearly independent reactions.
See PET_CalcRea.nb for more examples.
Called from: User.
Calls: -MakeCompositionMatrix-, -NullSpace-.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

MakeReaMode::usage = "MakeReaMode is an option of -MakeRea-."

SelectRea::usage = "SelectRea[rea,{paragenesis}]
selects all those reactions from rea = {list of reactions}, calculated before with -MakeRea-,
that contain the phases defined in the list {paragenesis}.
The following option is available with -SelectRea-:\n
Name             value          meaning\n
SelectReaMode -> 0 (default)    returns all those reactions where the phases in {paragenesis}
                                are part of the reactants in one side of the reaction equation.
                 1              returns all those reactions that have exactly {paragenesis} as
                                reactants in one side of the reaction equation (strict search).\n
Example: phases = {dsp, qz, ky, kao, pyp, zo, ma, gr, an, h2o, law};
rea = MakeRea[phases, MakeReaMode -> 1];
rea1 = SelectRea[rea, {ma}, SelectReaMode -> 1];
{{-9. ma, 14. dsp, 3. gr, 1. kao, 7. ky},
{-7. ma, 10. dsp, 2. gr, 6. ky, 1. law},
{-3. ma, 4. dsp, 1. gr, 1. h2o, 3. ky},
{-1. ma, 1. an, 2. dsp},
{-12. ma, 22. dsp, 4. gr, 8. ky, 1. pyp},
{-3. ma, 6. dsp, 1. gr,2. ky, 1. qz},
{-3. dsp, -1. ky, -1. zo, 2. ma}}\n
This selects all reactions (from a total of 280) where only margarite is reactant.
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

SelectReaMode::usage = "SelectReaMode is an option of -SelectRea-."

CalcReaIntersection::usage = "CalcReaIntersection[rea] calculates intersections of reactions curves,
based on equilibrium data calculated earlier with -CalcRea- or -CalcThermoBaro- and assigned to rea.
The following option is available with -CalcReaIntersection-:\n
Name                         value          meaning\n
CalcReaIntersectionFilter -> 0 (default)    no filtering is applied
                             n (n=1,2,3,..) filter out only reactions of the form rea1 = i, rea2 = i+n\n
If the value of the option CalcReaIntersectionFilter is e.g. 5, the intersection of only the i-th reaction with
the (i+n)-th reaction is calculated. This is useful if rea contains e.g. the results of five grt/bt pairs and
five calculations of the GASP barometer. In such a case, intersections of reaction 1 with 6, reaction 2 with 7,
etc. are relevant and filtered.\n
Example: (see PET_CalcRea.nb, example 6):
CalcReaIntersection[rea]
ReturnValue: {{3969.71,479.382,{1,2}}}
{1,2} indicates that this is the intersection of reaction 1 and 2.
If the option CalcReaIntersectionFilter has been used with a value > 0, the output is preceeded by the mean and the
standard deviation of the intersections.
Called from: User.Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

CalcReaIntersectionFilter::usage = "CalcReaIntersectionFilter is an option of -CalcReaIntersection-."

MakeAnalysisTable::usage = "MakeAnalysisTable[\"filename\"] combines chemical analyses (wt%) of the
file \"filename\" with calculated formula units produced earlier with CalcFormula[\"filename\"] as stored
in the file \"filename.fu\" and writes these data in usual tabular form to the file \"filename.tab\"
for further use (e.g. output from a text editor to a printer, or import into a text program).
The following options are available with -MakeAnalysisTable-:\n
Name                              value          meaning\n
MakeAnalysisTableDigits ->        3  (default)   sets the number of digits in the formula units (maximum 5).
MakeAnalysisTableSplit  ->        10 (default)   determines after how many analyses the file will be split
                                                 into separate parts.
MakeAnalysisTableAddParameters -> \"\" (default)   adds mineralchemical parameters (e.g. Al(VI), SumCat, XFe, etc.)
                                                 works only if one type of mineral is present in the data file.\n                                          
Example for the data file \"hs78b\", described under CalcFormula::usage:\n
MakeAnalysisTable[\"hs78b\"]\n
The sequence\n
file = \"hs78b\";
CalcFormula[file];
MakeAnalysisTable[file];\n
calculates formula units from the data file  \"hs78b\"
and stores the results in tabular form in the file  \"hs78b.tab\".
Another example, changing the default splitting:\n
MakeAnalysisTable[file,MakeAnalysisTableSplit->20]\n
Another example, adding mineralchemical parameters:\n
ExtractMinDat[amph,\"\",{\"pet2\"},ExtractMinDatFile -> {\"pet2\"},ExtractMinDatMode -> SearchFiles]
CalcFormula[\"pet2_amph\"];
MakeAnalysisTable[\"pet2_amph\",MakeAnalysisTableAddParameters -> {\"Al(VI)\",\"Al(IV)\",\"SumCat\",\"name\"}]\n
In this example -ExtractMinDat- is used with the option \"ExtractMinDatMode -> SearchFiles\" to extract
all amphibole analyses from the file \"pet2\", which are then stored in  \"pet2_amph\".
Then the formulae are calculated with -CalcFormula-, and -MakeAnalysisTable- is called with the option
MakeAnalysisTableAddParameters -> {\"Al(VI)\",\"Al(IV)\",\"SumCat\",\"name\"},
which causes that these parameters are appended following the formula units in the file  \"pet2_amph.tab\".
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

MakeAnalysisTableDigits::usage = "MakeAnalysisTableDigits is an option of -MakeAnalysisTable-."
MakeAnalysisTableSplit::usage = "MakeAnalysisTableSplit is an option of -MakeAnalysisTable-."

TransformDatFile::usage = "TransformDatFile[\"microprobe-filename\",\"filename\"] transforms
microprobe result files (oxide weight %) into the file \"filename\" that can be read by -CalcFormula-.
The following option is available with -TransformDatFile-:\n
Name                   value                 meaning\n
TransformDatFileEMP -> Salzburg (default)    convert data files of a JEOL-JX 8600 microprobe (Salzburg)
                       Innsbruck             convert data files of a JEOL-J 8900R microprobe (Innsbruck)\n
TransformDatFileEMP -> Salzburg
Was written for a JEOL-JX 8600 microprobe and can be adapted to other data file structures with some
Mathematica experience. Using this option, -TransformDatFile- searches between \"Point\" and \"Mean=\",
which must appear in the microprobe data file.
The microprobe results file has the form:\n
----------------------------------------------------------------------
Results file : Example (created from a JEOL-JX 8600 microprobe)
Some text
Results summarised as:  Oxide weight %
 Point             Na2O  SiO2  Al2O3 MgO   K2O   TiO2  CaO   FeO   MnO \n
1:amphibole c    .27  56.3  1.31  20.5   .15  .03<  12.2   5.6   .16
2:amphibole r    .17  56.2  1.18  19.6   .04 -.01<  12.4   7.1   .29
3:mica         -.00<  27.0  19.6  22.1 -.00<   .06   .03  13.9   .22
4:mica           .55  47.2  28.3  2.95  10.5   .19  .01<   2.0  .00<
5:rutile       -.02<  37.2  27.6   .08 -.01<   .44  23.0   5.5   .17
6:epidote       .03<  37.0  27.2   .14 -.01<   .14  22.2   4.7   .07 \n
Mean=    .1  41.6  16.0   9.3   1.5   4.5  14.0   5.6 
Some other text
----------------------------------------------------------------------\n
Use some text editor, to bring this file into the following form:\n
----------------------------------------------------------------------
Results file : Example (created from a JEOL-JX 8600 microprobe)
Some text
Results summarised as:  Oxide weight %
 Point Label       Na2O  SiO2  Al2O3 MgO   K2O   TiO2  CaO   FeO   MnO  \n
1 amph           .27  56.3  1.31  20.5   .15    0   12.2   5.6   .16
2 amph           .17  56.2  1.18  19.6   .04    0   12.4   7.1   .29
3 wm               0  27.0  19.6  22.1     0   .06   .03  13.9   .22
4 wm             .55  47.2  28.3  2.95  10.5   .19     0   2.0     0
5 fetiox           0  37.2  27.6   .08     0   .44  23.0   5.5   .17
6 zoep             0  37.0  27.2   .14     0   .14  22.2   4.7   .07 \n
Mean=    .1  41.6  16.0   9.3   1.5   4.5  14.0   5.6 
Some other text
----------------------------------------------------------------------\n
Note that \"Label\" has been inserted in the first line,
\"-\" and \"<\" signs have been replaced by \"0\",
and that the correct mineral abbreviations have been introduced,
separated by spaces from the analyses numbers.
The transformed data file then has the form required by -CalcFormula-:\n
Label Mineral Na2O SiO2 Al2O3  MgO   K2O  TiO2   CaO   FeO  MnO Fe2O3	
1     amph     .27 56.3  1.31  20.5  .15     0  12.2   5.6  .16     0	
2     amph     .17 56.2  1.18  19.6  .04     0  12.4   7.1  .29     0	
3     wm         0 27.0  19.6  22.1    0   .06   .03  13.9  .22     0	
4     wm       .55 47.2  28.3  2.95 10.5   .19     0   2.0    0     0	
5     fetiox     0 37.2  27.6   .08    0   .44  23.0   5.5  .17     0	
6     zoep       0 37.   27.2  0.14    0  0.14  22.2     0  .07  5.22\n
TransformDatFileEMP -> Innsbruck
Using this option, -TransformDatFile- searches between \"No.\" and \"Minimum\",
which must appear in the microprobe data file (with data in rows in between).
A column \"PET\" must have been inserted between the column \"Total\" and \"Comment\",
containing the appropriate mineral codes for PET (e.g. grt for garnet, amph for amphibole, etc.).\n
If zoisite/epidote, feldspar, alumosilicate, or sphen analyses appear,
a separate column \"Fe2O3\" is automatically appended.
If you have a data file \"file1\" that contains analyses of zoisite/epidote, feldspar,
alumosilicate, or sphen, where iron is given as FeO, you can let -TransformDatFile-
introduce a column \"Fe2O3\" for you (-CalcFormula- will not work unless this has
been done):
Use a text editor and replace \"Label\" in the first line by \"Point\";
Add \"Mean=\" as last line at the end of the file.
Use TransformDatFile[\"file1\",\"file2\",TransformDatFileEMP -> Salzburg]
The new file \"file2\" then has the desired form for -CalcFormula-.
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

ExtractMinDat::usage = "ExtractMinDat[mineral_abbreviation, \"parameter(s)\", \"filename(s)\"]
can be used to extract mineral-chemical parameters from file(s) \"filename(s).fu\", created before with
-CalcFormula- (the file-extension \"fu\" is automatically appended). This is useful, if XY- or triangle plots
of such parameters shall be created, e.g. with the Mathematica functions -ListPlot- or -MultipleListPlot-, or
the PET functions -Triangle- or -XYPlot- (see Triangle::usage or XYPlot::usage for more details).
Another very useful purpose of -ExtractMinDat- is to search file(s) for specific analyses or to combine data files. 
<mineral_abbreviation> must be any given under CalcFormula::usage (e.g. bt for biotite, grt for garnet, etc.).
\"parameter(s)\" can be any stored for that mineral in the file(s) \"filename(s).fu\", e.g. \"Al(VI)\", \"XFe\", \"ann\", etc.,
or a list of such parameters (e.g. {\"XFe\", \"XMg\", \"XCa\", \"XMn\"}).
If you type \"SiO2\", or \"Al2O3\", etc., the function returns the formula Si, respectively Al, etc.
If more than one analysis of a specific mineral is found, a list of the parameter-values is returned.
The following options are available with -ExtractMinDat-:\n
Name                 value                       meaning\n
ExtractMinDatMode -> ExtractParameter (default)  extract specified parameter(s) from \"filename(s).fu\"
                                                 and return them as a data-list.
                      SearchFiles                search \"filename(s)\" for specific analyses, e.g. all amphiboles
                                                 and store them in a new file (default name can be modified
                                                 with the option ExtractMinDatFile).
ExtractMinDatFile -> \"\" (default)               define a new file name
ExtractMinDatTexture -> \"\" (default)            define a substring of the analsis label, e.g. indicating a specific
                                                 tectural position of the analysis (e.g. \"ig\" for inclusion in garnet)
ExtractMinDatTextureRange -> {-3,-1} (default)   define the position of such a substring in the analysis label;
                                                 {-3,-1} indicates the last three positions in the analysis label.\n
ExtractMinDatTexture can be used to specify analyses that belong to a specific texture. If e.g. the analysis-label
has \"ig\" at its end, setting ExtractMinDatTexture -> \"ig\", and ExtractMinDatTextureRange->{-2,-1}
will only return those analyses that represent inclusions in garnet.\n
Example 1: dat = ExtractMinDat[wm,\"Al(VI)\",\"hs78b\"]
ReturnValue: {{1.89589}}\n
Example 2: dat = ExtractMinDat[wm, {\"Al(IV)\", \"Al(VI)\"}, {\"hs78b\", \"pet1\"}];
ReturnValue: {{0.87958, 0.87958}, {1.89589, 1.89589}}\n
This extracts Al(IV) and Al(VI) for white mica from the files,
\"hs78b\" and \"pet1\", which then could be plotted with:\n
ListPlot[Transpose[dat], PlotRange -> {{0, 1},{1, 2}}];\n
-ExtractMinDat- can be used in combination with the PET functions
-TrianglePlot- and -XYPlot- to plot data in ternary and XY-diagrams.\n
Example 3: dat = ExtractMinDat[grt, \"XFe\", \"pet1\", ExtractMinDatTexture -> \"r\",
                                                   ExtractMinDatTextureRange -> {-1, -1}]\n
ReturnValue: {{0.66343}}
This extracts XFe pfu of garnet from the data file \"pet1.fu\" (created before with -CalcFormula-),
of those garnet analyses whose label has \"r\" as the last letter (indicating garnet-rim composition).\n
Example 4:  file = {\"pet1\",\"pet2\"};
ExtractMinDat[amph,\"SiO2\",file,ExtractMinDatTexture->\"mar\",
                               ExtractMinDatTextureRange->{-3,-1},
                               ExtractMinDatFile->\"NewFile\",
                               ExtractMinDatMode->SearchFiles];\n
This searches all amphibol analyses of the data-files \"files\" whose analysis label has \"mar\" as the
last three letters (indicating matrix-rim) and stores them in the new file \"NewFile_amph_mar\".
The order of oxides in \"NewFile\" is defined by their appearance in the list:
{SiO2,Al2O3,FeO,MgO,CaO,MnO,TiO2,Na2O,K2O,BaO,Cr2O3,Fe2O3,ZnO,F,Cl,
SrO,B2O3,BeO,Ce2O3,CoO,Eu2O3,HfO2,La2O3,Li2O,Lu2O3,Nd2O3,NiO,PbO,Y2O3,
ZrO2,V2O3,Er2O3,Dy2O3,Pr2O3,Gd2O3,Sm2O3,ThO2,UO2,Sc2O3,P2O5,CO2,CeO2,
CuO,H2O,MnO2,Mn3O4,Nb2O5,Rb2O,S,SO3,SnO,Ta2O5,Cs2O};
This list appears at the top of the function -CombineFiles- (in UTILITY.m).
A user-defined order can be achieved by changing the order of oxides in this list. Formula units of
\"NewFile\" can then be calculated by using -CalcFormula-.\n
Example 5: file = {\"hs78b\",\"pet1\",\"pet2\"};
ExtractMinDat[all,\"SiO2\",file, ExtractMinDatFile->\"NewFile\",
                               ExtractMinDatMode->SearchFiles];\n
This combines all analyses of the files \"file1\", \"file2\" and \"file3\"
to one file named \"NewFile_all\". The value of <parameter> (SiO2 in the
above example, is ignored in the case when \"all\" appears).
For further examples see PET_Mineralchemical_Plots.nb.
Called from: User, -TrianglePlot-, -XYPlot-.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

ExtractMinDatMode::usage = "ExtractMinDatMode is an option of -ExtractMinDat-"
ExtractMinDatTexture::usage = "ExtractMinDatTexture is an option of -ExtractMinDat-"
ExtractMinDatTextureRange::usage = "ExtractMinDatTextureRange is an option of -ExtractMinDat-"
ExtractMinDatFile::usage = "ExtractMinDatFile is an option of -ExtractMinDat-"

DataSymbols::usage = "DataSymbols[shape, size] allows to chose various plot symbols for data points and their size.
<shape> must be any of:\n
SymbolShapeSquare             filled square,
SymbolShapeCircle             filled circle = dot,
SymbolShapeTriangle           filled triangle,
SymbolShapeTriangleInverted   filled triangle, inverted
SymbolShapeDiamond            filled diamond,
SymbolShapeHexagon            filled hexagon,
SymbolShapeOctagon            filled octagon,
SymbolShapeCross              filled cross,
SymbolShapeSquareOpen         open square,
SymbolShapeCircleOpen         open circle.\n
The function returns a pure function object that can be used with the option \"SymbolShape\" of the
Mathematica function -MultipleListPlot-, to plot the data with the desired symbol.\n
Example: plotting data-points with filled triangles\n
MultipleListPlot[{{1, 1}, {.2, .2}, {5, 3}, {8, 6}},
                 SymbolShape -> DataSymbols[SymbolShapeTriangle, 0.04],
                 PlotRange -> {{0, 10}, {0, 10}}, AspectRatio -> 1]\n
Called from: User, -TrianglePlot-, -XYPlot-.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

TrianglePlot::usage = "TrianglePlot[plotdata] plots triangular diagrams. <plotdata> must be a list where each element
is a triple of data (e.g. extracted before with the PET-function -ExtractMinDat-).
The data are plotted in the order: left corner, right corner, apex.\n
Options: Name            value                           meaning\n
TrianglePlotSymbolShape->SymbolShapeDot  (default)       define symbol shape: dot
                         SymbolShapeSquare                                    filled suare
                         SymbolShapeCircle                                    filled circle
                         SymbolShapeTriangle                                  filled triangle
                         SymbolShapeTriangleInverted                          filled triangle, inverted
                         SymbolShapeDiamond                                   filled diamond
                         SymbolShapeHexagon                                   filled hexagon
                         SymbolShapeOctagon                                   filled octagon
                         SymbolShapeCross                                     cross
                         SymbolShapeSquareOpen                                open square
                         SymbolShapeCircleOpen                                open circle\n
TrianglePlotSymbolSize->0.008            (default)       define symbol size
TrianglePlotFrameThickness->0.006        (default)       define frame thickness
TrianglePlotTickThickness->0.006         (default)       define tick thickness
TrianglePlotAxesLabel->{\"\",\"\",\"\"}        (default)       define axes labels
TrianglePlotText->{},                    (default)       define text to be written within the triangle
TrianglePlotTicks->TrianglePlotTicksNone (default)       define wether ticks are plotted or not
                   TrianglePlotTicksYes,
TrianglePlotGrid->TrianglePlotGridNone   (default)       draw no grid
                  TrianglePlotGridMesh                   draw a 10%-interval mesh
                  TrianglePlotGridPx                     draw the grid Jd-Ae-Q for pyroxenes
                  TrianglePlotGridOwn                    draw your own grid
TrianglePlotGridData->{}                 (default)       pass your own grid data (list of triples) to -TrianglePlot-
TrianglePlotGridThickness -> 0.004       (default)       define grid thickness\n
Example 1: Use the PET-function -TrianglePlot- to plot some data into the concentration triangle A-B-C.
data = {{100, 0, 0}, {50, 50, 0}, {1/3, 1/3, 1/3}, {30, 50, 20}};
TrianglePlot[data, TrianglePlotSymbolShape -> SymbolShapeDot, TrianglePlotSymbolSize -> 0.01,
                   TrianglePlotGrid -> TrianglePlotGridMesh,
                   TrianglePlotAxesLabel -> {FontForm[\"A\", {\"Helvetica-Bold\", 14}],
                                             FontForm[\"B\", {\"Helvetica-Bold\", 14}],
                                             FontForm[\"C\", {\"Helvetica-Bold\", 14}]}];\n
Example 2: plot pyroxene data from the file \"pet2\" into the triangle Jd - Ae - Q.
\"pet2\" contains 20 analyses of zoned omphacites, 10 with analyses labels
ending in \"mar\" (indicating \"ma\"trix \"r\"im compositions),
10 ending in \"mac\" (indicating \"ma\"trix \"c\"ore compositions).
Use triangles and dots as plot symbols, draw tick marks, use the
Na-pyroxene nomenclature grid and plot two text-labels into the triangle:\n
file = \"pet2\";
d1 = ExtractMinDat[cpx, {\"MolJd\", \"MolAe\", \"MolQ\"}, file,
     ExtractMinDatTexture -> \"mar\", ExtractMinDatTextureRange -> {-3, -1}];
d2 = ExtractMinDat[cpx, {\"MolJd\", \"MolAe\", \"MolQ\"}, file,
     ExtractMinDatTexture -> \"mac\", ExtractMinDatTextureRange -> {-3, -1}];
t1 = TrianglePlot[Transpose[d1], TrianglePlotSymbolShape -> SymbolShapeSquare,
     TrianglePlotSymbolSize -> 0.01];
t2 = TrianglePlot[Transpose[d2], TrianglePlotSymbolShape -> SymbolShapeDot,
     TrianglePlotSymbolSize -> 0.01,
     TrianglePlotText -> {Text[FontForm[\"text1\", {\"Helvetica-Bold\", 14}],
                               Scaled[{0.67, 0.5}], {1, 0}, {1, 0}],
                          Text[FontForm[\"text2\", {\"Helvetica-Bold\", 14}],
                               Scaled[{0.4, 0.19}], {1, 0}, {1, 0}]},
      TrianglePlotTicks -> TrianglePlotTicksYes,
      TrianglePlotGrid -> TrianglePlotGridPx,
      TrianglePlotAxesLabel -> {FontForm[\"Jd\", {\"Helvetica-Bold\", 14}],
                                FontForm[\"Ae\", {\"Helvetica-Bold\", 14}],
                                FontForm[\"Q\",  {\"Helvetica-Bold\", 14}]}];
Show[t1, t2];\n
For further examples see PET_Mineralchemical_Plots.nb.
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

TrianglePlotSymbolShape::usage = "TrianglePlotSymbolShape is an option of -TrianglePlot-"
TrianglePlotSymbolSize::usage = "TrianglePlotSymbolSize is an option of -TrianglePlot-"
TrianglePlotLineThickness::usage = "TrianglePlotLineThickness is an option of -TrianglePlot-"
TrianglePlotAxesLabel::usage = "TrianglePlotAxesLabel is an option of -TrianglePlot-"
TrianglePlotText::usage = "TrianglePlotText is an option of -TrianglePlot-"
TrianglePlotTicks::usage = "TrianglePlotTicks is an option of -TrianglePlot-"
TrianglePlotGrid::usage = "TrianglePlotGrid is an option of -TrianglePlot-"
TrianglePlotGridData::usage = "TrianglePlotGridData is an option of -TrianglePlot-"

XYPlot::usage = "XYPlot[\"filename\"] draws XY-plots of mineral-chemical parameters as stored in \"filename.fu\".
There are a lot of options that define the plot-type, plot-style, the way of search in \"filename.fu\",etc.
Expand the final plot to W = 650, then axes-labels will appear correct !\n
Options:
Name        value                                meaning\n
XYPlotType->XYPlotTypeAmph1  (default)           Si vs Mg/(Mg + Fe2) for amphibole
            XYPlotTypeAmph2                      Si vs Na[B] for amphibole
            XYPlotTypeAmph3                      Ca vs Na for amphibole
            XYPlotTypeAmph4                      Ca[B] vs Na[B] for amphibole
            XYPlotTypeAmph5                      Al[IV] vs Al[VI] for amphibole
            XYPlotTypeAmph6                      Al[IV] vs Al[VI] + Fe3 for amphibole
            XYPlotTypeAmphSodic1                 Si vs Mg/(Mg + Fe2) for sodic amphibole
            XYPlotTypeAmphSodic2                 Fe3/(Fe3 + Al[VI]) vs Mg/(Mg + Fe2) for
                                                 sodic amphibole with (Na + K)[A] < 0.5
            XYPlotTypeAmphSodicCalcic1           Si vs Mg/(Mg + Fe2) for sodic-calcic amphibole
            XYPlotTypeAmphSodicCalcic2           Si vs Mg/(Mg + Fe2) for sodic-calcic amphibole
                                                 with (Na + K)[A] >= 0.5
            XYPlotTypeAmphSodicCalcic3           Si vs Mg/(Mg + Fe2) for sodic-calcic amphibole
                                                 with (Na + K)[A] < 0.5
            XYPlotTypeAmphCalcic1                Si vs Mg/(Mg + Fe2) for calcic amphibole
            XYPlotTypeAmphCalcic2                Si vs Mg/(Mg + Fe2) for calcic amphibole
                                                 with (Na + K)[A] >= 0.5 and Ti < 0.5
            XYPlotTypeAmphCalcic3                Si vs Mg/(Mg + Fe2) for calcic amphibole
                                                 with (Na + K)[A] < 0.5 and Ti < 0.5
            XYPlotTypeAmphMgFeMnLi1              Si vs Mg/(Mg + Fe2) for Mg-Fe-Mn-Li amphibole
            XYPlotTypeWm1                        Al[IV] vs Al[VI] - 1 for white mica
            XYPlotTypeWm2                        Si - 3 vs (Fe + Mg)[VI] for white mica
            XYPlotTypeWm3                        Si vs Al[tot] for white mica
            XYPlotTypeBt1                        Al[IV] - 1 vs Al[VI] for biotite
            XYPlotTypeBt2                        Al[IV] - 1 vs XMg for biotite
            XYPlotTypeBt3                        Si vs Al[tot] for biotite
            XYPlotTypeZoEp1                      Al vs Fe3 for zoisite/epidote
            XYPlotTypeChl1                       Si vs Mg/(Mg + Fe2) for chlorite
            XYPlotTypeGrtProfileXFe              XFe for a garnet profile
            XYPlotTypeGrtProfileXMg              XMg for a garnet profile
            XYPlotTypeGrtProfileXCa              XCa for a garnet profile
            XYPlotTypeGrtProfileXMn              XMn for a garnet profile\n
XYPlotSymbolShape->SymbolShapeDot (default)      define symbol shape: dot
                   SymbolShapeSquare                                  filled square,
                   SymbolShapeCircle                                  filled circle,
                   SymbolShapeTriangle                                filled triangle,
                   SymbolShapeTriangleInverted                        filled triangle, inverted
                   SymbolShapeDiamond                                 filled diamond,
                   SymbolShapeHexagon                                 filled hexagon,
                   SymbolShapeOctagon                                 filled octagon,
                   SymbolShapeCross                                   filled cross,
                   SymbolShapeSquareOpen                              open square,
                   SymbolShapeCircleOpen                              open circle.\n
XYPlotSymbolSize->0.02        (default)          define a size for the plot symbols
XYPlotGridThickness->0.002    (default)          define the thickness of lines in the plot
XYPlotTickThickness->0.003    (default)          define the thickness of ticks in the plot
XYPlotFrameThickness->0.006   (default)          define the frame thickness
XYPlotTypeGrtProfileFactor->1 (default)          x-scale factor (microns) in a garnet-profile
XYPlotGrid->XYPlotGridYes  (default)             plot grid
            XYPlotGridNo                         do not plot grid 
XYPlotLabelPosition->                            change the position of labels in a plot
{{0.1, 0.7},{0.1, 0.15},{0.85, 0.35},{0.5, 0.2}} of garnet profiles
(default)  
XYPlotTexture->\"\" (default)                      define a \"texture-label\" for the search in \"filename.fu\"
XYPlotTextureRange->{-3,-1}  (default)           specify the position of \"texture-label\" in the analysis label\n
In some diagrams for amphibole, names according to Leake et al. (1997, Eur J Mineral 9:623-651) are plotted.
Own plot-types may be easily appended by copying an appropriate If-block in -XYPlot- (each starts with
\"If[type == ...\" and adapting the parameters in the call to -ExtractMinDat- to user-defined needs, as well
as the x- and y-ticks, the label- and range specifications, etc.) and by inserting the new plot-type name
into the list \"opt\" at the beginning of -XYPlot-, such that -XYPlot- will recognize the new plot-type.\n
XYPlotTexture and XYPlotTextureRange can be used to specify the way -XYPlot- searches for analyses
(see analogous options under ExtractMinDat::usage for more details).\n
Example 1:
XYPlot[\"pet2\"]\n
This draws a xy-plot with all default settings (e.g. Si vs Mg/(Mg + Fe2) for amphibole).\n
Example 2: plot for zoisite/epidote
XYPlot[\"pet2\", XYPlotType -> XYPlotTypeZoEp1, XYPlotSymbolShape -> SymbolShapeSquare,
               XYPlotSymbolSize -> 0.01]\n
This draws Al vs Fe3 for zoisite/epidote using squares and enlarging the symbol size.
Example 3: garnet profile
p1 = XYPlot[\"pet2\", XYPlotType -> XYPlotTypeGrtProfileXFe, XYPlotSymbolShape -> SymbolShapeSquare];
p2 = XYPlot[\"pet2\", XYPlotType -> XYPlotTypeGrtProfileXMg, XYPlotSymbolShape -> SymbolShapeDot];
p3 = XYPlot[\"pet2\", XYPlotType -> XYPlotTypeGrtProfileXCa, XYPlotSymbolShape -> SymbolShapeTriangle,
                    XYPlotSymbolSize -> 0.014];
p4 = XYPlot[\"pet2\", XYPlotType -> XYPlotTypeGrtProfileXMn, XYPlotSymbolShape -> SymbolShapeDiamond,
                    XYPlotTextOwn -> Text[FontForm[\"sample XY\", {\"Helvetica-Bold\", 16}],
                                          Scaled[{0.5, 0.8}], {0, 0}, {1, 0}]];
Show[p1, p2, p3, p4]\n
This creates a garnet profile, using squares, dots, triangles
and diamonds as plot symbols and inserting a text into the plot.
For further examples see PET_Mineralchemical_Plots.nb.
Called from: User.
Package name: UTILITY.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

XYPlotType::usage = "XYPlotType is an option of -XYPlot-"
XYPlotSymbolShape::usage = "XYPlotSymbolShape is an option of -XYPlot-"
XYPlotSymbolSize::usage = "XYPlotSymbolSize is an option of -XYPlot-"
XYPlotGridThickness::usage = "XYPlotGridThickness is an option of -XYPlot-"
XYPlotTickThickness::usage = "XYPlotTickThickness is an option of -XYPlot-"
XYPlotFrameThickness::usage = "XYPlotFrameThickness is an option of -XYPlot-"
XYPlotLabel::usage = "XYPlotLabel is an option of -XYPlot-"
XYPlotLabelPosition::usage = "XYPlotLabelPosition is an option of -XYPlot-"
XYPlotTextStyle::usage = "XYPlotTextStyle is an option of -XYPlot-"
XYPlotTextOwn::usage = "XYPlotTextOwn is an option of -XYPlot-"
XYPlotTexture::usage = "XYPlotTexture is an option of -XYPlot-"
XYPlotTextureRange::usage = "XYPlotTextureRange is an option of -XYPlot-"


Begin["`Private`"]

OO2buffers[p_,t_,UTILITY`Buffer_] := Block[{r=8.3143,buf="not defined",opt={UTILITY`NNO,UTILITY`QFM,UTILITY`QFI,UTILITY`WM,UTILITY`MI,UTILITY`WI,UTILITY`CCO,UTILITY`WWO,UTILITY`MH}},
	If[Intersection[{UTILITY`Buffer},opt] == {}, Print["wrong value \"",UTILITY`Buffer,"\" for option \"Buffer\""];
	   Print["Allowed values are: ",opt];Return[]];
	If[UTILITY`Buffer==UTILITY`NNO, If[t>=700 && t<=1700, buf = (-478967+248.514 t-9.7961 t Log[t]+0.8764(p-1))/(r t Log[10])]]; (* NNO *)
	If[UTILITY`Buffer==UTILITY`QFM, If[t>=900 && t<=1420, buf = (-587474+1584.427 t-203.3164 t Log[t]+0.09271 t^2+1.7942(p-1))/(r t Log[10])]]; (* QFM *)
	If[UTILITY`Buffer==UTILITY`QFI, (* QFI *)
	  If[t>=900 && t<=1042, buf = (-542941-33.182 t+22.446 t Log[t]+0.9518(p-1))/(r t Log[10])];
	  If[t>=1042 && t<=1184, buf = (-562377+103.384 t+5.4771 t Log[t]+0.9518(p-1))/(r t Log[10])];
	  If[t>=1184 && t<=1420, buf = (-602739+369.704 t-27.3443 t Log[t]+0.9518(p-1))/(r t Log[10])]]; 
	If[UTILITY`Buffer==UTILITY`WM, (* MW *)
	  If[t>=833 && t<=1270, buf = (-581927-65.618 t+38.741 t Log[t]+1.7048(p-1))/(r t Log[10]) ]];
	If[UTILITY`Buffer==UTILITY`MI, (* MI *)
	  If[t>=750 && t<=900, buf = (-607673+1060.994 t-132.3909 t Log[t]+0.06657 t^2+1.1624(p-1))/(r t Log[10]) ]];
	If[UTILITY`Buffer==UTILITY`WI, (* WI *)
	    If[t>=833 && t<1042, buf = (-605568+1366.42 t-182.7955 t Log[t]+0.10359 t^2+0.9816(p-1))/(r t Log[10])]; (* WI *)
	    If[t>=1042 && t<1184, buf = (-519113+59.129 t+8.9276 t Log[t]+0.9816(p-1))/(r t Log[10])];
  	    If[t>=1184 && t <=1644, buf = (-550915+269.106 t-16.9484 t Log[t]+0.9816(p-1))/(r t Log[10])]];
	If[UTILITY`Buffer==UTILITY`CCO, (* Co-CoO *)
	  If[t>=700 && t<=1394, buf = (-492186+509.322 t-53.284 t Log[t]+0.02518 t^2+0.994(p-1))/(r t Log[10])];
	  If[t>=1394 && t<=1760, buf = (-484276+235.092 t-11.344 t Log[t]+0.994(p-1))/(r t Log[10])]];
	If[UTILITY`Buffer==UTILITY`WWO, If[t>=700 && t<=1700, buf = (-569087+300.479 t-15.9697 t Log[t]+1.0375(p-1))/(r t Log[10])]]; (* W-WO2 *)	
	If[UTILITY`Buffer==UTILITY`CuCu2O, If[t>=700 && t<=1700, buf = (-347705+246.096 t-12.9053 t Log[t]+0.9211(p-1))/(r t Log[10])]]; (* Cu-Cu2O *)	
	If[UTILITY`Buffer==UTILITY`MH,buf = -25632/t + 14.62 + 0.019(p-1)/t]; (* MH *)	
	Return[N[{p,t,buf,UTILITY`Buffer},10]]]
Options[O2buffers] = {UTILITY`Buffer->UTILITY`NNO};
O2buffers[p_,t_,opts___] := Block[{opt={UTILITY`Buffer},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -O2buffers-"];
	   Print["Known option is: ",opt];Return[]]];
	OO2buffers[p,t,UTILITY`Buffer/.{opts}/.Options[O2buffers]]];

SaveRea[rea_,fname_] := Put[rea,fname];

GetRea[fname_] := Block[{r}, r = Get[fname];
	If[r == $Failed, Print["File error: file ",fnamel," does not exist"]; Return[0]];
	Return[r]]

PPlotRea[res_,UTILITY`PlotReaMode_,UTILITY`PlotReaStyle_] := Block[{resl,pl,plot,i},
		If[Dimensions[Dimensions[res[[1]]]][[1]] == 2, resl=res[[1]]]; 	(* data from -CalcRea- *)
		If[Dimensions[Dimensions[res[[1]]]][[1]] == 1, resl=res]; 	(* data from -CalcThermoBaro- *)
		If[Dimensions[resl[[1]]][[1]] < 3, Return["Message from -PlotRea-: There are no equilibrium data so far !"]];
		pl = Table[0,{i,1,Dimensions[resl][[1]]}]; 
		For[i=1,i<=Dimensions[resl][[1]],i++,
		   If[Head[resl[[i,3]]] == List,
		     pl[[i]] = ListPlot[resl[[i,3]],PlotJoined->True,PlotStyle->UTILITY`PlotReaStyle,DisplayFunction->Identity];
		     If[i==1, plot = pl[[1]]];
		     plot = Show[plot,pl[[i]],PlotRange->All];
		     ];
		   ];
		If[UTILITY`PlotReaMode == 0, Return[Show[plot,DisplayFunction->$DisplayFunction]]];
		Return[plot]]                                           
Options[PlotRea] = {UTILITY`PlotReaMode->0,UTILITY`PlotReaStyle->Automatic};
PlotRea[res_,opts___] := Block[{opt={UTILITY`PlotReaMode,UTILITY`PlotReaStyle},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -PlotRea-"];
	   Print["Known option is: ",opt];Return[]]];	
	PPlotRea[res,UTILITY`PlotReaMode/.{opts}/.Options[PlotRea],UTILITY`PlotReaStyle/.{opts}/.Options[PlotRea]]];

	
MakeCompositionMatrix[phasen_] :=
  	(* build matrix of chemical composition *)
  	Block[{n,i,j,ch,pos1,pos2,pos3,el,eln,elem,totelem={},nn,m},
    	n = Dimensions[phasen][[1]];
    	elem = Table[0, {i, 1, n}];
    	For[i = 1, i <= n, i++,
	   ch = MinDat[phasen[[i]]];
	   If[ch == -1, Return[{-1,phasen[[i]]}]];	   
      	   ch = ch[[1, 3]];
      	   pos1 = Union[Flatten[StringPosition[ch, "("]]];
      	   pos2 = Union[Flatten[StringPosition[ch, ")"]]];
      	   pos3 = Delete[pos2, Dimensions[pos2][[1]]];
      	   pos3 = Prepend[pos3, 0];
      	   el = eln = {};
      	   For[j = 1, j <= Dimensions[pos1][[1]], j++,
              eln = Append[eln, ToExpression[StringTake[ch, {pos1[[j]] + 1, pos2[[j]] - 1}]]];
              el = Append[el, StringTake[ch, {pos3[[j]] + 1, pos1[[j]] - 1}]];
              ];
      	   elem[[i]] = {el, eln};
      	   ];    
    	For[i = 1, i <= n, i++, totelem = Join[totelem, elem[[i, 1]]]];
    	totelem = Union[totelem];
       	m = Table[0, {i, 1, nn = Dimensions[totelem][[1]]}, {j, 1, n}];
       	For[i = 1, i <= nn, i++,
      	   For[j = 1, j <= n, j++,
              pos1 = Position[elem[[j, 1]], totelem[[i]]];          
              If[pos1 != {}, m[[i, j]] = elem[[j, 2, pos1[[1, 1]]]], m[[i, j]] = 0];
              ];
          ];
    
    Return[{m,totelem}]]


Binom[n_Integer,-1] := {-1}; Binom[n_Integer,0] := {0};
Binom[n_Integer,1] := Binom[n,1] = Partition[Range[n],1];
Binom[n_Integer,n_Integer] := Binom[n,n] = Range[n];
Binom[n_Integer,m_Integer] := Binom[n,m] = Partition[Flatten[{Binom[n-1,m],Map[Append[#,n]&,Binom[n-1,m-1]]}],m];

MMakeRea[phases_,UTILITY`MakeReaMode_] := Block[{mode=UTILITY`MakeReaMode,m,e,r={},nr,n,li,re,i,ii,nullspace,
    ir,nir,inva,count=0,np,nkomp,f,nf,max,ind,rl,opt={0,1,2}},
    If[Intersection[{UTILITY`MakeReaMode},opt] == {}, 
      Print["Error-message from -MakeRea-: wrong value \"",UTILITY`MakeReaMode,"\" for option \"MakeReaMode\"."];
      Print["Allowed values are: ",opt,"."];Return[-1]];
    {m, e} = MakeCompositionMatrix[phases];
    If[m == -1,  Print["Error-message from -MakeRea-: wrong phase abbreviation \"",e,"\" encountered."]; Return[]];    
    nullspace = NullSpace[m];

    If[nullspace == {}, Return[nullspace]];
    
    If[mode == 0, 
      r = nullspace.phases; 
      ];
       
     If[mode == 1,
       ir = nullspace; nir = Dimensions[ir][[1]]; 
       If[nir == 1, r = nullspace.phases];
       If[nir > 1,
         np = Dimensions[phases][[1]];
         nkomp = np - nir;	(* number of components *)		  	
         f = Table[i,{i,1,nf=nkomp}]; (* degrees of freedom *)
         n = nkomp+2-f; (* number of phases for each degree of freedom *)
         For[i=1,i<=nf,i++, max = Binomial[np,n[[i]]];
	    Print["Calculating reactions with ",n[[i]]," phases"];
	    Print["(degree of freedom =  ",i," ): from combinatorics, there are ",max," possible reactions."]; 
	    Scan[(ind=#; {m, e} = MakeCompositionMatrix[phases[[ind]]]; rl = NullSpace[m];
	        If[rl != {}, r=Join[r,rl.phases[[ind]]]])&,Binom[np,n[[i]]]];
	    r = Union[r];
	    ];
	  ];	  
       ];     
     
    If[mode == 2,
      Off[LinearSolve::nosol]; Off[Inverse::sing]; Off[Inverse::luc];
      ir = nullspace; nir = Dimensions[ir][[1]]; n = Dimensions[phases][[1]];
      (* algorithm of Powell 1990 *)
      Scan[(inva = Chop[Inverse[Join[Transpose[ir][[k=#]],{Array[1.&,{nir}]}]]];
      If[MatrixQ[inva]==True,
      r =  Append[r,Chop[Transpose[ir].(lc=inva.Join[Array[0.&,{nir-1}],{1.}])]], count++];
	   )&,Binom[n,nir-1]];      
      r = Union[Map[Chop[#/Min[#]]&,r]]; (* try to get simple odd and even numbers  *)
      r = Union[Round[Map[Chop[#(Min[Denominator[Rationalize[#]]]Max[Denominator[Rationalize[#]]])]&,r]]];      
      r = r . phases;
      On[LinearSolve::nosol]; Off[Inverse::sing]; Off[Inverse::luc];
      If[count > 0, Print["Warning from -MakeRea-: singular matrix occurred during calculation. Not all reactions may have been found."];
	Print["Use option MakeReaMode -> 1 to find all reactions."]];
     ]; 

     (* sorting and reformating *)
     nr = Dimensions[r][[1]]; (* number of lin. independent reactions  *)
     rea = Table[0, {i, 1, nr}];
     For[ii = 1, ii <= nr, ii++, (* loop over number of lin. independent reactions  *)
        n = Dimensions[r[[ii]]][[1]];
        li = re = {};
        For[i = 1, i <= n, i++, (* loop over each reaction  *)
          If[Dimensions[r[[ii, i]]] == {2},           
            If[r[[ii, i, 1]] < 0, 
              li = Append[li, 1.r[[ii, i, 1]]*r[[ii, i, 2]]]];          
            If[r[[ii, i, 1]] > 0, 
              re = Append[re, 1.r[[ii, i, 1]]*r[[ii, i, 2]]]];
            ];
          If[Dimensions[r[[ii, i]]] == {}, re = Append[re, 1.*r[[ii, i]]] ];
          ];
        li = Sort[li]; re = Sort[re];
        rea[[ii]] = Flatten[{li, re}];
        ]; (* end of For[ii = 1, ii <= nr, ii++,   *)
    Return[rea];
]
Options[MakeRea] = {UTILITY`MakeReaMode->0};
MakeRea[phases_,opts___] := Block[{opt={UTILITY`MakeReaMode},
	i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -MakeRea-"];
	   Print["Known options are: ",opt];Return[]]];
	MMakeRea[phases,UTILITY`MakeReaMode/.{opts}/.Options[MakeRea]]]; 
    

SSelectRea[rea_,para_,UTILITY`SelectReaMode_] := Block[{mode=UTILITY`SelectReaMode,i,k,m,p,n,r={},opt={0,1},flag=Dimensions[Dimensions[rea[[1]]]][[1]]}, 
	If[Intersection[{UTILITY`SelectReaMode},opt] == {}, Print["wrong value \"",UTILITY`SelectReaMode,"\" for option \"SelectReaMode\""];
	   Print["Allowed values are: ",opt];Return[]];
	For[i=1,i<=Dimensions[rea][[1]],i++,
	   If[flag==2, k = Part[rea[[i,1]],Transpose[Position[rea[[i,1]],_Real]][[1]],1];
	      m = Part[rea[[i,1]],Transpose[Position[rea[[i,1]],_Real]][[1]],2]];
	   If[flag==1, k = Part[rea[[i]],Transpose[Position[rea[[i]],_Real]][[1]],1];
	      m = Part[rea[[i]],Transpose[Position[rea[[i]],_Real]][[1]],2]];
	   p = Flatten[Position[k,_Real?Positive]];
	   n = Flatten[Position[k,_Real?Negative]];
	   p1 = m[[p]]; p2 = m[[n]];
	   If[mode == 1, (* strict search *)
     	  If[Sort[p1]==Sort[para] || Sort[p2]==Sort[para] , r=Append[r,rea[[i]]]]]; 
	   If[mode == 0, (* less strict search *)
	     If[Intersection[para,p1]==Sort[para] || Intersection[para,p2]==Sort[para], 
	     r=Append[r,rea[[i]]]]]];
	Return[r]]
Options[SelectRea] = {UTILITY`SelectReaMode->1};
SelectRea[rea_,para_,opts___] := Block[{opt={UTILITY`SelectReaMode},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -SelectRea-"];
	   Print["Known option is: ",opt];Return[]]];
	SSelectRea[rea,para,UTILITY`SelectReaMode/.{opts}/.Options[SelectRea]]];

	
CCalcReaIntersection[rea_,UTILITY`CalcReaIntersectionFilter_] := Block[{real,nrea=0,int,min,max,i,bin,is,res,p,t,tt,
	mw,sd,fil={},filter=UTILITY`CalcReaIntersectionFilter},
	Off[Interpolation::inhr];Off[InterpolatingFunction::dmval]; Off[InterpolatingFunction::dmwarn]; 
	Off[FindRoot::frnum];	
	If[Dimensions[Dimensions[rea[[1]]]][[1]] == 2, real=rea[[1]]]; 	(* data from -CalcRea- *)
	If[Dimensions[Dimensions[rea[[1]]]][[1]] == 1, real=rea]; 	(* data from -CalcThermoBaro- *)
	
	For[i=1,i<=Dimensions[real][[1]],i++,
	   If[Head[real[[i,3]]] == List,nrea++];
	   ];
	int = min = max = Table[0,{i,1,nrea}];
	For[i=1,i<=nrea,i++,
	   int[[i]] = Interpolation[real[[i,3]]];
	   If[Dimensions[Dimensions[int[[i,1]]]][[1]] == 1, min[[i]] = int[[i]][[1,1]]; max[[i]] = int[[i]][[1,2]]];
	   If[Dimensions[Dimensions[int[[i,1]]]][[1]] == 2, min[[i]] = int[[i]][[1,1,1]]; max[[i]] = int[[i]][[1,1,2]]];
	   ];
	bin = Binom[nrea,2]; If[nrea == 2, bin = {bin}];
	is = p = t = Table[0,{i,1,Dimensions[bin][[1]]}];
	For[i=1,i<=Dimensions[bin][[1]],i++,
	   res = FindRoot[int[[bin[[i,1]]]][tt] == int[[bin[[i,2]]]][tt],
	             {tt,Max[min[[bin[[i,1]]]],min[[bin[[i,2]]]]],Min[max[[bin[[i,1]]]],max[[bin[[i,2]]]]]}][[1,2]];
	   If[!NumberQ[res], is[[i]] = {"no intersection",bin[[i]]}; Continue[]];
	   is[[i]] = res;
	   t[[i]] = is[[i]];
	   p[[i]] = int[[bin[[i,1]]]][t[[i]]];
	   is[[i]] = Join[{p[[i]],t[[i]],bin[[i]]}]];
	p = Union[p]; t = Union[t];
	If[p[[1]] == 0, p = Delete[p,1]];
	If[t[[1]] == 0, t = Delete[t,1]];
	If[filter > 0,
	  For[i=1,i<=Dimensions[is][[1]],i++,
		 If[Abs[is[[i,Dimensions[is[[i]]][[1]],2]]-is[[i,Dimensions[is[[i]]][[1]],1]]] == filter, 
           fil = Append[fil,is[[i]]]]]; 
	   Return[{{Mean[Transpose[fil][[1]]],StandardDeviation[Transpose[fil][[1]]]},
		 {Mean[Transpose[fil][[2]]],StandardDeviation[Transpose[fil][[2]]]},fil}]];
	Return[is]]
Options[CalcReaIntersection] = {UTILITY`CalcReaIntersectionFilter->0};
CalcReaIntersection[rea_,opts___] := Block[{opt={UTILITY`CalcReaIntersectionFilter},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -CalcReaIntersection-"];
	   Print["Known options are: ",opt];Return[]]];
	CCalcReaIntersection[rea,UTILITY`CalcReaIntersectionFilter/.{opts}/.Options[MakeRea]]]; 

MMakeAnalysisTable[fname_,UTILITY`MakeAnalysisTableDigits_,UTILITY`MakeAnalysisTableSplit_,UTILITY`MakeAnalysisTableFileFormat_,UTILITY`MakeAnalysisTableAddParameters_] := 
	Block[{o,f,fnamel,ftest,file,r,w,wt,i,j,k,ft,fu,str,nw,dig=UTILITY`MakeAnalysisTableDigits,
	opt={2,3,4,5},opt1={UTILITY`Standard,UTILITY`Pisa},n,x,split=UTILITY`MakeAnalysisTableSplit,parts,take,wtt,first,lab,par,
	fe2pos,fe3pos,grtpos,fe3grt,opxpos,fe3opx,cpxpos,fe3cpx,amphpos,fe3amph,parname={},parvalue={},pos,post,
	spinpos,fe3spin,ctdpos,fe3ctd,saphpos,fe3saph,fetioxpos,fe3fetiox,min,dat},
	o = {"Label","Mineral","SiO2","TiO2","Al2O3","Fe2O3","Cr2O3","FeO","MgO","MnO","CaO","Na2O","K2O","Total",
		 "BaO","BeO","B2O3","CeO2","Ce2O3","Cl","CoO","CO2","Cs2O","CuO","Dy2O3","Er2O3","Eu2O3","F",
		 "Gd2O3","HfO2","H2O","La2O3","Li2O","Lu2O3","MnO2","Mn3O4","Nb2O5","Nd2O3","NiO","PbO","Pr2O3",
		 "P2O5","Rb2O","S","Sc2O3","Sm2O3","SnO","SO3","SrO","Ta2O5","ThO2","UO2","V2O3","Y2O3","ZnO","ZrO2",
		 "Sifu","Tifu","Alfu","Fe3fu","Crfu","Fe2fu","Mgfu","Mnfu","Cafu","Nafu","Kfu","Bafu","Befu","Bfu","Ce4fu","Ce3fu","Clfu","Cofu","CO2fu",
		 "Csfu","Cufu","Dyfu","Erfu","Eufu","Ffu","Gdfu","Hffu","OHfu","Lafu","Lifu","Lufu","Mn4fu","Mn32fu","Nbfu","Ndfu","Nifu","Pbfu","Prfu",
		 "Pfu","Rbfu","Sfu","Scfu","Smfu","Snfu","SO3fu","Srfu","Tafu","Thfu","Ufu","Vfu","Yfu","Znfu","Zrfu"};
	If[Intersection[{UTILITY`MakeAnalysisTableDigits},opt] == {}, 
	   Print["wrong value \"",UTILITY`MakeAnalysisTableDigits,"\" for option \"MakeAnalysisTableDigits\""]; 
	   Print["Allowed values are: ",opt];Return[]];
	If[Intersection[{UTILITY`MakeAnalysisTableFileFormat},opt1] == {}, 
	   Print["wrong value \"",UTILITY`MakeAnalysisTableFileFormat,"\" for option \"MakeAnalysisTableFileFormat\""]; 
	   Print["Allowed values are: ",opt1];Return[]];
	If[ToString[Head[fname]] != "String", Print["Error-message from -MakeAnalysisTable-: File-name is not a string."]; Return[]];
	fnamel = StringJoin[fname,".fu"];
	r = Get[fnamel];
	If[r == $Failed, Print["Error-message from -MakeAnalysisTable-: file \"",fnamel,"\" does not exist. Use -CalcFormula- before."]; Return[]];
	ftest = OpenRead[fname]; Close[ftest];
	If[ftest == $Failed, Return["Error-message from -MakeAnalysisTable-: file \"",fname,"\" does not exist."]];

	w = ReadList[fname,Word,RecordLists->True,
                 WordSeparators->{" ","\t"},RecordSeparators->{"\n","\r"}];
	wt = Transpose[w];
	{lab,wt} = {wt[[1]],Delete[wt,1]};
	wt = ToExpression[wt];
	w = Transpose[Join[{lab},wt]];
	nw = Dimensions[w][[2]];
	wt = Transpose[w];
	f = par = Table[0,{i,1,Dimensions[r[[2]]][[1]]}];
	For[i=1,i<=Dimensions[r[[2]]][[1]],i++,
	   f[[i]] = Take[r[[2,i]],{2,Dimensions[r[[1]]][[1]]}];
	   par[[i]] = Take[r[[2,i]],{Dimensions[r[[1]]][[1]]+1,Dimensions[r[[2,i]]][[1]]}];
	   ];
	ft = Transpose[f];
	wt = Append[wt,Prepend[Last[ft],ToExpression["Total"]]];
	ft = Delete[ft,Dimensions[ft][[1]]];
	fu = Take[r[[1]],{2,Dimensions[r[[1]]][[1]]-1}];
	For[i=1,i<=Dimensions[fu][[1]],i++,
	   fu[[i]] = ToString[fu[[i]]];
	   If[fu[[i]]=="K2O"||fu[[i]]=="F"||fu[[i]]=="B2O3"||fu[[i]]=="Y2O3"||fu[[i]]=="V2O3"||
	     fu[[i]]=="UO2"||fu[[i]]=="P2O5"||fu[[i]]=="B"||fu[[i]]=="S"||fu[[i]]=="CO2",
	     fu[[i]] = StringTake[fu[[i]],1],
	     If[fu[[i]] == "Fe2O3", fu[[i]] = "Fe3",
	     If[fu[[i]] == "FeO", fu[[i]] = "Fe2" ,
	     If[fu[[i]] == "Ce2O3", fu[[i]] = "Ce3",
	     If[fu[[i]] == "CeO2", fu[[i]] = "Ce4" ,
	     If[fu[[i]] == "MnO2", fu[[i]] = "Mn4" ,
	     If[fu[[i]] == "Mn3O4", fu[[i]] = "Mn32" ,
	     If[fu[[i]] == "H2O", fu[[i]] = "OH",
	     fu[[i]] = StringTake[fu[[i]],2]]]]]]]]
	     ];
	   ];
	fu = ToExpression[fu];
	f = Transpose[Prepend[Transpose[Delete[ft,1]],Delete[fu,1]]];
	wt = Join[wt,f];
	fe2pos = Flatten[Position[wt,UTILITY`Fe2]];
	If[fe2pos != {},
	  grtpos = Position[r[[2]],UTILITY`grt]; opxpos = Position[r[[2]],UTILITY`opx]; 
	  cpxpos = Position[r[[2]],UTILITY`cpx]; amphpos = Position[r[[2]],UTILITY`amph]; 
	  spinpos = Position[r[[2]],UTILITY`spin]; ctdpos = Position[r[[2]],UTILITY`ctd]; 
	  saphpos = Position[r[[2]],UTILITY`saph]; fetioxpos = Position[r[[2]],UTILITY`fetiox]; 
	  If[grtpos != {},   fe3grt = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,grtpos]];
	  If[opxpos != {},   fe3opx = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,opxpos]];
	  If[cpxpos != {},   fe3cpx = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,cpxpos]];
	  If[amphpos != {}, fe3amph = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,amphpos]];
	  If[spinpos != {}, fe3spin = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,4]]&,spinpos]];
	  If[ctdpos != {},   fe3ctd = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,ctdpos]];
	  If[saphpos != {}, fe3saph = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,5]]&,saphpos]];
	  If[fetioxpos != {}, fe3fetiox = Map[r[[2,#[[1]],Dimensions[r[[1]]][[1]]+1,1,2,3]]&,fetioxpos]];
	  ];
	If[grtpos != {} || opxpos != {} || cpxpos != {} || amphpos != {} || spinpos != {} || 
	   ctdpos != {} || saphpos != {} || fetioxpos != {}, 
	  fe3pos = Flatten[Position[wt,UTILITY`Fe3]];
	  If[fe3pos == {}, wt = Insert[wt,Table[0,{i,1,Dimensions[wt[[1]]][[1]]}],fe2pos[[1]]+1];
	    wt[[fe2pos[[1]]+1,1]] = Fe3]; 
	  fe3pos = Flatten[Position[wt,UTILITY`Fe3]];
	  ];
	If[fe3pos != {}, 
	  If[grtpos != {},
	    For[i=1,i<=Dimensions[grtpos][[1]],i++,
	       wt[[fe3pos[[1]],grtpos[[i]][[1]]+1]] = fe3grt[[i]]]];
	  If[opxpos != {},
	    For[i=1,i<=Dimensions[opxpos][[1]],i++,
	       wt[[fe3pos[[1]],opxpos[[i]][[1]]+1]] = fe3opx[[i]]]];
	  If[cpxpos != {},
	    For[i=1,i<=Dimensions[cpxpos][[1]],i++,
	       wt[[fe3pos[[1]],cpxpos[[i]][[1]]+1]] = fe3cpx[[i]]]];
	  If[amphpos != {},
	    For[i=1,i<=Dimensions[amphpos][[1]],i++,
	       wt[[fe3pos[[1]],amphpos[[i]][[1]]+1]] = fe3amph[[i]]]];
	  If[spinpos != {},
	    For[i=1,i<=Dimensions[spinpos][[1]],i++,
	       wt[[fe3pos[[1]],spinpos[[i]][[1]]+1]] = fe3spin[[i]]]];
	  If[ctdpos != {},
	    For[i=1,i<=Dimensions[ctdpos][[1]],i++,
	       wt[[fe3pos[[1]],ctdpos[[i]][[1]]+1]] = fe3ctd[[i]]]];
	  If[saphpos != {},
	    For[i=1,i<=Dimensions[saphpos][[1]],i++,
	       wt[[fe3pos[[1]],saphpos[[i]][[1]]+1]] = fe3saph[[i]]]];
	  If[fetioxpos != {},
	    For[i=1,i<=Dimensions[fetioxpos][[1]],i++,
	       wt[[fe3pos[[1]],fetioxpos[[i]][[1]]+1]] = fe3fetiox[[i]]]];
	  ];

	If[UTILITY`MakeAnalysisTableAddParameters != "" || Head[UTILITY`MakeAnalysisTableAddParameters] == List,
	  min = Union[Take[wt[[2]],{2,Length[wt[[2]]]}]];
	  If[Dimensions[min][[1]] != 1,
	    Print["Error-message from -MakeAnalysisTable- (option -AddParameters-): "];
	    Print["For this option the data file must contain only one sort of mineral."];
	    Print["Your data file \"",fnamel,"\" contains: ",min,"."];
	     Return[]
	    ];
	  
	  dat=ExtractMinDat[min[[1]], UTILITY`MakeAnalysisTableAddParameters, fname];
	  If[Dimensions[dat][[1]] == 1,
	    If[Head[dat[[1,1]]] == String, 
	      If[StringTake[dat[[1, 1]], {1, 5}] == "Error", 
	        Print["Error-message from -MakeAnalysisTable-: Parameter \"",UTILITY`MakeAnalysisTableAddParameters,"\" not recognized."];Return[];
	        ];
	      ];	  	  
	    wt = Append[wt, Flatten[{UTILITY`MakeAnalysisTableAddParameters, dat}]];
	    ];
	  If[Dimensions[dat][[1]] > 1,
	    For[i=1,i<=Dimensions[dat][[1]],i++,
	       If[Head[dat[[i,1]]] == String, 
	         If[StringTake[dat[[i, 1]], {1, 5}] == "Error", 	       
	           Print["Error-message from -MakeAnalysisTable-: Parameter \"",UTILITY`MakeAnalysisTableAddParameters[[i]],"\" not recognized."];;Return[];
	           ];
	         ];	       
	       wt = Append[wt, Flatten[{UTILITY`MakeAnalysisTableAddParameters[[i]], dat[[i]]}]];
	       ];	  
	    ];	  
	  ];

	If[UTILITY`MakeAnalysisTableFileFormat == UTILITY`Standard,
	  x = Dimensions[wt][[2]]-1;
	  n = Table[split i,{i,1,Floor[x/split]}];
	  n = Union[Prepend[Append[n,x],0]]; parts = Dimensions[n][[1]]-1;
	  file = OpenWrite[StringJoin[fname,".tab"]];
	  wtt = Transpose[wt]; first = wtt[[1]];
	  wtt = Delete[wtt,1];
	  For[k=1,k<=parts,k++,
	     take = {n[[k]]+1,n[[k+1]]};
	     wt = Transpose[Prepend[Take[wtt,take],first]];
	     For[i=1,i<=Dimensions[wt][[1]],i++, 
	        For[j=1,j<=Dimensions[wt[[i]]][[1]],j++,
	           str = ToString[NumberForm[wt[[i,j]],{dig+3,dig}]];
	           If[i==1 && j==1,str=" "];
	           WriteString[file,str,"\t"];
	           ];
		   WriteString[file,"\n"];
	        ];
		WriteString[file,"\n"];
	      ];
	  Close[file]; 	
	  ];
	If[UTILITY`MakeAnalysisTableFileFormat == UTILITY`Pisa, (* Format for Pisa-data bank  *)
	  wtt = Transpose[wt]; first = wtt[[1]]; wtt = Delete[wtt,1]; r = par;
	  For[i=1,i<=Dimensions[first][[1]],i++, first[[i]] = ToString[first[[i]]]];
	  post = Position[first,"Total"][[1,1]];
	  For[i=post+1,i<=Dimensions[first][[1]],i++, first[[i]] = StringJoin[first[[i]],"fu"]];
	  file = OpenWrite[StringJoin[fname,".pis"]];
	  For[i=1,i<=Dimensions[wtt][[1]],i++, 
	     For[j=1,j<=Dimensions[o][[1]],j++, 
		pos = Flatten[Position[first,o[[j]]]];
		If[pos != {}, str = N[wtt[[i,pos[[1]]]]];
		If[NumberQ[str] == True, str = ToString[NumberForm[str,{dig+3,dig}]]];
	        WriteString[file,str,","]];
		If[pos == {}, WriteString[file,","]];
	        ];	        
	     If[ToString[wtt[[i,2]]] != "alsi" && StringPosition[ToString[wtt[[i,2]]],"min"] == {},
	       parname = Flatten[Join[r[[i,1,1,1]], r[[i,1,2,1]]]];
	       parvalue = Flatten[Join[r[[i,1,1,2]], r[[i,1,2,2]]]];
	       For[j=1,j<=Dimensions[parname][[1]],j++,
	          WriteString[file,parname[[j]],","];
	          WriteString[file,ToString[NumberForm[parvalue[[j]],{dig+3,dig}]],","];
	          ];
	       ];	(* Ende if  *)
	     WriteString[file,"\n"];	
	     ];
	   Close[file]; 	
	   ];
	Print["Message from -MakeAnalysisTable-: creating file \"",StringJoin[fname,".tab"],"\"."];
]
Options[MakeAnalysisTable] = {UTILITY`MakeAnalysisTableDigits->3,UTILITY`MakeAnalysisTableSplit->10,
UTILITY`MakeAnalysisTableFileFormat->UTILITY`Standard,UTILITY`MakeAnalysisTableAddParameters->""};
MakeAnalysisTable[fname_,opts___] := Block[{opt={UTILITY`MakeAnalysisTableDigits,UTILITY`MakeAnalysisTableSplit,UTILITY`MakeAnalysisTableFileFormat,UTILITY`MakeAnalysisTableAddParameters},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -MakeAnalysisTable-"];
	   Print["Known options are: ",opt];Return[]]];
	MMakeAnalysisTable[fname,UTILITY`MakeAnalysisTableDigits/.{opts}/.Options[MakeAnalysisTable],
	UTILITY`MakeAnalysisTableSplit/.{opts}/.Options[MakeAnalysisTable],
	UTILITY`MakeAnalysisTableFileFormat/.{opts}/.Options[MakeAnalysisTable],
	UTILITY`MakeAnalysisTableAddParameters/.{opts}/.Options[MakeAnalysisTable]
	]];

TTransformDatFile[emsfname_,fname_,UTILITY`TransformDatFileEMP_] := Block[{wbtt,ftest,startpos={},endpos,n,i,j,dat,dat1,pos={},file,fe2,n1,fe3sum,
	kfsppos,plagpos,alsipos,zoeppos,sphenpos,opt={UTILITY`Salzburg,UTILITY`Innsbruck}},
	If[Intersection[{UTILITY`TransformDatFileEMP},opt] == {}, 
	   Print["wrong value \"",UTILITY`TransformDatFileEMP,"\" for option \"TransformDatFileEMP\""]; 
	   Print["Allowed values are: ",opt];Return[]];	
	If[ToString[Head[fname]] != "String" || ToString[Head[emsfname]] != "String", Print["Error-message from -TransformDatFile-: File-name is not a string."]; Return[]];
	ftest = OpenRead[emsfname]; Close[ftest];
	If[ftest == $Failed, Print["Error-message from -TransformDatFile-: File \"",emsfname,"\" does not exist."];Return[]];
	If[emsfname == fname,Print["Error-message from -TransformDatFile-: Equal file names."];Return[]];
	If[FileNames[fname] != {},Print["Error-message from -TransformDatFile-: File \"",fname,"\" already exists (would be overwritten)."];Return[]];
	wbtt = ReadList[emsfname,Word,RecordLists->True,
	WordSeparators->{" ","\t"},RecordSeparators->{"\n","\r"}];
	
	If[UTILITY`TransformDatFileEMP == UTILITY`Salzburg,
	  startpos = Position[wbtt,"Point"];
	  endpos = Position[wbtt,"Mean="];
	  If[startpos == {} && endpos == {}, Print["Error-message from -TransformDatFile-: Wrong EMP-file type."]; Return[], 
	    startpos = startpos[[1,1]]; endpos = endpos[[1,1]]];
	  n = endpos - startpos;
	  dat = Table[0,{i,1,n}]; 
	  For[i=1,i<=n,i++, dat[[i]] = wbtt[[startpos+i-1]];
	     If[Dimensions[dat[[1]]][[1]] != Dimensions[dat[[i]]][[1]],
	       Print["Error-message from -TransformDatFile-: Format error in the file \"",emsfname," \":"];
	       Print["Unequal number of elements in the list"]; Print["\r"];
	       Print[dat[[1]]]; Print[];
	       Print["\nand in the list"]; Print["\r"];
	       Print[dat[[i]]];
	       Return[]]];
	  dat[[1,1]] = ToExpression["Label"];
	  dat[[1,2]] = ToExpression["Mineral"];

	  If[Last[dat[[1]]] == "Total",
   	    dat = Transpose[Delete[Transpose[dat],Dimensions[Transpose[dat]][[1]]]]]; 

	];
	
	If[UTILITY`TransformDatFileEMP == UTILITY`Innsbruck,
	  startpos = Position[wbtt, "No."];
	  endpos = Position[wbtt, "Minimum"];
	  If[startpos == {} && endpos == {}, Print["Error-message from -TransformDatFile-: Wrong EMP-file type."]; Return[], 
	    startpos = startpos[[1,1]]; endpos = endpos[[1,1]]];
	  n = endpos - startpos;
	  dat = Table[0, {i, 1, n}];
	  For[i = 1, i <= n, i++, dat[[i]] = wbtt[[startpos + i - 1]]];
	  pos = Position[dat,"PET"];
	  If[pos == {}, Print["Message from -TransformDatFile-: Format error in EMP-file \"",emsfname,"\"."];
	  		Print["A column \"PET\" must appear after \"Total\", containing mineral codes for PET."]; Return[], pos = pos[[1,2]]]; 
	  
	  If[dat[[1,pos-1]] != "Total", Print["Message from -TransformDatFile-: Format error in EMP-file \"",emsfname,"\"."];
	  		Print["A column \"PET\" must appear after \"Total\", containing mineral codes for PET."]; Return[]]; 
	  If[dat[[1, pos - 2]] == "O", n1 = pos-2];

	  dat1 = Table[0, {i, 1, n},{j, 1, n1}];
	  dat1[[1,1]] = ToExpression["Label"];
	  dat1[[1,2]] = ToExpression["Mineral"];
 	  dat1[[1, Table[i, {i, 3, n1}]]] = Take[dat[[1]], {2, n1-1}];
	  For[i=2,i<=n,i++,
	     dat1[[i,1]] = dat[[i,1]]; dat1[[i,2]] = dat[[i,pos]];
	     For[j=3,j<=n1,j++, dat1[[i,j]] = dat[[i,j-1]]]
	     ];
	  dat = dat1;
	  ];

	fe2 = Flatten[Position[dat[[1]], "FeO"]];
	If[fe2 != {}, zoeppos = Flatten[Position[dat, "zoep"]];
    	kfsppos = Flatten[Position[dat, "kf"]];
    	plagpos = Flatten[Position[dat, "plag"]];
    	alsipos = Flatten[Position[dat, "alsi"]];
    	sphenpos = Flatten[Position[dat, "sphen"]];
    	If[zoeppos != {} || kfsppos != {} || plagpos != {} || alsipos != {} || sphenpos != {}, 
      	  For[i = 1, i <= Dimensions[dat][[1]], i++, 
             dat[[i]] = Append[dat[[i]], "0"];
             If[i == 1, dat[[i, Dimensions[dat[[i]]][[1]]]] = "Fe2O3"];
        If[dat[[i, 2]] == "zoep" || dat[[i, 2]] == "kf" || dat[[i, 2]] == "plag" || dat[[i, 2]] == "alsi" || 
           dat[[i, 2]] == "sphen", dat[[i]] = ToExpression[dat[[i]]];          
        dat[[i, Dimensions[dat[[i]]][[1]]]] = NumberForm[dat[[i, fe2[[1]]]]1.1113,{5,3}];        
        dat[[i, fe2[[1]]]] = 0;
        dat[[i]] = Map[ToString[#] &, dat[[i]]];]]]];
	fe3sum = Sum[ToExpression[dat[[i, Dimensions[dat[[i]]][[1]]]]], {i, 2, n}];
	If[fe3sum == 0, dat = Transpose[Delete[Transpose[dat], Dimensions[dat[[1]]][[1]]]]];
	n1 = Dimensions[dat[[1]]][[1]];
	file = OpenWrite[fname];
	For[i = 1, i <= n, i++, 
    	   For[j = 1, j <= n1, j++, WriteString[file, dat[[i, j]], "\t"];];
    	      WriteString[file, "\n"];];
	Close[file];
	Print["Message from -TransformDatFile-: File \"",fname,"\" was created."];
	];
Options[TransformDatFile] = {UTILITY`TransformDatFileEMP->UTILITY`Salzburg};
TransformDatFile[emsfname_,fname_,opts___] := Block[{opt={UTILITY`TransformDatFileEMP},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -TransformDatFile-"];
	   Print["Known options are: ",opt];Return[]]];
	TTransformDatFile[emsfname,fname,UTILITY`TransformDatFileEMP/.{opts}/.Options[TransformDatFile]]];


FindMineralParameter[par_,dat_,ox_] := Block[{i,o=ox,posox,pos,pv,datl,str1,str2},
   (* subfunction of -ExtractMinDat- : determine Position of parameter par in dat or ox *)
   For[i=1,i<=Dimensions[ox][[1]], i++, o[[i]] = ToString[ox[[i]]]];
   posox = Position[o,par];
   pos = Position[dat,par];
   If[posox == {} && pos == {}, 
     Return[StringJoin["Error: Parameter \"",ToString[par],"\" not recognised"]]];
    
   If[posox != {}, (* the parameter searched for is a formula unit (or Label, or Total)  *)
     pv = dat[[Flatten[posox][[1]]]]];
   If[posox == {}, (* the parameter searched for is not a formula unit  *)
     datl = Last[dat];   
     pos = Flatten[Position[datl,par]];
     If[pos[[1]] == 1,
       pv = datl[[pos[[1]],2,pos[[3]]]];     
       ];
     If[pos[[1]] == 2,
       pv = datl[[pos[[1]],2,pos[[3]],pos[[4]]]];     
       ];
     ];
   Return[pv];
]


CombineFiles[min_,fname_,text_,lab_,sfile_] := Block[{i,wt,ox,j,d={},dd={},oxall,s,dat,k,pos,del,o,
   fnamel,file,str,count=0,dn,oxn,dim=Dimensions[fname]},
   (* subfunction of -ExtractMinDat- *)
    o = {"Label","Mineral","SiO2","TiO2","Al2O3","Cr2O3","Fe2O3","FeO","MgO","CaO","MnO","Na2O","K2O","BaO",
    "ZnO","F","Cl","SrO","B2O3","BeO","Ce2O3","CoO","Eu2O3","HfO2","La2O3","Li2O","Lu2O3","Nd2O3","NiO","PbO",
    "Y2O3","ZrO2","V2O3","Er2O3","Dy2O3","Pr2O3","Gd2O3","Sm2O3","ThO2","UO2","Sc2O3","P2O5","CO2","CeO2",
    "CuO","H2O","MnO2","Mn3O4","Nb2O5","Rb2O","S","SO3","SnO","Ta2O5","Cs2O"};

    If[dim == {}, Return["Error: In this mode a list of files is required"]];
    wt = ox = dat = Table[0,{i,1,dim[[1]]}];
    For[i=1,i<=dim[[1]],i++, d = {};           
       wt[[i]] = ReadList[fname[[i]],Word,RecordLists -> True, WordSeparators -> {" ","\t"}, RecordSeparators -> {"\n","\r"}];
       ox[[i]] = wt[[i, 1]];	(* List of oxides in each file *)          
       For[j=2,j<=Dimensions[wt[[i]]][[1]],j++, 
          If[ToString[min] == "all", d = Append[d, wt[[i, j]]]];                 
          If[ToString[min] != "all", 
          If[ToString[wt[[i,j,2]]] == ToString[min], d = Append[d, wt[[i, j]]]]];
          ];
       dat[[i]] = d;
       ];
    oxall = Union[Flatten[ox]];
    s = {ox,dat};
    pos = Flatten[pos = Position[s, {}]];
    If[pos != {}, del = {{1,pos[[2]]},pos};
    s = Delete[s, del]];
    dat = Table[0,{i,1,Dimensions[oxall][[1]]}];
    For[i=1,i<=Dimensions[oxall][[1]], i++,(* durchlaeuft alle Oxide *)
       dd = {};
       For[j=1,j<=Dimensions[s][[2]],j++,(* durchlaeuft verschiedene Datensaetze *)
          d = Transpose[s[[2, j]]];	(* Daten *)
          pos = Flatten[Position[s[[1,j]],oxall[[i]]]];
          If[pos != {}, d = d[[pos[[1]]]]];
          If[pos == {}, d = Table[0, {k, 1, Dimensions[d][[2]]}]];
          dd = Append[dd, d];
          ];
       dat[[i]] = Flatten[dd];
       ];
    
    (* Ordnen in der Reihenfolge von o *)
    dn = oxn = Table[0,{i,1,Dimensions[oxall][[1]]}];
    For[i=1,i<=Dimensions[oxall][[1]],i++, 
       oxall[[i]] = ToString[oxall[[i]]]];
    For[i=1,i<=Dimensions[o][[1]],i++, 
       pos = Flatten[Position[oxall, o[[i]]]];
       If[pos != {}, count++; dn[[count]] = dat[[pos[[1]]]]; 
         oxn[[count]] = oxall[[pos[[1]]]];
         ];
       ];
    d = {};
    dn = Transpose[dn];
    For[i=1,i<=Dimensions[dn][[1]], i++, 
       If[text == "", d = Append[d, dn[[i]]]];	   
       If[text != "", 
         str = StringTake[dn[[i, 1]], lab]; (* read textural info *)
         If[str == text, d = Append[d, dn[[i]]]];
         ];
       ];
    d = Prepend[d,oxn];
    If[text == "", fnamel = StringJoin[sfile, "_",ToString[min]]];
    If[text != "", fnamel = StringJoin[sfile, "_",ToString[min], "_", text]];
    file = OpenWrite[fnamel];
    For[i=1,i<=Dimensions[d][[1]], i++, 
       For[j=1,j<=Dimensions[d[[i]]][[1]], j++, 
          str = ToString[NumberForm[d[[i, j]]]];
          WriteString[file, str, "\t"];
          ];
       WriteString[file, "\n"];
       ];
    Close[file]; 
    Print["Message from -ExtractMinDat-: The file \"", fnamel, "\" has been created."];
]
  

EExtractMinDat[min_,par_,fname_,UTILITY`ExtractMinDatTexture_,UTILITY`ExtractMinDatTextureRange_,UTILITY`ExtractMinDatFile_, 
   UTILITY`ExtractMinDatMode_] := 
   Block[{opt={UTILITY`ExtractParameter,UTILITY`SearchFiles},mininstalled,mode=UTILITY`ExtractMinDatMode,pv,parl=par,fn,i,j,fnamel,r,p,dat,str},
   mininstalled = {"grt","bt","wm","plag","kf","chl","stau","ctd","alsi","crd","ol","zoep","cc","dol","spin","saph","fetiox", 
   "sphen","min","talc","amph","cpx","opx","all"};	
    
   If[Intersection[{UTILITY`ExtractMinDatMode}, opt] == {}, 
     Print["wrong value \"",UTILITY`ExtractMinDatMode,"\" for option \"UTILITY`ExtractMinDatMode\""]; 
     Print["Allowed values are: ",opt]; Return[]];
    If[Position[mininstalled, ToString[min]] == {} && StringPosition[ToString[min],"min"] == {}, 
     Print["Error-message from -ExtractMinDat-:: wrong mineral abbreviation \"",ToString[min],"\" encountered !"]; 
     Print["Allowed abbreviation are: ",mininstalled]; Return[]];
   If[mode == UTILITY`SearchFiles,(* search file(s) for specific analyses *)
     pv = CombineFiles[min,fname,UTILITY`ExtractMinDatTexture,UTILITY`ExtractMinDatTextureRange,UTILITY`ExtractMinDatFile]; Return[pv]];
   
   If[mode == UTILITY`ExtractParameter,(* extract parameter(s) for the mineral min from the file(s) fname(s).fu  *)
     If[Dimensions[par] == {}, parl = {par}]; (* only one - parameter in parameter - list  *)
     pv = Table[{},{i,1,Dimensions[parl][[1]]}];
     If[Dimensions[fname] == {}, fn = {fname}, fn = fname];
     For[i=1,i<=Dimensions[parl][[1]],i++,  (* loop over number of parameters  *)
        If[ToString[Head[parl[[i]]]] != "String", Print["Error-message from -ExtractMinDat-: parameter ",parl[[i]]," is not a string."]; Return[]];
                    
        For[j=1,j<=Dimensions[fn][[1]],j++, (* loop over number of files  *)
           If[ToString[Head[fn[[j]]]] != "String", Print["Error-message from -ExtractMinDat-: File-name ",fn[[j]]," is not a string."]; Return[]];
           fnamel = StringJoin[fn[[j]],".fu"];
           r = Get[fnamel];	(* read data file *)         	
           If[r == $Failed, Print["Error-message from -ExtractMinDat-: file \"",fnamel,"\" does not exist."]; Return[]];
           p = Position[r,min];          	
           For[ii=1,ii<=Dimensions[p][[1]],ii++, (* loop over number of analyses for mineral min in a file  *)
              dat = r[[2,p[[ii,2]]]];
              If[UTILITY`ExtractMinDatTexture == "",  
                pv[[i]] = Append[pv[[i]],FindMineralParameter[parl[[i]],dat,r[[1]]]]];
              If[UTILITY`ExtractMinDatTexture != "",              		
                If[StringLength[dat[[2]]] >= StringLength[UTILITY`ExtractMinDatTexture],str = StringTake[dat[[2]],UTILITY`ExtractMinDatTextureRange];                	           
                If[str == UTILITY`ExtractMinDatTexture, 
                  pv[[i]] = Append[pv[[i]],FindMineralParameter[parl[[i]],dat,r[[1]]]]];
                  ]; 
              	];
              ]; (* end of For[ii = 1, ...]  *)
           ]; (* end of For[j = 1, ...]  *)
        ]; (* end of For[i = 1, ...]  *)
     Return[pv];
     ]; (* end of If[mode == UTILITY`ExtractParameter]  *)
]
Options[ExtractMinDat] = {UTILITY`ExtractMinDatTexture -> "", UTILITY`ExtractMinDatTextureRange -> {-3, -1}, UTILITY`ExtractMinDatFile -> "", UTILITY`ExtractMinDatMode -> UTILITY`ExtractParameter};
ExtractMinDat[min_, par_, fname_, opts___] := 
   Block[{opt = {UTILITY`ExtractMinDatTexture, UTILITY`ExtractMinDatTextureRange, UTILITY`ExtractMinDatFile, UTILITY`ExtractMinDatMode}, i, 
   n = Dimensions[{opts}][[1]]}, 
   For[i = 1, i <= n, i++, 
      If[Position[opt, {opts}[[i, 1]]] == {}, Print["Unknown option ", {opts}[[i, 1]], " in -ExtractMinDat-"];
        Print["Known options are: ", opt]; Return[]]];
   EExtractMinDat[min, par, fname, UTILITY`ExtractMinDatTexture /. {opts} /. Options[ExtractMinDat], 
   UTILITY`ExtractMinDatTextureRange /. {opts} /. Options[ExtractMinDat], 
   UTILITY`ExtractMinDatFile /. {opts} /. Options[ExtractMinDat], 
   UTILITY`ExtractMinDatMode /. {opts} /. Options[ExtractMinDat]]];


(*
DataSymbols[shape_,size_] := Block[{t,opt={UTILITY`SymbolShapeCircleOpen,UTILITY`SymbolShapeCircle,
	UTILITY`SymbolShapeDot,UTILITY`SymbolShapeTriangle,
   	UTILITY`SymbolShapeTriangleInverted,UTILITY`SymbolShapeSquareOpen,UTILITY`SymbolShapeSquare,UTILITY`SymbolShapeDiamond,
   	UTILITY`SymbolShapeHexagon,UTILITY`SymbolShapeOctagon,UTILITY`SymbolShapeCross}},
   
   	If[Intersection[{shape}, opt] == {}, 
     	Print["wrong value \"",shape,"\" in the call to -DataSymbols-"]; 
     	Print["Allowed values are: ",opt]; Return[]];

	If[shape == UTILITY`SymbolShapeCircleOpen, (* open circle *)
	  t = Circle[Scaled[{0, 0}, #1], size 2^0.5]&];
	If[shape == UTILITY`SymbolShapeCircle || shape == UTILITY`SymbolShapeDot, (* filled circle = dot *)
	  t = Disk[Scaled[{0, 0}, #1], size 2^0.5]&];
	If[shape == UTILITY`SymbolShapeTriangle, (* filled triangle *)
	  t = Polygon[{Scaled[{0, size}, #1], Scaled[{-N[Cos[30 Pi/180]]size, -N[Sin[30 Pi/180]]size}, #1],
          Scaled[{N[Cos[30 Pi/180]]size, -N[Sin[30 Pi/180]]size}, #1]}]&];
	If[shape == UTILITY`SymbolShapeTriangleInverted, (* filled triangle inverted *)
	  t = Polygon[{Scaled[{0, -size}, #1], Scaled[{-N[Cos[30 Pi/180]]size, N[Sin[30 Pi/180]]size}, #1],
     	  Scaled[{N[Cos[30 Pi/180]]size, N[Sin[30 Pi/180]]size}, #1]}]&];
	If[shape == UTILITY`SymbolShapeSquareOpen, (* open square *)
	  t = Line[{Scaled[{size, size}, #1], Scaled[{size, -size}, #1],
     	  Scaled[{-size, -size}, #1],Scaled[{-size, size}, #1],Scaled[{size, size}, #1]}]&];
	If[shape == UTILITY`SymbolShapeSquare, (* filled square *)
	  t = Polygon[{Scaled[{size, size}, #1], Scaled[{size, -size}, #1],
          Scaled[{-size, -size}, #1],Scaled[{-size, size}, #1]}]&];
	If[shape == UTILITY`SymbolShapeDiamond, (* filled diamond *)
	  t = Polygon[{Scaled[{0, size 2^0.5}, #1], Scaled[{size 2^0.5, 0}, #1],
          Scaled[{0, -size 2^0.5}, #1],Scaled[{-size 2^0.5, 0}, #1]}]&];
	If[shape == UTILITY`SymbolShapeHexagon, (* filled hexagon *)
	  t = Polygon[{Scaled[{-size,0}, #1], Scaled[{-size/2,size/2 3^0.5}, #1], Scaled[{size/2,size/2 3^0.5}, #1],
          Scaled[{size,0}, #1], Scaled[{size/2,-size/2 3^0.5}, #1],Scaled[{-size/2,-size/2 3^0.5}, #1]}]&];
	If[shape == UTILITY`SymbolShapeOctagon, (* filled octagon *)
	  t = Polygon[{Scaled[{N[Cos[22.5 Pi/180]]size, N[Sin[22.5 Pi/180]]size}, #1], 
	 	  Scaled[{N[Cos[22.5 Pi/180]]size, -N[Sin[22.5 Pi/180]]size}, #1],
	 	  Scaled[{N[Sin[22.5 Pi/180]]size, -N[Cos[22.5 Pi/180]]size}, #1],
	 	  Scaled[{-N[Sin[22.5 Pi/180]]size, -N[Cos[22.5 Pi/180]]size}, #1],
	 	  Scaled[{-N[Cos[22.5 Pi/180]]size, -N[Sin[22.5 Pi/180]]size}, #1],
	 	  Scaled[{-N[Cos[22.5 Pi/180]]size, N[Sin[22.5 Pi/180]]size}, #1],	 
	 	  Scaled[{-N[Sin[22.5 Pi/180]]size, N[Cos[22.5 Pi/180]]size}, #1],
	 	  Scaled[{N[Sin[22.5 Pi/180]]size, N[Cos[22.5 Pi/180]]size}, #1]}]&];
	If[shape == UTILITY`SymbolShapeCross, (* filled cross *)
	  t = Polygon[{Scaled[{size/5, size/5}, #1], Scaled[{size, size/5}, #1], Scaled[{size, -size/5}, #1],
	   	   Scaled[{size/5, -size/5}, #1], Scaled[{size/5, -size}, #1], Scaled[{-size/5, -size}, #1],
	 	   Scaled[{-size/5, -size/5}, #1], Scaled[{-size, -size/5}, #1], Scaled[{-size, size/5}, #1],
		   Scaled[{-size/5, size/5}, #1], Scaled[{-size/5, size}, #1],Scaled[{size/5, size}, #1]}]&];
Return[t];
]
*)

DataSymbols[shape_, size_] := 
 Block[{t, 
   opt = {UTILITY`SymbolShapeCircleOpen, UTILITY`SymbolShapeCircle, 
     UTILITY`SymbolShapeDot, UTILITY`SymbolShapeTriangle, 
     UTILITY`SymbolShapeTriangleInverted, 
     UTILITY`SymbolShapeSquareOpen, UTILITY`SymbolShapeSquare, 
     UTILITY`SymbolShapeDiamond, UTILITY`SymbolShapeHexagon, 
     UTILITY`SymbolShapeOctagon, UTILITY`SymbolShapeCross}}, 
  If[Intersection[{shape}, opt] == {}, 
   Print["wrong value \"", shape, "\" in the call to -DataSymbols-"];
   Print["Allowed values are: ", opt]; Return[]];
  If[shape == UTILITY`SymbolShapeCircleOpen,(*open circle; t=
   Circle[{0,0},1]*)t = Circle[{0, 0}, 1]];
  
  
  If[shape == UTILITY`SymbolShapeCircle || 
    shape == UTILITY`SymbolShapeDot,(*filled circle=dot*)
   t = Disk[{0, 0}, 1]];
  If[shape == UTILITY`SymbolShapeTriangle,(*filled triangle*)
   t = Polygon[{{0, 
       1}, {-Cos[30 Pi/180], -Sin[30 Pi/180]}, {Cos[
        30 Pi/180], -Sin[30 Pi/180]}}]];
  If[shape == 
    UTILITY`SymbolShapeTriangleInverted,(*filled triangle inverted*)
   t = Polygon[{{0, -1}, {-N[Cos[30 Pi/180]], 
       N[Sin[30 Pi/180]]}, {N[Cos[30 Pi/180]], N[Sin[30 Pi/180]]}}]];
  If[shape == UTILITY`SymbolShapeSquareOpen,(*open square*)
   t = Line[{{-0.5, -0.5}, {0.5, -0.5}, {0.5, 0.5}, {-0.5, 
       0.5}, {-0.5, -0.5}}]];
  If[shape == UTILITY`SymbolShapeSquare,(*filled square*)
   t = Polygon[{{-0.5, -0.5}, {0.5, -0.5}, {0.5, 0.5}, {-0.5, 
       0.5}, {-0.5, -0.5}}]];
  If[shape == UTILITY`SymbolShapeDiamond,(*filled diamond*)
   t = Polygon[{{0, 2^0.5}, {2^0.5, 0}, {0, -2^0.5}, {-2^0.5, 0}}]];
  If[shape == UTILITY`SymbolShapeHexagon,(*filled hexagon*)
   t = Polygon[{{-1, 0}, {-1/2, 1/2 3^0.5}, {1/2, 1/2 3^0.5}, {1, 
       0}, {1/2, -1/2 3^0.5}, {-1/2, -1/2 3^0.5}}]];
  If[shape == UTILITY`SymbolShapeOctagon,(*filled octagon*)
   t = Polygon[{{Cos[22.5 Pi/180], 
       Sin[22.5 Pi/180]}, {Cos[22.5 Pi/180], -Sin[22.5 Pi/180]}, {Sin[
        22.5 Pi/180], -Cos[22.5 Pi/180]}, {-Sin[22.5 Pi/180], -Cos[
         22.5 Pi/180]}, {-Cos[22.5 Pi/180], -Sin[22.5 Pi/180]}, {-Cos[
         22.5 Pi/180], Sin[22.5 Pi/180]}, {-Sin[22.5 Pi/180], 
       Cos[22.5 Pi/180]}, {Sin[22.5 Pi/180], Cos[22.5 Pi/180]}}]];
  If[shape == UTILITY`SymbolShapeCross,(*filled cross*)
   t = Polygon[{{1/5, 1/5}, {1, 
       1/5}, {1, -1/5}, {1/5, -1/5}, {1/5, -1}, {-1/5, -1}, {-1/5, -1/
        5}, {-1, -1/5}, {-1, 1/5}, {-1/5, 1/5}, {-1/5, 1}, {1/5, 1}}]];
  Return[Graphics[t]];
  ]
  
  
TrianglePlotNormalize[d_] := Block[{datl=d,h=100,origin=0,laenge=2h/(3^0.5),fak=laenge/h,b,c,y,x,i},
	For[i=1,i<=Dimensions[datl][[1]],i++, (* normalise data  *)
	   datl[[i,1]] = 100 d[[i,1]]/(d[[i,1]]+d[[i,2]]+d[[i,3]])	;
	   datl[[i,2]] = 100 d[[i,2]]/(d[[i,1]]+d[[i,2]]+d[[i,3]])	;
	   datl[[i,3]] = 100 d[[i,3]]/(d[[i,1]]+d[[i,2]]+d[[i,3]])	];
	b = Transpose[datl][[2]]; c = Transpose[datl][[3]];
	y = origin+c; x = (b fak+(y-origin)/(3^0.5));
	Return[Transpose[{x,y}]];
]

TTrianglePlotGrid[type_,data_] := Block[{typel=type,l,d,i},
	If[typel == UTILITY`TrianglePlotGridPx,
	  l = {{{90,0,10},{0,90,10}},{{80,0,20},{0,80,20}},{{20,0,80},{0,20,80}},
	       {{50,50,0},{10,10,80}},{{90,10,0},{18,2,80}},{{10,90,0},{2,18,80}}};
	  ];
	If[typel == UTILITY`TrianglePlotGridOwn, l = data];
	d = l;
	For[i=1,i<=Dimensions[l][[1]],i++,
		d[[i]] = TrianglePlotNormalize[l[[i]]];
	   ];
	Return[Table[Line[d[[i]]],{i,1,Dimensions[d][[1]]}]];	
]

TTrianglePlotGrid[type_, data_, dicke_] := Block[{typel = type, l, d, i},
    If[typel == UTILITY`TrianglePlotGridPx, 
      l = {{{90, 0, 10}, {0, 90, 10}}, {{80, 0, 20}, {0, 80, 20}}, {{20, 0, 80}, {0, 20, 80}}, 
            {{50, 50, 0}, {10, 10, 80}}, {{90, 10, 0}, {18, 2, 80}}, {{10, 90, 0}, {2, 18, 80}}};
      ];
    If[typel == UTILITY`TrianglePlotGridMesh, 
      l = {{{90, 0, 10}, {0, 90, 10}}, {{80, 0, 20}, {0, 80, 20}}, {{70, 0, 30}, {0, 70, 30}},            
           {{60, 0, 40}, {0, 60, 40}}, {{50, 0, 50}, {0, 50, 50}}, {{40, 0, 60}, {0, 40, 60}}, 
           {{30, 0, 70}, {0, 30, 70}}, {{20, 0, 80}, {0, 20, 80}}, {{10, 0, 90}, {0, 10, 90}}, 
           {{90, 10, 0}, {0, 10, 90}}, {{80, 20, 0}, {0, 20, 80}}, {{70, 30, 0}, {0, 30, 70}}, 
           {{60, 40, 0}, {0, 40, 60}}, {{50, 50, 0}, {0, 50, 50}}, {{40, 60, 0}, {0, 60, 40}},
           {{30, 70, 0}, {0, 70, 30}}, {{20, 80, 0}, {0, 80, 20}}, {{10, 90, 0}, {0, 90, 10}},
           {{10, 90, 0}, {10, 0, 90}}, {{20, 80, 0}, {20, 0, 80}}, {{30, 70, 0}, {30, 0, 70}}, 
           {{40, 60, 0}, {40, 0, 60}}, {{50, 50, 0}, {50, 0, 50}}, {{60, 40, 0}, {60, 0, 40}}, 
           {{70, 30, 0}, {70, 0, 30}}, {{80, 20, 0}, {80, 0, 20}}, {{90, 10, 0}, {90, 0, 10}}};
      ];
    If[typel == UTILITY`TrianglePlotGridOwn, l = data];
    d = l;
    For[i = 1, i <= Dimensions[l][[1]], i++, d[[i]] = TrianglePlotNormalize[l[[i]]];];
    Return[Table[{Thickness[dicke], Line[d[[i]]]}, {i, 1, Dimensions[d][[1]]}]];]
  

TTrianglePlot[dat_, UTILITY`TrianglePlotSymbolShape_, UTILITY`TrianglePlotSymbolSize_, 
    UTILITY`TrianglePlotFrameThickness_,UTILITY`TrianglePlotTickThickness_,
    UTILITY`TrianglePlotAxesLabel_, UTILITY`TrianglePlotText_, UTILITY`TrianglePlotTicks_,
    UTILITY`TrianglePlotGrid_, UTILITY`TrianglePlotGridData_, UTILITY`TrianglePlotGridThickness_] := 
  Block[{flag = UTILITY`TrianglePlotTicks, i, datl = dat, sum, b, c, x, y, xy, 
      h = 100, origin = 0, laenge = 2h/(3^0.5), fak = laenge/h, l = 2, ecken, 
      tr, t1, t2, t3, ticks, yticks, xticks, ticks1, yticks1, xticks1, text, 
      text1, graphics, dicke = UTILITY`TrianglePlotFrameThickness, 
      tdicke = UTILITY`TrianglePlotTickThickness,
      p, at1, bt1, ct1, xyticks, xyticks1, tickl, symbol, points, grid, 
      gridflag = UTILITY`TrianglePlotGrid, 
      shape = UTILITY`TrianglePlotSymbolShape, 
      size = UTILITY`TrianglePlotSymbolSize, 
      griddata = UTILITY`TrianglePlotGridData, 
      axlabel = UTILITY`TrianglePlotAxesLabel, 
      opt1 = {UTILITY`SymbolShapeDot, UTILITY`SymbolShapeSquare, 
          UTILITY`SymbolShapeCircle, UTILITY`SymbolShapeTriangle, 
          UTILITY`SymbolShapeTriangleInverted, UTILITY`SymbolShapeDiamond, 
          UTILITY`SymbolShapeHexagon, UTILITY`SymbolShapeOctagon, 
          UTILITY`SymbolShapeCross, UTILITY`SymbolShapeSquareOpen, 
          UTILITY`SymbolShapeCircleOpen}, 
      opt2 = {UTILITY`TrianglePlotGridNone, UTILITY`TrianglePlotGridPx, 
          UTILITY`TrianglePlotGridOwn, UTILITY`TrianglePlotGridMesh}, 
      opt3 = {UTILITY`TrianglePlotTicksNone, UTILITY`TrianglePlotTicksYes}},
    
    If[Intersection[{shape}, opt1] == {}, Print["wrong value \"", shape, "\" for option \"TrianglePlotSymbolShape\""]; 
      Print["Allowed values are: ", opt1]; Return[]];
    If[Intersection[{gridflag}, opt2] == {}, Print["wrong value \"", gridflag, "\" for option \"TrianglePlotGrid\""]; 
      Print["Allowed values are: ", opt2]; Return[]];
    If[Intersection[{flag}, opt3] == {}, 
      Print["wrong value \"", flag, "\" for option \"TrianglePlotTicks\""]; 
      Print["Allowed values are: ", opt3]; Return[]];
    
    text = Graphics[{Text[axlabel[[1]], Scaled[{0, -0.03}], {0, 0}, {1, 0}], 
          	     Text[axlabel[[2]], Scaled[{1, -0.03}], {0, 0}, {1, 0}], 
		     Text[axlabel[[3]], Scaled[{0.5, 1.02}], {0, 0}, {1, 0}]}];
    text1 = Graphics[UTILITY`TrianglePlotText];
    ecken = Line[{{0, origin}, {laenge, origin}, {laenge/2, h + origin}, {0, origin}}];
    graphics = {{Thickness[dicke], ecken}};
    tr = Graphics[graphics, AspectRatio -> 0.89];
    
    If[flag == TrianglePlotTicksYes,(* draw ticks *)
      t1 = Transpose[{Table[100 - 10i, {i, 1, 9}], Table[0, {i, 1, 9}], Table[10 i, {i, 1, 9}]}];
      t2 = Transpose[{Table[0, {i, 1, 9}], Table[100 - 10i, {i, 1, 9}], Table[10 i, {i, 1, 9}]}];
      t3 = Transpose[{Table[100 - 10i, {i, 1, 9}], Table[10 i, {i, 1, 9}], Table[0, {i, 1, 9}]}];
      ticks = Join[t1, t2, t3];
      yticks = origin + Transpose[ticks][[3]];
      xticks = (Transpose[ticks][[2]] fak + (yticks - origin)/(3^0.5));
      xyticks = Transpose[{xticks, yticks}];
      yticks1 = Join[Take[yticks, {1, 18}] + 0.5 l, Take[yticks, {19, 27}] - l];
      xticks1 = Join[Take[xticks, {1, 9}] - N[Cos[30 Pi/180]]l, Take[xticks, {10, 18}] + N[Cos[30 Pi/180]]l, 
          	     Take[xticks, {19, 27}]];
      xyticks1 = Transpose[{xticks1, yticks1}];
      tickl = Table[{Thickness[tdicke], Line[{xyticks[[i]], xyticks1[[i]]}]}, {i, 1,Dimensions[xyticks][[1]]}];
      graphics = Append[graphics, tickl];
      tr = Graphics[graphics, AspectRatio -> 0.89]];
    
    If[gridflag == UTILITY`TrianglePlotGridPx || gridflag == UTILITY`TrianglePlotGridOwn || gridflag == UTILITY`TrianglePlotGridMesh,
      grid = TTrianglePlotGrid[gridflag, griddata, UTILITY`TrianglePlotGridThickness];
      graphics = Append[graphics, grid];
      tr = Graphics[graphics, AspectRatio -> 0.89]];
    
    xy = TrianglePlotNormalize[dat];
    If[ToString[shape] == "SymbolShapeDot", 
      points = Graphics[{Table[{PointSize[1.5size 2^0.5], Point[xy[[i]]]}, {i,1, Dimensions[xy][[1]]}]}]];
    If[ToString[shape] != "SymbolShapeDot", 
      symbol = DataSymbols[shape, 0.01];
      points = ListPlot[xy, AxesLabel -> axlabel, PlotMarkers -> {{symbol, size}}]];

Show[points,DisplayFunction->$DisplayFunction];
    Return[Show[tr, points, text, text1, PlotRange -> All]];]
Options[TrianglePlot] = {
      UTILITY`TrianglePlotSymbolShape -> UTILITY`SymbolShapeDot, 
      UTILITY`TrianglePlotSymbolSize -> 0.008, 
      UTILITY`TrianglePlotFrameThickness -> 0.006, 
      UTILITY`TrianglePlotTickThickness -> 0.006, 
      UTILITY`TrianglePlotAxesLabel -> {"", "", ""}, 
      UTILITY`TrianglePlotText -> {}, 
      UTILITY`TrianglePlotTicks -> UTILITY`TrianglePlotTicksNone, 
      UTILITY`TrianglePlotGrid -> UTILITY`TrianglePlotGridNone, 
      UTILITY`TrianglePlotGridData -> {}, 
      UTILITY`TrianglePlotGridThickness -> 0.004};
TrianglePlot[dat_, opts___] := 
    Block[{opt = {UTILITY`TrianglePlotSymbolShape, 
            UTILITY`TrianglePlotSymbolSize, UTILITY`TrianglePlotFrameThickness,
            UTILITY`TrianglePlotTickThickness,
            UTILITY`TrianglePlotAxesLabel, UTILITY`TrianglePlotText, 
            UTILITY`TrianglePlotTicks, UTILITY`TrianglePlotGrid, 
            UTILITY`TrianglePlotGridData, UTILITY`TrianglePlotGridThickness}, i,
         n = Dimensions[{opts}][[1]]}, 
      For[i = 1, i <= n, i++, 
        If[Position[opt, {opts}[[i, 1]]] == {}, 
          Print["Unknown option ", {opts}[[i, 1]], " in -TrianglePlot-"];
          Print["Known options are: ", opt]; Return[]]];
      TTrianglePlot[dat, 
        UTILITY`TrianglePlotSymbolShape /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotSymbolSize /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotFrameThickness /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotTickThickness /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotAxesLabel /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotText /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotTicks /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotGrid /. {opts} /. Options[TrianglePlot], 
        UTILITY`TrianglePlotGridData /. {opts} /. Options[TrianglePlot],
        UTILITY`TrianglePlotGridThickness /. {opts} /. Options[TrianglePlot]
]];



XXYPlot[file_, UTILITY`XYPlotType_, UTILITY`XYPlotSymbolShape_, UTILITY`XYPlotSymbolSize_, UTILITY`XYPlotTexture_, 
    UTILITY`XYPlotTextureRange_, UTILITY`XYPlotGridThickness_, UTILITY`XYPlotTickThickness_, UTILITY`XYPlotFrameThickness_,
    UTILITY`XYPlotGrid_, UTILITY`XYPlotLabelPosition_,UTILITY`XYPlotTypeGrtProfileFactor_] :=
    Block[{type = UTILITY`XYPlotType, shape = UTILITY`XYPlotSymbolShape, size = UTILITY`XYPlotSymbolSize, 
          tx1 = grid = gridpoints = labels = Graphics[{}], xticks = {}, yticks = {}, plot, range, 
          tx = UTILITY`XYPlotTexture, lab = UTILITY`XYPlotTextureRange, thick1 = UTILITY`XYPlotGridThickness, 
      	  thick2 = UTILITY`XYPlotTickThickness, thick3 = UTILITY`XYPlotFrameThickness, 
      	  pos = UTILITY`XYPlotLabelPosition, fak=UTILITY`XYPlotTypeGrtProfileFactor,
      	  opt = {
      	  	UTILITY`XYPlotTypeAmph1, 
          	UTILITY`XYPlotTypeAmph2, 
          	UTILITY`XYPlotTypeAmph3, 
          	UTILITY`XYPlotTypeAmph4, 
          	UTILITY`XYPlotTypeAmph5, 
          	UTILITY`XYPlotTypeAmph6, 
          	UTILITY`XYPlotTypeAmphSodic1, 
          	UTILITY`XYPlotTypeAmphSodic2, 
          	UTILITY`XYPlotTypeAmphSodicCalcic1, 
          	UTILITY`XYPlotTypeAmphSodicCalcic2, 
          	UTILITY`XYPlotTypeAmphSodicCalcic3, 
          	UTILITY`XYPlotTypeAmphCalcic1, 
          	UTILITY`XYPlotTypeAmphCalcic2, 
          	UTILITY`XYPlotTypeAmphCalcic3, 
          	UTILITY`XYPlotTypeAmphMgFeMnLi1, 
          	UTILITY`XYPlotTypeWm1, 
          	UTILITY`XYPlotTypeWm2,
          	UTILITY`XYPlotTypeWm3, 
          	UTILITY`XYPlotTypeBt1, 
          	UTILITY`XYPlotTypeBt2, 
          	UTILITY`XYPlotTypeBt3, 
          	UTILITY`XYPlotTypeZoEp1,
          	UTILITY`XYPlotTypeChl1, 
          	UTILITY`XYPlotTypeGrtProfileXFe, 
          	UTILITY`XYPlotTypeGrtProfileXMg, 
          	UTILITY`XYPlotTypeGrtProfileXCa,
          	UTILITY`XYPlotTypeGrtProfileXMn
          	},
        defaultfont = {"Times-Roman", 14},
      	opt1 = {UTILITY`XYPlotGridNo, UTILITY`XYPlotGridYes},
      	ar = 1, group, fe3, alvi, xmg, x = {}, y = {}, xy = {}, x1, i, si, ti, 
      	caa, nab, fe, mg, st1, st2, st3, st4, st5},
        
    If[Intersection[{type}, opt] == {}, 
      Print["wrong value \"", type, "\" for option \"XYPlotType\""]; 
      Print["Allowed values are: ", opt]; Return[]];
    If[Intersection[{UTILITY`XYPlotGrid}, opt1] == {}, 
      Print["wrong value \"", type, "\" for option \"XYPlotLabel\""]; 
      Print["Allowed values are: ", opt]; Return[]];
    
 
    If[type == UTILITY`XYPlotTypeAmph1,(* XY plot for amphiboles : Si versus Mg/(Mg + Fe2), no names *)
      {si, xmg} = ExtractMinDat[ToExpression["amph"], {"SiO2", "Mg/(Fe2+Mg)"},
                                file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          			ExtractMinDatMode -> ExtractParameter];
      {x, y} = {-si, xmg};
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], 
                	Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
        ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmph2,(* XY plot for amphiboles : Si versus Na(B) *)
      {si, nab} = ExtractMinDat[ToExpression["amph"], {"SiO2", "NaB"}, 
      		  		file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          	  		ExtractMinDatMode -> ExtractParameter];
      {x, y} = {-si, nab};
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0.0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}},{0.2, "", {0.015, 0}, {Thickness[thick2]}},{0.3, "", {0.015, 0}, {Thickness[thick2]}},{0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
      		{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}},{0.7, "", {0.015, 0}, {Thickness[thick2]}},{0.8, "", {0.015, 0}, {Thickness[thick2]}},{0.9, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}},{1.2, "", {0.015, 0}, {Thickness[thick2]}},{1.3, "", {0.015, 0}, {Thickness[thick2]}},{1.4, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}},{1.7, "", {0.015, 0}, {Thickness[thick2]}},{1.8, "", {0.015, 0}, {Thickness[thick2]}},{1.9, "", {0.015, 0}, {Thickness[thick2]}},  
          {2.0, "2.0", {0.02, 0}, {Thickness[thick2]}}};	        
      tx1 = {"Si", "\!\(\*SubscriptBox[\"Na\", \"B\"]\)"};

      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 2.1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 2.1}}]}, 
        		 {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}, {Thickness[thick1], Line[{{-8, 1.5}, {0, 1.5}}]}}];
        ];
      range = {{-8, -5.5}, {0, 2.1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmph3,(* XY plot for amphiboles : Ca versus Na *)
      {x, y} = ExtractMinDat[ToExpression["amph"], {"CaO", "Na2O"}, file, 
      			     ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          		     ExtractMinDatMode -> ExtractParameter];
      xticks = yticks = {{0.0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}},{0.2, "", {0.015, 0}, {Thickness[thick2]}},{0.3, "", {0.015, 0}, {Thickness[thick2]}},{0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
      		{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}},{0.7, "", {0.015, 0}, {Thickness[thick2]}},{0.8, "", {0.015, 0}, {Thickness[thick2]}},{0.9, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}},{1.2, "", {0.015, 0}, {Thickness[thick2]}},{1.3, "", {0.015, 0}, {Thickness[thick2]}},{1.4, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}},{1.7, "", {0.015, 0}, {Thickness[thick2]}},{1.8, "", {0.015, 0}, {Thickness[thick2]}},{1.9, "", {0.015, 0}, {Thickness[thick2]}},  
          {2.0, "2.0", {0.02, 0}, {Thickness[thick2]}}};	        
      tx1 = {"Ca", "Na"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{2, 0}, {0, 2}}]}, {Thickness[thick1], Line[{{2, 1}, {1, 2}}]}, 
        		 {Thickness[thick1], Line[{{0, 0.5}, {2, 0.5}}]}, {Thickness[thick1], Line[{{0, 1}, {2, 1}}]},
        		 {Thickness[thick1], Line[{{0, 1.5}, {2, 1.5}}]}, {Thickness[thick1], Line[{{0.5, 0}, {0.5, 2}}]},
        		 {Thickness[thick1], Line[{{1, 0}, {1, 2}}]}, {Thickness[thick1], Line[{{1.5, 0}, {1.5, 2}}]}}];
          ];
      range = {{0, 2}, {0, 2}}; ar = 1;
      ];
    
    If[type == UTILITY`XYPlotTypeAmph4,(* XY plot for amphiboles : Ca(B) versus Na(B) *)
      {x, y} = ExtractMinDat[ToExpression["amph"], {"CaB+NaB", "NaB"}, file, 
          		     ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          		     ExtractMinDatMode -> ExtractParameter];
      x = x - y;
      xticks = yticks = {{0.0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}},{0.2, "", {0.015, 0}, {Thickness[thick2]}},{0.3, "", {0.015, 0}, {Thickness[thick2]}},{0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
      		{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}},{0.7, "", {0.015, 0}, {Thickness[thick2]}},{0.8, "", {0.015, 0}, {Thickness[thick2]}},{0.9, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}},{1.2, "", {0.015, 0}, {Thickness[thick2]}},{1.3, "", {0.015, 0}, {Thickness[thick2]}},{1.4, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}},{1.7, "", {0.015, 0}, {Thickness[thick2]}},{1.8, "", {0.015, 0}, {Thickness[thick2]}},{1.9, "", {0.015, 0}, {Thickness[thick2]}},  
          {2.0, "2.0", {0.02, 0}, {Thickness[thick2]}}};	        
      tx1 = {"\!\(\*SubscriptBox[\"Ca\", \"B\"]\)", "\!\(\*SubscriptBox[\"Na\", \"B\"]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{2, 0}, {0, 2}}]}}];
        ];
      range = {{0, 2}, {0, 2}}; ar = 1;
      ];
    
    If[type == UTILITY`XYPlotTypeAmph5,(* XY plot for amphiboles : AlIV versus AlVI *)
      {x, y} = ExtractMinDat[ToExpression["amph"], {"Al(IV)", "Al(VI)"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
        xticks = yticks = {{0.0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}},{0.2, "", {0.015, 0}, {Thickness[thick2]}},{0.3, "", {0.015, 0}, {Thickness[thick2]}},{0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
      		{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}},{0.7, "", {0.015, 0}, {Thickness[thick2]}},{0.8, "", {0.015, 0}, {Thickness[thick2]}},{0.9, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}},{1.2, "", {0.015, 0}, {Thickness[thick2]}},{1.3, "", {0.015, 0}, {Thickness[thick2]}},{1.4, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}},{1.7, "", {0.015, 0}, {Thickness[thick2]}},{1.8, "", {0.015, 0}, {Thickness[thick2]}},{1.9, "", {0.015, 0}, {Thickness[thick2]}},  
          {2.0, "2.0", {0.02, 0}, {Thickness[thick2]}}};	        
      tx1 = {"\!\(\*SuperscriptBox[\"Al\", \"IV\"]\)", "\!\(\*SuperscriptBox[\"Al\", \"VI\"]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{0, 0}, {2, 2}}]}}];
        ];
      range = {{0, 2}, {0, 2}}; ar = 1;
      ];
    
    If[type == UTILITY`XYPlotTypeAmph6,(* XY plot for amphiboles : AlIV versus AlVI + Fe3 *)
      {x, y, fe3} = ExtractMinDat[ToExpression["amph"], {"Al(IV)", "Al(VI)", "Fe3"}, 
      				  file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          			  ExtractMinDatMode -> ExtractParameter];
      y = y + fe3;
         xticks = yticks = {{0.0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}},{0.2, "", {0.015, 0}, {Thickness[thick2]}},{0.3, "", {0.015, 0}, {Thickness[thick2]}},{0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
      		{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}},{0.7, "", {0.015, 0}, {Thickness[thick2]}},{0.8, "", {0.015, 0}, {Thickness[thick2]}},{0.9, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}},{1.2, "", {0.015, 0}, {Thickness[thick2]}},{1.3, "", {0.015, 0}, {Thickness[thick2]}},{1.4, "", {0.015, 0}, {Thickness[thick2]}},  
      		{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}},{1.7, "", {0.015, 0}, {Thickness[thick2]}},{1.8, "", {0.015, 0}, {Thickness[thick2]}},{1.9, "", {0.015, 0}, {Thickness[thick2]}},  
          {2.0, "2.0", {0.02, 0}, {Thickness[thick2]}}};	        
       tx1 = {"\!\(\*SuperscriptBox[\"Al\", \"IV\"]\)", "\!\(\*SuperscriptBox[\"Al\", \"VI\"]\)+ \!\(\*SuperscriptBox[\"Fe\", 
						 RowBox[{\"3\", \"+\"}]]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{0, 0}, {2, 2}}]}}];
        ];
      range = {{0, 2}, {0, 2}}; ar = 1;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphSodic1, (* XY plot for sodic amphiboles : Si versus Mg/(Mg + Fe2), no names *)
      {group, si, xmg, x1} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "NaA+KA"}, file, 
          		     ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          		     ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
         If[group[[i]] == "sodic-group" , x = Append[x, -si[[i]]];
           y = Append[y, xmg[[i]]] ]];
     xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, 
        		 {Thickness[thick1], Line[{{-7.0, 0}, {-7.0, 1}}]}, 
        		 {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
        ];
      range = {{-8, -6.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphSodic2,(* XY plot for sodic amphiboles : Fe3/(Fe3 + AlVI) versus Mg/(Mg + Fe2) for (Na + K)A < 0.5 *)
      {group, fe3, alvi, xmg, x1} = ExtractMinDat[ToExpression["amph"], {"group", "Fe3", "Al(VI)", 
      				    		 "Mg/(Fe2+Mg)", "NaA+KA"}, 
          					 file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          					 ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
         If[group[[i]] == "sodic-group" && x1[[i]] < 0.5, 
           x = Append[x, fe3[[i]]/(fe3[[i]] + alvi[[i]])];
           y = Append[y, xmg[[i]]] ]];
      grid = Graphics[{{Thickness[thick1], Line[{{0.5, 0}, {0.5, 1}}]}, {Thickness[thick1], Line[{{0, 0.5}, {1, 0.5}}]}}];
     xticks = yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
     tx1 = {"\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"3\", \"+\"}]]\)/(\!\(\*SuperscriptBox[\"Fe\",RowBox[{\"3\", \"+\"}]]\)+\!\(\*SuperscriptBox[\"Al\", \"VI\"]\))", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
     range = {{0, 1}, {0, 1}}; size = size*4/3;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphSodicCalcic1, (* XY plot for sodic - calcic amphiboles : Si versus Mg/(Mg + Fe2) *)
      {group, si, xmg} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)"}, file, 
          			      ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          			      ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
         If[group[[i]] == "sodic-calcic-group" , x = Append[x, -si[[i]]];
           y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphSodicCalcic2, (* XY plot for sodic - calcic amphiboles with (Na + K)A >= 0.5 : Si versus Mg/(Mg + Fe2) *)
      {group, si, xmg, x1} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "NaA+KA"}, file, 
          				  ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          				  ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
        If[group[[i]] == "sodic-calcic-group"  && x1[[i]] >= 0.5, 
          x = Append[x, -si[[i]]];
          y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphSodicCalcic3, (* XY plot for sodic - calcic amphiboles with (Na + K)A < 0.5 : Si versus Mg/(Mg + Fe2) *)
      {group, si, xmg, x1} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "NaA+KA"}, file, 
          				  ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          				  ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,            
        If[group[[i]] == "sodic-calcic-group"  && x1[[i]] < 0.5, 
          x = Append[x, -si[[i]]];
          y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphCalcic1,(* XY plot for calcic amphiboles : Si versus Mg/(Mg + Fe2), no names *)
      {group, si, xmg} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)"}, file, 
          			      ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          			      ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
         If[group[[i]] == "calcic-group", x = Append[x, -si[[i]]];
           y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphCalcic2,
      (* XY plot for calcic amphiboles with (Na + K)A >= 0.5 and Ti < 0.5 : Si versus Mg/(Mg + Fe2) *)
      {group, si, xmg, x1, ti} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "NaA+KA", "TiO2"}, 
          				      file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          				      ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,            
        If[group[[i]] == "calcic-group" && x1[[i]] >= 0.5 && ti[[i]] < 0.5, 
          x = Append[x, -si[[i]]];
          y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}},{-5.4,"",{0.015, 0}, {Thickness[thick2]}},{-5.3,"",{0.015, 0}, {Thickness[thick2]}},{-5.2,"",{0.015, 0}, {Thickness[thick2]}},{-5.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.0, "5.0", {0.02, 0}, {Thickness[thick2]}},{-4.9,"",{0.015, 0}, {Thickness[thick2]}},{-4.8,"",{0.015, 0}, {Thickness[thick2]}},{-4.7,"",{0.015, 0}, {Thickness[thick2]}},{-4.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-4.5, "4.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-5.5, 0}, {-5.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -4.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphCalcic3,(* XY plot for calcic amphiboles with (Na + K)A < 0.5 and Ti < 0.5 : Si versus Mg/(Mg + Fe2) *)
      {group, si, xmg, x1, caa} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "NaA+KA", "CaO"}, 
          					file, ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          					ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,           
        If[group[[i]] == "calcic-group" && x1[[i]] < 0.5 && 
          caa[[i]] - 2 < 0.5, x = Append[x, -si[[i]]];
          y = Append[y, xmg[[i]]] ]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.5, 0}, {-7.5, 1}}]}, {Thickness[thick1], Line[{{-6.5, 0}, {-6.5, 1}}]}, {Thickness[thick1], Line[{{-8, 0.9}, {-7.5, 0.9}}]},{Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
         ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeAmphMgFeMnLi1,(* XY plot for Mg - Fe - Mn - Li amphiboles : Si versus Mg/(Mg + Fe2), no names *)
      {group, si, xmg, name} = ExtractMinDat[ToExpression["amph"], {"group", "SiO2", "Mg/(Fe2+Mg)", "name"}, file, 
          				    ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          				    ExtractMinDatMode -> ExtractParameter];
      For[i = 1, i <= Dimensions[group][[1]], i++,
         If[group[[i]] == "Mg-Fe-Mn-Li-group", x = Append[x, -si[[i]]];
           y = Append[y, xmg[[i]]]]];
      xticks = {{-8.0, "8.0", {0.02, 0}, {Thickness[thick2]}}, {-7.9,"",{0.015, 0}, {Thickness[thick2]}}, {-7.8,"",{0.015, 0}, {Thickness[thick2]}},{-7.7,"",{0.015, 0}, {Thickness[thick2]}},{-7.6,"",{0.015, 0}, {Thickness[thick2]}},
      		{-7.5, "7.5", {0.02, 0}, {Thickness[thick2]}},{-7.4,"",{0.015, 0}, {Thickness[thick2]}},{-7.3,"",{0.015, 0}, {Thickness[thick2]}},{-7.2,"",{0.015, 0}, {Thickness[thick2]}},{-7.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-7.0, "7.0", {0.02, 0}, {Thickness[thick2]}},{-6.9,"",{0.015, 0}, {Thickness[thick2]}},{-6.8,"",{0.015, 0}, {Thickness[thick2]}},{-6.7,"",{0.015, 0}, {Thickness[thick2]}},{-6.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.5, "6.5", {0.02, 0}, {Thickness[thick2]}},{-6.4,"",{0.015, 0}, {Thickness[thick2]}},{-6.3,"",{0.015, 0}, {Thickness[thick2]}},{-6.2,"",{0.015, 0}, {Thickness[thick2]}},{-6.1,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-6.0, "6.0", {0.02, 0}, {Thickness[thick2]}},{-5.9,"",{0.015, 0}, {Thickness[thick2]}},{-5.8,"",{0.015, 0}, {Thickness[thick2]}},{-5.7,"",{0.015, 0}, {Thickness[thick2]}},{-5.6,"",{0.015, 0}, {Thickness[thick2]}}, 
      		{-5.5, "5.5", {0.02, 0}, {Thickness[thick2]}}};  	  
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si", "Mg/(Mg+\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"2\", \"+\"}]]\))"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{-7.0, 0}, {-7.0, 1}}]},{Thickness[thick1], Line[{{-8, 0.5}, {0, 0.5}}]}}];
        ];
      range = {{-8, -5.5}, {0, 1}}; ar = 1/GoldenRatio;
    ];
    
    If[type == UTILITY`XYPlotTypeWm1,(* XY plot for white mica : Al(IV) versus Al(VI) - 1  *)
      {x, y} = ExtractMinDat[ToExpression["wm"], {"Al(IV)", "Al(VI)"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
      y = y - 1;
     xticks = yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"\!\(\*SuperscriptBox[\"Al\", \"IV\"]\)","\!\(\*SuperscriptBox[\"Al\", \"VI\"]\)- 1"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{0, 0}, {1, 1}}]}}]; 
        ];
      range = {{0, 1}, {0, 1}};
      ];
    
    If[type == UTILITY`XYPlotTypeWm2,(* XY plot for white mica : Si - 3 versus (Fe + Mg)VI  *)
      {si, fe, mg} = ExtractMinDat[ToExpression["wm"], {"SiO2", "FeO", "MgO"}, file, ExtractMinDatTexture -> tx, 
          			  ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
      x = si - 3; y = fe + mg;
     xticks = yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si - 3","Fe + Mg"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{0, 0}, {1, 1}}]}}]; 
        ];
      range = {{0, 1}, {0, 1}};
      ];
    
    If[type == UTILITY`XYPlotTypeWm3,(* XY plot for white mica : Si versus Al(tot)  *)
      {x, y} = ExtractMinDat[ToExpression["wm"], {"SiO2", "Al2O3"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
  
     xticks = {{3.0, "3.0", {0.02, 0}, {Thickness[thick2]}},{3.1, "", {0.015, 0}, {Thickness[thick2]}}, {3.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{3.3, "", {0.015, 0}, {Thickness[thick2]}}, {3.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{3.5, "3.5", {0.02, 0}, {Thickness[thick2]}},{3.6, "", {0.015, 0}, {Thickness[thick2]}}, {3.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{3.8, "", {0.015, 0}, {Thickness[thick2]}}, {3.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{4, "4.0", {0.02, 0}, {Thickness[thick2]}}};
      yticks = {{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}}, {1.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{1.3, "", {0.015, 0}, {Thickness[thick2]}}, {1.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}}, {1.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{1.8, "", {0.015, 0}, {Thickness[thick2]}}, {1.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{2, "2.0", {0.02, 0}, {Thickness[thick2]}},{2.1, "", {0.015, 0}, {Thickness[thick2]}}, {2.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.3, "", {0.015, 0}, {Thickness[thick2]}}, {2.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{2.5, "2.5", {0.02, 0}, {Thickness[thick2]}},{2.6, "", {0.015, 0}, {Thickness[thick2]}}, {2.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.8, "", {0.015, 0}, {Thickness[thick2]}}, {2.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{3, "3.0", {0.02, 0}, {Thickness[thick2]}}};

      tx1 = {"Si","\!\(\*SubscriptBox[\"Al\", \"tot\"]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{3, 3}, {4, 1}}]}}]];
      range = {{3, 4}, {1, 3}};
      ];
    
    If[type == UTILITY`XYPlotTypeBt1,(* XY plot for biotite : Al(IV) - 1 versus (Al)VI  *)
      {x, y} = ExtractMinDat[ToExpression["bt"], {"Al(IV)", "Al(VI)"}, file, 
      			    ExtractMinDatTexture -> tx, ExtractMinDatTextureRange -> lab, 
          		    ExtractMinDatMode -> ExtractParameter];
      x = x - 1;
     xticks = yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"\!\(\*SuperscriptBox[\"Al\", \"IV\"]\)- 1","\!\(\*SuperscriptBox[\"Al\", \"VI\"]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{0, 0}, {1, 1}}]}}]; 
        ];
      range = {{0, 1}, {0, 1}};
      ];
    
    If[type == UTILITY`XYPlotTypeBt2,(* XY plot for biotite : Al(IV) - 1 versus XMg *)
      {x, y} = ExtractMinDat[ToExpression["bt"], {"Al(IV)", "XMgM"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
      x = x - 1;
     xticks = yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"\!\(\*SuperscriptBox[\"Al\", \"IV\"]\)- 1","Mg/(Mg + Fe)"};
      range = {{0, 1}, {0, 1}};
      ];
    
    If[type == UTILITY`XYPlotTypeBt3,(* XY plot for biotite : Si versus Al(tot)  *)
      {x, y} = ExtractMinDat[ToExpression["bt"], {"SiO2", "Al2O3"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
     xticks = {{2, "2.0", {0.02, 0}, {Thickness[thick2]}},{2.1, "", {0.015, 0}, {Thickness[thick2]}}, {2.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.3, "", {0.015, 0}, {Thickness[thick2]}}, {2.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{2.5, "2.5", {0.02, 0}, {Thickness[thick2]}},{2.6, "", {0.015, 0}, {Thickness[thick2]}}, {2.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.8, "", {0.015, 0}, {Thickness[thick2]}}, {2.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{3, "3.0", {0.02, 0}, {Thickness[thick2]}}};
      yticks = {{1.0, "1.0", {0.02, 0}, {Thickness[thick2]}},{1.1, "", {0.015, 0}, {Thickness[thick2]}}, {1.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{1.3, "", {0.015, 0}, {Thickness[thick2]}}, {1.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{1.5, "1.5", {0.02, 0}, {Thickness[thick2]}},{1.6, "", {0.015, 0}, {Thickness[thick2]}}, {1.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{1.8, "", {0.015, 0}, {Thickness[thick2]}}, {1.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{2, "2.0", {0.02, 0}, {Thickness[thick2]}},{2.1, "", {0.015, 0}, {Thickness[thick2]}}, {2.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.3, "", {0.015, 0}, {Thickness[thick2]}}, {2.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{2.5, "2.5", {0.02, 0}, {Thickness[thick2]}},{2.6, "", {0.015, 0}, {Thickness[thick2]}}, {2.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.8, "", {0.015, 0}, {Thickness[thick2]}}, {2.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{3, "3.0", {0.02, 0}, {Thickness[thick2]}}};
      tx1 = {"Si","\!\(\*SubscriptBox[\"Al\", \"tot\"]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{2, 3}, {3, 1}}]}}]; 
        ];
      range = {{2, 3}, {1, 3}};
      ];
    
    If[type == UTILITY`XYPlotTypeZoEp1,(* XY plot for zoisite/epidote : AlVI - 2 versus Fe(3 +)  *)
      {x, y} = ExtractMinDat[ToExpression["zoep"], {"Al2O3", "Fe2O3"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
      
      xticks = {{2, "2.0", {0.02, 0}, {Thickness[thick2]}},{2.1, "", {0.015, 0}, {Thickness[thick2]}}, {2.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.3, "", {0.015, 0}, {Thickness[thick2]}}, {2.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{2.5, "2.5", {0.02, 0}, {Thickness[thick2]}},{2.6, "", {0.015, 0}, {Thickness[thick2]}}, {2.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.8, "", {0.015, 0}, {Thickness[thick2]}}, {2.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{3, "3.0", {0.02, 0}, {Thickness[thick2]}}};
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
          	
      tx1 = {"Al","\!\(\*SuperscriptBox[\"Fe\", RowBox[{\"3\", \"+\"}]]\)"};
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
        grid = Graphics[{{Thickness[thick1], Line[{{1.9, 1.1}, {3, 0}}]}}]];
      range = {{1.9, 3}, {0, 1.1}};
      ];
    
    If[type == UTILITY`XYPlotTypeChl1,(* XY plot for chlorites : Si versus Mg/(Mg + Fe2), no names *)
      {x, fe,mg} = ExtractMinDat[ToExpression["chl"], {"SiO2", "FeO", "MgO"}, file, ExtractMinDatTexture -> tx, 
          		    ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter];
      y = mg/(mg+fe);
      xticks = {{2.5, "2.5", {0.02, 0}, {Thickness[thick2]}},{2.6, "", {0.015, 0}, {Thickness[thick2]}}, {2.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{2.8, "", {0.015, 0}, {Thickness[thick2]}}, {2.9, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{3, "3.0", {0.02, 0}, {Thickness[thick2]}},{3.1, "", {0.015, 0}, {Thickness[thick2]}}, {3.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{3.3, "", {0.015, 0}, {Thickness[thick2]}}, {3.4, "", {0.015, 0}, {Thickness[thick2]}},
          	{3.5, "3.5", {0.02, 0}, {Thickness[thick2]}}};
      yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};          	
      tx1 = {"Si","Mg/(Mg + Fe)"};
      range = {{2.5, 3.5}, {0, 1}}; ar = 1/GoldenRatio;
      ];
    
    If[type == UTILITY`XYPlotTypeGrtProfileXFe || 
       type == UTILITY`XYPlotTypeGrtProfileXMg || 
       type == UTILITY`XYPlotTypeGrtProfileXCa || 
       type == UTILITY`XYPlotTypeGrtProfileXMn ,
      (* garnet profile : XFe, XMg, XCa, XMn versus equally spaced distance *)
      If[type == UTILITY`XYPlotTypeGrtProfileXFe, 
        y = ExtractMinDat[ToExpression["grt"], "XFe", file, ExtractMinDatTexture -> tx, 
            		 ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter]]; 
      If[type == UTILITY`XYPlotTypeGrtProfileXMg, 
        y = ExtractMinDat[ToExpression["grt"], "XMg", file, ExtractMinDatTexture -> tx, 
            		 ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter]]; 
      If[type == UTILITY`XYPlotTypeGrtProfileXCa, 
        y = ExtractMinDat[ToExpression["grt"], "XCa", file, ExtractMinDatTexture -> tx, 
            		 ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter]]; 
      If[type == UTILITY`XYPlotTypeGrtProfileXMn, 
        y = ExtractMinDat[ToExpression["grt"], "XMn", file, ExtractMinDatTexture -> tx, 
            		 ExtractMinDatTextureRange -> lab, ExtractMinDatMode -> ExtractParameter]];
      x = Table[i*fak, {i, 1, Dimensions[Flatten[y]][[1]]}];
      If[UTILITY`XYPlotGrid == UTILITY`XYPlotGridYes,
       yticks = {{0, "0.0", {0.02, 0}, {Thickness[thick2]}},{0.1, "", {0.015, 0}, {Thickness[thick2]}}, {0.2, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.3, "", {0.015, 0}, {Thickness[thick2]}}, {0.4, "", {0.015, 0}, {Thickness[thick2]}}, 
          	{0.5, "0.5", {0.02, 0}, {Thickness[thick2]}},{0.6, "", {0.015, 0}, {Thickness[thick2]}}, {0.7, "", {0.015, 0}, {Thickness[thick2]}},
          	{0.8, "", {0.015, 0}, {Thickness[thick2]}}, {0.9, "", {0.015, 0}, {Thickness[thick2]}},
          	{1, "1.0", {0.02, 0}, {Thickness[thick2]}}};
        xticks = Automatic;
        tx1 = {"distance (microns)","mole fraction"};
        If[type == UTILITY`XYPlotTypeGrtProfileXFe,          
          labels = Graphics[{Text["XFe", Scaled[{pos[[1, 1]], pos[[1, 2]]}], {0, 0}, {1, 0}, BaseStyle -> {FontSize -> Scaled[0.05]}], FontWeight -> "Bold", FontFamily -> "Helvetica"}]];
        If[type == UTILITY`XYPlotTypeGrtProfileXMg,          
          labels = Graphics[{Text["XMg", Scaled[{pos[[2, 1]], pos[[2, 2]]}], {0, 0}, {1, 0}, BaseStyle -> {FontSize -> Scaled[0.05]}], FontWeight -> "Bold", FontFamily -> "Helvetica"}]];
        If[type == UTILITY`XYPlotTypeGrtProfileXCa,          
          labels = Graphics[{Text["XCa", Scaled[{pos[[3, 1]], pos[[3, 2]]}], {0, 0}, {1, 0}, BaseStyle -> {FontSize -> Scaled[0.05]}], FontWeight -> "Bold", FontFamily -> "Helvetica"}]];
        If[type == UTILITY`XYPlotTypeGrtProfileXMn,          
          labels = Graphics[{Text["XMn", Scaled[{pos[[4, 1]], pos[[4, 2]]}], {0, 0}, {1, 0}, BaseStyle -> {FontSize -> Scaled[0.05]}], FontWeight -> "Bold", FontFamily -> "Helvetica"}]];
        ];
      range = {{0, Max[x] + 1}, {0, 1}}; y = Flatten[y];
      ];
    
    If[x != {} && y != {}, xy = Transpose[{x, y}];
    points = ListPlot[xy, PlotRange -> range, Axes -> None, PlotMarkers -> {{DataSymbols[UTILITY`XYPlotSymbolShape, 0.01], size}}];     
    Return[Show[points,grid,labels, Frame -> True, FrameTicks -> {xticks, yticks}, FrameStyle -> Thickness[thick3],
           AspectRatio -> ar, PlotRange -> range,LabelStyle -> {FontSize -> 14, FontSlant -> "Plain", 
  				 FontWeight -> "Bold", FontFamily -> "Helvetica"},FrameLabel->{tx1[[1]], tx1[[2]]}]
          ];
       ];
    Return[Print["No analyses found for XYPlotType: ", type]];         
    ]

Options[XYPlot] = {
   UTILITY`XYPlotType -> UTILITY`XYPlotTypeAmph1, 
   UTILITY`XYPlotSymbolShape -> UTILITY`SymbolShapeDot, 
   UTILITY`XYPlotSymbolSize -> 0.02, UTILITY`XYPlotTexture -> "", 
   UTILITY`XYPlotTextureRange -> {-3, -1},
   UTILITY`XYPlotGridThickness -> 0.002, 
   UTILITY`XYPlotTickThickness -> 0.003, 
   UTILITY`XYPlotFrameThickness -> 0.006,
   UTILITY`XYPlotGrid -> UTILITY`XYPlotGridYes, 
   UTILITY`XYPlotLabelPosition -> {{0.1, 0.7}, {0.1, 0.15}, {0.85, 0.35}, {0.5, 0.2}},
   UTILITY`XYPlotTypeGrtProfileFactor->1
      };
XYPlot[fname_, opts___] := 
    Block[{opt = {UTILITY`XYPlotType, UTILITY`XYPlotSymbolShape, 
            UTILITY`XYPlotSymbolSize, UTILITY`XYPlotTexture, 
            UTILITY`XYPlotTextureRange, UTILITY`XYPlotGridThickness, 
            UTILITY`XYPlotTickThickness, UTILITY`XYPlotFrameThickness,
            UTILITY`XYPlotGrid, UTILITY`XYPlotLabelPosition, 
            UTILITY`XYPlotTypeGrtProfileFactor}, i, n = Dimensions[{opts}][[1]]}, 
      For[i = 1, i <= n, i++, If[Position[opt, {opts}[[i, 1]]] == {}, 
          Print["Unknown option \"", {opts}[[i, 1]], "\" in -XYPlot-"];
          Print["Known options are: ", opt]; Return[]]];
      XXYPlot[fname, UTILITY`XYPlotType /. {opts} /. Options[XYPlot], 
        UTILITY`XYPlotSymbolShape /. {opts} /. Options[XYPlot], 
        UTILITY`XYPlotSymbolSize /. {opts} /. Options[XYPlot], 
        UTILITY`XYPlotTexture /. {opts} /. Options[XYPlot], 
        UTILITY`XYPlotTextureRange /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotGridThickness /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotTickThickness /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotFrameThickness /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotGrid /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotLabelPosition /. {opts} /. Options[XYPlot],
        UTILITY`XYPlotTypeGrtProfileFactor /. {opts} /. Options[XYPlot]
        ]
      ];


End[]
                     
EndPackage[]
