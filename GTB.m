  (* Name: GTB`  
         package of PET: Petrological Elementary Tools 
	 Dachs, E (1998): Computers & Geoscience 24:219-235
	 	  (2004): Computers & Geoscience 30:173-182 *)

(* Summary: this package calculates geothermobarometers *)

(* Author: Edgar Dachs, Department of Mineralogy
                        University of Salzburg, Austria
                        email: edgar.dachs@sbg.ac.at
                        last update:  03-2004           *)

BeginPackage["GTB`",{"ACTIVITY`","FLUIDS`","FORMEL`","DEFDAT`"}]

CalcThermoBaro::usage = "CalcThermoBaro[{gtb1, gtb2, ...},\"inputfile\",\"outputfile\"] 
calculates various geothermobarometers (gtb's).
Each gtb in the list {gtb1, gtb2, ...} has the form:
{gtb_specification,{min,max,step}}:
<gtb_specification> is either gt+number for the installed geothermometers (see the list below),
or gb+number for the geobarometers. gt1 e.g. represents the garnet-biotite thermometer (FunctionName: GT1).
{min, max, step} define the pressure range (in bar) and interval, for which temperatures are calculated
in the case of a geothermometer, and vice versa for geobarometers (T in C). 
Some gtb's require a third parameter after {min, max, step}, e.g. specifiying an Al2SiO5-polymorph).
\"inputfile\" must have been created earlier with \n
CalcFormula[\"inputfile\",CalcFormulaMode->Gtb]\n
(the option CalcFormulaMode->Gtb is required to calculate specific mineral-chemical
parameters e.g. for clinopyroxene and garnet in the grt-cpx thermometer, etc.).
If \"inputfile\" contains more than one pair of e.g. grt and bt, the analyses are grouped together
in order of their appearance, 1. grt with 1. bt, 2. grt with 2. bt, etc. The data are written to
\"outputfile.ptx\" for later use and are also returned to the screen and have the form:\n
1.element: specification of the gtb (e.g. gt1),
2.element: name of \"inputfile\",
3.element: lnKD for that geothermobarometer,
4.element: calibration that has been used
5.element: list of PT-data.\n
The user is responsible for not applying the various calibrations beyond the range of their
compositional applicability.\n
The following geothermometers (gt's) are available in PET:
speci-    explanation                               FunctionName
fication\n
gt1       garnet - biotite          FeMg-1          GT1
gt2       garnet - phengite         FeMg-1          GT2
gt3       garnet - chlorite         FeMg-1          GT3
gt4       biotite - chlorite        FeMg-1          GT4
gt5       phengite - biotite        FeMg-1          GT5
gt6       garnet - ilmenite         FeMn-1          GT6
gt7       garnet - clinopyroxene    FeMg-1          GT7
gt8       plagioclase - muscovite   NaK-1           GT8
gt9       garnet - orthopyroxene    FeMg-1          GT9
gt10      ortho-/clinopyoxene       CaMg-1          GT10
gt11      orthopyroxene - biotite   FeMg-1          GT11
gt12      garnet - olivine          FeMg-1          GT12
gt13      clinopyroxene - olivine   FeMg-1          GT13
gt14      garnet - hornblende       FeMg-1          GT14
gt15      garnet - cordierite       FeMg-1          GT15
gt16      garnet - staurolite       FeMg-1          GT16
gt17      garnet - chloritoid       FeMg-1          GT17
gt18      chlorite - chloritoid     FeMg-1          GT18
gt19      biotite - chloritoid      FeMg-1          GT19
gt20      garnet - spinel           FeMg-1          GT20
gt21      olivine - spinel          FeMg-1          GT21
gt22      cordierite - spinel       FeMg-1          GT22
gt23      amphibole - plagioclase   exchange        GT23
gt24      calcite - dolomite        solvus          GT24
gt25      plagioclase - Kfeldspar   solvus          GT25\n
The following geobarometers (gb's) are available in PET:
speci-    explanation                               FunctionName
fication\n
gb1       GASP                                      GB1
gb2       garnet-plagioclase-white mica-biotite     GB2
gb3       garnet-plagioclase-white mica             GB3
gb4       garnet-plagioclase-biotite                GB4
gb5       garnet-white mica-Al2SiO5-quartz          GB5
gb6       garnet-white mica-biotite-Al2SiO5-quartz  GB6
gb7       GRAIL                                     GB7
gb8       chlorite-biotite-white mica               GB8
gb9       garnet-amphibole-plagioclase              GB9
gb10      albite = jadeite + quartz                 GB10
gb11      garnet-phengite-omphacite                 GB11
gb12      amphibole - chlorite                      GB12
gb13      Al-in-hornblende                          GB13
gb14      Al-in-orthopyroxene                       GB14
gb15      garnet-orthopyroxene-plagioclase-quartz   GB15
gb16      garnet-clinopyroxene-plagioclase-quartz   GB16\n
For most gtb's there are several calibrations available. The program returns the latest version
by default, but the user can choose the calibration most appropriate for his/her purpose.
Type\n
FunctionName::usage (e.g. GT1::usage)\n
to see the available calibrations for each gtb (examples are also given for each gtb, using data from the file
\"gtb.fu\". This file is an arbitrary collection of analyses, so results are in no way meaningful !).\n
To change the default calibration use:\n
SetOptions[FunctionName, FunctionNameCalibration->YourChoice(Number: 0,1,2,etc.)];\n
before calling -CalcThermoBaro-.
(Number=0 is the default, otherwise number must be 1, 2, 3, etc., depending on how many calibrations there are).\n
Example: \n
SetOptions[GT1,GT1Calibration->16];
result = CalcThermoBaro[{{gt1,{2000,6000,2000}},
{gb1,{400,600,25},sillimanite}},\"gtb\",\"test\"]\n
This calculates the garnet-biotite thermometer and the GASP barometer from mineralchemical data of the file
\"gtb.fu\" (created with CalcFormula[\"gtb\", CalcFormulaMode -> Gtb]), storing results in
the file \"test.ptx\", using the Hodges & Spear calibration for the garnet-biotite geothermometer.
ReturnValue:\n
{{{grt-bt FeMg-1}, {gtb, {lnKD = -2.08361, GT1Calibration = Hodges & Spear (1982), eq.(9)}},
{{472.31, 2000.}, {478.94, 4000.}, {485.56, 6000.}}},
{{GASP barometer}, {gtb, {lnK = -1.62754, GB1Calibration = Koziol (1989), sillimanite}},
{{400., 3142.22}, {425., 3681.78}, {450., 4221.1}, {475., 4760.2}, {500., 5299.06}, {525., 5837.68},
{550., 6376.07}, {575., 6914.23}, {600., 7452.15}}}}\n
Data can be plotted with PlotRea[result], and the intersection of grt/bt and GASP can be calculated with
CalcReaIntersection[result].
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT1::usage = "
Garnet - biotite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT1Calibration -> 0 (default)  Holdaway (2000), Am Min 85:881-892
                  1            Gessmann et al. (1997), Am Min 82:1225-1240
                  2            Holdaway et al. (1997), Am Min 82:582-595
                  3            Kleemann & Reinhardt (1994), Eur J Mineral 6:925-941,
                               with Berman (1990) garnet model
                  4            Bhattacharya et al. (1992), Contrib Mineral Petrol 111:87-93,
                               with Ganguly & Saxena (1984) garnet model
                  5            Bhattacharya et al. (1992), Contrib Mineral Petrol 111:87-93,
                               with Hackler & Wood (1984) garnet model
                  6            Dasgupta et al. (1991), Contrib Mineral Petrol 109:130-137
                  7            Williams & Grambling (1990), Am Min 75:886-908
                  8            Aranovich et al. (1988), Geokhimiya 5:668-676
                  9            Hoinkes (1986), Contrib Mineral Petrol 92:393-399
                  10           Indares & Martignole (1985), Model B, Am Min 70:272-278
                  11           Indares & Martignole (1985), Model A, Am Min 70:272-278
                  12           Ganguly & Saxena (1984), asymmetric garnet model, Am Min 69:88-97
                  13           Ganguly & Saxena (1984), symmetric garnet model, Am Min 69:88-97
                  14           Perchuk & Lavrent'eva (1983), In: Saxena, SK ed., Kinetics and
                               Equilibrium in Mineral Reactions. Springer Verlag, pp.199-240
                  15           Pigage & Greenwood (1982), Am J Sci 282:943-969
                  16           Hodges & Spear (1982), Am Min 67:1118-1134
                  17           Lavrent'yeva & Perchuk (1981), Dokl Akad Nauk SSSR 260:731-734
                  18           Ferry & Spear (1978), Contrib Mineral Petrol 66:113-117
                  19           Holdaway & Lee (1977), Contrib Mineral Petrol 63:175-198
                  20           Goldman & Albee (1977), Am J Sci 277:750-767,
                               with 1000ln(alfa) according to Matthews et al. (1983)
                  21           Goldman & Albee (1977), Am J Sci 277:750-767,
                               with 1000ln(alfa) according to Bottinga & Javoy (1973)
                  22           Thompson (1976), Am J Sci 276:425-454\n
Example (using default calibration): \n
result = CalcThermoBaro[{{gt1,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-bt FeMg-1}, {gtb, {lnKD = -2.08361, GrtBtCalibration = Holdaway (2000)}},
{{559.52, 3000}, {567.22, 6000}}}}\n
Example (using calibration No. 18): \n
SetOptions[GT1, GT1Calibration->18];
result = CalcThermoBaro[{{gt1,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-bt FeMg-1}, {gtb, {lnKD = -2.08361, GT1Calibration = Ferry and Spear (1978), eq. (7)}},
{{465.91, 3000}, {475.92, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT2::usage = "
GT2: Garnet - phengite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT2Calibration -> 0 (default)  Hynes & Forest (1988), J metamorphic Geol 6:297-309
                  1            Green & Hellman (1982), Lithos 15:253-266,
                               basaltic composition: > 2 wt% bulk CaO
                  2            Green & Hellman (1982), Lithos 15:253-266,
                               pelitic composition: <= 2 wt% bulk CaO, Mg poor
                  3            Green & Hellman (1982), Lithos 15:253-266,
                               pelitic composition: <= 2 wt% bulk CaO, Mg rich
                  4            Krogh & Raheim (1978), Contrib Mineral Petrol 66:75-80\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt2,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-wm FeMg-1},{gtb,{lnKD = 2.25382, GT2Calibration = Hynes & Forest (1988)}},
{{491.091, 3000}, {491.091, 6000}}}}\n
Example (using calibration No. 4): \n
SetOptions[GT2, GT2Calibration->4];
result = CalcThermoBaro[{{gt2,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-wm FeMg-1}, {gtb, {lnKD = 2.25382, GT2Calibration = Krogh & Raheim (1978)}},
{{405.136, 3000}, {445.196, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT3::usage = "
GT3: Garnet - chlorite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT3Calibration -> 0 (default)  Perchuk (1991), In: Perchuk LL (ed) Progress in
                               Metamorphic and Magmatic Petrology
                  1            Grambling (1990), Contrib Mineral Petrol 105:617-628
                  2            Ghent et al. (1987), J metamorphic Geol 5:239-254
                  3            Dickensen & Hewitt (1986), modified in Laird (1989),
                               MSA reviews in mineralogy 19:405-453
Example (using default calibration):\n
result = CalcThermoBaro[{{gt3,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-chl FeMg-1},{gtb,{lnKD = -1.97069, GT3Calibration = Perchuk (1991), eq.(18)}},
{{564.383, 3000}, {564.383, 6000}}}}\n
Example (using calibration No. 3): \n
SetOptions[GT3, GT3Calibration->3];
result = CalcThermoBaro[{{gt3,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-chl FeMg-1}, {gtb, {lnKD = -1.97069, GT3Calibration = Dickensen & Hewitt (1986), modified in
Laird (1989)}}, {{539.509, 3000}, {548.661, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT4::usage = "
GT4: Biotite - chlorite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT4Calibration -> 0 (default)  Dickensen & Hewitt (1986), cited in Laird (1989),
                               MSA reviews in mineralogy 19:405-453\n
Example:\n
result = CalcThermoBaro[{{gt4,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{bt-chl FeMg-1}, {gtb, {lnKD = -0.112917, GT4Calibration = Dickensen & Hewitt (1986)}},
{{144.635, 3000}, {158.398, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT5::usage = "
GT5: Phengite - biotite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT5Calibration -> 0 (default)  Hoisch (1989), Am Min 74:565-572\n
Example:\n
result = CalcThermoBaro[{{gt5,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{wm-bt FeMg-1}, {gtb, {lnKD = -1.21074, GT5Calibration = Hoisch (1989)}}, 
{{467.107, 3000.}, {525.416, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT6::usage = "
GT6: Garnet - ilmenite FeMn-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT6Calibration -> 0 (default)  Pownceby et al. (1991), Contrib Mineral Petrol 97:116-126
                  1            Pownceby et al. (1987), corrected (1987),
                               Contrib Mineral Petrol 97:116-126, Contrib Mineral Petrol 97:539
                  2            Pownceby et al. (1987), with Ganguly & Saxena (1984) garnet model\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt6,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-fetiox FeMn-1}, {gtb, {lnKD = 2.34926, GT6Calibration = Pownceby et al. (1991)}},
{{422.246, 3000}, {422.246, 6000}}}}\n
Example (using calibration No. 2): \n
SetOptions[GT6, GT6Calibration->2];
result = CalcThermoBaro[{{gt6,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-fetiox FeMn-1}, {gtb, {lnKD = 2.34926, GT6Calibration = Pownceby et al. (1987) with
Ganguly & Saxena (1984) garnet model}}, {{447.824, 3000.}, {447.824, 3000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT7::usage = "
GT7: Garnet - clinopyroxene FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT7Calibration -> 0 (default)  Krogh (2000), J metamorphic Geol 18: 211-219
                  1            Berman et al. (1995), Contrib Mineral Petrol 119:30-42
                  2            Ai (1994), Contrib Mineral Petrol 115:467-473
                  3            Pattison & Newton (1989), Contrib Mineral Petrol 101:87-103
                  4            Sengupta et al. (1989), Contrib Mineral Petrol 103:223-227
                  5            Krogh (1988), Contrib Mineral Petrol 99:44-48
                  6            Powell (1985), J metamorphic Geol 3:231-243
                  7            Dahl (1980), Am Min 65:854-866
                  8            Ellis & Green (1979), Contrib Mineral Petrol 71:13-22
                  9            Ganguly (1979), Geochim Cosmochim Acta 43:1021-1029
                  10           Saxena (1979), Contrib Mineral Petrol 70:229-235
                  11           Mori & Green (1978), J Geol 86:83-97
                  12           Raheim & Green (1974), Contrib Mineral Petrol 48:179-203
Note that your results depend critically on whether Fe(3+) recalculation is applied or not from
-CalcFormula- (for GT7Calibration->1, authors advise no Fe(3+) recalculation).\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt7,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-cpx FeMg-1}, {gtb, {lnKD = 2.99809, GT7Calibration = Krogh (2000)}},
{{314.695, 3000.}, {326.735, 6000.}}}}\n
Example (using calibration No. 8): \n
SetOptions[GT7, GT7Calibration->8];
result = CalcThermoBaro[{{gt7,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-cpx FeMg-1}, {gtb, {lnKD = 2.99809, GT7Calibration = Ellis & Green (1979)}},
{{367.755, 3000.}, {374.402, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT8::usage = "
GT8: Plagioclase - muscovite NaK-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT8Calibration -> 0 (default)  Green & Usdansky (1986), Am Min 71:1109-1117\n
Example:\n
result = CalcThermoBaro[{{gt8,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{plag-wm NaK-1}, {gtb, {lnKD = 5.95517, GT8Calibration = Green & Usdansky (1986)}},
{{498.695, 3000}, {529.739, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT9::usage = "
GT9: Garnet - orthopyroxene FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name              Value        Reference\n
GT9Calibration -> 0 (default)  Aranovich & Berman (1997): Alm = 3Fs + Al2O3; Am Min 82:345-353
                  1            Lal (1993), J metamorphic Geol 11:855-866
                  2            Bhattacharya et al. (1991), Contrib Mineral Petrol 86:359-373
                  3            Lavrent'eva & Perchuk (1990), Dokl Akad Nauk SSSR 310:179-182
                  4            Lee & Ganguly (1988), J Petrol 29:93-113
                  5            Harley (1984), Contrib Mineral Petrol 86:359-373
                  6            Sen & Bhattacharya (1984), Contrib Mineral Petrol 88:64-71
                  7            Kawasaki & Matsui (1983), Geochim Cosmochim Acta 47:1661-1679
                  8            Dahl (1980), Am Min 65:854-866
                  9            Mori & Green (1978), J Geol 86:83-97
Note that the default calibration is based on the reaction: Alm = 3Fs + Al2O3,
whereas all other calibrations represent the FeMg-1 exchange between garnet and orthopyroxene.
Example (using default calibration):\n
result = CalcThermoBaro[{{gt9,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-opx FeMg-1}, {gtb, {lnKD = -6.20737, GT9Calibration = Aranovich & Berman (1997): Alm = 3Fs + Al2O3}},
 {{585.883, 3000.}, {669.539, 6000.}}}}\n
Example (using calibration No. 8): \n
SetOptions[GT9, GT9Calibration->8];
result = CalcThermoBaro[{{gt9,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-opx FeMg-1}, {gtb, {lnKD = 2.66679, GT9Calibration = Dahl (1980)}},
{{255.662, 3000.}, {255.662, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT10::usage = "
GT10: Orthopyroxene - clinopyroxene solvus.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT10Calibration -> 0 (default)  Brey & Köhler (1990): En(opx) = En(cpx), J Petrology 31:1353-1378
                   1            Brey & Köhler (1990): Na partitioning, J Petrology 31:1353-1378
                   2            Brey & Köhler (1990): Ca-in-opx, J Petrology 31:1353-1378
                   3            Bertrand & Mercier (1985): En(opx) = En(cpx), single px, EPSL 76:109-122
                   4            Bertrand & Mercier (1985): En(opx) = En(cpx), two px, EPSL 76:109-122
                   5            Mori & Green (1978): Fe/Mg-exchange
                   6            Wells (1977): En(opx) = En(cpx), Contrib Mineral Petrol 62:129-139
                   7            Herzberg & Chapman (1976): En(opx) = En(cpx), 12 kb, Am Min 61:626-637
                   8            Herzberg & Chapman (1976): En(opx) = En(cpx), 16 kb, Am Min 61:626-637
                   9            Nehru & Wyllie (1974): En(opx) = En(cpx), 30 kb, Contrib Mineral Petrol 48:221-228
                   10           Wood & Banno (1973): En(opx) = En(cpx), Contrib Mineral Petrol 42:109-124\n
Example (using default calibration) and the following analyses (from Brey & Köhler, 1990):\n
Label  Mineral SiO2    TiO2  Al2O3   Cr2O3   FeO    MnO  MgO     CaO     Na2O
2      opx     56.999  0     1.252   0.263   6.420  0    33.528  1.5386  0
3      cpx     55.563  0     1.895   0.530   4.433  0    20.332  16.153  1.094\n
result = CalcThermoBaro[{{gt10,{1000,11000,5000}}},\"BreyKöhler\",\"test\"]\n
ReturnValue:
{{{opx-cpx solvus}, {BreyKöhler, {lnKD = -1.0529, GT10Calibration = Brey & Koehler (1990): En(opx) = En(cpx)}},
{{1245.02, 1000.}, {1257.4, 6000.}, {1269.78, 11000.}}}}\n
Example (using calibration No. 2): \n
SetOptions[GT10, GT10Calibration->2];
result = CalcThermoBaro[{{gt10,{1000,11000,5000}}},\"BreyKöhler\",\"test\"]\n
ReturnValue:
{{{opx-cpx solvus}, {BreyKöhler, {lnKD = -2.8647, GT10Calibration = Brey & Koehler (1990): Ca-in-opx}},
{{1097.24, 1000.}, {1125.28, 6000.}, {1153.32, 11000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT11::usage = "
GT11: Orthopyroxene - biotite  FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT11Calibration -> 0 (default)  Sengupta et al. (1990), J metamorphic Geol 8:191-197\n
Example:\n
result = CalcThermoBaro[{{gt11,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{opx-bt FeMg-1}, {gtb, {lnKD = -0.583165, GT11Calibration = Sengupta et al. (1990)}},
{{1426.76, 3000.}, {1450.92, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT12::usage = "
GT12: Garnet - olivine  FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT12Calibration -> 0 (default)  O'Neill & Wood (1979, 1980), Contrib Mineral Petrol 70:59-70,
                                Contrib Mineral Petrol 72:337)
                   1            Mori & Green (1978), J Geol 86:83-97\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt12,{30000,36000,6000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-ol FeMg-1}, {gtb, {lnKD = 2.59536, GT12Calibration = O'Neill & Wood (1979), corrected (1980)}},
{{105.286, 30000.}, {125.854, 36000.}}}}\n
Example (using calibration No. 1): \n
SetOptions[GT12, GT12Calibration->1];
result = CalcThermoBaro[{{gt12,{30000,36000,6000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-ol FeMg-1}, {gtb, {lnKD = 2.59536, GT12Calibration = Mori & Green  (1978)}},
{{86.08, 30000.}, {86.08,36000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT13::usage = "
GT13: Clinopyroxene - olivine FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT13Calibration -> 0 (default)  Powell & Powell (1974), Contrib Mineral Petrol 48:249-263
                   1            Mori & Green (1978), J Geol 86:83-97\n
Example:\n
result = CalcThermoBaro[{{gt13,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{cpx-ol FeMg-1}, {gtb, {lnKD = -0.402721, GT13Calibration = Powell & Powell (1974)}},
{{1016.68, 3000.}, {1033.65, 6000.}}}}\n
Example (using calibration No. 1): \n
SetOptions[GT13, GT13Calibration -> 0];
result = CalcThermoBaro[{{gt13,{30000,36000,6000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{cpx-ol FeMg-1}, {gtb, {lnKD = -0.402721, GT13Calibration = Mori & Green  (1978)}},
{{1892.64, 3000.}, {1892.64, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT14::usage = "
GT14: Garnet - hornblende FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT14Calibration -> 0 (default)  Dale et al. (2000), Contrib Mineral Petrol 140:353-362
                   1            Perchuk et al. (1985), J metamorphic Geol 3:265-310
                   2            Powell (1985), J metamorphic Geol 3:231-243
                   3            Graham & Powell (1984), J metamorphic Geol 2:13-31\n
Example (using default calibration): note that this calibration requires Fe(3+) calculation for amph
according to Holland & Blundy (1994), e.g.\n
CalcFormula[file, Fe3Amph -> HollandBlundy, CalcFormulaMode -> Gtb]\n
result = CalcThermoBaro[{{gt14,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-amph FeMg-1}, {gtb, {lnKD = 11.8265, GT14Calibration = Dale et al. (2000)}},
{{402.596, 3000.}, {416.469, 6000.}}}}\n
Example (using calibration No. 3): \n
SetOptions[GT14, GT14Calibration->3];
result = CalcThermoBaro[{{gt14,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-amph FeMg-1}, {gtb, {lnKD = 2.3653, GT14Calibration = Graham & Powell (1984)}},
{{345.32, 3000.}, {345.32, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT15::usage = "
GT15: Garnet - cordierite FeMg-1 exchange geothermometer.\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT15Calibration -> 0 (default)  Bhattacharya et al. (1988), Am Min 73:338-344
                   1            Perchuk & Lavrent'eva (1983), In: Saxena, SK ed., Kinetics and Equilibrium
                                in Mineral Reactions. Springer Verlag, pp.199-240,
                                corrected Perchuk, (1991)
                   2            Wells (1979), J Petrology 20:187-226
                   3            Holdaway & Lee (1977), Contrib Mineral Petrol 63:175-198
                   4            Thompson (1976), Am J Sci 276:425-454\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt15,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-crd FeMg-1}, {gtb, {lnKD = -3.58328, GT15Calibration = Bhattacharya et al. (1988)}},
{{438.767, 3000}, {448.656, 6000}}}}\n
Example (using calibration No. 3): \n
SetOptions[GT15, GT15Calibration->3];
result = CalcThermoBaro[{{gt15,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-crd FeMg-1}, {gtb, {lnKD = -3.58328, GT15Calibration = Holdaway & Lee (1977), Table 7}},
{{363.029, 3000}, {372.295, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT16::usage = "
GT16: Garnet - staurolite FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT16Calibration -> 0 (default)  Perchuk (1991), In: Perchuk LL (ed) Progress in
                                Metamorphic and Magmatic Petrology\n
Example:\n
result = CalcThermoBaro[{{gt16,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-stau FeMg-1}, {gtb, {lnKD = 0.455363, GT16Calibration = Perchuk (1991), eq.(19)}},
{{555.737, 3000}, {562.651, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT17::usage = "
GT17: Garnet - chloritoide FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT17Calibration -> 0 (default)  Perchuk (1991), In: Perchuk LL (ed) Progress in
                                Metamorphic and Magmatic Petrology\n
Example:\n
result = CalcThermoBaro[{{gt17,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-ctd FeMg-1}, {gtb, {lnKD = 0.572602, GT17Calibration = Perchuk (1991), eq.(20)}},
{{526.915, 3000}, {533.588, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT18::usage = "
GT18: Chlorite - chloritoide FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT18Calibration -> 0 (default)  Vidal et al. (1999), J metamorphic Geol 17: 25-39
                   1            Perchuk (1991), In: Perchuk LL (ed) Progress in
                                Metamorphic and Magmatic Petrology\n
Example:\n
result = CalcThermoBaro[{{gt18,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{chl-ctd FeMg-1}, {gtb, {lnKD = 1.39809, GT18Calibration = Vidal et al. (1999), eq.(4)}},
{{561.642, 3000}, {561.642, 6000}}}}\n
Example (using calibration No. 1): \n
SetOptions[GT18, GT18Calibration -> 1];
result = CalcThermoBaro[{{gt18,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{chl-ctd FeMg-1}, {gtb, {lnKD = 1.39809, GT18Calibration = Perchuk (1991), eq.(21)}},
{{486.621, 3000.}, {486.621, 6000.}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT19::usage = "
GT19: Biotite - chloritoide FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT19Calibration -> 0 (default)  Perchuk (1991), In: Perchuk LL (ed) Progress in
                                Metamorphic and Magmatic Petrology\n
Example:\n
result = CalcThermoBaro[{{gt19,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{bt-ctd FeMg-1}, {gtb, {lnKD = 1.51101, GT19Calibration = Perchuk (1991), eq.(22)}},
{{416.295, 3000}, {416.295, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT20::usage = "
GT20: Garnet - spinell FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value        Reference\n
GT20Calibration -> 0 (default)  Perchuk (1991), In: Perchuk LL (ed) Progress in
                                Metamorphic and Magmatic Petrology\n
Example:\n
result = CalcThermoBaro[{{gt20,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-spin FeMg-1}, {gtb, {lnKD = 1.09385, GT20Calibration = Perchuk (1991), eq.(29)}},
{{648.369, 3000}, {653.559, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT21::usage = "
GT21: Olivine - spinell FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value          Reference\n
GT21Calibration -> 0 (default)    Ballhaus et al. (1991), Contrib Mineral Petrol 107:27-40+Erratum
                   1              Fabries (1979), Contrib Mineral Petrol 69:329-336
                   2              Roeder et al. (1979), Contrib Mineral Petrol 68:325-334\n
For calibration 1, use\n
CalcFormula[datafile, Fe3Spin -> NoCalculation, CalcFormulaMode -> Gtb]\n
to avoid Fe(3+) recalculation in spinel.
Example (using default calibration):\n
result = CalcThermoBaro[{{gt21,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{ol-spin FeMg-1}, {gtb, {lnKD = 1.50151, GT21Calibration = Ballhaus et al. (1991)}},
{{285.501, 3000.}, {290.841, 6000.}}}}\n
Example (using calibration No. 2): \n
SetOptions[GT21, GT21Calibration->2];
result = CalcThermoBaro[{{gt21,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{ol-spin FeMg-1}, {gtb, {lnKD = 1.50151, GT21Calibration = Roeder et al. (1979)}},
{{569.743, 3000}, {569.743, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT22::usage = "
GT22: Cordierite - spinell FeMg-1 exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value          Reference\n
GT22Calibration -> 0 (default)    Perchuk (1991), In: Perchuk LL (ed) Progress in
                                  Metamorphic and Magmatic Petrology
                   1              Vielzeuf (1983), Contrib Mineral Petrol 82:301-311\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt22,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{crd-spin FeMg-1}, {gtb, {lnKD = -2.48943, GT22Calibration = Perchuk (1991), eq.(29)}},
{{510.975, 3000}, {529.999, 6000}}}}\n
Example (using calibration No. 1): \n
SetOptions[GT22, GT22Calibration->1];
result = CalcThermoBaro[{{gt22,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{crd-spin FeMg-1}, {gtb, {lnKD = -2.48943, GT22Calibration = Vielzeuf (1983), Fig.(3)}},
{{561.828, 3000}, {561.828, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT23::usage = "
GT23: Amphibole - plagioclase exchange geothermometer\n
Option for selecting a specific calibration:
Name               Value          Reference\n
GT23Calibration -> 0 (default)    Holland & Blundy (1994), edenite - tremolite reaction
                                  Contrib Mineral Petrol 116:433-447
                   1              Holland & Blundy (1994), edenite - richterite reaction
                                  Contrib Mineral Petrol 116:433-447\n
Fe(3+) in amphibole must have been calculated with:\n
CalcFormula[\"gtb\", Fe3Amph->HollandBlundy, CalcFormulaMode -> Gtb].\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt23,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{amph-plag exchange}, {gtb, {lnK = -1.55132, GT23Calibration = Holland & Blundy (1994),
edenite-tremolite}}, {{615.867, 3000}, {619.262, 6000}}}}\n
Example (using calibration No. 1): \n
SetOptions[GT23, GT23Calibration->1];
result = CalcThermoBaro[{{gt23,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{amph-plag exchange}, {gtb, {lnK = -4.53531, GT23Calibration = Holland & Blundy (1994),
edenite-richterite}}, {{562.865, 3000}, {586.3, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT24::usage = "
GT24: Calcite - dolomite solvus geothermometer\n
For this method, only calcite analyses are required.
The program also returns the calculated composition
of coexisting dolomite. 
Option for selecting a specific calibration:
Name               Value          Reference\n
GT24Calibration -> 0 (default)    Gottschalk (1990), PHD thesis, University of Tübingen,
                                  valid for the Ca-Mg system, allowed range: 0.01 < X-Mg(Cal) < 0.25
                   1              Anovitz & Essene (1987), eq.(23), J Petrol 28:389-414,
                                  the program only calculates eq.(23) for the Ca-Mg system.
                                  Eq.(31) for the Ca-Mg-Fe system does not yield reasonable
                                  results (type-setting error ?).
                   2              Powell et al. (1984), J metamorphic Geol 2:33-41
                   3              Bickle & Powell (1977), Contrib Mineral Petrol 59:281-292\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt24,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{cal-dol solvus}, {gtb, {X-Mg(Dol)= 0.991219, GT24Calibration = Gottschalk (1990) for pure Ca-Mg system}}, 
{{427.098, 3000}, {417.073, 6000}}}}\n
Example (using calibration No. 3): \n
SetOptions[GT24, GT24Calibration->3];
result = CalcThermoBaro[{{gt24,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{cal-dol solvus}, {gtb, {X-Mg(Dol)= 0.602275, GT24Calibration = Bickle & Powell (1977)}},
{{483.114, 3000}, {472.791, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

Afs::usage = "Afs[P (bar), T (K), flag, Xab, Xan, Xor]
calculates the activities of the albite, anorthite and orthoclase phase components in feldspar,
and is used for GT25: Plagioclase - kalifeldspar solvus geothermometer.
The ReturnValue depends on the value of flag:
flag = 1: a(ab),
flag = 2: a(an),
flag = 3: a(or),
flag = 4: excess H for ab, an, or, +add. entropy contribution,
flag = 5: excess S for ab, an, or, +add. entropy contribution,
flag = 6: excess V for ab, an, or, +add. entropy contribution,\n
Default value for option AfsModel is:
AfsModel->FuhrmanLindsley: Fuhrman & Lindsley (1988)
          (Am Mineral 73, 201-215;
          WOrAn and WAnOr exchanged, see
          Wen & Nekvasil 1994,
          Comp Geosci 20:1025-1040).
Other allowed values for AfsModel are:
AfsModel->ElkinsGrove: Elkins & Grove (1990)
          (Am Min 75:544-559;
          Wv for Ab-Or have been interchanged
          (Kroll et al., 1993, CMP 114:510-518).
AfsModel->LindsleyNekvasil: Lindsley & Nekvasil (1988)
          (EOS 70:506)
AfsModel->NekvasilBurnham: Nekvasil & Burnham (1987)
          (In: Mysen (ed), magmatic processes)
AfsModel->GreenUsdansky: Green & Usdansky (1986)
          (Am Min 71:1100-1108)
AfsModel->Ghiorso: Ghiorso (1984)
          (Contrib Mineral Petrol 87:282-296)
Called from: -GT25-.
Package name: GTB.M
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GT25::usage = "
GT25: Plagioclase - kalifeldspar solvus geothermometer\n
Calibrations based on the distribution of albite component
between coexisting plagioclase and K-feldpar (one thermometer equation):\n
Option for selecting a specific calibration:
Name               Value          Reference\n
GT25Calibration -> 0 (default)    Perchuk et al. (1991), In: Perchuk LL (ed) Progress in
                                  Metamorphic and Magmatic Petrology
                                  For the ordering parameter Z (describing order/disorder
                                  in K-feldspar, see Hovis 1986, Am Min 71:869-890),
                                  the program uses Z = 0 by default (complete disorder).
                                  This value can be overridden with the option:
                                  GT25Z->Value (0 <= Value <= 1).
                   1              Powell & Powell (1977), Min Mag 41:253-256
                   2              Stormer (1975), Am Min 60:667-674\n
Calibrations based on the distribution of albite, anorthite,
and orthoclase component between coexisting plagioclase
and K-feldpar (three thermometer equations):\n
GT25Calibration -> 3              in this mode, the program performs
                                  analogous calculations to SOLVCALC (Wen & Nekvasil 1994,
                                  Comp Geosci 20: 1025-1040): it searches for the most concordant
                                  temperature by adjusting the two feldspar compositions within a
                                  2 mol% uncertainty (step size 1 mol%, similar to the algorithm used
                                  by Fuhrman & Lindsley, 1988) and returns the mean of the three
                                  temperatures T(ab), T(an), T(or), if these lie within 40 C of
                                  each other. Depending on the speed of your computer
                                  this may take some time.\n
The default feldspar activity model in the calculation is the
calibration of Fuhrman & Lindsley (1988). It can be changed to other
calibrations (e.g. to that of Elkins & Grove, 1990) by typing:\n
SetOptions[Afs,AfsModel->ElkinsGrove];\n
before calling -CalcThermoBaro- (see Afs::usage for more details).\n
The examples given below use the following two analyses of the file \"plagkf\":\n
Label   Mineral SiO2    Al2O3   CaO     Na2O    K2O
1       plag    49.75   32.12   14.892  2.732   0.508
2       kf      63.627  19.968  1.627   1.798   12.981\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gt25,{3000,6000,3000}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{plag-kf solvus}, {plagkf, {lnKD = -0.413248, GT25Calibration = Perchuk et al. (1991), eq.(64, 68)}},
{{631.004, 3000}, {437.267, 6000}}}}\n
Example (using calibration No. 3): \n
SetOptions[GT25, GT25Calibration -> 3];
result = CalcThermoBaro[{{gt25, {3000, 6000, 3000}}}, \"plagkf\", \"test\"]\n
ReturnValue:
{{{plag-kf solvus}, {plagkf, {lnKD = -0.413248, GT25Calibration = mean of concordant T(ab), T(an), T(or);
{AfsModel -> FspFuhrmanLindsley}}},
{{871.008, 3000}, {879.29, 6000}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB1::usage = "
GB1: Garnet - plagioclase - Al2SiO5 - quartz geobarometer (GASP)\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB1Calibration -> 0 (default)    Koziol (1989), EOS 70, no.15, p.493
                  1              Hodges & Crowley (1985), Am Min 70:702-709
                  2              Ganguly & Saxena (1984), Am Min 69:88-97
                  3              Hodges & Spear (1982), Am Min 67:1118-1134
                  4              Newton & Haselton (1981), In: Newton, Navrotsky, Wood (eds),
                                 Thermodynamics of Minerals and Melts
GB1GammaAn -> 1.8 (default)      this is used as default for gamma(An) with the Hodges & Spear calibration.
The Al2SiO5 phase is defined after the list {min, max, step}, and has to be: kyanite, sillimanite, or andalusite.
Example (using default calibration):\n
result = CalcThermoBaro[{{gb1,{400,700,100},kyanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{GASP barometer}, {gtb, {lnK = -1.49787, GB1Calibration = Koziol (1989), kyanite}},
{{400, 2928.19}, {500, 5069.85}, {600, 7211.52}, {700, 9353.18}}}}\n
Example (using calibration No. 4): \n
SetOptions[GB1, GB1Calibration->4];
result = CalcThermoBaro[{{gb1,{400,700,100},kyanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{GASP barometer}, {gtb, {lnK = -1.559, GB1Calibration = Newton & Haselton (1981), kyanite}},
{{400, 2077.31}, {500, 4382.04}, {600, 6686.77}, {700, 8991.5}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB2::usage = "
GB2: Garnet - plagioclase - muscovite - biotite geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB2Calibration -> 0 (default)    Hoisch (1990), Mg reaction (R5), Contrib Mineral Petrol 104:225-234
                  1              Hoisch (1990), Fe reaction (R6), Contrib Mineral Petrol 104:225-234
                  2              Hodges & Crowley (1985), Fe reaction (R3), Am Min 70:702-709
                  3              Ghent & Stout (1981), Mg reaction, Contrib Mineral Petrol 76:92-97
                  4              Ghent & Stout (1981), Fe reaction, Contrib Mineral Petrol 76:92-97\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gb2,{400,700,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-wm-bt barometer}, {gtb, {lnK = 8.99924, GB2Calibration = Hoisch (1990), Mg-reaction (R5)}},
{{400, 2951.61}, {500, 4049.16}, {600, 5146.71}, {700, 6244.26}}}}\n
Example (using calibration No. 4): \n
SetOptions[GB2, GB2Calibration->4];
result = CalcThermoBaro[{{gb2,{400,700,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-wm-bt barometer}, {gtb, {lnK = 3.04006, GB2Calibration = Ghent & Stout (1981), Fe-reaction}},
{{400., 3695.75}, {500., 4584.78}, {600., 5473.82}, {700., 6362.85}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB3::usage = "
GB3: Garnet - plagioclase - muscovite - quartz geobarometer\n
Option for selecting a specific calibration:
Name                Value          Reference\n
GB3BtCalibration -> 0 (default)    Hoisch (1990), Mg reaction (R3), Contrib Mineral Petrol 104:225-234
                    1              Hodges & Crowley (1985), Fe reaction (R4), Am Min 70:702-709\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gb3,{400,600,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-wm barometer}, {gtb, {lnK = 3.38733, GB3Calibration = Hoisch (1990), Mg-reaction (R3)}},
{{400., 2717.33}, {500., 4131.59}, {600., 5545.84}}}}\n
Example (using calibration No. 1): \n
SetOptions[GB3, GB3Calibration->1];
result = CalcThermoBaro[{{{grt,plag,wm},{400,600,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-wm barometer}, {gtb, {lnK = 1.9725, GB3Calibration = Hodges & Crowley (1985), (R4)}},
{{400., 1964.97}, {500., 4188.43}, {600., 6411.88}}}}\n
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB4::usage = "
GB4: Garnet - plagioclase - biotite - quartz geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB4Calibration -> 0 (default)    Hoisch (1990), Mg reaction (R1), Contrib Mineral Petrol 104:225-234
                  1              Hoisch (1990), Fe reaction (R2), Contrib Mineral Petrol 104:225-234
Example (using default calibration):\n
result = CalcThermoBaro[{{gb4,{400,600,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-bt barometer}, {gtb, {lnK = 4.59807, GB4Calibration = Hoisch (1990), Mg-reaction (R1)}}, 
{{400, 2925.95}, {500, 4444.94}, {600, 5963.92}}}}\n
Example (using calibration No. 1): \n
SetOptions[GB4, GB4Calibration->1];
result = CalcThermoBaro[{{gb4,{400,600,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-plag-bt barometer}, {gtb, {lnK = 2.54359, GB4Calibration = Hoisch (1990), Fe-reaction (R2)}}, 
{{400, 2473.13}, {500, 4546.44}, {600, 6619.75}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB5::usage = "
GB5: Garnet - muscovite - Al2SiO5 - quartz geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB5Calibration -> 0 (default)    Hodges & Crowley (1985), Fe reaction (R7), Am Min 70:702-709\n
The Al2SiO5 phase is defined after the list {min, max, step} and has to be: kyanite, sillimanite, or andalusite.
Example (using default calibration):\n
result = CalcThermoBaro[{{gb5,{500,600,50},kyanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-wm-Al2SiO5-qz barometer}, {gtb, {lnK = -8.47419, GB5Calibration = Hodges & Crowley (1985), (R7), kyanite}},
{{500., 2133.16}, {550., 5222.64}, {600., 8312.11}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB6::usage = "
GB6: Garnet - muscovite - biotite - Al2SiO5 - quartz geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB6Calibration -> 0 (default)    Holdaway et al. (1988), Am Min 73:20-47
                  1              Hodges & Crowley (1985), Fe reaction (R12), Am Min 70:702-709
                  2              Hodges & Crowley (1985), Fe reaction (R9), Am Min 70:702-709\n
The Al2SiO5 phase is defined after the list {min, max, step} and has to be: kyanite, sillimanite, or andalusite.
Example (using default calibration):\n
result = CalcThermoBaro[{{gb6,{500,600,50},sillimanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-wm-bt-Al2SiO5-qz barometer}, {gtb, {lnK = -1.64115, GB6Calibration = Holdaway et al. (1988), sillimanite}},
{{500., 2133.87}, {550., 3216.82}, {600., 4299.78}}}}\n
Example (using calibration No. 2): \n
SetOptions[GB6, GB6Calibration->2];
result = CalcThermoBaro[{{gb6,{500,600,50},sillimanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-wm-bt-Al2SiO5-qz barometer}, {gtb, {lnK = -17.7228, GB6Calibration = Hodges & Crowley (1985), (R9),sillimanite}},
{500., 5017.8}, {550., 6542.04}, {600., 8066.28}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB7::usage = "
GB7: GRAIL geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB7Calibration -> 0 (default)    Bohlen et al. (1983), Am Min 68:1049-1058\n
Delta-H and delta-S of the endmember reaction (with sillimanite as Alsi phase) were extracted from
the experimantal data (750-900 C runs in alfa-Qz field) using delta-V from the Berman data set.
The garnet activity model is that of the original paper (Perkins, 1979).\n
The Al2SiO5 phase is defined after the list {min, max, step} and has to be: kyanite, sillimanite, or andalusite.
Example (using default calibration):\n
result =
CalcThermoBaro[{{gb7,{500,700,100},sillimanite}},\"gtb\",\"test\"]\n
ReturnValue:
{{{GRAIL geobarometer}, {gtb, {lnK = -0.442639, GB7Calibration = Bohlen et al. (1983), GRAIL, sillimanite}},
{{500, 7739.89}, {600, 8488.94}, {700, 9237.99}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB8::usage = "
GB8: Chlorite - biotite - phengite geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference/Explanation\n
GB8Calibration -> 0 (default)    Bucher-Nurminen (1987), Contrib Mineral Petrol 96:519-522
                  1              Powell & Evans (1983), J metamorphic Geol 1:331-336
GB8Ah2o -> 1 (default)           define a(H2O) in the calculation.
                                 H2O-fugacity is calculated according to Holland & Powell (1991).\n
Example (using default calibration):\n
result = CalcThermoBaro[{{gb8,{600,800,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{chl-bt-wm barometer}, {gtb, {lnK = 10.6526, GB8Calibration = Bucher-Nurminen (1987)}},
{{600., 5207.41}, {700., 9867.89}, {800., 16072.5}}}}\n

Example (using calibration No. 1 and a(H2O) = 0.8): \n
SetOptions[GB8, GB8Calibration->1,GB8Ah2o->0.8];
result = CalcThermoBaro[{{gb8,{500,700,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{chl-bt-wm barometer}, {gtb, {lnK = 10.6526, GB8Calibration = Powell & Evans (1983)}},
{{500., 8293.66}, {600., 10807.2}, {700., 13368.8}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB9::usage = "
GB9: Garnet - amphibole - plagioclase geobarometer\n
Option for selecting a specific calibration:
Name              Value          Reference\n
GB9Calibration -> 0 (default)    Dale et al. (2000), tschermakite - tremolite reaction,
                                 Contrib Mineral Petrol 140:353-362
                  1              Dale et al. (2000), pargasite - tremolite reaction,
                                 Contrib Mineral Petrol 140:353-362
                  2              Dale et al. (2000), glaucophane - tremolite reaction,
                                 Contrib Mineral Petrol 140:353-362
                  3              Kohn & Spear (1990), tremolite - Mg-tschermakite reaction,
                                 Am Min 75:89-96
                  4              Kohn & Spear (1990), Fe-actinolite - Fe-tschermakite reaction,
                                 Am Min 75:89-96
                  5              Kohn & Spear (1989), tremolite - pargasite reaction, model 1
                                 Am Min 74:77-84
                  6              Kohn & Spear (1989), Fe-actinolite - Fe-pargasite reaction, model 1
                                 Am Min 74:77-84
                  7              Kohn & Spear (1989), tremolite - pargasite reaction, model 2
                                 Am Min 74:77-84
                  8              Kohn & Spear (1989), Fe-actinolite - Fe-pargasite reaction, model 2
                                 Am Min 74:77-84
Note that for the Dale et al. calibrations Fe(3+) in amphibole must have been calculated according to
Holland & Blundy (1994), which is achievd with:\n
CalcFormula[\"file_name\", Fe3Amph->HollandBlundy, CalcFormulaMode -> Gtb].\n
For the Kohn & Spear calibrations, Fe(3+) in amphibole must be calculated to a minimum value using
the method of Spear & Kimball (1984, Comp Geosci 10:317-325), which is equivalent to the method of
Leake et al. (1997, Eur J Mineral 9:623-651), whereas no Fe(3+)-recalculation is permitted for garnet:
CalcFormula[\"file_name\", Fe3Amph->LeakeFe3Min, Fe3Grt->NoCalculation, CalcFormulaMode -> Gtb].\n
Example using default calibration and the following analyses of amphibole, garnet and plagioclase
(sample 2468 of Hoschek (1998), Neues Jahrb Mineral Abh 173:155-187):\n
Label   Mineral SiO2    TiO2    Al2O3   FeO     MnO     MgO     CaO     Na2O    K2O    Fe2O3
1       amph    41.03   0.35    18.66   17.41   0.05    7.3     10.95   1.48    0.45   0
2       grt     37.74   0.05    22.06   30.73   0.76    2.42    7.4     0       0      0
3       plag    54.36   0.01    30.08   0       0       0.03    10.98   5.06    0.1    0.044\n
result = CalcThermoBaro[{{gb9, {500, 700, 100}}}, file_name, \"test\"]\n	
ReturnValue:
{{{grt-amph-plag barometer}, {file_name, {lnK = 2.65922, GB9Calibration = Dale et al. (2000), reaction (1):
Tschermakite-tremolite}}, {{500., 6281.7}, {600., 7699.24}, {700., 9116.79}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB10::usage = "
GB10 Albite = jadeite + quartz reaction: GB10\n
Option for selecting a specific calibration:
Name               Value          Reference/Explanation\n
GB10Calibration -> 0 (default)    Holland (1980), Am Min 65:129-134,
                                  a(jd) as in THERMOCALC
GB10Xab -> 1 (default)            X(Ab) in the calculation
GB10Xan -> 0 (default)            X(An) in the calculation
GB10Xor -> 0 (default)            X(Or) in the calculation\n
Example:
result = CalcThermoBaro[{{gb10, {500, 700, 100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{Ab = Jd+Qz barometer}, {gtb, {lnK = 2.41973, GB10Calibration = Holland (1980), a(jd) as in THERMOCALC}},
{{500., 7073.43}, {600., 7341.33}, {700., 7609.23}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB11::usage = "
GB11: Garnet - phengite - omphacite geobarometer for phengite eclogites\n
This barometer is based on the reaction Py + 2 Gro + 3 Cel = 6 Di + 3 Ms.
Option for selecting a specific calibration:
Name               Value          Reference/Explanation\n
GB11Calibration -> 0 (default)    Waters & Martin (1996)
                                  http://www.earth.ox.ac.uk/~davewa/research/ecbarcal.html
                                  for ordered P2/n cpx (below T(crit) = 865 C)
GB11Calibration -> 1              Waters & Martin (1996)
                                  http://www.earth.ox.ac.uk/~davewa/research/ecbarcal.html
                                  for disordered C2/c cpx
GB11Calibration -> 2              Waters & Martin (1993), Terra Abstracts 5:410-411
                                  using a(di) = X(di)\n
Calibrations 0 and 1 are programed as described on the cited web-page. 
For further details on activity models see: http://www.earth.ox.ac.uk/~davewa/research/ecbarcal.html.
In case of ordered P2/n omphacite, application of equ.12b of Holland (1990, CMP 105:446-453) requires
that di-hed-jd-ac are projected to pseudo-binary form. As an approximation, di + hed are taken together as X(di),
the rest to 1-X(ac) is then X(jd), X(di) and X(jd) are then normalized to unity.
Above T(crit) = 865 C, the equations for disordered C2/c cpx are used in any case.
result = CalcThermoBaro[{{gb11,{500,700,100}}},\"grtwmcpx\",\"out\"].\n
ReturnValue:
{{{grt-phe-omph barometer},{grtwmcpx,{lnK = 5.58463, GB11Calibration = Waters & Martin (1996): ordered P2/n omph}},
{{500.,30331.1},{600.,29368.1},{700.,28707.9}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB12::usage = "
GB12: Amphibole - chlorite geobarometer\n
Reference: M. Chou (cited in Laird (1988): Chlorites: Metamorphic petrology, Reviews in Mineralogy, Vol. 19, p.442).
This barometer uses the pressure dependence of FeMg-1 between actinolite and chlorite in low grade metabasites.
The barometer equation is not temperature dependent.
Example:\n
result = CalcThermoBaro[{{gb12,{500,700,100}}},\"gtb\",\"test\"].\n
ReturnValue:
{{{amph-chl barometer}, {gtb, {lnKD = 0.394609, GB12Calibration = Cho, M. (cited in Laird, 1988)}},
{{500, 4643.4}, {600, 4643.4}, {700, 4643.4}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB13::usage = "
GB13: Al-in-hornblende geobarometer\n
Option for selecting a specific calibration:
Name               Value          Reference  \n
GB13Calibration -> 0 (default)    Anderson & Smith (1995), Am Min 80: 549-559
                   1              Schmidt (1992), Contrib Mineral Petrol 110: 304-310
                   2              Johnson & Rutherford (1989), Geology 17: 837-841\n
Example:\n
result = CalcThermoBaro[{{gb13,{500,700,100}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{Al-in-hornblende barometer}, {gtb, {lnKD = {}, GB13Calibration = Anderson & Smith (1995)}},
{{500., 6453.9}, {600., 6799.18}, {700., 5898.81}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB14::usage = "
GB14: Al-in-opx geobarometer\n
Reference: Brey & Köhler (1990), J Petrology 31:1353-1378
Example using the worked example data in Brey & Köhler (1990):\n
Label   Mineral SiO2    TiO2    Al2O3   Cr2O3   FeO     MnO     MgO     CaO     Na2O
1       opx     56.9990 0       1.2515  0.2634  6.4200  0       33.5275 1.5386  0
2       grt     42.2545 0.2898  22.2284 2.2268  7.4084  0.2827  20.7301 4.5881  0\n
result = CalcThermoBaro[{{gb14, {1390, 1490, 100}}},\"file_name\",\"test\"]\n
ReturnValue:
{{{Al-in-opx barometer},{file_name,{lnKD = 3.46798,GB14Calibration = Brey & Köhler (1990)}},
{{1390.,59257.3},{1490.,65999.2}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB15::usage = "
GB15: Garnet - orthopyroxene - plagioclase - quartz geobarometer\n
Option for selecting a specific calibration:
Name               Value          Reference  \n
GB15Calibration -> 0 (default)    Lal (1993), Mg-reaction (C), J metamorphic Geol 11:855-866
                   1              Lal (1993), Fe-reaction (B), J metamorphic Geol 11:855-866
                   2              Bhattacharya et al. (1991), Mg-reaction (B), J Petrology 32:629-656
                   3              Bhattacharya et al. (1991), Fe-reaction (C), J Petrology 32:629-656
                   4              Eckert et al. (1991), Mg-reaction (A), Am Min 76:148-160
                   5              Newton & Perkins (1982), Mg-reaction (A), Am Min 67:203-222\n 
Example (using default calibration):\n
result = CalcThermoBaro[{{gb15, {500, 600, 50}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-opx-plag-qz barometer}, {gtb, {lnK = -4.84039, GB15Calibration = Lal (1993), Mg-reaction (C)}},
{{500., 1251.02}, {550., 876.471}, {600., 501.927}}}}\n
Example (using calibration No. 3): \n
SetOptions[GB15, GB15Calibration -> 3];
result = CalcThermoBaro[{{gb15, {500, 600, 50}}},\"gtb\",\"test\"]\n
ReturnValue:
{{{grt-opx-plag-qz barometer},{gtb,{lnK = -0.493987, GB15Calibration = Bhattacharya et al. (1991),
Fe-reaction (C)}},{{500.,5750.92},{550.,6355.78},{600.,6960.63}}}}\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."

GB16::usage = "
GB16: Garnet - clinopyroxene - plagioclase - quartz geobarometer\n
Option for selecting a specific calibration:
Name               Value          Reference\n
GB16Calibration -> 0 (default)    Eckert et al. (1991), Mg-reaction (B), Am Min 76:148-160
                   1              Newton & Perkins (1982), Mg-reaction (B), Am Min 67:203-222\n
Example for function call (using default calibration):\n
result = CalcThermoBaro[{{gb16, {500, 600, 50}}},\"gtb\",\"test\"]\n
ReturnValue:
Example (using calibration No. 1): \n
SetOptions[GB16, GB16Calibration -> 1];
result = CalcThermoBaro[{{gb16, {500, 600, 50}}},\"gtb\",\"test\"]\n
Package name: GTB.m
PET: Petrological Elementary Tools, (c) Edgar Dachs."


Begin["`Private`"]

GGT1[p_,grt_,bt_,GTB`GT1Calibration_] := (* GT1: Garnet - biotite FeMg-1 exchange geothermometer  *)
	Block[{r1=8.3143,r2=1.987,kd,xfegt,xmggt,xcagt,xmngt,xkbt,xfebt,xmgbt,xalvibt,xtibt,xohbt,xfbt,t,res,g,kygt,gex,
	wfemg,wmgfe,aal,apy,tt,kybt,mode=GTB`GT1Calibration,grt22},
	If[mode < 0 || mode > 22, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	grt22 = {{xcagt,xmggt,xfegt,xmngt},{1,0}};	(* for call of -ActivityB-  *)
	{xmgbt,xfebt,xtibt,xalvibt,xohbt} = bt[[3, 2, 1]]; xfbt = 1-xohbt;
	kd = (xmggt xfebt)/(xfegt xmgbt);
	If[mode == 22, mode = "Thompson (1976), Table 1";
	  g = -1.56+2739.646/t+0.0234(p-1)/t-Log[1/kd];
	  res = Solve[g == 0,t][[1,1,2]]-273.15];	
	If[mode == 21, mode = "Goldman & Albee (1977), eq.(9), with Bottinga & Javoy (1973) 1000ln(alfa-Qz/Mag)";
	  g = -0.177 5.57(10^6/tt^2)-1.22 xmngt-2.14 xcagt+1.4 xfebt+0.942 xtibt-1.59 xalvibt-0.492-Log[kd];
	  res = FindRoot[g == 0,{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 20, mode = "Goldman & Albee (1977), eq.(9), with Matthews et al. (1983) 1000ln(alfa-Qz/Mag)";
	  g = -0.177 6.61(10^6/tt^2)-1.22 xmngt-2.14 xcagt+1.4 xfebt+0.942 xtibt-1.59 xalvibt-0.492-Log[kd];
	  res = FindRoot[g == 0,{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 19, mode = "Holdaway & Lee (1977), Table 7";
	  g = 6150 - t 3.93 + .0246 p + 1.987 t Log[kd];
	  res = Solve[g == 0,t][[1,1,2]]-273.15];	
	If[mode == 18, mode = "Ferry and Spear (1978), eq. (7)";
	  g = 12454 - 4.662 t + 0.057 p + 3r2 t Log[kd];
	  res = Solve[g == 0,t][[1,1,2]]-273.15];	
	If[mode == 17, mode = "Lavrent'yeva & Perchuk (1981), eq.(8)";
	  res = (1000)/(0.9901+0.3144Log[Log[1/kd]])-273.15];
	If[mode == 16, mode = "Hodges & Spear (1982), eq.(9)";
	  kygt = (3300-1.5 t)(xcagt^2+xfegt xcagt+xcagt xmngt+xmggt xcagt)/(r2 t);
	  g = 12454 - 4.662 t + 0.057 p + 3r2 t Log[kd] + 3r2 t kygt;
	  res = Solve[g == 0,t][[1,1,2]]-273.15];	
	If[mode == 15, mode = "Pigage & Greenwood (1982)";
	  res = (1586xcagt+1308xmngt+2089+0.00956p)/(0.78198-Log[kd])-273.15];
	If[mode == 14, mode = "Perchuk & Lavrenteva (1983), eq.(31)";
	  res = (7843.7+(.0577+.0246)/2(p-6000))/(r2 Log[1/kd]+5.699)-273.15];
	If[mode == 13, mode = "Ganguly & Saxena (1984), symmetric, eq. (12), (13), (14)";
	  wfemg = (xfegt 2500 + xmggt 200)/(xfegt+xmggt);
	  res = (1175.06+p .00945+(wfemg(xfegt-xmggt)+3000 xcagt+3000 xmngt)/r2)/(.782-Log[kd])-273.15];	
	If[mode == 12, mode = "Ganguly & Saxena (1984), asymmetric, eq.(12), (13), (A1), (A2)";
	  aal = ActivityB[p,tt,ToExpression["alm"],grt22,ActivityModelGrt->GrtGangulySaxena,ActivityMode -> ActivityCoefficient][[1]];
	  apy = ActivityB[p,tt,ToExpression["py"], grt22,ActivityModelGrt->GrtGangulySaxena,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = (apy/aal)^(1/3);
	  res = FindRoot[tt==(1175.06+p .00945)/(.782-Log[kd kygt]),{tt,300,1500}][[1,2]]-273.15];
	If[mode == 11, mode = "Indares & Martignole (1985), model A, eq.(18)";
	  res = FindRoot[tt==(12454+.057 p+3(-464 xalvibt-6767 xtibt)-3(-(3300-1.5 tt))xcagt)/
	                 (4.662-5.9616 Log[kd]),{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 10, mode = "Indares & Martignole (1985), model B, eq.(19)";
	  res = (12454+.057 p+3(-1590 xalvibt-1451 xtibt)-3(-3000(xcagt+xmngt)))/(4.662-5.9616 Log[kd])-273.15];
	If[mode == 9, mode = "Hoinkes (1986)";
	  res = (2089+0.00956 p)/(0.7821-Log[kd]-2.978 xcagt+5.906 xcagt^2)-273.15];
	If[mode == 8, mode = "Aranovich et al. (1988), cited in Perchuk (1991), eq.(9)";
	  res = (3873.1+2871 xcagt+0.0124 p-957 3xalvibt)/(Log[1/kd]+2.609+1.449 xcagt+0.287 3xalvibt+0.503 xfbt)-273.15];
	If[mode == 7, mode = "Williams & Grambling (1990) eq.(13)";
	  res = (-17042-.0795p+1579-2000(xfegt-xmggt)-12550xcagt-8230xmngt)/(8.3143(Log[kd]-0.782+Log[.9]))-273.15];
	If[mode == 6, mode = "Dasgupta et al. (1991) eq.(5)";
	  res = (4301+3000 xcagt+1300 xmngt-495(xmggt-xfegt)-3595 xalvibt-4423 xtibt+1073(xmgbt-xfebt)+
	        0.0246 p)/(1.85 - 1.987 Log[kd])-273.15];
	If[mode == 5, mode = "Bhattacharya et al. (1992), Hackler & Wood (1984) garnet model";
	  res = (20286+.0193 p -(2080 xmggt^2-6350 xfegt^2-13807 xcagt(1-xmngt)+8540 xfegt xmggt(1-xmngt)+
	        4215 xcagt(xmggt-xfegt))+4441(2xmgbt-1))/(13.138+8.3143 Log[1/kd]+6.276 xcagt(1-xmngt))-273.15];
	If[mode == 4, mode = "Bhattacharya et al. (1992), Ganguly & Saxena (1984) garnet model";
	  res = (13538+.0193 p -(837 xmggt^2-10460 xfegt^2-13807 xcagt(1-xmngt)+19246 xfegt xmggt(1-xmngt)+
	        5649 xcagt(xmggt-xfegt))+7972(2xmgbt-1))/(6.778+8.3143 Log[1/kd]+6.276 xcagt(1-xmngt))-273.15];    
	If[mode == 3, mode = "Kleemann & Reinhardt (1994), eq.(5), (19), with Berman 1990 garnet model";
	  aal = ActivityB[p,tt,ToExpression["alm"],grt22,ActivityModelGrt->GrtBerman,ActivityMode -> ActivityCoefficient][[1]];
	  apy = ActivityB[p,tt,ToExpression["py"], grt22,ActivityModelGrt->GrtBerman,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = (apy/aal)^(1/3);
	  kybt = Exp[(-77785 xalvibt + 18138 xtibt + 94.1 xalvibt tt - 11.7 xtibt tt)/(r1 tt)];     
	  g = 20253 - 10.66 tt + 0.108(p-1) + r1 tt Log[kd kygt/kybt];
	  res = FindRoot[g == 0,{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 2, mode = "Holdaway et al. (1997)";
	  aal = ActivityB[p,tt,ToExpression["alm"],grt22,ActivityModelGrt->GrtMukhopadhyay,ActivityMode -> ActivityCoefficient][[1]];
	  apy = ActivityB[p,tt,ToExpression["py"], grt22,ActivityModelGrt->GrtMukhopadhyay,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = apy/aal;
	  gex =  r1 tt Log[kygt]+(40719-30tt)(xmgbt-xfebt)+(210190-245.4tt)xalvibt+(310990-370.39tt)xtibt;	  
	  g = 40719 - 10.35tt + 0.311p +3r1 tt Log[kd] + gex;
	  res = FindRoot[g == 0,{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 1, mode = "Gessmann et al. (1997), eq.(5)";
	  aal = ActivityB[p,tt,ToExpression["alm"],grt22,ActivityModelGrt->GrtBerman,ActivityMode -> ActivityCoefficient][[1]];
	  apy = ActivityB[p,tt,ToExpression["py"], grt22,ActivityModelGrt->GrtBerman,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = aal/apy;
	  gex = r1 tt Log[kygt] -(-7548)(xmgbt-xfebt)-(-56572)xalvibt;	  
	  g = -57594 - 0.236(p-1) + tt 24.44 + 3r1 tt Log[1/kd] + gex;
	  res = FindRoot[g == 0,{tt,700,800}][[1,2]]-273.15];
	If[mode == 0, mode = "Holdaway (2000)";
	  aal = ActivityB[p,tt,ToExpression["alm"],grt22,ActivityModelGrt->GrtHoldaway,ActivityMode -> ActivityCoefficient][[1]];
	  apy = ActivityB[p,tt,ToExpression["py"], grt22,ActivityModelGrt->GrtHoldaway,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = apy/aal; (* three-site gamma *)
	  gex =  r1 tt Log[kygt]+(22998-17.396tt)(xmgbt-xfebt)+(245559-280.306tt)xalvibt+(310990-370.39tt)xtibt;	  
	  g = 40198 - 7.802tt + 0.295p +3r1 tt Log[kd] + gex;
	  res = FindRoot[g == 0,{tt,300,1500}][[1,2]]-273.15];	
	  
	res = ToExpression[ToString[NumberForm[res ,{10,2}]]];
	Return[{{res,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT1Calibration = ",mode]}}]]
Options[GT1] = {GTB`GT1Calibration->0};
GT1[p_,grt_,bt_,opts___] := GGT1[p,grt,bt,GTB`GT1Calibration/.{opts}/.Options[GT1]];

GGT2[p_,grt_,wm_,GTB`GT2Calibration_] := (* GT2: Garnet - phengite FeMg-1 exchange geothermometer *)
	Block[{mode=GTB`GT2Calibration,xfegt,xmggt,xcagt,xmngt,xfewm,xmgwm,kd,t,wfemg,lnk,tt,res,dummy},
	If[mode < 0 || mode > 4, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xfewm,xmgwm,dummy} = wm[[3, 2, 1]]; 	
	kd = (xfegt xmgwm)/(xmggt xfewm);
	If[mode == 0, mode = "Hynes & Forest (1988)";
	  wfemg = 200(xmggt/(xmggt+xfegt))+2500(xfegt/(xmggt+xfegt));
	  lnk = Log[kd]+(0.8 wfemg-wfemg(xfegt-xmggt)-3000 xmngt)/(1.987 tt)-2.978 xcagt(844/tt)+5.906(xcagt 844/tt)^2;
	  t = FindRoot[tt==4790/(lnk+4.13),{tt,300,1500}][[1,2]]-273.15];	
	If[mode == 1, mode = "Green & Hellman (1982), eq. (c), basaltic system: CaO > 2 wt%";
	  t = (5170+0.036 p)/(Log[kd]+4.17)-273.15];	
	If[mode == 2, mode = "Green & Hellman (1982), eq. (b), pelitic system:  CaO <= 2 wt%, mg poor";
	  t = (5680+0.036 p)/(Log[kd]+4.48)-273.15];	
	If[mode == 3, mode = "Green & Hellman (1982), eq. (a), pelitic system: CaO <= 2 wt%, mg rich";
	  t = (5560+0.036 p)/(Log[kd]+4.65)-273.15];	
	If[mode == 4, mode = "Krogh & Raheim (1978)";
	  t = (3685+0.0771 p)/(Log[kd]+3.52)-273.15];	
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT2Calibration = ",mode]}}]]
Options[GT2] = {GTB`GT2Calibration->0};
GT2[p_,grt_,wm_,opts___] := GGT2[p,grt,wm,GTB`GT2Calibration/.{opts}/.Options[GT2]];

GGT3[p_,grt_,chl_,GTB`GT3Calibration_] := (* GT3: Garnet - chlorite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT3Calibration,xfegt,xmggt,xcagt,xmngt,xfechl,xmgchl,kd,t,g,tt},
	If[mode < 0 || mode > 3, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xfechl,xmgchl} = chl[[3, 2, 1]]; 
	kd = (xmggt xfechl)/(xfegt xmgchl);
	If[mode == 0, mode = "Perchuk (1991), eq.(18)";
	  t = (3973)/(Log[1/kd]+2.773)-273.15];	
	If[mode == 1, mode = "Grambling (1990)";
	  g = 0.05-19.02 tt+4607 Log[kd]+24156;
	  t = Solve[g == 0,tt][[1,1,2]]-273.15];	
	If[mode == 2, mode = "Ghent et al. (1987), eq.(8a)";
	  t = (2109.92+0.00608 p)/(.6867-Log[kd])-273.15];	
	If[mode == 3, mode = "Dickensen & Hewitt (1986), modified in Laird (1989)";
	  t = (55841+0.212 p)/(10.76-1.987 15Log[kd])-273.15];	
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT3Calibration = ",mode]}}]]
Options[GT3] = {GTB`GT3Calibration->0};
GT3[p_,grt_,chl_,opts___] := GGT3[p,grt,chl,GTB`GT3Calibration/.{opts}/.Options[GT3]];

GGT4[p_,bt_,chl_,GTB`GT4Calibration_] := (* GT4: Biotite - chlorite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT4Calibration,xfebt,xmgbt,xfechl,xmgchl,kd,t,g,tt,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xmgbt,xfebt,dummy,dummy,dummy} = bt[[3, 2, 1]];
	{xfechl,xmgchl} = chl[[3, 2, 1]]; 
	kd = (xmgchl xfebt)/(xfechl xmgbt);
	If[mode == 0, mode = "Dickensen & Hewitt (1986)";
	  g = 6429-12.547 tt+.073 p+15 tt 1.987 Log[kd];
	  t = Solve[g == 0,tt][[1,1,2]]-273.15];	
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT4Calibration = ",mode]}}]]
Options[GT4] = {GTB`GT4Calibration->0};
GT4[p_,bt_,chl_,opts___] := GGT4[p,bt,chl,GTB`GT4Calibration/.{opts}/.Options[GT4]];

GGT5[p_,wm_,bt_,GTB`GT5Calibration_] := (* GT5: Phengite - biotite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT5Calibration,xmgbt,xalvibt,xmgwm,xalviwm,kd,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xmgbt,dummy,dummy,xalvibt,dummy} = bt[[3, 2, 1]];
	{xfewm,xmgwm,xalviwm} = wm[[3, 2, 1]]; 
	kd = 27(xmgwm/xalviwm)/(xmgbt/xalvibt);
	If[mode == 0, mode = "Hoisch (1989)";
	  t = (500.11+.014789 p-878.745(xmgbt-xalvibt)-4532.67(xmgwm(xmgwm-2)))/
	      (1+.0237527 8.3144 Log[kd])-273.15];	
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT5Calibration = ",mode]}}]]
Options[GT5] = {GTB`GT5Calibration->0};
GT5[p_,wm_,bt_,opts___] := GGT5[p,wm,bt,GTB`GT5Calibration/.{opts}/.Options[GT5]];

GGT6[p_,grt_,fetiox_,GTB`GT6Calibration_] := (* GT6: Garnet-Ilmenite FeMn-1 exchange geothermometer  *)
	Block[{mode=GTB`GT6Calibration,xfegt,xmggt,xcagt,xmngt,xfeilm,xmnilm,kd,t,aal,asp,tt,g,dummy},
	If[mode < 0 || mode > 2, mode = 0];
	{xfeilm,xmnilm,dummy} = fetiox[[3, 2, 1]];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	kd = (xmngt xfeilm)/(xfegt xmnilm);
	If[mode == 0, mode = "Pownceby et al. (1991)";
	  t = (14918-2200(2xmnilm-1)+620(xmngt-xfegt)-972xcagt)/(8.3143 Log[kd]+4.38)-273.15];
	If[mode == 1, mode = "Pownceby et al. (1987), corrected (1987)";
	  t = (-4089+420(2xmnilm-1)-77(2xmngt-1))/(-1.987 Log[kd]-1.44)-273.15];
	If[mode == 2, mode = "Pownceby et al. (1987) with Ganguly & Saxena (1984) garnet model";
	  aal = ActivityB[p,tt,ToExpression["alm"],{{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtGangulySaxena,ActivityMode -> ActivityCoefficient][[1]];
	  asp = ActivityB[p,tt,ToExpression["spi"], {{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtGangulySaxena,ActivityMode -> ActivityCoefficient][[1]];
	  kygt = (asp/aal)^(1/3);
	  g = 4089-1.44 tt -420(2xmnilm-1)-1.987 tt Log[kd kygt];
	  t = FindRoot[g == 0, {tt,300,1500},MaxIterations->30][[1,2]]-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT6Calibration = ",mode]}}]]
Options[GT6] = {GTB`GT6Calibration->0};
GT6[p_,grt_,fetiox_,opts___] := GGT6[p,grt,fetiox,GTB`GT6Calibration/.{opts}/.Options[GT6]];

Ex[xmgm1_,xfem1_,xalm1_,xmggrt_,xfegrt_,xcagrt_,flag_] := (* subfunction of GGT7 *) 
	Block[{wh12cpx=-1910,ws12cpx=-1.05,wv12cpx=0,wh1323cpx=11180,ws1323cpx=0,wv1323cpx=0,
		wh112=67530,ws112=13.3,wv112=0.214,wh122=43040,ws122=13.3,wv122=0.017,wh113=8610,
		ws113=0,wv113=0.17,wh133=3400,ws133=0,wv133=0.09,wh223=600,ws223=0,wv223=0.01,
		wh233=1810,ws233=0,wv233=0.06,wh123=62490,ws123=13.3,wv123=0.281,w112,w122,w113,
		w133,w223,w233,w123,w12cpx,w1323cpx,ex,y1=xmgm1,y2=xfem1,y3=xalm1,x1=xcagrt,x2=xmggrt,x3=xfegrt},
	wh1323cpx=0;
	If[flag == 1, (* Hex *)
	  w12cpx = wh12cpx; w1323cpx = wh1323cpx;
	  w112 = wh112; w122 = wh122; w113 = wh113;
	  w133 = wh133; w223 = wh223; w233 = wh233; w123 = wh123];
	If[flag == 2, (* Sex *)
	  w12cpx = ws12cpx; w1323cpx = ws1323cpx;
	  w112 = ws112; w122 = ws122; w113 = ws113;
	  w133 = ws133; w223 = ws223; w233 = ws233; w123 = ws123];
	If[flag == 3, (* Vex *)
	  w12cpx = wv12cpx; w1323cpx = wv1323cpx;
	  w112 = wv112; w122 = wv122; w113 = wv113;
	  w133 = wv133; w223 = wv223; w233 = wv233; w123 = wv123];
	ex = 3w12cpx(y2-y1)+3 w1323cpx y3 - w112 x1^2 - w122 2x1 x2 + w113 x1^2
    	     + w133 2x1 x3 + w223 (x2^2-2x2 x3) + w233(2x2 x3-x3^2)-w123(x1 x3-x1 x2);
	Return[ex]]

GGT7[p_,grt_,cpx_,GTB`GT7Calibration_] := (* GT7: Garnet-Clinopyroxene FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT7Calibration,
	femggt,xcagt,xmggt,xfegt,xmngt,xmgs,
	femgcpx,xfem1cpx,xmgm1cpx,xalm1cpx,xwo,xen,xfs,xal,mgno,
	       kd,t,g,tt,r=8.3143,so=-25.99,ho=-64420,vo=-0.312,hex,sex,vex,a,b,c,ao,
	       bo,co,do,a1,b1,c1,d1,x,lngfe,lngmg,q1,q2,dummy},
	If[mode < 0 || mode > 12, mode = 0];

    	{femggt,xcagt,xmggt,xfegt,xmngt,xmgs} = grt[[3, 2, 2]];
    	{femgcpx,xmgm1cpx,xfem1cpx,xalm1cpx,xmgm2cpx,xfem2cpx} = cpx[[3, 2, 1]];
    	kd = femggt/femgcpx;

    	If[mode == 0, mode = "Krogh (2000)";    	
	  t = ((1939.9+3270*xcagt-1396*xcagt^2+3319*xmngt-3535*xmngt^2+1105*xmgs-
	       3561*xmgs^2+2324*xmgs^3+169.4*10^(-4)*p)/(Log[kd]+1.223)) - 273.15];	  	  
    	If[mode == 1, mode = "Berman et al. (1995)";    	    
           hex = Ex[xmgm1cpx,xfem1cpx,xalm1cpx,xmggt,xfegt,xcagt,1];
   	   sex = Ex[xmgm1cpx,xfem1cpx,xalm1cpx,xmggt,xfegt,xcagt,2];
           vex = Ex[xmgm1cpx,xfem1cpx,xalm1cpx,xmggt,xfegt,xcagt,3];
	   a = 1.762 10^-7(p-1);
	   b = 3 r Log[kd] - so - sex - 1.4017 10^-4(p-1);
	   c = ho + hex + (p-1)(vo + vex + 0.02613)+4.0335 10^-7 p^2 + 4.7 10^-12 p^3;
	   t = (-b+(b^2-4a c)^0.5)/(2a) - 273.15];
     	If[mode == 2, mode = "Ai (1994)";
	  mgno = 100*xmgs;
	  t = ((-1629 xcagt^2 + 3648.55 xcagt - 6.59 mgno + 1987.98 + 0.01766 p)/(Log[kd] + 1.076)) - 273.15;
	  ];

   	If[mode == 3, mode = "Pattison & Newton (1989)";
      	If[xcagt >= .2 && xcagt <= .5,
          x = xmgs;
          ao = Interpolation[{{.2,3.606},{.3,15.87},{.4,14.64},{.5,9.408}}];
          bo = Interpolation[{{.2,-5.172},{.3,-20.3},{.4,-18.72},{.5,-12.37}}];
          co = Interpolation[{{.2,2.317},{.3,7.468},{.4,6.94},{.5,4.775}}];
          do = Interpolation[{{.2,0.1742},{.3,-0.1479},{.4,-0.2583},{.5,-0.2331}}];
          a1 = Interpolation[{{.2,26370},{.3,43210},{.4,44900},{.5,38840}}];
          b1 = Interpolation[{{.2,-32460},{.3,-53230},{.4,-55250},{.5,-47880}}];
          c1 = Interpolation[{{.2,11050},{.3,18120},{.4,18820},{.5,16300}}];
          d1 = Interpolation[{{.2,1012},{.3,776},{.4,712},{.5,859}}];
	  t = (a1[xcagt]x^3+b1[xcagt]x^2+c1[xcagt]x+d1[xcagt])/
	      (Log[kd]+ao[xcagt]x^3+bo[xcagt]x^2+co[xcagt]x+do[xcagt])+5.5(p/1000-15)-273.15,
	  t = "garnet-composition outside range"]];
    	If[mode == 4, mode = "Sengupta et al. (1989)";
      	  lngfe = xcagt^2(1.52-5.17xfegt)+xmggt^2(0.1+2.26xfegt)+xcagt xmggt(3.01-6.67xfegt+1.5xcagt-
                  1.5xmggt)+xcagt xmngt(.98-4.08xfegt)+xmggt xmngt(.02+3.71 xfegt);
      	  lngmg = xfegt^2(1.23-2.26xmggt)+xcagt^2(-0.26+3xmggt)+xfegt xcagt(3.53-4.85xmggt+2.58xfegt-
                  2.58xcagt)+xfegt xmngt(1.3-2.75xmggt)+0.78xmngt^2+xcagt xmngt(1.27+3xmggt);
	  t = (3030+0.01086 p)/(Log[kd]+1.9034+lngfe-lngmg)-273.15];
    	If[mode == 5, mode = "Krogh (1988)";
	  t = (-6173 xcagt^2+6731xcagt+1879+.01p)/(Log[kd]+1.393)-273.15];
    	If[mode == 6, mode = "Powell (1985)";
	  t = (2790+0.01 p+3140 xcagt)/(Log[kd]+1.735)-273.15];
   	If[mode == 7, mode = "Dahl (1980)";
	  t = (2324+0.022 p+1509(xfegt-xmggt)+2810xcagt+2855xmngt)/(1.987Log[kd])-273.15];
    	If[mode == 8, mode = "Ellis & Green (1979)";
	  t = (3104 xcagt+3030+.01086 p)/(Log[kd]+1.9034)-273.15];
    	If[mode == 9, mode = "Ganguly (1979)";
	  g = (4801+0.01107 p)/tt-2.93+1586/tt xcagt-Log[kd];
	  t = FindRoot[g == 0, {tt,300,1500},MaxIterations->30][[1,2]]-273.15];
    	If[mode == 10, mode = "Saxena (1979)";
	  {xfs,xen,xwo,xal} = cpx[[3, 2, 2]];	  
	  q1 = 2710(xfegt-xmggt)+3150xcagt+2600xmngt;
	  q2 = -6594(xfs(xfs-2xen))-12762(xfs-xen(1-xfs))-11281(xwo(1-xal)-2xen xwo)+6137(xwo(2xen+xal))+
	       35791(xal(1-2xen))+25409xwo^2-55137(xwo(xen-xfs))-11338(xal(xfs-xen));
	  t = (8288+0.0276p+q1-q2)/(1.987Log[kd]+2.4083)-273.15];
    	If[mode == 11, mode = "Mori & Green (1978)";
	  t = 2800/(Log[kd]+1.19)-273.15];
    	If[mode == 12, mode = "Raheim & Green (1974)";
	  t = (3686+.02835 p)/(Log[kd]+2.33)-273.15];
	  	  
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT7Calibration = ",mode]}}]]
Options[GT7] = {GTB`GT7Calibration->0};
GT7[p_,grt_,cpx_,opts___] := GGT7[p,grt,cpx,GTB`GT7Calibration/.{opts}/.Options[GT7]];

GGT8[p_,plag_,wm_,GTB`GT8Calibration_] := (* GT8: Plagioklas - muscovite NaK-1 exchange geothermometer *)
	Block[{mode=GTB`GT8Calibration,xms,xpa,xab,xan,xor,lnkd,a,b,c,d,e,f,g,h},
	If[mode < 0 || mode > 0, mode = 0];
	{xms,xpa} = wm[[3, 2, 2]];	
	{xab,xan,xor} = plag[[3, 2, 1]];
    	If[mode == 0, mode = "Green & Usdansky (1986)";
	  a = 1-4xms+5xms^2-2xms^3-2xpa+4xpa^2-2xpa^3;
	  b = 2xms-4xms^2+2xms^3+4xpa-5xpa^2+2xpa^3-1;
	  c = 2xab xor^2+0.5xor xan-xab^2+2xor xab^2-0.5xan xab+2xor xan xab;
	  d = xor^2-2xab xor^2+0.5xor xan-2xor xab^2-0.5xan xab-2xor xan xab;
	  e = 2xab xan^2+0.5xor xan+xor xan xab+0.5xan xab-xan xab(xan-xab);
	  f = xan^2-2xab xan^2+0.5xor xan-xan xab xor+0.5xan xab+xan xab(xan-xab);
	  g = -0.5xor xan-xan xor(xor-xan)-2xor xan^2-0.5xan xab-xor xan xab;
	  h = -0.5xor xan+xan xor(xor-xan)-xan^2+2xor xan^2-0.5xan xab+xor xan xab;
	  lnkd = Log[xms]+Log[xab(2-xab-xor)(xab+xor)]-Log[xpa]-Log[xor(2-xab-xor)(xab+xor)];
	  t = ((19456 a+12230 b+27320 c+18810 d+8473 e+28226 f-65407 g+65305.4 h-2087.6587)+
	      (p(-0.0431-0.456 a+0.6653 b+0.364 c+0.364 d+2.1121 g+0.9699 h)))/
	      (7.5805-8.3147 lnkd-1.6544 a-0.7104 b+10.3 c+10.3 d-114.104 g+12.5365 h)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[lnkd]],StringJoin["GT8Calibration = ",mode]}}]]
Options[GT8] = {GTB`GT8Calibration->0};
GT8[p_,plag_,wm_,opts___] := GGT8[p,plag,wm,GTB`GT8Calibration/.{opts}/.Options[GT8]];

GGT9[p_,grt_,opx_,GTB`GT9Calibration_] := (* GT9: Garnet - orthopyroxene FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT9Calibration,femggt,xfegt,xmggt,xcagt,xmngt,xmgs,femgopx,xfeopx,xmgopx,xalopx,A,B,kd,t,tt,g,
	dummy,feopx,mgopx,alopx,xen,xfs,xok,hoa,soa,voa,hxfs,hxok,hxalm,sxfs,sxok,sxalm,vxfs,vxok,vxalm},
	If[mode < 0 || mode > 9, mode = 0];

    	{femggt,xcagt,xmggt,xfegt,xmngt,xmgs} = grt[[3, 2, 2]];
    	{femgopx,xfeopx,xmgopx,xalopx} = opx[[3, 2, 3]];
	kd = femggt/femgopx;
	
    	If[mode == 0, mode = "Aranovich & Berman (1997): Alm = 3Fs + Al2O3";
    	  {feopx,mgopx,alopx,dummy,dummy,dummy,dummy,dummy} = opx[[3, 2, 4]];
	  xen = mgopx/2; xfs = feopx/2; xok = alopx/4; (* X(En), X(Fs), X(Ok) for 6-O formula  *)
	  hoa = 72767; soa = 16.79; voa = 1.58;
	  hxfs = -2600xen^2-32398xok^2-13120.4xen*xok;
	  sxfs = -1.342xen^2-1.342xen*xok;
	  vxfs = -0.883xok^2-0.497xen*xok;
	  hxok = -21878.4xen^2-32398.4xfs^2-51676.4xen*xfs+26534.9xfs/(xfs+xen);
	  sxok = 1.342xen*xfs+16.111xfs/(xfs+xen);
	  vxok = -0.386xen^2-0.883xfs^2-1.269xen*xfs+0.175xfs/(xfs+xen);
	  hxalm = 5064.5(xmggt^2-2xmggt^2*xfegt)+6249.1(xfegt*xmggt-2xmggt*xfegt^2)-66940xcagt^2*xmggt-
	          136560xcagt*xmggt^2+21951(xcagt^2-2xcagt^2*xfegt)+11581.5(xcagt*xfegt-2xcagt*xfegt^2)+
	          73298(xcagt*xmggt-2xcagt*xmggt*xfegt);
	  sxalm = 4.11(xmggt^2-2xmggt^2*xfegt)+4.11(xfegt*xmggt-2xmggt*xfegt^2)-18.79xcagt^2*xmggt-
	          18.79xcagt*xmggt^2+9.43(xcagt^2-2xcagt^2*xfegt)+9.43(xcagt*xfegt-2xcagt*xfegt^2)+
	          32.33(xcagt*xmggt-2xcagt*xmggt*xfegt);
	  vxalm = 0.01(xmggt^2-2xmggt^2*xfegt)+0.06(xfegt*xmggt-2xmggt*xfegt^2)-0.346xcagt^2*xmggt-
	          0.072xcagt*xmggt^2+0.17(xcagt^2-2xcagt^2*xfegt)+0.09(xcagt*xfegt-2xcagt*xfegt^2)+
	          0.281(xcagt*xmggt-2xcagt*xmggt*xfegt);
	  kd = xfs^3*xok/xfegt^3;
	  t = (-hoa-3hxfs-hxok+hxalm-p(voa-3vxfs-vxok+vxalm))/(8.3143Log[kd]-soa-3sxfs-sxok+sxalm) - 273.15;
	  ];
    	If[mode == 1, mode = "Lal (1993)";
     	  A = -1256xmggt^2-2880xfegt^2+8272xmggt xfegt+812xcagt(xmggt-xfegt)+90xcagt^2-2340xcagt(xfegt+xmggt)-
              3047xmggt xcagt-1813xfegt xcagt+xcagt(xfegt-xmggt)(-4498);
     	  B = xmggt^2+1.7xfegt^2-5.4xfegt xmggt-0.35xcagt(xmggt-xfegt)+1.5xcagt^2+1.666xcagt(xfegt-xmggt)+
              0.332xfegt xcagt+xcagt(xfegt-xmggt)1.516;
	  t = (3367+(p-1)0.024-A-948(xfeopx-xmgopx)-1950xalopx)/(1.987Log[kd]+1.634+B-0.34(xfeopx-xmgopx))-273.15];
    	If[mode == 2, mode = "Bhattacharya et al. (1991)";
	  t = (1611+.021p+906xcagt+(-1220xfegt xmggt-441xcagt(xmggt-xfegt)-136 xmggt^2+746 xfegt^2)+
	      477(2xmgopx-1))/(Log[kd]+.796)-273.15];
    	If[mode == 3, mode = "Lavrent'eva & Perchuk (1990)";
	  t = (4066-347(xmgopx-xfeopx)-17484xalopx+5769xcagt+.02342p)/(1.987Log[kd]+2.143+
	  	   0.0929(xmgopx-xfeopx)-12.8994xalopx+3.846xcagt)-273.15];
    	If[mode == 4, mode = "Lee & Ganguly (1988)";
	  g = 1/tt(3000xcagt/1.987+3000xmngt/1.987-297.75+0.01191p)-1.574Log[tt]-Log[kd]+12.067;
	  t = FindRoot[g == 0, {tt,300,1500},MaxIterations->30][[1,2]]-273.15];
    	If[mode == 5, mode = "Harley (1984)";
	  t = (3740+1400xcagt+0.02286p)/(1.987Log[kd]+1.96)-273.15];
    	If[mode == 6, mode = "Sen & Bhattacharya (1984)";
	  t = (2713+0.022p+3300xcagt+195(xfegt-xmggt))/(-1.9872Log[1/kd]+0.787+1.5xcagt)-273.15];
    	If[mode == 7, mode = "Kawasaki & Matsui (1983)";
	  g = -4740+2.16 tt + 1.987 tt Log[kd];
	  t = Solve[g == 0,tt][[1,1,2]]-273.15];	
    	If[mode == 8, mode = "Dahl (1980)";
	  t = (1391+1509(xfegt-xmggt)+2810 xcagt+2855 xmngt)/(1.987Log[kd])-273.15];
    	If[mode == 9, mode = "Mori & Green (1978)";
	  t = (1300)/(Log[kd]+.12)-273.15];
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT9Calibration = ",mode]}}]]
Options[GT9] = {GTB`GT9Calibration->0};
GT9[p_,grt_,opx_,opts___] := GGT9[p,grt,opx,GTB`GT9Calibration/.{opts}/.Options[GT9]];

GGT10[p_,opx_,cpx_,GTB`GT10Calibration_] := (* GT10: Orthopyroxene - clinopyroxene solvus  *)
	Block[{mode=GTB`GT10Calibration,cacpx,nacpx,mncpx,alcpx,crcpx,ticpx,fecpx,mgcpx,fe3cpx,
	caopx,naopx,mnopx,alopx,cropx,tiopx,feopx,mgopx,fe3opx,xfeopx,xfecpx,xmgopx,xmgcpx,
	xmgm1cpx,xmgm2cpx,xmgm1opx,xmgm2opx,kd="no value",caopxs,cacpxs,t,tt,dummy},
	If[mode < 0 || mode > 10 , mode = 0];

	{feopx,mgopx,alopx,caopx,naopx,xmgm1opx,dummy,xmgm2opx} = opx[[3, 2, 4]];	
	{fecpx,mgcpx,alcpx,cacpx,nacpx,xmgm1cpx,dummy,xmgm2cpx} = cpx[[3, 2, 4]];	
	xfeopx = feopx/(feopx+mgopx); xmgopx = mgopx/(feopx+mgopx);
	xfecpx = fecpx/(fecpx+mgcpx); xmgcpx = mgcpx/(fecpx+mgcpx);

	If[mode > 5, kd = (xmgm2cpx xmgm1cpx)/(xmgm2opx xmgm1opx)]; (* En(opx) = En(cpx) *)
	
	If[mode == 0, mode = "Brey & Koehler (1990): En(opx) = En(cpx)";
	  kd = (1-cacpx/(1-nacpx))/(1-caopx/(1-naopx));	  
	  t =(23664+(24.9+126.3 xfecpx)p/1000)/(13.38+Log[kd]^2+11.59 xfeopx)-273.15];
	If[mode == 1, mode = "Brey & Koehler (1990): Na partitioning";
	  kd = naopx/nacpx;
	  t =(35000+0.0615 p/1000)/(Log[kd]^2+19.8)-273.15];
	If[mode == 2, mode = "Brey & Koehler (1990): Ca-in-opx";
	  kd = caopx;
	  t =(6425+26.4 p/1000)/(-Log[kd]+1.843)-273.15];
	If[mode == 3, mode = "Bertrand & Mercier (1985): En(opx) = En(cpx), single px";
	  kd = (1-cacpx)/0.95;
	  t = (33696+0.04545 p)/(17.61-8.314Log[kd]-12.13 cacpx^2)-273.15];
	If[mode == 4, mode = "Bertrand & Mercier (1985): En(opx) = En(cpx), two px";
	  caopxs = caopx/(1-naopx); 
	  cacpxs = (cacpx/(1-nacpx)+(-0.77+10^-3*tt)xfecpx);
	  kd = (1-cacpxs)/(1-caopxs);
 	  t = FindRoot[tt == (36273+0.0399 p)/(19.31-8.3143 Log[kd]-12.15 cacpxs^2),
 	      {tt,300,1500},MaxIterations->30][[1,2]]-273.15;
 	  kd = kd /. tt ->(t+273.15);
 	  ]; 	      
    	If[mode == 5, mode = "Mori & Green (1978): Fe/Mg-exchange";
	  kd = (xfeopx/xmgopx)/(xfecpx/xmgcpx);
	  t = (1500)/(Log[kd]+1.07)-273.15];
	If[mode == 6, mode = "Wells (1977): En(opx) = En(cpx)";
	  t = 7341/(3.355+2.44 xfeopx-Log[kd])-273.15];
	If[mode == 7, mode = "Herzberg & Chapman (1976): En(opx) = En(cpx), 12 kb";
	  t = -8392/(Log[kd]-3.64)-273.15];
	If[mode == 8, mode = "Herzberg & Chapman (1976): En(opx) = En(cpx), 16 kb";
	  t = -8494/(Log[kd]-3.58)-273.15];
	If[mode == 9, mode = "Nehru & Wyllie (1974): En(opx) = En(cpx), 30 kb";
	  t = -5006/(Log[kd]-1.72)-273.15];
	If[mode == 10, mode = "Wood & Banno (1973): En(opx) = En(cpx)";
	  t = -10202/(Log[kd]-7.65 xfeopx+3.88 xfeopx^2-4.6)-273.15];
	  
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT10Calibration = ",mode]}}]]
Options[GT10] = {GTB`GT10Calibration->0};
GT10[p_,opx_,cpx_,opts___] := GGT10[p,opx,cpx,GTB`GT10Calibration/.{opts}/.Options[GT10]];

GGT11[p_,opx_,bt_,GTB`GT11Calibration_] := (* GT11: Orthopyroxene - biotite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT11Calibration,xfebt,xmgbt,xtibt,xalvibt,xfeopx,xmgopx,kd,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{dummy,xfeopx,xmgopx,dummy} = opx[[3, 2, 3]];	
	{xmgbt,xfebt,xtibt,xalvibt,dummy} = bt[[3, 2, 1]];
	kd = (xfeopx/xmgopx)/(xfebt/xmgbt);
    	If[mode == 0, mode = "Sengupta et al. (1990)";
	  t = (4130+603(xmgopx-xfeopx)-4423xtibt-3595xalvibt+0.017p)/(1.987Log[kd]+3.27)-273.15];
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT11Calibration = ",mode]}}]]
Options[GT11] = {GTB`GT11Calibration->0};
GT11[p_,opx_,bt_,opts___] := GGT11[p,opx,bt,GTB`GT11Calibration/.{opts}/.Options[GT11]];

GGT12[p_,grt_,ol_,GTB`GT12Calibration_] := (* GT12: Garnet - olivine FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT12Calibration,xfegt,xmggt,xcagt,xfeol,xmgol,kd,t,tt,pp=p/1000,dv,g,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xcagt,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{xfeol,xmgol} = ol[[3, 2, 1]];
	kd = (xmgol xfegt)/(xmggt xfeol);
    	If[mode == 0, mode = "O'Neill & Wood (1979), corrected (1980)";
	  dv = -462.5(1.0191+(tt-1073)(2.87 10^-5))(pp-2.63 10^-4 pp^2-29.76)-262.4(1.0292+(tt-1073)*
	       (4.5 10^-5))(pp-3.9 10^-4 pp^2-29.65)+454(1.02+(tt-1073)(2.84 10^-5))(pp-2.36 10^-4 pp^2-29.79)+
	       278.3(1.0234+(tt-1073)(2.3 10^-5))(pp-4.5 10^-4 pp^2-29.6);
	  g = (902+dv+(xmgol-xfeol)(498+1.51(pp-30))-98(xmggt-xfegt)+1347xcagt)/(Log[kd]+.357)-tt;
	  t = FindRoot[g == 0, {tt,300,1500},MaxIterations->30][[1,2]]-273.15];
    	If[mode == 1, mode = "Mori & Green  (1978)";
	  t = (900)/(Log[kd]-0.09)-273.15];
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT12Calibration = ",mode]}}]]
Options[GT12] = {GTB`GT12Calibration->0};
GT12[p_,grt_,ol_,opts___] := GGT12[p,grt,ol,GTB`GT12Calibration/.{opts}/.Options[GT12]];

GGT13[p_,cpx_,ol_,GTB`GT13Calibration_] := (* GT13: Clinopyroxene - olivine FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT13Calibration,xfem1cpx,xmgm1cpx,xalm1cpx,xfeol,xmgol,kd,t,tt,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{dummy,dummy,xalm1cpx,dummy,dummy,xmgm1cpx,xfem1cpx,dummy} = cpx[[3, 2, 4]];
	{xfeol,xmgol} = ol[[3, 2, 1]];
	kd = (xmgol xfem1cpx)/(xmgm1cpx xfeol);
    	If[mode == 0, mode = "Powell & Powell (1974)"; (* note the error in eq.(13) of the original paper *)
	  t = (-2xalm1cpx(920000+3.6 p)-0.0435(p-1)+10100)/(8+2 1.987Log[kd]-(714.3 2xalm1cpx))-273.15];
	If[mode == 1, mode = "Mori & Green  (1978)";
	  t = (1900)/(Log[kd]+1.28)-273.15];	  
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT13Calibration = ",mode]}}]]
Options[GT13] = {GTB`GT13Calibration->0};
GT13[p_,cpx_,ol_,opts___] := GGT13[p,cpx,ol,GTB`GT13Calibration/.{opts}/.Options[GT13]];

GGT14[p_,grt_,amph_,dataset_,GTB`GT14Calibration_] := (* GT14: Garnet - hornblende FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT14Calibration,xfegt,xmggt,xcagt,xfeamph,xmgamph,xmgm13,xfem13,xmgm2,xfem2,check,
	kd=1,t=0,dummy,rtlnypy,rtlnyalm,rtlnyamph,pgl,pparg,pkpa,pfts,pts,pcum,ptia,pmna,pfact,ptr,rr=0.0083143},
	If[mode < 0 || mode > 3, mode = 0];
	{xcagt,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{xfeamph,xmgamph} = amph[[3, 2, 1]];

	If[mode == 0, mode = "Dale et al. (2000)"; 
	  check=Last[amph[[1,2]]];	
	  If[check != "HollandBlundy", 
	    Print["Error-message from GT14: wrong Fe(3+) calculation for amphibole."]; 
	    Print["Use CalcFormula[\"file\",Fe3Amph->HollandBlundy,CalcFormulaMode -> Gtb]."];
	    mode = "wrong Fe(3+) calculation";
	    ];
	  If[check == "HollandBlundy", 
            If[dataset == "HP31" || dataset == "HP32", 
	      {{xnaa,xka,xva},{xcam4,xnam4},{xmgm13,xfem13},{xmgm2,xfem2,xalm2,xfe3m2},{xsit1,xalt1}} = amph[[2,2]]];
            If[dataset == "B88" || dataset == "G97", 
	      {{xnaa,xka,xva}, {xcam4,xmgm4,xfem4,xmnm4,xnam4},{xmgm13,xfem13,xmnm13},
	      {xmgm2,xfem2,xalm2,xfe3m2,xtim2},{xoh},{xalt1,xsit1}} = amph[[2,2]]];	
	    rtlnypy = (1-xmggt)xcagt 33 + (1-xmggt)xfegt 2.55;
	    rtlnyalm = -xmggt xcagt 33 + (1-xfegt)xmggt 2.55;
	    {pgl,pparg,pkpa,pfts,pts,pcum,ptia,pmna,pfact,ptr} = amph[[3, 2, 3]];
	    kd = (xmgm13^3*xmgm2^2*xfegt^5)/(xfem13^3*xfem2^2*xmggt^5);
            rtlnyamph = 11.4(pfact-ptr)+20.8*pts+17.9*pparg+20.3*pgl+49.8*pkpa;
	    t = (117.78+0.722(p/1000)+(5/3)rtlnypy-(5/3)rtlnyalm-rtlnyamph)/(0.0578+rr Log[kd])-273.15];
	  ];
	If[mode > 0, kd = (xmgamph xfegt)/(xmggt xfeamph)];
    	If[mode == 1, mode = "Perchuk et al. (1985)";
	  t = 3330/(Log[kd]+2.333)-273.15];
    	If[mode == 2, mode = "Powell  (1985)";
	  t = (2580+3340xcagt)/(Log[kd]+2.2)-273.15];
    	If[mode == 3, mode = "Graham & Powell (1984)";
	  t = (2880+3280xcagt)/(Log[kd]+2.426)-273.15];
Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT14Calibration = ",mode]}}]]
Options[GT14] = {GTB`GT14Calibration->0};
GT14[p_,grt_,amph_,dataset_,opts___] := GGT14[p,grt,amph,dataset,GTB`GT14Calibration/.{opts}/.Options[GT14]];

GGT15[p_,grt_,crd_,GTB`GT15Calibration_] := (* GT15: Garnet - cordierite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT15Calibration,xfegt,xmggt,xcagt,xmngt,xfecrd,xmgcrd,kd,t,tt,g},
	If[mode < 0 || mode > 4, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xfecrd,xmgcrd} = crd[[3, 2, 1]];
	kd = (xmggt xfecrd)/(xmgcrd xfegt);
    	If[mode == 0, mode = "Bhattacharya et al. (1988)";
	  t = (1814+0.0152p+1122(xmgcrd-xfecrd)-1258(xmggt-xfegt)+1510(xcagt-xmngt))/(1.028-Log[kd])-273.15];
	If[mode == 1, mode = "Perchuk & Lavrenteva (1983), eq.(25), corrected Perchuk (1991), eq.(10)";
	  t = (3020+0.018 p)/(Log[1/kd]+1.287)-273.15];
	If[mode == 2, mode = "Wells (1979), eq.(10)";
	  t = (33248-0.1768(p-1))/(6 1.987 Log[1/kd]+10.94)-273.15];
    	If[mode == 3, mode = "Holdaway & Lee (1977), Table 7";
	  g = 6150 - tt 2.69 + .0303 p + 1.987 tt Log[kd];
	  t = Solve[g == 0,tt][[1,1,2]]-273.15];	
    	If[mode == 4, mode = "Thompson (1976), Table 1";
	  g = -0.896+2724.948/tt+0.0155(p-1)/tt-Log[1/kd];
	  t = Solve[g == 0,tt][[1,1,2]]-273.15];	
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT15Calibration = ",mode]}}]]
Options[GT15] = {GTB`GT15Calibration->0};
GT15[p_,grt_,crd_,opts___] := GGT15[p,grt,crd,GTB`GT15Calibration/.{opts}/.Options[GT15]];

GGT16[p_,grt_,stau_,GTB`GT16Calibration_] := (* GT16: Garnet - staurolite FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT16Calibration,xfegt,xmggt,xfest,xmgst,kd,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{dummy,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{xfest,xmgst} = stau[[3, 2, 1]];
	kd = (xmgst xfegt)/(xmggt xfest);
    	If[mode == 0, mode = "Perchuk (1991), eq.(19)";
	  t = (2675+0.0075p)/(Log[kd]+2.799)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT16Calibration = ",mode]}}]]
Options[GT16] = {GTB`GT16Calibration->0};
GT16[p_,grt_,stau_,opts___] := GGT16[p,grt,stau,GTB`GT16Calibration/.{opts}/.Options[GT16]];

GGT17[p_,grt_,ctd_,GTB`GT17Calibration_] := (* GT17: Garnet - chloritoide FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT17Calibration,xfegt,xmggt,xfectd,xmgctd,kd,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{dummy,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{xfectd,xmgctd} = ctd[[3, 2, 1]];
	kd = (xmgctd xfegt)/(xmggt xfectd);
    	If[mode == 0, mode = "Perchuk (1991), eq.(20)";
	  t = (2150.5)/(Log[kd]+1.773)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT17Calibration = ",mode]}}]]
Options[GT17] = {GTB`GT17Calibration->0};
GT17[p_,grt_,ctd_,opts___] := GGT17[p,grt,ctd,GTB`GT17Calibration/.{opts}/.Options[GT17]];

GGT18[p_,chl_,ctd_,GTB`GT18Calibration_] := (* GT18: Chlorite - chloritoide FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT18Calibration,xfechl,xmgchl,xfectd,xmgctd,kd,t,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xfechl,xmgchl} = chl[[3, 2, 1]]; 
	{xfectd,xmgctd} = ctd[[3, 2, 1]];
	kd = (xmgchl xfectd)/(xmgctd xfechl);
    	If[mode == 0, mode = "Vidal et al. (1999), eq.(4)";
	  t = (1977.7)/(Log[kd]+0.971)-273.15];
    	If[mode == 1, mode = "Perchuk (1991), eq.(21)";
	  t = (1822)/(Log[kd]+1)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT18Calibration = ",mode]}}]]
Options[GT18] = {GTB`GT18Calibration->0};
GT18[p_,chl_,ctd_,opts___] := GGT18[p,chl,ctd,GTB`GT18Calibration/.{opts}/.Options[GT18]];

GGT19[p_,bt_,ctd_,GTB`GT19Calibration_] := (* GT19: Biotite - chloritoide FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT19Calibration,xfebt,xmgbt,xfectd,xmgctd,kd,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xmgbt,xfebt,dummy,dummy,dummy} = bt[[3, 2, 1]];
	{xfectd,xmgctd} = ctd[[3, 2, 1]];
	kd = (xmgbt xfectd)/(xmgctd xfebt);
    	If[mode == 0, mode = "Perchuk (1991), eq.(22)";
	  t = (1796.7)/(Log[kd]+1.095)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT19Calibration = ",mode]}}]]
Options[GT19] = {GTB`GT19Calibration->0};
GT19[p_,bt_,ctd_,opts___] := GGT19[p,bt,ctd,GTB`GT19Calibration/.{opts}/.Options[GT19]];

GGT20[p_,grt_,sp_,GTB`GT20Calibration_] := (* GT20: Garnet - spinell FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT20Calibration,xfegt,xmggt,xcagrt,fesp,mgsp,crsp,xfesp,xmgsp,xcrsp,
	kd,hemg,hefe,semg,sefe,vemg,vefe,whmg=-469,wsmg=-1.3,wvmg=0.02,whfe=-1219,wsfe=-1.579,wvfe=0,
	hecagt,hecr,hezn,ho=3909,so=3.216,vo=0.009,t,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xcagt,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{fesp,mgsp,crsp,dummy,dummy,dummy} = sp[[3, 2, 1]];
	xfesp = fesp/(fesp+mgsp); xmgsp = mgsp/(fesp+mgsp); xcrsp = crsp/2;
	kd = (xmgsp xfegt)/(xmggt xfesp);
    	If[mode == 0, mode = "Perchuk (1991), eq.(29)";
          hemg = ((2whmg-whfe)-2(whfe-whmg)xfesp)xfesp^2;
          hefe = ((2whfe-whmg)+2(whfe-whmg)xmgsp)xmgsp^2;
      	  semg = ((2wsmg-wsfe)-2(wsfe-wsmg)xfesp)xfesp^2;
     	  sefe = ((2wsfe-wsmg)+2(wsfe-wsmg)xmgsp)xmgsp^2;
	  vemg = ((2wvmg-wvfe)-2(wvfe-wvmg)xfesp)xfesp^2;
	  vefe = ((2wvfe-wvmg)+2(wvfe-wvmg)xmgsp)xmgsp^2;
	  hecagt = -2134 xcagt; hecr = 3636 xcrsp; hezn = -865 xcrsp;
	  t = (ho+vo p+hemg-hefe+hecr+hezn+hecagt)/(1.987 Log[kd]+so+semg-sefe)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT20Calibration = ",mode]}}]]
Options[GT20] = {GTB`GT20Calibration->0};
GT20[p_,grt_,sp_,opts___] := GGT20[p,grt,sp,GTB`GT20Calibration/.{opts}/.Options[GT20]];

GGT21[p_,ol_,sp_,GTB`GT21Calibration_] := (* GT21: Olivine - spinell FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT21Calibration,xfeol,xmgol,fe2sp,mgsp,crsp,tisp,alsp,fe3sp,xfesp,xmgsp,xalsp,xfe3sp,xcrsp,xtisp,
	alfa,beta,gamma,kd,t,logfo2},
	If[mode < 0 || mode > 2, mode = 0];
	{xfeol,xmgol} = ol[[3, 2, 1]];
	{fe2sp,mgsp,crsp,tisp,alsp,fe3sp} = sp[[3, 2, 1]];
    	xmgsp = mgsp/(mgsp+fe2sp); xfesp = fe2sp/(mgsp+fe2sp);
	alfa = crsp/(crsp+alsp+fe3sp); beta = alsp/(crsp+alsp+fe3sp); gamma = fe3sp/(crsp+alsp+fe3sp);    	
	kd = (xmgol xfesp)/(xmgsp xfeol);
    	If[mode == 0, mode = "Ballhaus et al. (1991)";
    	  xfe3sp = fe3sp/(fe3sp+fe2sp); xcrsp = crsp/(crsp+alsp+fe3sp); xtisp = tisp;
	  t = (6350+280(p/10000)+(7000+108(p/10000))(1-2xfeol)-1960(xmgsp-xfesp)+16150*xcrsp+25150(xfe3sp+xtisp))/
	      (8.3143Log[kd]+4.705)-273.15];
	  (* logfo2 = 0.27+2505/t-400(p/10000)/t-6Log[10,xfeol]-3200(1-xfeol)^2/t+2Log[10,xfesp]+4Log[10,xfe3sp]+2630 beta^2/t; *)
    	If[mode == 1, mode = "Fabries (1979)";
	  t = (4250*alfa+1343)/(Log[kd]+1.825*alfa+0.571)-273.15];
    	If[mode == 2, mode = "Roeder et al. (1979)";
	  t = (alfa 3480+beta 1018-gamma 1720+2400)/(alfa 2.23+beta 2.56-gamma 3.08-1.47+1.987Log[kd])-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT21Calibration = ",mode]}}]]
Options[GT21] = {GTB`GT21Calibration->0};
GT21[p_,ol_,sp_,opts___] := GGT21[p,ol,sp,GTB`GT21Calibration/.{opts}/.Options[GT21]];

GGT22[p_,crd_,sp_,GTB`GT22Calibration_] := (* GT22: Cordierite - spinell FeMg-1 exchange geothermometer  *)
	Block[{mode=GTB`GT22Calibration,xfecrd,xmgcrd,fe2sp,mgsp,crsp,tisp,alsp,fe3sp,xfesp,xmgsp,xcrsp,kd,
	hemg,hefe,semg,sefe,vemg,vefe,whmg=-469,wsmg=-1.3,wvmg=0.02,whfe=-1219,wsfe=-1.579,wvfe=0,
	hecr,hezn,ho=2225,so=-0.659,vo=0.026,t,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xfecrd,xmgcrd} = crd[[3, 2, 1]];
	{fe2sp,mgsp,crsp,tisp,alsp,fe3sp} = sp[[3, 2, 1]];
    	xmgsp = mgsp/(mgsp+fe2sp); xfesp = fe2sp/(mgsp+fe2sp);
	kd = (xmgsp xfecrd)/(xmgcrd xfesp);
    	If[mode == 0, mode = "Perchuk (1991), eq.(29)";
    	  xcrsp = crsp/(crsp+alsp+fe3sp); 
          hemg = ((2whmg-whfe)-2(whfe-whmg)xfesp)xfesp^2;
          hefe = ((2whfe-whmg)+2(whfe-whmg)xmgsp)xmgsp^2;
          semg = ((2wsmg-wsfe)-2(wsfe-wsmg)xfesp)xfesp^2;
          sefe = ((2wsfe-wsmg)+2(wsfe-wsmg)xmgsp)xmgsp^2;
          vemg = ((2wvmg-wvfe)-2(wvfe-wvmg)xfesp)xfesp^2;
          vefe = ((2wvfe-wvmg)+2(wvfe-wvmg)xmgsp)xmgsp^2;
          hecr = 3636 xcrsp; hezn = -865 xcrsp;
	  t = (ho+vo p+hemg-hefe+hecr+hezn)/(1.987 Log[1/kd]+so+semg-sefe)-273.15];
    	If[mode == 1, mode = "Vielzeuf (1983), Fig.(3)";
	  t = (-1763)/(Log[kd]+0.378)-273.15];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT22Calibration = ",mode]}}]]
Options[GT22] = {GTB`GT22Calibration->0};
GT22[p_,crd_,sp_,opts___] := GGT22[p,crd,sp,GTB`GT22Calibration/.{opts}/.Options[GT22]];

GGT23[p_,amph_,plag_,GTB`GT23Calibration_] := (* GT23: Amphibole - plagioclase exchange geothermometer  *)
	Block[{mode=GTB`GT23Calibration,xnaa,xka,xalm2,xva,xsit1,xalt1,xnam4,xcam4,xab,xan,yab=0,yaban=3,
	k=1,t=0,check,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	check=Last[amph[[1,2]]];	
	If[check != "HollandBlundy", 
	  Print["Error-message from GT23: wrong Fe(3+) calculation for amphibole."]; 
	  Print["Use CalcFormula[\"file\",Fe3Amph->HollandBlundy,CalcFormulaMode -> Gtb]."];
	  mode = "wrong Fe(3+) calculation";
	  ];
	If[check == "HollandBlundy", 
	  {xsit1,xalt1,xalm2,xcam4,xnam4,xnaa,xka,xva} = amph[[3, 2, 2]];
	  {xab,xan,dummy} = plag[[3, 2, 1]];
	  If[mode == 0, mode = "Holland & Blundy (1994), edenite-tremolite";
	    If[xab <= 0.5, yab = 12(1-xab)^2-3]; 
	    If[xva==0 || xab==0 || xnaa==0, Return[{"undefined","undefined","undefined"}]];
	    k = (27xva xsit1 xab)/(256xnaa xalt1);
	    t = (-76.95+0.00079p+yab+39.4xnaa+22.4xka+(41.5-0.00289p)xalm2)/
	        (-0.065-0.0083144 Log[k])-273.15];
	  If[mode == 1, mode = "Holland & Blundy (1994), edenite-richterite";
	    If[xab <= 0.5, yaban = 12(2xab-1)+3]; 
	    If[xnam4==0 || xan==0 || xcam4==0 || xab==0,Return[{"undefined","undefined","undefined"}]];
	    k = (27xnam4 xsit1 xan)/(64xcam4 xalt1 xab);
	    t = (78.44+yaban-33.6xnam4-(66.8-0.00292p)xalm2+78.5xalt1+9.4xnaa)/
	        (0.0721-0.0083144 Log[k])-273.15];
	  ];
Return[{{t,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GT23Calibration = ",mode]}}]]
Options[GT23] = {GTB`GT23Calibration->0};
GT23[p_,amph_,plag_,opts___] := GGT23[p,amph,plag,GTB`GT23Calibration/.{opts}/.Options[GT23]];

Dis[p_,t_,xdol_] := Block[{w,gl,s,res,r=8.3143,tkrit=1100+273.15,vdis=0.022},
	(* calculate order/disorder term for carbonates: parameter values from Gottschalk (1990) *)
	w = r tkrit + vdis(p-1); (* Energieparameter W fuer order/disorder   *)
	gl = - 2w s xdol^2 + xdol/2 r t Log[((1+s)(1-(1-s)xdol/2))/
            ((1-s)(1-(1+s)xdol/2))];  
	res = FindRoot[gl == 0,{s,10^-6,1-10^-6},MaxIterations -> 50,WorkingPrecision->20];
	If[res[[1,2]] <= 10^-5, res[[1,2]] = 0];
	Return[N[{res[[1,2]],w}]]]

Muecal[p_,t_,xdol_] := Block[{r=8.3143,a=-0.08,b=0.07,c=0.05,ao=21750,a1=0,s,w,res,muecal},
	(* calculate chem. mixing potential of calcite component in calcite or dolomite: parameter values from Gottschalk (1990) *)
	res = Dis[p,t,xdol];
	s = res[[1]]; w = res[[2]];
    	muecal = -(a*xdol^2) + ao*xdol^2 + 3*a1*xdol^2 + 3*b*xdol^2 - 5*c*xdol^2 + 
             a*p*xdol^2 - 3*b*p*xdol^2 + 5*c*p*xdol^2 - w*xdol^2 + s^2*w*xdol^2 - 4*a1*xdol^3 - 
             4*b*xdol^3 + 16*c*xdol^3 + 4*b*p*xdol^3 - 16*c*p*xdol^3 - 12*c*xdol^4 + 
             12*c*p*xdol^4 + r*t*Log[1 - xdol/2 - (s*xdol)/2] + r*t*Log[(2 - xdol + s*xdol)/2];
	Return[N[muecal]]]
						
Muedol[p_,t_,xdol_] := Block[{r=8.3143,a=-0.08,b=0.07,c=0.05,ao=21750,a1=0,s,w,res,muedol,xcal=1-xdol},
	(* calculate chem. mixing potential of dolomite component in calcite or dolomite: parameter values from Gottschalk (1990) *)
	res = Dis[p,t,xdol];
	s = res[[1]]; w = res[[2]];
    	muedol = w - s^2*w - a*xcal^2 + ao*xcal^2 - 3*a1*xcal^2 - 3*b*xcal^2 - 5*c*xcal^2 + 
   		a*p*xcal^2 + 3*b*p*xcal^2 + 5*c*p*xcal^2 - w*xcal^2 + s^2*w*xcal^2 + 4*a1*xcal^3 + 
   		4*b*xcal^3 + 16*c*xcal^3 - 4*b*p*xcal^3 - 16*c*p*xcal^3 - 12*c*xcal^4 + 
   		12*c*p*xcal^4 + (r*t*Log[((1 - s)*(1 - xcal))/2])/2 - 
   		(r*s*t*Log[((1 - s)*(1 - xcal))/2])/2 + (r*t*Log[((1 + s)*(1 - xcal))/2])/2 + 
   		(r*s*t*Log[((1 + s)*(1 - xcal))/2])/2 + (r*t*Log[(1 + s + xcal - s*xcal)/2])/2 + 
   		(r*s*t*Log[(1 + s + xcal - s*xcal)/2])/2 + (r*t*Log[(1 - s + xcal + s*xcal)/2])/2 - 
   		(r*s*t*Log[(1 - s + xcal + s*xcal)/2])/2;
	Return[N[muedol]]]
	
Func1[p_,t_,xdolcal_,xdoldol_] := Block[{res}, (* subfunction of Df1: calculates delta-mue calcite  *)
	res = Muecal[p,t,xdolcal]-Muecal[p,t,xdoldol];
	Return[res]]

Func2[p_,t_,xdolcal_,xdoldol_] := Block[{res}, (* subfunction of Df2: calculates delta-mue dolomite  *)
	res = Muedol[p,t,xdolcal]-Muedol[p,t,xdoldol];
	Return[res]]

Df1[p_,t_,xdolcal_,xdoldol_,flag_] := Block[{x=xdolcal,y=xdoldol,dt=10^-6,dx=10^-6,dy=10^-6,w1,w2,df},
	If[flag == 1, w1 = Func1[p,t,x-dx,y]; w2 = Func1[p,t,x+dx,y];
		df = (w2-w1)/(2dx)];
	If[flag == 2, w1 = Func1[p,t,x,y-dy]; w2 = Func1[p,t,x,y+dy];
		df = (w2-w1)/(2dy)];
	If[flag == 3, w1 = Func1[p,t-dt,x,y]; w2 = Func1[p,t+dt,x,y];
		df = (w2-w1)/(2dt)];
		Return[N[df,30]]]
	
Df2[p_,t_,xdolcal_,xdoldol_,flag_] := Block[{x=xdolcal,y=xdoldol,dt=10^-6,dx=10^-6,dy=10^-6,w1,w2,df},
	If[flag == 1, w1 = Func2[p,t,x-dx,y]; w2 = Func2[p,t,x+dx,y];
		df = (w2-w1)/(2dx)];
	If[flag == 2, w1 = Func2[p,t,x,y-dy]; w2 = Func2[p,t,x,y+dy];
		df = (w2-w1)/(2dy)];
	If[flag == 3, w1 = Func2[p,t-dt,x,y]; w2 = Func2[p,t+dt,x,y];
		df = (w2-w1)/(2dt)];
		Return[N[df,30]]]

CalcCalDolSolvus[p_,xdolcal_] := 
(* CalDol-Thermometer: calculates temperature and composition of coexisting dolomite on input p and X(Dol) in calcite following
   the principles and data compiled by Gottschalk (1990), PHD thesis University of Tuebingen, Germany: valid for the Ca-Mg system.
   Uses a primitive iteration algorithm and is not very fast, but FindRoot does not work for this problem.  *)
Block[{w1,w2,gl1,gl2,dx,dy,dxx,dyy,t,x=xdolcal,y=0.9999,start,res,n=0},
	If[xdolcal < 0.02 || xdolcal > 0.5, Return["out of allowed range"]];
	If[xdolcal >= 0.02 && xdolcal < 0.3, t=600+273.15];
	If[xdolcal >= 0.3 && xdolcal <= 0.5, t=900+273.15];
	Label[start];
	w1 = Func1[p,t,x,y]; w2 = Func2[p,t,x,y];
	gl1 = Df1[p,t,x,y,3]dx + Df1[p,t,x,y,2]dy + w1;
	gl2 = Df2[p,t,x,y,3]dx + Df2[p,t,x,y,2]dy + w2;
	res = Solve[{gl1==0,gl2==0},{dx,dy}];
	dxx = res[[1,1,2]]; dyy = res[[1,2,2]];
	xv = t; yv = y;
	t = t + dxx; y = y + dyy;
	If[Abs[xv-t] < 10^-2 && Abs[yv-y] < 10^-4, Return[{t-273.15,y}]];
	Goto[start];
	]

GGT24[p_,cc_,GTB`GT24Calibration_] := (* GT24: Calcite - dolomite solvus geothermometer *)
	Block[{mode=GTB`GT24Calibration,xca,xmg,xfe,A,B,C,D,E,a,b,c,d,e,f,tmg,t,wfe,wmg,gomg,gofe,
	g1,g2,xmgdol,tt,res,wcafe,wcamg,xmgpur,dummy},
	Off[FindRoot::precw];
	If[mode < 0 || mode > 3, mode = 0];
	{xca,xmg,xfe,dummy} = cc[[3, 2, 1]];
    	If[mode == 0, mode = "Gottschalk (1990) for pure Ca-Mg system";
	  res = CalcCalDolSolvus[p,2xmg]; t = res[[1]]; xmgdol = res[[2]]];
    	If[mode == 1, mode = "Anovitz & Essene (1987), eq. (23) for pure Ca-Mg System";
     	  A=-2360; B=-0.01345; C=2620; D=2608; E=334; xmgdol=ToExpression["NoValue"];
	  tmg = A xmg + B/xmg^2 + C xmg^2 + D xmg^0.5 + E;
      	  a=1718; b=-10610; c=22.49; d=-26260; e=1.333; f=0.32837 10^-7;	  
	  (* Eq.(31) or some parameter in this eq. seems wrong (f ?, possibly 0.32837 10^-7 instead of 10^7 ??);
	    due to this uncertainty only tmg is returned *) 
	  t = (tmg+a xfe+b xfe^2+c xfe/xmg+d xfe xmg+e(xfe/xmg)^2+f(xfe/xmg)^2)-273.15;
	  t = tmg-273.15;];
    	If[mode == 2, mode = "Powell et al. (1984)";
	  wfe=15500; wmg = 14740 - 0.000259 p;
	  gofe=-500; gomg = 6980 + 0.000149 p;
	  g1 = gomg+8.3143 tt Log[xca xmg/(xmgdol)]+wmg(1-xfe-2xmg xca)+wfe xfe(1-2xca);
	  g2 = gofe+8.3143 tt Log[xca xfe/(1-xmgdol)]+wmg xmg(1-2xca)+wfe(1-xmg-2xfe xca);
	  res = FindRoot[{g1==0,g2==0},{tt,800,500},{xmgdol,.96,.99},MaxIterations->100,PrecisionGoal->5];
	  t = res[[1,2]]-273.15; xmgdol = res[[2,2]]];
    	If[mode == 3, mode = "Bickle & Powell (1977)";
	  wcafe = 3800; wcamg = 5360 - 0.032 p;
	  xmgpur = Exp[0.847-3091/tt]+(p-1)(0.17 10^-8 tt-0.33 10^-6);
	  g1 = xmg+xfe Exp[(wcafe-wcamg)/(1.987 tt)]-xmgpur;
	  g2 = xmg+(1-xmgdol) Exp[-wcamg/(1.987 tt)]-xmgpur;
	  res = FindRoot[{g1==0,g2==0},{tt,800,500},{xmgdol,.96,.99},MaxIterations->100,PrecisionGoal->5];
	  t = res[[1,2]]-273.15; xmgdol = res[[2,2]]];
	On[FindRoot::precw];
	Return[{{t,p},{StringJoin["X-Mg(Dol)= ",ToString[xmgdol]],StringJoin["GT24Calibration = ",mode]}}]]
Options[GT24] = {GTB`GT24Calibration->0};
GT24[p_,cc_,opts___] := GGT24[p,cc,GTB`GT24Calibration/.{opts}/.Options[GT24]];

AAfs[p_, t_, ko_,xab_,xan_,xor_,GTB`AfsModel_] := 
	Block[{modell=GTB`AfsModel,r=8.3143,wabor,worab,waban,wanab,wanor,woran,woraban,whabor,wsabor,wvabor,whorab,wsorab,wvorab,whaban,wsaban,wvaban,
	whanab,wsanab,wvanab,whoran,wsoran,wvoran,whanor,wsanor,wvanor,whoraban,wsoraban,wvoraban,exab,exan,exor,
	csab=1,csan=1,csor=1,opt={GTB`ElkinsGrove,GTB`FuhrmanLindsley,GTB`Ghiorso,GTB`GreenUsdansky,GTB`LindsleyNekvasil,GTB`NekvasilBurnham}},
	If[ko != 1 && ko != 2  && ko != 3 && ko != 4  && ko != 5  && ko != 6, Return["Error: <flag> must be 1, 2, 3, 4, 5 or 6"]];      
	If[Intersection[{GTB`AfsModel},opt] == {}, Print["wrong value \"",GTB`AfsModel,"\" for option \"AfsModel\""];
	   Print["Allowed values are: ",opt];Return[]];
	If[modell == GTB`ElkinsGrove, (* Elkins & Grove (1990) *)
      	  whabor=18810; whorab=27320; whaban=7924; whanab=0; whoran=40317; whanor=38974; whoraban=12545;
	  wsabor=10.3; wsorab=10.3; wsaban=0; wsanab=0; wsoran=0; wsanor=0; wsoraban=0;
	  wvabor=0.3264; wvorab=0.4602; wvaban=0; wvanab=0; wvoran=0; wvanor=-0.1037; wvoraban=-1.095];
	If[modell == GTB`FuhrmanLindsley, (* Fuhrman & Lindsley (1988) *)
      	  whabor=18810; whorab=27320; whaban=28226; whanab=8471; whoran=52468; whanor=47396; whoraban=8700;
	  wsabor=10.3; wsorab=10.3; wsaban=0; wsanab=0; wsoran=0; wsanor=0; wsoraban=0;
	  wvabor=0.394; wvorab=0.394; wvaban=0; wvanab=0; wvoran=0; wvanor=-0.12; wvoraban=-1.094];
	If[modell == GTB`LindsleyNekvasil, (* Lindsley & Nekvasil (1988) *)
      	  whabor=18810; whorab=27320; whaban=14129; whanab=11226; whoran=33415; whanor=43369; whoraban=19969;
	  wsabor=10.3; wsorab=10.3; wsaban=6.18; wsanab=7.87; wsoran=0; wsanor=8.43; wsoraban=0;
	  wvabor=0.4602; wvorab=0.3264; wvaban=0; wvanab=0; wvoran=0; wvanor=-0.1037; wvoraban=-1.095];
	If[modell == GTB`NekvasilBurnham, (* Nekvasil & Burnham (1987) *)
      	  whabor=30978; whorab=17062; whaban=14129.4; whanab=11225.7; whoran=25030.3; whanor=75023.3; whoraban=0;
	  wsabor=21.4; wsorab=0; wsaban=6.14; wsanab=7.87; wsoran=-10.8; wsanor=22.97; wsoraban=0;
	  wvabor=0.361; wvorab=0.361; wvaban=0; wvanab=0; wvoran=0; wvanor=0; wvoraban=0];
	If[modell == GTB`GreenUsdansky, (* Green & Usdansky (1986) *)
      	  whabor=18810; whorab=27320; whaban=28230; whanab=8473; whoran=65305; whanor=-65407; whoraban=0;
	  wsabor=10.3; wsorab=10.3; wsaban=0; wsanab=0; wsoran=-114.104; wsanor=12.537; wsoraban=0;
	  wvabor=0.364; wvorab=0.364; wvaban=0; wvanab=0; wvoran=0.9699; wvanor=2.1121; wvoraban=0];
	If[modell == GTB`Ghiorso, (* Ghiorso (1984) *)
      	  whabor=30978; whorab=17062; whaban=28226; whanab=8471; whoran=67469; whanor=27983; whoraban=-13869;
	  wsabor=21.4; wsorab=0; wsaban=0; wsanab=0; wsoran=-20.21; wsanor=11.06; wsoraban=-14.63;
	  wvabor=0.361; wvorab=0.361; wvaban=0; wvanab=0; wvoran=0; wvanor=0; wvoraban=0];
	If[ko == 1 || ko == 2 || ko == 3, (* return excess G when ko = 1, 2 or 3  *)
	  wabor = whabor - t wsabor + p wvabor; worab = whorab - t wsorab + p wvorab;
	  waban = whaban - t wsaban + p wvaban; wanab = whanab - t wsanab + p wvanab;
	  woran = whoran - t wsoran + p wvoran; wanor = whanor - t wsanor + p wvanor;
	  woraban = whoraban - t wsoraban + p wvoraban];
	If[ko == 4, (* return excess H for ab, an, or *)
	  wabor = whabor; worab = whorab; waban = whaban; wanab = whanab; woran = whoran; wanor = whanor; woraban = whoraban];
	If[ko == 5, (* return excess S  *)
	  wabor = wsabor; worab = wsorab; waban = wsaban; wanab = wsanab; woran = wsoran; wanor = wsanor; woraban = wsoraban];
	If[ko == 6, (* return excess V  *)
	  wabor = wvabor; worab = wvorab; waban = wvaban; wanab = wvanab; woran = wvoran; wanor = wvanor; woraban = wvoraban];
	If[modell == GTB`FuhrmanLindsley || modell == GTB`GreenUsdansky, csab = csor = 1-xan^2; csan = (1+xan)^2/4];
	exab = (worab(2xab xor(1-xab) + xor xan(0.5-xab)) + wabor(xor^2(1-2xab) + xor xan(0.5-xab)) +
		woran(xor xan(0.5-xab-2xan)) + wanor(xor xan(0.5-xab-2xor)) +
		waban(xan^2(1-2xab)+xan xor(0.5-xab)) + wanab(2xab xan(1-xab)+xan xor(0.5-xab)) +
		woraban(xor xan(1-2xab)));
	exan = (worab(xab xor(0.5-xan-2xab)) + wabor(xab xor(0.5-xan-2xor)) + 
      		woran(2xor xan(1-xan)+xab xor(0.5-xan)) + wanor(xor^2(1-2xan)+xab xor(0.5-xan)) +
		waban(2xab xan(1-xan)+xab xor(0.5-xan)) +wanab(xab^2(1-2xan)+xab xor(0.5-xan)) +
		woraban(xor xab(1-2xan)));
	exor = (worab(xab^2(1-2xor) + xab xan(0.5-xor)) + 
		wabor(2xab xor(1-xor) + xab xan(0.5-xor)) + woran(xan^2(1-2xor) + xab xan(0.5-xor)) +
		wanor(2xor xan(1-xor) + xab xan(0.5-xor)) + waban(xab xan(0.5-xor-2xan)) +
		wanab(xab xan(0.5-xor-2xab)) + woraban(xab xan(1-2xor)));
	If[modell == GTB`ElkinsGrove || modell == GTB`FuhrmanLindsley || modell == GTB`LindsleyNekvasil ||
	   modell == GTB`NekvasilBurnham || modell == GTB`GreenUsdansky || GTB`Ghiorso,
     	   If[ko == 1,Return[N[xab csab Exp[exab/(r t)]]]];		(* a (Ab)  *)
     	   If[ko == 2,Return[N[xan csan Exp[exan/(r t)]]]];		(* a (An)  *)
     	   If[ko == 3,Return[N[xor csor Exp[exor/(r t)]]]];		(* a (Or)  *)
     	   If[ko == 4,Return[{exab,exan,exor,csab,csan,csor}]];	(* ex-H of ab, an, or, additional entropy contribution ab, an, or *)
     	   If[ko == 5,Return[{exab,exan,exor,csab,csan,csor}]];	(* ex-S of ab, an, or, additional entropy contribution ab, an, or *)
     	   If[ko == 6,Return[{exab,exan,exor,csab,csan,csor}]]];	(* ex-V of ab, an, or, additional entropy contribution ab, an, or *)
	Return["Afs: wrong option"];
     ]
Options[Afs] = {GTB`AfsModel->GTB`FuhrmanLindsley};
Afs[p_, t_, ko_,xab_,xan_,xor_,opts___] := Block[{opt={GTB`AfsModel},i,n=Dimensions[{opts}][[1]]},
	For[i=1,i<=n,i++, If[Position[opt,{opts}[[i,1]]] == {}, Print["Unknown option ",{opts}[[i,1]]," in -Afs-"];
	   Print["Known option is: ",opt];Return[]]];
	AAfs[p,t,ko,xab,xan,xor,GTB`AfsModel/.{opts}/.Options[Afs]]];

PlagKfsp3T[p_,xabpl_,xanpl_,xorpl_,xabkf_,xankf_,xorkf_] :=
(* 2 feldspar-thermometer: search for the most concordant temperatures T(Ab), T(An), T(Or), by
  adjusting original compositions within 2 mol%; algorithm of Fuhrmann & Lindsley (1988);
  subfunction of GT25  *)
	Block[{limit=40,step=.01,max=.02,n,i,j,k,l,sign,plstep,kfstep,xabpll,xanpll,xorpll,xabkfl,xankfl,xorkfl,
	t,tab,tan,tor,whpl,wspl,wvpl,whkf,wskf,wvkf,diff,tmin,pos,c=0},
	n = max/step;
        sign = Join[Permutations[{0,1,1}],Permutations[{0,1,-1}],Permutations[{0,0,1}],
              Permutations[{0,0,-1}],Permutations[{0,0,0}],Permutations[{1,1,1}],
              Permutations[{-1,-1,-1}],Permutations[{1,-1,-1}],Permutations[{1,1,-1}]];
	tmin = Table[0,{i,1,50}];
	For[i=1,i<=n,i++,
	   For[j=1,j<=n,j++,
	      For[k=1,k<=Dimensions[sign][[1]],k++,
		 For[l=1,l<=Dimensions[sign][[1]],l++,
		    plstep = step j;
		    kfstep = step i;
		    xabpll = xabpl+plstep sign[[l,1]];
		    xanpll = xanpl+plstep sign[[l,2]];
		    xorpll = xorpl+plstep sign[[l,3]];
		    xabkfl = xabkf+kfstep sign[[k,1]];
		    xankfl = xankf+kfstep sign[[k,2]];
		    xorkfl = xorkf+kfstep sign[[k,3]];
		    If[xabpll>0&&xabpll<1&&xanpll>0&&xanpll<1&&xorpll>0&&xorpll<1&&
		    xabkfl>0&&xabkfl<1&&xankfl>0&&xankfl<1&&xorkfl>0&&xorkfl<1,
		    whpl = Afs[p,0,4,xabpll,xanpll,xorpll];
		    wspl = Afs[p,0,5,xabpll,xanpll,xorpll];
		    wvpl = Afs[p,0,6,xabpll,xanpll,xorpll];
		    whkf = Afs[p,0,4,xabkfl,xankfl,xorkfl];
		    wskf = Afs[p,0,5,xabkfl,xankfl,xorkfl];
		    wvkf = Afs[p,0,6,xabkfl,xankfl,xorkfl];
		    tab = ((whkf[[1]]-whpl[[1]])+(wvkf[[1]]-wvpl[[1]])p)/(8.3143 Log[(xabpll whpl[[4]])/(xabkfl whkf[[4]])]+
 			  (wskf[[1]]-wspl[[1]]))-273.15;
		    tan = ((whkf[[2]]-whpl[[2]])+(wvkf[[2]]-wvpl[[2]])p)/(8.3143 Log[(xanpll whpl[[5]])/(xankfl whkf[[5]])]+
	  		  (wskf[[2]]-wspl[[2]]))-273.15;
		    tor = ((whkf[[3]]-whpl[[3]])+(wvkf[[3]]-wvpl[[3]])p)/(8.3143 Log[(xorpll whpl[[6]])/(xorkfl whkf[[6]])]+
	  		  (wskf[[3]]-wspl[[3]]))-273.15;
		    t = {tab,tan,tor};
		    diff = Abs[Abs[tab]-Abs[tor]]+Abs[Abs[tor]-Abs[tan]]+Abs[Abs[tan]-Abs[tab]];
		    If[diff < limit, tmin[[++c]]={t,{xabpll,xanpll,xorpll,xabkfl,xankfl,xorkfl}}]]]]]];
	tmin = Delete[Union[tmin],1];
	If[tmin == {}, Return["no convergent temperature found"]];
	diff = Table[0,{i,1,Dimensions[tmin][[1]]}];
	For[i=1,i<=Dimensions[tmin][[1]],i++,
	   diff[[i]] = Abs[Abs[tmin[[i,1,1]]]-Abs[tmin[[i,1,3]]]]+Abs[Abs[tmin[[i,1,3]]]-Abs[tmin[[i,1,2]]]]+
			Abs[Abs[tmin[[i,1,2]]]-Abs[tmin[[i,1,1]]]]];	
	pos = Position[diff,Min[diff]][[1,1]];	
Return[tmin[[pos]]]]
   
GGT25[p_,pl_,kf_,GTB`GT25Calibration_,GTB`GT25Z_] := (* GT25: Plagioklas - kalifeldspar solvus geothermometer *)
	Block[{mode=GTB`GT25Calibration,xabpl,xanpl,xorpl,xabkf,xankf,xorkf,kd,
	cs="no change",whabhigh=4612,whorhigh=6560,whablow=7594,whorlow=7832,wsabhigh=2.504,wsorhigh=2.486,
	wsablow=5.931,wsorlow=2.657,wvabhigh=0.101,wvorhigh=0.074,wvablow=0.142,wvorlow=0.074,z=GTB`GT25Z,
	whabkf,whorkf,wsabkf,wsorkf,wvabkf,wvorkf,heabkf,seabkf,veabkf,whabpl=6860,wsabpl=3.877,wvabpl=0,whanpl=1980,
	wsanpl=1.526,wvanpl=0,heabpl,seabpl,veabpl,ho65=2600,so65=4.541,vo65=0.0086,res},
	If[mode < 0 || mode > 3, mode = 0];
	If[model < 1 || model > 6, model = 1];
	{xabpl,xanpl,xorpl} = pl[[3, 2, 1]];
	{xabkf,xankf,xorkf} = kf[[3, 2, 1]];
	kd = xabkf/xabpl;
    	If[mode == 0, mode = "Perchuk et al. (1991), eq.(64, 68)";
      	If[z<0 || z > 1, z = 0];
      	whabkf = z whablow+(1-z)whabhigh; whorkf = z whorlow+(1-z)whorhigh;
      	wsabkf = z wsablow+(1-z)wsabhigh; wsorkf = z wsorlow+(1-z)wsorhigh;
      	wvabkf = z wvablow+(1-z)wvabhigh; wvorkf = z wvorlow+(1-z)wvorhigh;
      	heabkf = (1-xabkf)^2(whabkf+2xabkf(whorkf-whabkf));
      	seabkf = (1-xabkf)^2(wsabkf+2xabkf(wsorkf-wsabkf));
      	veabkf = (1-xabkf)^2(wvabkf+2xabkf(wvorkf-wvabkf));
      	heabpl = (1-xabpl)^2(whabpl+2xabpl(whanpl-whabpl));
      	seabpl = (1-xabpl)^2(wsabpl+2xabpl(wsanpl-wsabpl));
      	veabpl = (1-xabpl)^2(wvabpl+2xabpl(wvanpl-wvabpl));
	t = (heabpl-heabkf+ho65 z-(vo65 z-veabkf+veabpl)p)/(1.987 Log[kd]-seabkf+seabpl+so65 z)-273.15];
    	If[mode == 1, mode = "Powell & Powell (1977), eq.(18)";
	  t = (-xorkf^2(6330+0.093p+2xabkf(1340+0.019p)))/(1.987Log[kd]+xorkf^2(-4.63+1.54 xabkf))-273.15];
    	If[mode == 2, mode = "Stormer (1975), eq.(18)";
	  t = (6326.7-9963.2 xabkf+943.3 xabkf^2+2690.2 xabkf^3+(0.0925-0.1458 xabkf+0.0141 xabkf^2+0.0392 xabkf^3)p)/
	      (-1.9872Log[kd]+4.6321-10.815 xabkf+7.7345 xabkf^2-1.5512 xabkf^3)-273.15];
    	If[mode == 3, mode = "mean of concordant T(ab), T(an), T(or); ";
	  res = PlagKfsp3T[p,xabpl,xanpl,xorpl,xabkf,xankf,xorkf];
	    If[res == "no convergent temperature found",Return[{{0,0},{"no convergent temperature found",0,0,0}}]];
	    Print[];
	    Print["For P = ",p," bar, T(Ab), T(An), T(or) are: ",res[[1]]];
	    Print["Original feldspar compositions are:"];
	    Print["X-Ab(Pl) = ",N[xabpl,5],", X-An(Pl) = ",N[xanpl,5],", X-Or(Pl) = ",N[xorpl,5]];
	    Print["X-Ab(Kf) = ",N[xabkf,5],", X-An(Kf) = ",N[xankf,5],", X-Or(Kf) = ",N[xorkf,5]];
	    Print[];
	    Print["Feldspar compositions have been adjusted to:"];
	    Print["X-Ab(Pl) = ",N[res[[2,1]],5],", X-An(Pl) = ",N[res[[2,2]],5],", X-Or(Pl) = ",N[res[[2,3]],5]];
	    Print["X-Ab(Kf) = ",N[res[[2,4]],5],", X-An(Kf) = ",N[res[[2,5]],5],", X-Or(Kf) = ",N[res[[2,6]],5]];
	    t = (res[[1,1]]+res[[1,2]]+res[[1,3]])/3;
	    Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT25Calibration = ",
	           StringJoin[mode,ToString[Options[Afs]]]]}}]
	  ];
	Return[{{t,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GT25Calibration = ",mode]}}]	  
];
Options[GT25] = {GTB`GT25Calibration->0,GTB`GT25Z->0};
GT25[p_,pl_,kf_,opts___] := GGT25[p,pl,kf,GTB`GT25Calibration/.{opts}/.Options[GT25],
GTB`GT25Z/.{opts}/.Options[GT25]];

GGB1[tc_,grt_,plag_,alsi_,GTB`GB1Calibration_,GTB`GB1GammaAn_] := 
	(* GB1: Garnet - plagioclase - Al2SiO5 - quartz geobarometer  *)
	Block[{mode=GTB`GB1Calibration,xfegt,xmggt,xcagt,xmngt,xan,xab,kd,p,w1,w2,
	par1={a1=125.24,b1=-11.205,c1=-0.512,d1=-0.418,e1=0.94,f1=0.083},
	par2={a2=125.24,b2=-8.293,c2=-1.482,d2=-0.48,e2=0.914,f2=0.066},a,b,c,d,e,f,z,pvolgr,
	vrest,h,s,v,agr,aan,t=tc+273.15,grtt=Last[grt],dummy},
	If[mode < 0 || mode > 4, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xab,xan,dummy} = plag[[3, 2, 1]];
	If[mode == 1 || mode == 2 || mode == 3 || mode == 4,
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = (xfegt+xmggt-e)/f;
	  pvolgr = (a-c(xfegt+xmggt)^2+d(1+(z(xfegt+xmggt))/f)Exp[-z^2/2])/41.84; (* part. MolVol gr in cal/bar *)
	  If[alsi == "kyanite", h = 13349.3; s = -36.70746; vrest = -4.57553]; 
	    (* derived from P(bar)=-2100+23.2 Tc using delta-V=-66.2 cm^3 *)	  
	  If[alsi == "sillimanite", h = 10006.78; s = -31.0471; vrest = -4.3033];
	    (* derived from P(bar)=-1170+23.8 Tc (Ganguly & Saxena 1984, p.93), 
	       vrest based on delta-V(Ky)=-66.2 cm^3 and  volume data of Holdaway (1971), giving delta-V(sil)=-54.81 cm^3 *)
	  If[alsi == "andalusite", h = 11213.3; s = -32.18746; vrest = -4.223];
	    (* vrest based on delta-V(ky)=-66.2 cm^3 and  volume data of Holdaway (1971), giving delta-V(and)=-51.454 cm^3;
	       h and s calculated from (h, s)kyanite using standard enthalpy and entropy data for ky and andalusite given
	       by Holdaway (1971), p.123 *)	  
	  If[mode == 1, (* Hodges & Crowley (1985)  *)  
	    If[alsi == "kyanite",  h = 13352.06; s = -36.70913; vrest = -4.57553];
	    If[alsi == "sillimanite", h = 9755.975; s = -30.449; vrest = -4.3033];
	    If[alsi == "andalusite", h = 8222.04; s = 28.589; vrest = -4.223];
	    {a,b,c,d,e,f} = {a2,b2,c2,d2,e2,f2}; 	    
	    z = ((1-xcagt)-e)/f;
	    pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/41.84];
	  v = vrest + pvolgr];
	If[mode == 0, mode = "Koziol (1989)";
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  w1 = -2060+357.4 (100xmggt)/(xmggt+xfegt)-4.95((100xmggt)/(xmggt+xfegt))^2;
	  w2 = 3391-371 (100xmggt)/(xmggt+xfegt)+6.49((100xmggt)/(xmggt+xfegt))^2;
	  agr = xcagt Exp[((1-xcagt)^2(w1+2xcagt(w2-w1)))/(8.3143 t)];
	  If[alsi == "kyanite", p = 22.8 tc-1093-3 8.3143 t Log[aan/agr]/6.594 ];	(* delta-V from Berman data set  *)
	  If[alsi == "sillimanite", p = -0.0001872 tc^2+23.41 tc-25-3 8.3143 t Log[aan/agr]/5.452 ];
	  If[alsi == "andalusite", p = -0.0001872 tc^2+23.98 tc-581-3 8.3143 t Log[aan/agr]/5.124 ]];
	If[mode == 1, mode = "Hodges & Crowley (1985)";
	  aan = xan Exp[610.34/t-0.3837]; 
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)];
	  p = (h+t(s-3 1.987Log[agr/aan]))/v];
	If[mode == 2, mode = "Ganguly & Saxena (1984)";
	  aan = xan Exp[(xab^2(967-715(3xan-xab)))/(1.987 t)]; (* Saxena & Ribbe (1972)  *)
	  agr = ActivityB[1,t,ToExpression["gr"],{{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtGangulySaxena][[1]];
	  p = (h+t(s-1.987Log[agr/aan^3]))/v];
	If[mode == 3, mode = "Hodges & Spear (1982)";
	  aan = xan GTB`GB1GammaAn;
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)];	  
	  p = (h+t(s-3 1.987Log[agr/aan]))/v];
	If[mode == 4, mode = "Newton & Haselton (1981)";
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt))/(1.987 t)];	  	  
	  p = (h+t(s-3 1.987Log[agr/aan]))/v];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[agr/aan]]],StringJoin["GB1Calibration = ",mode],alsi}}]]
Options[GB1] = {GTB`GB1Calibration->0,GTB`GB1GammaAn->1.8};
GB1[tc_,grt_,plag_,alsi_,opts___] := GGB1[tc,grt,plag,alsi,GTB`GB1Calibration/.{opts}/.Options[GB1],
	GTB`GB1GammaAn/.{opts}/.Options[GB1]];

GGB2[tc_,grt_,plag_,wm_,bt_,GTB`GB2Calibration_] := 
	(* GB2: Garnet - plagioclase - muscovite - biotite geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB2Calibration,xfegt,xmggt,xcagt,xmngt,xan,xab,k,p,
	xkwm,xalviwm,xnawm,xfebt,xmgbt,aan,agr,aal,apy,wpa,wmu,awm,g,r=8.3144,
	par1={a1=125.24,b1=-11.205,c1=-0.512,d1=-0.418,e1=0.94,f1=0.083},
	par2={a2=125.24,b2=-8.293,c2=-1.482,d2=-0.48,e2=0.914,f2=0.066},a,b,c,d,e,f,z,pvolgr,h,s,v,vo,vrest,dummy},
	If[mode < 0 || mode > 4, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xab,xan,dummy} = plag[[3, 2, 1]];
	{xmgbt,xfebt,dummy,dummy,dummy} = bt[[3, 2, 1]]; 
	{xkwm,xnawm,xalviwm,dummy} = wm[[3, 2, 3]];
	If[mode == 0, mode = "Hoisch (1990), Mg-reaction (R5)";
	  h = 3546.01; s = 121.347; vo = 6.37161;
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10; (* part. MolVol gr in J/bar *)
	  v = vo-(pvolgr-12.53);
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)];
	  apy = xmggt Exp[((3300-1.5t)(xcagt^2+xcagt xfegt+xcagt xmngt))/(1.987 t)];	  
	  k = (aan^3 xmgbt^3)/(xalviwm^2 apy^3 agr^3);
	  p = (-h+t s - r t Log[k])/v];
	If[mode == 1, mode = "Hoisch (1990), Fe-reaction (R6)";
	  h = 55530.41; s = 140.635; vo = 6.5994;
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10; (* part. MolVol gr in J/bar *)
	  v = vo-(pvolgr-12.53);
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)];
	  aal = xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)];
	  k = (aan^3 xfebt^3)/(xalviwm^2 aal^3 agr^3);
	  p = (-h+t s - r t Log[k])/v];
	If[mode == 2, mode = "Hodges & Crowley (1985), (R3)";
	  {a,b,c,d,e,f} = {a2,b2,c2,d2,e2,f2}; 	    
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10;  (* part. MolVol gr in J/bar  *)
	  vrest = 20.087; (* J/bar; based on Helgeson (1978) for Ann, An, Ms, Gr; Alm from Berman (1988) *)
	  v = vrest - pvolgr;
	  aan = xan Exp[610.34/t-0.3837]; 
	  agr = xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)];
	  aal = xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)];
	  wpa = 2923.1+0.159 p +0.1698 t; wmu = 4650.1+0.109 p+0.3954 t;
	  awm = (xkwm xalviwm^2)Exp[((xnawm xalviwm^2)^2(wmu+2xkwm xalviwm^2(wpa-wmu)))/(1.987 t)];	  
	  k = (aan^3 xfebt^3)/(awm aal^3 agr^3);
	  g = 69965 - t 162.992 + v(p-1) + 8.3143 t Log[k];
	  p = FindRoot[g==0,{p,1,20000}][[1,2]]];
	If[mode == 3, mode = "Ghent & Stout (1981), Mg-reaction";
	  k = (xan^3 xmgbt^3)/(xkwm xalviwm^2 xmggt^3 xcagt^3);
	  p = (8888.4+16.675t-1.987 t Log[k])/1.738];
	If[mode == 4, mode = "Ghent & Stout (1981), Fe-reaction";
	  k = (xan^3 xfebt^3)/(xkwm xalviwm^2 xfegt^3 xcagt^3);
	  p = (-4124.4+22.061t-1.987 t Log[k])/1.802];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB2Calibration = ",mode]}}]]
Options[GB2] = {GTB`GB2Calibration->0};
GB2[tc_,grt_,plag_,wm_,bt_,opts___] := GGB2[tc,grt,plag,wm,bt,GTB`GB2Calibration/.{opts}/.Options[GB2]];

GGB3[tc_,grt_,plag_,wm_,GTB`GB3Calibration_] := 
	(* GB3: Garnet - plagioclase - muscovite - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB3Calibration,xfegt,xmggt,xcagt,xmngt,xmgwm,xfewm,xan,k,p,
	xalviwm,aan,agr,aal,apy,ats,r=8.3144,a,b,c,d,e,f,z,pvolgr,h,s,v,vo,vrest,
	par1={a1=125.24,b1=-11.205,c1=-0.512,d1=-0.418,e1=0.94,f1=0.083},
	par2={a2=125.24,b2=-8.293,c2=-1.482,d2=-0.48,e2=0.914,f2=0.066},dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{dummy,xan,dummy} = plag[[3, 2, 1]];
	{xfewm,xmgwm,xalviwm} = wm[[3, 2, 1]];
	If[mode == 0, mode = "Hoisch (1990), Mg-reaction (R3)";
	  h = 20681.4; s = 69.8341; vo = 4.17399;
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10; (* part. MolVol gr in J/bar *)	  
	  v = vo-2(pvolgr-12.53)/3;
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = (xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)])^3;
	  apy = (xmggt Exp[((3300-1.5t)(xcagt^2+xcagt xfegt+xcagt xmngt))/(1.987 t)])^3;
	  k = (aan^2 4 xmgwm xalviwm)/(xalviwm^2 apy^(1/3) agr^(2/3));
	  p = (-h+t s - r t Log[k]-185443(xmgwm(xmgwm-2)))/v];
	If[mode == 1, mode = "Hodges & Crowley (1985), (R4)";
	  h = 189029; s = 352.644; {a,b,c,d,e,f} = {a2,b2,c2,d2,e2,f2}; z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10;  (* part. MolVol gr in J/bar  *)
	  vrest = 40.7202; (* J/bar; based on Helgeson (1978) for An, Ms, Qz; Alm from Berman (1988), V(ts) from HC *)
	  v = vrest - 2pvolgr;
	  aan = xan Exp[610.34/t-0.3837]; 
	  agr = (xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)])^3;
	  aal = (xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)])^3;
	  ats = (2xalviwm-1)/(2 xfewm);
	  k = aan^6/(aal agr^2 ats^3);
	  p = (-h+t s - r t Log[k])/v];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB3Calibration = ",mode]}}]]
Options[GB3] = {GTB`GB3Calibration->0};
GB3[tc_,grt_,plag_,wm_,opts___] := GGB3[tc,grt,plag,wm,GTB`GB3Calibration/.{opts}/.Options[GB3]];

GGB4[tc_,grt_,plag_,bt_,GTB`GB4Calibration_] := 
	(* GB4: Garnet - plagioclase - biotite - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB4Calibration,xfegt,xmggt,xcagt,xmngt,xfebt,xmgbt,xalvibt,xan,k,p,
	aan,agr,aal,apy,r=8.3144,a,b,c,d,e,f,z,pvolgr,h,s,v,vo,vrest,xtibt,
	par1={a1=125.24,b1=-11.205,c1=-0.512,d1=-0.418,e1=0.94,f1=0.083},
	par2={a2=125.24,b2=-8.293,c2=-1.482,d2=-0.48,e2=0.914,f2=0.066},dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{dummy,xan,dummy} = plag[[3, 2, 1]];
	{xmgbt,xfebt,xtibt,xalvibt,dummy} = bt[[3, 2, 1]]; 

	If[mode == 0, mode = "Hoisch (1990), Mg-reaction (R1)";
	  h = 31830.6; s = 79.0281; vo = 3.81446;
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10; (* part. MolVol gr in J/bar *)	  
	  v = vo-2(pvolgr-12.53)/3;
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = (xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)])^3;
	  apy = (xmggt Exp[((3300-1.5t)(xcagt^2+xcagt xfegt+xcagt xmngt))/(1.987 t)])^3;	  
	  k = (aan^2 xmgbt^3)/(apy^(1/3)agr^(2/3)6.75 xmgbt^2 xalvibt);
	  p = (-h+t s - r t Log[k]-26968.7(xalvibt-xmgbt)+32604.5 xfebt+42855.4 xtibt)/v];
	If[mode == 1, mode = "Hoisch (1990), Fe-reaction (R2)";
	  h = 46707.2; s = 85.5824; vo = 3.89856;
	  {a,b,c,d,e,f} = par1 xmggt/(xmggt+xfegt)+par2 xfegt/(xmggt+xfegt); 	(* proportional average *)
	  z = ((1-xcagt)-e)/f;
	  pvolgr = (a-c(1-xcagt)^2+d(1+(z(1-xcagt))/f)Exp[-z^2/2])/10; (* part. MolVol gr in J/bar *)	  
	  v = vo-2(pvolgr-12.53)/3;
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = (xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)])^3;
	  aal = (xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)])^3;
	  k = (aan^2 xfebt^3)/(aal^(1/3)agr^(2/3)6.75 xfebt^2 xalvibt);
	  p = (-h+t s - r t Log[k]-30960.2(xalvibt-xfebt)+24289.6 xmgbt+37265.6 xtibt)/v];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB4Calibration = ",mode]}}]]
Options[GB4] = {GTB`GB4Calibration->0};
GB4[tc_,grt_,plag_,bt_,opts___] := GGB4[tc,grt,plag,bt,GTB`GB4Calibration/.{opts}/.Options[GB4]];

GGB5[tc_,grt_,wm_,alsi_,GTB`GB5Calibration_] := 
	(* GB5: Garnet - muscovite - Al2SiO5 - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB5Calibration,xfegt,xmggt,xcagt,xfewm,k,p,
	xalviwm,aal,apy,ats,r=8.3144,h,s,v,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xcagt,xmggt,xfegt,dummy} = grt[[3, 2, 1]];
	{xfewm,dummy,xalviwm} = wm[[3, 2, 1]];
	If[mode == 0, 
	  If[alsi == "kyanite", mode = "Hodges & Crowley (1985), (R7), kyanite";
	    h = 110340; s = 78.948; v = 2.4198];
	    (* v in J/bar; based on Helgeson (1978) for qz, ky; alm from Berman (1988), V(ts) from HC *)
	  If[alsi == "sillimanite", mode = "Hodges & Crowley (1985), (R7), sillimanite";
	    h = 140432; s = 131.332; v = 4.7438];
	    (* v in J/bar; based on Helgeson (1978) for qz, sill; alm from Berman (1988), V(ts) from HC *)
	  aal = (xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)])^3;
	  ats = (2xalviwm-1)/(2 xfewm);
	  k = 1/(aal ats^3);
	  p = (-h+t s - r t Log[k])/v];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB5Calibration = ",mode]}}]]
Options[GB5] = {GTB`GB5Calibration->0};
GB5[tc_,grt_,wm_,alsi_,opts___] := GGB5[tc,grt,wm,alsi,GTB`GB5Calibration/.{opts}/.Options[GB5]];

GGB6[tc_,grt_,wm_,bt_,alsi_,GTB`GB6Calibration_] := 
	(* GB6: Garnet - muscovite - biotite - Al2SiO5 - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB6Calibration,xfegt,xmggt,xcagt,xmngt,k,p,
	xkwm,xalviwm,xnawm,xfewm,xvwm=1,xms,xfebt,xkbt,aal,apy,wpa,wmu,ams,gms,ats,g,r=8.3144,h,s,v,a,b,c,pp,dummy},
	If[mode < 0 || mode > 2, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xfebt,xkbt} = bt[[3, 2, 2]]; 
	{xkwm,xnawm,xalviwm,xfewm} = wm[[3, 2, 3]];
	If[wm[[1,2,4]] > 2, xvwm = 1-(wm[[1,2,4]]-2)]; (* wm[[1,2,4]] = SumOk  *)

	If[mode == 0, mode = "Holdaway et al. (1988), sillimanite";
	  a = 11222+1.389 t+0.2359 p; b = -1134+6.806 t-0.084 p; c = -7305+9.043 t; 
	  xms = xkwm+(1-wm[[1, 2, 5]]);
	  gms = Exp[((1-xms)^2(a+b(1-4xms)+c(1-2xms)(1-6xms)))/(8.3144 t)];
	  ams = xalviwm^2 xvwm xkwm gms;
	  aal = ActivityB[1,t,ToExpression["alm"],{{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtGangulySaxena][[1]];
 	  k = (xfebt^3 xkbt)/(ams aal);
	  g = (15(t-968)-(8.3144 t Log[k])/2.082)-p;
	  p = FindRoot[g==0,{p,1,20000}][[1,2]]];
	If[mode == 1, 
	  If[alsi == "kyanite", mode = "Hodges & Crowley (1985), (R12), kyanite";
	    h = 26848; s = 22.928; v = 0.9368];
	  If[alsi == "sillimanite", mode = "Hodges & Crowley (1985), (R12), sillimanite";
	    h = 41894; s = 49.12; v = 2.0988];
	  aal = xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)];
	  wpa = 2923.1+0.159 p +0.1698 t; wmu = 4650.1+0.109 p+0.3954 t;
	  ams = (xkwm xalviwm^2)Exp[((xnawm xalviwm^2)^2(wmu+2xkwm xalviwm^2(wpa-wmu)))/(1.987 t)];	 
	  k = xfebt^3/(ams aal);
	  g = h - t s + v(p-1) + 8.3144 t Log[k];
	  p = FindRoot[g==0,{p,1,20000}][[1,2]]];
	If[mode == 2, 
	  If[alsi == "kyanite", mode = "Hodges & Crowley (1985), (R9), kyanite";
	    h = 152551; s = 94.963; v = 6.167];
	  (* v in J/bar; based on Helgeson (1978) for Ann, Alsi, Ms; Alm from Berman (1988), V(ts) from HC *)	  
	  If[alsi == "sillimanite", mode = "Hodges & Crowley (1985), (R9), sillimanite";
	    h = 242827; s = 252.115; v = 13.139];
	  aal = xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)];
	  wpa = 2923.1+0.159 p +0.1698 t; wmu = 4650.1+0.109 p+0.3954 t;
	  ams = (xkwm xalviwm^2)Exp[((xnawm xalviwm^2)^2(wmu+2xkwm xalviwm^2(wpa-wmu)))/(1.987 t)];	  
	  ats = (2xalviwm-1)/(2 xfewm);	  
	  k = xfebt^12/(ams^4 aal^5 ats^3);
	  g = h - t s + v(p-1) + 8.3144 t Log[k];
	  p = FindRoot[g==0,{p,1,20000}][[1,2]]];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB6Calibration = ",mode]}}]];
Options[GB6] = {GTB`GB6Calibration->0};
GB6[tc_,grt_,wm_,bt_,alsi_,opts___] := GGB6[tc,grt,wm,bt,alsi,GTB`GB6Calibration/.{opts}/.Options[GB6]];

GGB7[tc_,grt_,fetiox_,alsi_,GTB`GB7Calibration_] := (* GB7: GRAIL geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB7Calibration,xfegt,xmggt,xcagt,xmngt,k,g,p,pp,xilm,xfeailm,xtibilm,wmgfe,wmgca,wfeca,aal,h,s,v,dummy},
	If[mode < 0 || mode > 0, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xfeailm,dummy,xtibilm} = fetiox[[3, 2, 1]];
	xilm = xfeailm*xtibilm;
	If[mode == 0, 
	  If[alsi == "kyanite", mode = "Bohlen et al. (1983), GRAIL, kyanite";
	    h = 11333.4; s = -4.678; v = -1.303];
	    (* v in J/bar; based on Berman data set; h (J), s (J/K), regressed from exp data (sillimanite reaction, 
	       750-900 C runs in alfa-Qz stability field); Ky = Sil used from Berman data set *)	  
	  If[alsi == "sillimanite", mode = "Bohlen et al. (1983), GRAIL, sillimanite";
	    h = 3203.5; s = -18.178; v = -1.874];
	    (* v in J/bar; based on Berman data set; h (J), s (J/K), regressed from exp data (750-900 C runs in alfa-Qz stability field) *)
	    wmgfe=3480-1.2 tc; wmgca = 4180-1.2 tc; wfeca = 1050-1.2 tc; (* Perkins (1979)  *)
	    aal = (xfegt Exp[(wfeca xcagt^2+wmgfe xmggt^2+(wfeca-wmgca+wmgfe)xcagt xmggt)/(1.987 t)])^3;
	    k = aal/xilm^3;
	    p = (-h+t s-8.3143 t Log[k])/v];
	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB7Calibration = ",mode]}}]];
Options[GB7] = {GTB`GB7Calibration->0};
GB7[tc_,grt_,fetiox_,alsi_,opts___] := GGB7[tc,grt,fetiox,alsi,GTB`GB7Calibration/.{opts}/.Options[GB7]];

GGB8[tc_,chl_,bt_,wm_,GTB`GB8Calibration_,GTB`GB8Ah2o_] := (* GB8: Chlorite - biotite - phengite geobarometer *)
	Block[{t=tc+273.15,mode=GTB`GB8Calibration,ah2o=GTB`GB8Ah2o,ams,acel,aclin,aphl1,aphl2,fh2o=0,g,pp,p,r=8.3143,k},
	If[mode < 0 || mode > 1, mode = 0]; If[ah2o <= 0 || ah2o > 1, ah2o = 1];
	{ams,acel} = wm[[3, 2, 4]];
	{aphl,aphl1} = bt[[3, 2, 3]];
	{aclin} = chl[[3, 2, 2]];
	k = (ams aphl^3)/(acel^4 aclin);	
	If[mode == 0, mode = "Bucher-Nurminen (1987)";
	  fh2o = Exp[RTlnf[ToExpression["h2o"],pp,t,FLUIDS`RTlnfModel -> FLUIDS`HollandPowell91]/(r*t)];
	  p = FindRoot[212522-566.87 t-5.529 pp+r t Log[k]+4 r t Log[fh2o*ah2o]==0,{pp,5000,10000}][[1,2]]];	  
	If[mode == 1, mode = "Powell & Evans (1983)";
	  fh2o = Exp[RTlnf[ToExpression["h2o"],pp,t,FLUIDS`RTlnfModel -> FLUIDS`HollandPowell91]/(r*t)];
	  p = FindRoot[212600-611.6 t-1.02 pp+r t Log[k]+4 r t Log[fh2o*ah2o]==0,{pp,5000,10000}][[1,2]]];	
Return[{{tc,p},{StringJoin["lnK = ",ToString[N[Log[k]]]],StringJoin["GB8Calibration = ",mode]}}]]
Options[GB8] = {GTB`GB8Calibration->0,GTB`GB8Ah2o->1};
GB8[tc_,chl_,bt_,wm_,opts___] := GGB8[tc,chl,bt,wm,GTB`GB8Calibration/.{opts}/.Options[GB8],
GTB`GB8Ah2o/.{opts}/.Options[GB8]];

GGB9[tc_,grt_,amph_,plag_,dataset_,GTB`GB9Calibration_] := (* GB9: Garnet - amphibole - plagioclase geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB9Calibration,k=1,p=0,r=8.3144,rr=0.0083143,
	xfegt,xmggt,xcagt,xmngt,rtlnypy,rtlnygr,rtlnyalm,apy,agr,aal,
	xfeamph,xmgamph,atr,afets,afeact,ats,aparg,agl,afparg,k1,k2,k3,pgl,rtlnyamph,check,check1,
	pparg,pkpa,pfts,pts,pcum,ptia,pmna,pfact,ptr,xnaa,xka,xva,xcam4,xmgm4,xfem4,xmnm4,xnam4,xmgm13,xfem13,xmnm13,
	xmgm2,xfem2,xalm2,xfe3m2,xtim2,xoh,xalt1,xsit1,xan,xab,xb,aan,rtlnyab,rtlnyan,a,b,c,dummy},

	If[mode < 0 || mode > 8, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xab,xan,dummy} = plag[[3, 2, 1]];
	{xfeamph,xmgamph} = amph[[3, 2, 1]];

        If[dataset == "HP31" || dataset == "HP32", 
	  {{xnaa,xka,xva},{xcam4,xnam4},{xmgm13,xfem13},{xmgm2,xfem2,xalm2,xfe3m2},{xsit1,xalt1}} = amph[[2,2]]];
        If[dataset == "B88" || dataset == "G97", 
	  {{xnaa,xka,xva}, {xcam4,xmgm4,xfem4,xmnm4,xnam4},{xmgm13,xfem13,xmnm13},
	  {xmgm2,xfem2,xalm2,xfe3m2,xtim2},{xoh},{xalt1,xsit1}} = amph[[2,2]]];	
	If[mode == 0 || mode == 1 || mode == 2, (* Dale et al. (2000) calibration  *)
	  check=Last[amph[[1,2]]];	
	  If[check != "HollandBlundy", 
	    Print["Error-message from GB9: wrong Fe(3+) calculation for amphibole."]; 
	    Print["Use CalcFormula[\"file\",Fe3Amph->HollandBlundy,CalcFormulaMode -> Gtb]."];
	    mode = "wrong Fe(3+) calculation";
	    ];
	  If[check == "HollandBlundy", 
	    rtlnypy = (1-xmggt)xcagt 33 + (1-xmggt)xfegt 2.55;
	    rtlnygr = xmggt(1-xcagt) 33 - xmggt xfegt 2.55;
	    rtlnyalm = -xmggt xcagt 33 + (1-xfegt)xmggt 2.55;
	    xb = 0.12 + 0.00038 t;
	    If[xan > xb, (* (I-1) plagioclase structure  *)
	      rtlnyan = 10(1-xan)^2;
	      rtlnyab = 10(1-xab)^2 - 9 xb^2];
	    If[xan <= xb, (* (C-1) plagioclase structure  *)
	      rtlnyan = (1-xan)^2 + 9(1-xb)^2;
	      rtlnyab = (1-xab)^2];
	    atr = xva*xcam4^2*xmgm13^3*xmgm2^2*xsit1^2;
	    {pgl,pparg,pkpa,pfts,pts,pcum,ptia,pmna,pfact,ptr} = amph[[3, 2, 3]];
	    If[mode == 0, mode = "Dale et al. (2000), reaction (1): Tschermakite-tremolite";
	      ats = 4xva*xcam4^2*xmgm13^3*xalm2^2*xsit1*xalt1;
	      k = (atr xan^4)/(ats xmggt^2 xcagt^4);
              rtlnyamph = (20.8(pts-ptr)+pparg(29.3-18.2)+pgl(35.3-15)+pfact(11.4)+pfts(88.3)+pkpa(35.8));
	      p = 1000(-12.25-0.1225 t+rr t Log[k]+4rtlnyan-(2/3)rtlnypy-(4/3)rtlnygr+rtlnyamph)/(-7.082);
              ];
	    If[mode == 1, mode = "Dale et al. (2000), reaction (2): Pargasite-tremolite";
	      aparg = 16xnaa*xcam4^2*xmgm13^3*xmgm2*xalm2*xalt1*xsit1;
	      k = (atr xan^2 xab)/(aparg xmggt xcagt^2);
	      rtlnyamph = 29.3(pparg-ptr)+2.6 pts-49.2 pgl;
	      p = 1000(-6.41-0.0454 t+rr t Log[k]+2rtlnyan+rtlnyab-(1/3)rtlnypy-(2/3)rtlnygr+rtlnyamph)/(-4.189);
     	      ];
	    If[mode == 2, mode = "Dale et al. (2000), reaction (3): Glaucophane-tremolite";
	      agl = xva*xnam4^2*xmgm13^3*xalm2^2*xsit1^2;
	      k = (atr xan^2 xab^2)/(agl xmggt^2 xcagt^4);
	      rtlnyamph = 35.3(pgl-ptr)+5.8 pts-55.2pparg-3.6pfact-38.8pkpa;
	      p = 1000(26.17-0.1729 t+rr t Log[k]+2rtlnyan+2rtlnyab-(2/3)rtlnypy-(4/3)rtlnygr+rtlnyamph)/(-7.89);
      	      ];
	    ];
	  ];
	If[mode >= 3 && mode <= 8, (* Kohn & Spear (1990) calibrations  *)	  
	  check=Last[amph[[1,2]]]; check1=Last[grt[[1,2]]];	
	  If[check != "LeakeFe3Min", 
	    Print["Error-message from GB9: wrong Fe(3+) calculation for amphibole."]; 
	    Print["Use CalcFormula[\"file\",Fe3Amph->LeakeFe3Min,Fe3Grt->NoCalculation,CalcFormulaMode -> Gtb]."];
	    mode = "wrong Fe(3+) calculation";
	    ];
	  If[check1 != "NoCalculation", 
	    Print["Error-message from GB9: no Fe(3+)-recalculation for garnet allowed with this calibration."]; 
	    Print["Use CalcFormula[\"file\",Fe3Amph->LeakeFe3Min,Fe3Grt->NoCalculation,CalcFormulaMode -> Gtb]."];
	    mode = "wrong Fe(3+) calculation";
	    ];
	  If[check == "LeakeFe3Min" && check1 == "NoCalculation", 
	    agr = (xcagt Exp[((3300-1.5t)(xmggt^2+xmggt xfegt+xmggt xmngt))/(1.987 t)])^3;
	    apy = (xmggt Exp[((3300-1.5t)(xcagt^2+xcagt xfegt+xcagt xmngt))/(1.987 t)])^3;	
	    aal = (xfegt Exp[((1.5t-3300)(xmggt xcagt))/(1.987 t)])^3;
	    aan = xan Exp[610.34/t-0.3837];
    	    If[mode == 3, mode = "Kohn & Spear (1990), Mg-reaction (1a)";
     	      ats = (256/27)xalt1 xsit1^3 xmgamph;
     	      atr = xsit1^4 xmgamph^2;
     	      k = (agr^2 apy ats^3)/(aan^6 atr^3);
              p = (79507+t 29.14 + r t Log[k])/10.988];
	    If[mode == 4, mode = "Kohn & Spear (1990), Fe-reaction (1b)";
     	      afets = (256/27)xalt1 xsit1^3 xfeamph;
      	      afeact = xsit1^4 xfeamph^2;
     	      k = (agr^2 aal afets^3)/(aan^6 afeact^3);
      	      p = (35327+t 56.09 + r t Log[k])/11.906];
	    If[mode == 5, mode = "Kohn & Spear (1989), Mg-reaction (1a), model 1";
	      aparg = 16xalt1^2 xsit1^2 xnaa;
	      atr = xsit1^4 xva;
     	      k = (agr^2 apy aparg^3)/(aan^6 xab^3 atr^3);
      	      p = (120593 + t(10.3-8.314Log[k]))/14.81];
	    If[mode == 6, mode = "Kohn & Spear (1989), Fe-reaction (1b), model 1";
	      afparg = 16xalt1^2 xsit1^2 xnaa;
	      afeact = xsit1^4 xva;
     	      k = (agr^2 aal afparg^3)/(aan^6 xab^3 afeact^3);
      	      p = (117993 + t(-47.8-8.314Log[k]))/11.29];
	    If[mode == 7, mode = "Kohn & Spear (1989), Mg-reaction (1a), model 2";
	      aparg = 4xalm2 xmgm2 xnaa;
	      atr = xmgm2^2 xva;
     	      k = (agr^2 apy aparg^3)/(aan^6 xab^3 atr^3);
      	      p = (44724 + t(51.9-8.314Log[k]))/9.19];
	    If[mode == 8, mode = "Kohn & Spear (1989), Fe-reaction (1b), model 2";
	      afparg = 4xalm2 xfem2 xnaa;
	      afeact = xfem2^2 xva;
     	      k = (agr^2 aal afparg^3)/(aan^6 xab^3 afeact^3);
      	      p = (-4948 + t(81.8-8.314Log[k]))/9.52];
      	    ];
	  ];     	  
      	        	  
Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB9Calibration = ",mode]}}]]
Options[GB9] = {GTB`GB9Calibration->0};
GB9[p_,grt_,amph_,plag_,dataset_,opts___] := GGB9[p,grt,amph,plag,dataset,GTB`GB9Calibration/.{opts}/.Options[GB9]];

GGB10[tc_,file_,datset_,GTB`GB10Calibration_,GTB`GB10Xab_,GTB`GB10Xan_,GTB`GB10Xor_] := (* GB10: Ab = Jd + Qz reaction *)
	Block[{t=tc+273.15,mode=GTB`GB10Calibration,xjd,xalm1,xfe2m1,xmgm1,xfe3m1,xcam2,xnam2,xab=GTB`GB10Xab,
	xan=GTB`GB10Xan,xor=GTB`GB10Xor,ajd,aab,p,dummy},
	If[mode < 0 || mode > 0, mode = 0];
        If[dataset == "B88" || dataset == "G97", 
	  Print["Wrong data set: Recalculate formulae with HP98 data set."];
	  mode = "wrong data set.";
	  ];
        If[dataset == "HP31" || dataset == "HP32", 
	  aab = ActivityHP[1,t,ToExpression["ab"],{{{xab,xan}},{xab,xan}},ActivityMode->RealActivity][[1]];
	  ajd = ActivityHP[1,t,ToExpression["jd"],dummy,ActivitySampleFile->file,ActivityMode ->RealActivity][[1]];
    	  If[mode == 0, mode = "Holland (1980), a(jd) as in THERMOCALC";
	    p = 350 + 26.5 tc - (8.3143 t Log[aab/ajd])/1.734];	  
	  ];
Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[aab/ajd]]],StringJoin["GB10Calibration = ",mode]}}]]
Options[GB10] = {GTB`GB10Calibration->0,GTB`GB10Xab->1,GTB`GB10Xan->0,GTB`GB10Xor->0};
GB10[tc_,file_,datset_,opts___] := GGB10[tc,file,datset,GTB`GB10Calibration/.{opts}/.Options[GB10],
GTB`GB10Xab/.{opts}/.Options[GB10],GTB`GB10Xan/.{opts}/.Options[GB10],GTB`GB10Xor/.{opts}/.Options[GB10]];

GGB11[tc_,grt_,wm_,cpx_,file_,datset_,GTB`GB11Calibration_] := (* Garnet - phengite - omphacite geobarometer for phengite eclogites *)
	Block[{t=tc+273.15,p,mode=GTB`GB11Calibration,dummy,xfegt,xmggt,xcagt,xmngt,ainvphe,lnadi=0,lnydi=0,lnydiord=0,apy,agr,lnk,
	xcam2,xnam2,xmgm2,xalm1,xfe3m1,xmgm1,xfem1,xjd,xxjd,xacm,xdi,xxdi,xhd,wa=26000,wb=25000,wc=0,r=8.3143,tcc=1138,a=23},	
	If[mode < 0 || mode > 2, mode = 0];
        If[dataset == "B88" || dataset == "G97", 
	  Print["Wrong data set: Recalculate formulae with HP98 data set."];
	  mode = "wrong data set.";
	  ];
        If[dataset == "HP31" || dataset == "HP32", 
	  {xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	  apy = ActivityB[1,t,ToExpression["py"],{{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtNewtonHaselton][[1]];
	  agr = ActivityB[1,t,ToExpression["gr"],{{xcagt,xmggt,xfegt,xmngt},{1,0}},ActivityModelGrt->GrtNewtonHaselton][[1]];
	  ainvphe = wm[[3, 2, 5]][[1]];	(* activity of inverse phengite  *)	
	  
	  If[mode == 0 || mode == 1, (* according to http://www.earth.ox.ac.uk/~davewa/research/ecbarcal.html. *)
	    {{{xcam2,xnam2,xmgm2},{xalm1,xfe3m1,xmgm1,xfem1}},{xxjd,xacm,xxdi,xhd}} = ExtractSampleDatHP["cpx", file];		  
	    (* for application of equ.12b of Holland (1990) di-hed-jd-ac must be projected to pseudo-binary form *)
	    (* di + hed are taken together as X(Di), the rest to (1-X(ac)) is then X(Jd)  *)	  
	    xxdi = xmgm1+xfem1; xxjd = (1-xfe3m1)-xxdi; 
	    xjd = xxjd/(xxjd+xxdi); xdi = xxdi/(xxjd+xxdi); (* normalize to unity  *)
	    lnydi = (xnam2(xfe3m1 (wa-wc)+xfem1 (wa-wb)+xalm1 wa))/(r t);	  
	    If[mode == 0, mode = "Waters & Martin (1996): ordered P2/n omph";	
	      If[t<tcc,lnydiord = (-a/3((4xjd xdi tcc-t)/tcc)^0.5(2tcc xjd(4xjd-1)-t))/(r t)]];
	    If[mode == 1, mode = "Waters & Martin (1996): disordered C2/c omph"];
	    lnadi = Log[xcam2 xmgm1] + lnydi + lnydiord;	  
	    lnk = 6lnadi - Log[apy] - 2Log[agr] + 3Log[ainvphe];
	    p = (28.05 + 0.02044 t - 0.003539 t lnk)1000;
	    ];
	  If[mode == 2, mode = "Waters & Martin (1993)";
	    adi = ActivityHP[1,t,ToExpression["di"],dummy,ActivitySampleFile->file,ActivityMode ->RealActivity][[1]];
	    lnk = 6Log[adi] - Log[apy] - 2Log[agr] + 3Log[ainvphe];
	    p = 26900 + 15.9 t - 2.49 t lnk;	    			  
	    ]; 	    	    	    
	  ];	  		
Return[{{tc,p},{StringJoin["lnK = ",ToString[lnk]],StringJoin["GB11Calibration = ",mode]}}]
]
Options[GB11] = {GTB`GB11Calibration->0};
GB11[tc_,grt_,wm_,cpx_,file_,datset_,opts___] := GGB11[tc,grt,wm,cpx,file,datset,GTB`GB11Calibration/.{opts}/.Options[GB11]];

GB12[tc_,amph_,chl_] := (* GB12: Amphibole - chlorite geobarometer *)
	Block[{p,mode="Cho, M. (cited in Laird, 1988)",xfeamph,xmgamph,xfechl,xmgchl,kd},
	{xfechl,xmgchl} = chl[[3, 2, 1]]; 
	{xfeamph,xmgamph} = amph[[3, 2, 1]];
	kd = (xmgamph/xfeamph)/(xmgchl/xfechl);
	p = 1000(10.5 Log[kd] + 0.5);
	Return[{{tc,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GB12Calibration = ",mode]}}]]

GGB13[tc_,amph_,GTB`GB13Calibration_] := (* GB13: Al-in-hornblende barometer *)
	Block[{p,mode=GTB`GB13Calibration,aliv,alvi,altot,kd={}},
	If[mode < 0 || mode > 2, mode = 0];
	aliv = amph[[1,2,1]]; alvi = amph[[1,2,2]]; altot = aliv + alvi;
	If[mode == 0, mode = "Anderson & Smith (1995)";
    	  p = (4.76 altot - 3.01 - (tc - 675)/85 (.53 altot + .005294 (tc - 675)))1000];
	If[mode == 1, mode = "Schmidt (1992)"; 
	  p = (0.476 altot - 0.301)10000];
	If[mode == 2, mode = "Johnson & Rutherford (1989)"; 
	  p = (-3.46 + 4.23 altot)1000];	  
	Return[{{tc,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GB13Calibration = ",mode]}}]]
Options[GB13] = {GTB`GB13Calibration->0};
GB13[tc_,amph_,opts___] := GGB13[tc,amph,GTB`GB13Calibration/.{opts}/.Options[GB13]];

GB14[tc_,grt_,opx_] := (* GB14: Al-in-opx barometer *)
	Block[{t=tc+273.15,p,r=8.3143,mode="Brey & Köhler (1990)",kd,xcagt,xmggt,xfegt,xmngt,xalgt,xcrgt,xalm1tsopx,xmfm1opx,xmfm2opx,xmgm1opx,xfem1opx,c1,c2,c3},
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{xalgt,xcrgt} = grt[[3, 2, 3]];
	{xalm1tsopx,xmfm1opx,xmfm2opx,xmgm1opx,xfem1opx} = opx[[3, 2, 5]];
	kd = ((1-xcagt)^3*xalgt^2)/(xmfm1opx*xmfm2opx^2*xalm1tsopx);
	c1 = - r*t*Log[kd]-5510+88.9*t-19*t^1.2+3xcagt^2*82458+xmgm1opx*xfem1opx(80942-46.7t)-
	     3*xfegt*xcagt*17793-xcagt*xcrgt(1.164*10^6-420.4t)-xfegt*xcrgt(-1.25*10^6+565t);
	c2 = -0.832-8.78*10^-5(t-298)+3xcagt^2*3.305-xcagt*xcrgt*13.45+xfegt*xcrgt*10.5;
	c3 = 16.6*10^-4;
	p = 1000*(-c2-(c2^2+4c3*c1/1000)^0.5)/(2c3);	
	Return[{{tc,p},{StringJoin["lnKD = ",ToString[Log[kd]]],StringJoin["GB14Calibration = ",mode]}}]]

GGB15[tc_,grt_,opx_,plag_,GTB`GB15Calibration_] := 
	(* GB15: Garnet - orthopyroxene - plagioclase - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB15Calibration,xfegt,xmggt,xcagt,xmngt,xan,k,p,femgopx,xfeopx,xmgopx,xalopx,
	aan,agr,aal,apy,aen,afs,wcamg,wmgca,wcafe,wfeca,wfemg,wmgfe,c123,dummy},
	If[mode < 0 || mode > 5, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
    	{femgopx,xfeopx,xmgopx,xalopx} = opx[[3, 2, 3]];
	{dummy,xan,dummy} = plag[[3, 2, 1]];

	If[mode == 0 || mode == 1, 
	  wcamg = 4047-1.5 t; (* Table 1, Lal (1993)  *)
	  wmgca = 1000-1.5 t;
	  wcafe = -723+0.332 t;
	  wfeca = 1090;
	  wfemg = -1256+1.0 t;
	  wmgfe = 2880-1.7 t;
	  c123 = -4498+1.516 t;
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2/(1.987 t)(2050+9392xan)];
	  agr = xcagt Exp[(xmggt^2(wcamg+2xcagt(wmgca-wcamg))+xfegt^2(wcafe+2xcagt(wfeca-wcafe))+
	        xmggt xfegt(0.5(wmgca+wcamg+wfeca+wcafe-wmgfe-wfemg)+xcagt(wmgca-wcamg+wfeca-wcafe)+
	        (xmggt-xfegt)(wmgfe-wfemg)-(1-2xcagt)c123))/(1.987 t)];
	  If[mode == 0, mode = "Lal (1993), Mg-reaction (C)";
	    (* activities returned from -Activity- would be slightly different, because calculated for a quaternary garnet.
	       Explicit activities for ternary garnet mixing are used here to be compatibel with Lal (1993)  *)
	    apy = xmggt Exp[(xfegt^2(wmgfe+2xmggt(wfemg-wmgfe))+xcagt^2(wmgca+2xmggt(wcamg-wmgca))+
	          xfegt xcagt(0.5(wfemg+wmgfe+wcamg+wmgca-wfeca-wcafe)+xmggt(wfemg-wmgfe+wcamg-wmgca)+
	          (xfegt-xcagt)(wfeca-wcafe)-(1-2xmggt)c123))/(1.987 t)];	  	  
	    aen = xmgopx*Exp[((948-0.34t)*xfeopx^2+(948-0.34t+1950)xfeopx*xalopx)/(1.987*t)];
	    k = (apy^2*agr)/(aan*aen^2);
	    p = (-3985+t*(-5.376-1.987Log[k]))/(-0.5614)+1;
	    ];
	  If[mode == 1, mode = "Lal (1993), Fe-reaction (B)";
	    aal = xfegt Exp[(xmggt^2(wfemg+2xfegt(wmgfe-wfemg))+xcagt^2(wfeca+2xfegt(wcafe-wfeca))+
	          xmggt xcagt(0.5(wmgfe+wfemg+wcafe+wfeca-wmgca-wcamg)+xfegt(wmgfe-wfemg+wcafe-wfeca)+
	          (xmggt-xcagt)(wmgca-wcamg)-(1-2xfegt)c123))/(1.987 t)];	  	  
	    afs = xfeopx*Exp[((948-0.34t)*xmgopx^2+(-1950)xalopx^2+(948-0.34t-1950)xmgopx*xalopx)/(1.987*t)];
	    k = (aal^2*agr)/(aan*afs^2);
	    p = (2749+t*(-8.644-1.987Log[k]))/(-0.60946)+1;
	    ];
	  ];
	If[mode == 2, mode = "Bhattacharya et al. (1991), Mg-reaction (B)";
	  apy = xmggt*Exp[0.906 xcagt^2+xfegt(0.746-1.22 xmggt)+xcagt xfegt(1.346-0.61 xmggt)];	  	  
	  agr = xcagt*Exp[0.906 xmggt^2+xfegt xmggt(0.465-0.61(xfegt-xmggt))];
	  aen = xmgopx*Exp[0.477(1-xmgopx)^2];
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2(1.009+4.62 xan)];
	  k = (apy^2*agr)/(aan*aen^2);
	  p = 3944+13.07 t+3.5038 t Log[k];
	  ];
	If[mode == 3, mode = "Bhattacharya et al. (1991), Fe-reaction (C)";
	  aal = xfegt*Exp[(0.136+1.22 xfegt)xmggt^2+xcagt xmggt(-0.465+0.61xfegt)];	  	  
	  agr = xcagt*Exp[0.906 xmggt^2+xfegt xmggt(0.465-0.61(xfegt-xmggt))];
	  afs = (1-xmgopx)*Exp[0.477 xmgopx^2];
	  aan = (xan(1+xan)^2)/4Exp[(1-xan)^2(1.009+4.62 xan)];
	  k = (aal^2*agr)/(aan*afs^2);
	  p = -3602+13.753t+3.352  t Log[k];
	  ];
	If[mode == 4 || mode == 5,
	  agr = xcagt*Exp[(3300-1.5t)(xmggt^2+xmggt*xfegt)/(1.987*t)];	  	  
	  apy = xmggt*Exp[(3300-1.5t)(xcagt^2+xcagt*xfegt)/(1.987*t)];
	  aen = opx[[3, 2, 4, 6]]*opx[[3, 2, 4, 8]]; (* a(En) = XMg(M1)*XMg(M2)  *)
	  aan = (xan(1+xan)^2)/4*Exp[((1-xan)^2(2025+2xan(6746-2025)))/(1.987 t)];
	  k = (apy^2*agr)/(aan*aen);
	  If[mode == 4, mode = "Eckert et al. (1991), Mg-reaction (A)";
	    p = 3470 + 13.07t + 3.5038 t Log[k]];
	  If[mode == 5, mode = "Newton & Perkins (1982), Mg-reaction (A)";
	    p = 3944 + 13.07t + 3.5038 t Log[k]];
	  ];

	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB15Calibration = ",mode]}}]]
Options[GB15] = {GTB`GB15Calibration->0};
GB15[tc_,grt_,opx_,plag_,opts___] := GGB15[tc,grt,opx,plag,GTB`GB15Calibration/.{opts}/.Options[GB15]];

GGB16[tc_,grt_,cpx_,plag_,GTB`GB16Calibration_] := 
	(* GB16: Garnet - clinopyroxene - plagioclase - quartz geobarometer  *)
	Block[{t=tc+273.15,mode=GTB`GB16Calibration,xfegt,xmggt,xcagt,xmngt,xan,k,p,aan,agr,apy,adi,dummy},
	If[mode < 0 || mode > 1, mode = 0];
	{xcagt,xmggt,xfegt,xmngt} = grt[[3, 2, 1]];
	{dummy,xan,dummy} = plag[[3, 2, 1]];

	If[mode == 0 || mode == 1,
	  agr = xcagt*Exp[(3300-1.5t)(xmggt^2+xmggt*xfegt)/(1.987*t)];	  	  
	  apy = xmggt*Exp[(3300-1.5t)(xcagt^2+xcagt*xfegt)/(1.987*t)];
	  adi = cpx[[3, 2, 4, 4]]*cpx[[3, 2, 4, 6]]; (* a(Di) = XCa(M2)*XMg(M1)  *)
	  aan = (xan(1+xan)^2)/4*Exp[((1-xan)^2(2025+2xan(6746-2025)))/(1.987 t)];
	  k = (apy*agr^2)/(aan*adi);
	  If[mode == 0, mode = "Eckert et al. (1991), Mg-reaction (B)";
	    p = 2600 + 17.179t + 3.5962 t Log[k]];
	  If[mode == 1, mode = "Newton & Perkins (1982), Mg-reaction (B)";
	    p = 675 + 17.179t + 3.5962 t Log[k]];
	  ];

	Return[{{tc,p},{StringJoin["lnK = ",ToString[Log[k]]],StringJoin["GB16Calibration = ",mode]}}]]
Options[GB16] = {GTB`GB16Calibration->0};
GB16[tc_,grt_,cpx_,plag_,opts___] := GGB16[tc,grt,cpx,plag,GTB`GB16Calibration/.{opts}/.Options[GB16]];


CalcThermoBaro[tb_,fname_,outputfile_] := 
	Block[{file,int,inb,int1,inb1,r,ntb,tbl,pos,na,n1,n2,dn,min,max,ox,step,pt,n,i,j,k,l,dat,alldat,res={},d,gtb,gtbn,check,count,alsi="",dataset},

	If[FileNames[file=StringJoin[fname,".fu"]] == {}, 	
	   Print["Error-message from -CalcThermoBaro-: File ",file," does not exist."]; 
	   Print["Use: \"CalcFormula[file_name, CalcFormulaMode -> Gtb]\" before !"];
	   Return[]];
	     
	r = Get[file]; ox = r[[1]]; dataset = r[[4]];
		
	int = {ToExpression["{grt,bt}"],ToExpression["{grt,wm}"],ToExpression["{grt,chl}"],ToExpression["{bt,chl}"],
	       ToExpression["{wm,bt}"],ToExpression["{grt,fetiox}"],ToExpression["{grt,cpx}"],ToExpression["{plag,wm}"],
	       ToExpression["{grt,opx}"],ToExpression["{opx,cpx}"],ToExpression["{opx,bt}"],ToExpression["{grt,ol}"],
	       ToExpression["{cpx,ol}"],ToExpression["{grt,amph}"],ToExpression["{grt,crd}"],ToExpression["{grt,stau}"],
	       ToExpression["{grt,ctd}"],ToExpression["{chl,ctd}"],ToExpression["{bt,ctd}"],ToExpression["{grt,spin}"],
	       ToExpression["{ol,spin}"],ToExpression["{crd,spin}"],ToExpression["{amph,plag}"],
	       ToExpression["{cal,cal}"],ToExpression["{plag,kf}"]};
	int1 = {"{grt-bt FeMg-1}","{grt-wm FeMg-1}","{grt-chl FeMg-1}","{bt-chl FeMg-1}",
	       "{wm-bt FeMg-1}","{grt-fetiox FeMn-1}","{grt-cpx FeMg-1}","{plag-wm NaK-1}",
	       "{grt-opx FeMg-1}","{opx-cpx solvus}","{opx-bt FeMg-1}","{grt-ol FeMg-1}",
	       "{cpx-ol FeMg-1}","{grt-amph FeMg-1}","{grt-crd FeMg-1}","{grt-stau FeMg-1}",
	       "{grt-ctd FeMg-1}","{chl-ctd FeMg-1}","{bt-ctd FeMg-1}","{grt-spin FeMg-1}",
	       "{ol-spin FeMg-1}","{crd-spin FeMg-1}","{amph-plag exchange}",
	       "{cal-dol solvus}","{plag-kf solvus}"};
	inb = {ToExpression["{grt,plag}"], ToExpression["{grt,plag,wm,bt}"], ToExpression["{grt,plag,wm}"], 
	       ToExpression["{grt,plag,bt}"], ToExpression["{grt,wm}"], ToExpression["{grt,wm,bt}"], 
      	       ToExpression["{grt,fetiox}"], ToExpression["{chl,bt,wm}"], ToExpression["{grt,amph,plag}"], 
      	       ToExpression["{cpx,cpx}"], ToExpression["{grt,wm,cpx}"], ToExpression["{amph,chl}"], 
      	       ToExpression["{amph,amph}"],ToExpression["{grt,opx}"],ToExpression["{grt,opx,plag}"],ToExpression["{grt,cpx,plag}"]};
	inb1 = {"{GASP barometer}", "{grt-plag-wm-bt barometer}", "{grt-plag-wm barometer}", 
	       "{grt-plag-bt barometer}", "{grt-wm-Al2SiO5-qz barometer}", "{grt-wm-bt-Al2SiO5-qz barometer}", 
      	       "{GRAIL barometer}", "{chl-bt-wm barometer}", "{grt-amph-plag barometer}", 
      	       "{Ab = Jd+Qz barometer}", "{grt-phe-omph barometer}", "{amph-chl barometer}", 
      	       "{Al-in-hornblende barometer}","{Al-in-opx barometer}","{grt-opx-plag-qz barometer}","{grt-cpx-plag-qz barometer}"};
	      
	ntb = Dimensions[tb][[1]];	
	mean = stddev = Table[0,{i,1,ntb}];

	For[k=1,k<=ntb,k++, (* loop over number of different thermobarometers *)
	   tbl = tb[[k]];
	   gtb = ToString[tbl[[1]]];
	   check = 0;
	   If[StringTake[gtb, {1, 1}] == "g" && StringTake[gtb, {2, 2}] == "t" || StringTake[gtb, {1, 1}] == "g" && StringTake[gtb, {2, 2}] == "b", 
	     If[NumberQ[ToExpression[StringTake[gtb, {3, 3}]]] == True, check = 1]];
	   If[check == 0, 
	     Print["Error-message from -CalcThermoBaro-: Use \"gt\"+number or \"gb\"+number to designate a geothermobarometer, e.g. gt12."];
	     Return[]];
	   gtbn = ToExpression[StringTake[gtb,{3,StringLength[gtb]}]];

	   If[StringTake[gtb, {2, 2}] == "t",	   	   
	     If[gtbn <= Dimensions[int][[1]],tbl[[1]] = int[[gtbn]]];	    
	     If[gtbn > Dimensions[int][[1]] || gtbn < 1,Print["Error-message from -CalcThermoBaro-: There exists no thermometer with number ",gtbn,"."]; Return[]]];
	   If[StringTake[gtb, {2, 2}] == "b",	   	   
	     If[gtbn <= Dimensions[inb][[1]],tbl[[1]] = inb[[gtbn]]];	    
	     If[gtbn > Dimensions[inb][[1]] || gtbn < 1,Print["Error-message from -CalcThermoBaro-: There exists no barometer with number ",gtbn,"."]; Return[]]];
	   pos = na = Table[{},{l,1,Dimensions[tbl[[1]]][[1]]}];
	   For[l=1,l<=Dimensions[tbl[[1]]][[1]],l++,
	      pos[[l]] = Position[r[[2]],tbl[[1,l]]]; na[[l]] = Dimensions[pos[[l]]][[1]]];
	   If[Dimensions[Union[na]][[1]] != 1, 
	   Return["Message from -CalcThermoBaro-: Data file error.Either unequal number of analyses (cannot be paired), or one phase absent."]];
	   dn = Table[0,{l,1,Dimensions[tbl[[1]]][[1]]},{i,1,na[[1]]}];
	   For[l=1,l<=Dimensions[tbl[[1]]][[1]],l++,
	      For[i=1,i<=na[[l]],i++, (* number of different analyses *)
              dn[[l,i]] = r[[2,pos[[l]][[i,1]]]]]];
	   If[Dimensions[tbl[[2]]][[1]] != 3, Return["Wrong input format: give a list {min, max, step} !"]];
	   min = tbl[[2,1]]; max = tbl[[2,2]]; step = tbl[[2,3]]; 
	   If[step == 0, Return["Step must be != 0"]];
	   n = Abs[max-min]/step + 1;
	   dat = Table[0,{i,1,na[[1]]}];

	   For[i=1,i<=na[[1]],i++, pt = min; (* loop over number of analyses  *)
	      dat[[i]] = Table[0,{j,1,n}];
	      If[Dimensions[Last[dn[[1,i]]]][[1]] != 3 || Dimensions[Last[dn[[2,i]]]][[1]] != 3,
		Print["Error-message from -CalcThermoBaro-: gtb-parameters not calculated by -CalcFormula-."];
		Print["Use: \"CalcFormula[file_name, CalcFormulaMode -> Gtb]\"."];
  		Return[]];

	      For[j=1,j<=n,j++,  (* loop over number of P or T increments  *)
	      
	      	 If[StringTake[gtb, {2, 2}] == "t",
	      	   If[gtbn == 1,  res = GT1[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]]; 
	      	   If[gtbn == 2,  res = GT2[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 3,  res = GT3[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 4,  res = GT4[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];	      	   
	      	   If[gtbn == 5,  res = GT5[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 6,  res = GT6[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 7,  res = GT7[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 8,  res = GT8[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 9,  res = GT9[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 10, res = GT10[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 11,  res = GT11[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 12,  res = GT12[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 13,  res = GT13[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 14,  res = GT14[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],dataset]];
	      	   If[gtbn == 15,  res = GT15[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 16,  res = GT16[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 17,  res = GT17[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 18,  res = GT18[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 19,  res = GT19[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 20,  res = GT20[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 21,  res = GT21[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 22,  res = GT22[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 23,  res = GT23[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 24,  res = GT24[pt,Last[dn[[1,i]]]]];
	      	   If[gtbn == 25,  res = GT25[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   ];	   	   

	      	 If[StringTake[gtb, {2, 2}] == "b",
	      	   If[gtbn == 1 || gtbn == 5 || gtbn == 6 || gtbn == 7, (* check Alsi-phase *)
	   	     If[Dimensions[tbl][[1]] != 3, (* Alsi present  *)
	   	       Print["Error-message from -CalcThermoBaro-: define an Alsi-phase as 3rd element for gb",gtbn,".(either kyanite, sillimanite or andalusite)."];
	   	       Return[]];
	     	     alsi = ToString[tbl[[3]]];
	     	     If[alsi != "kyanite" && alsi != "sillimanite" && alsi != "andalusite", alsi = "kyanite"];	      	   
	      	     ];
	      	   If[gtbn == 1,  res = GB1[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],alsi]];
	      	   If[gtbn == 2,  res = GB2[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]],Last[dn[[4,i]]]]];
	      	   If[gtbn == 3,  res = GB3[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]]]];
	      	   If[gtbn == 4,  res = GB4[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]]]];
	      	   If[gtbn == 5,  res = GB5[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],alsi]];
	      	   If[gtbn == 6,  res = GB6[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]],alsi]];
	      	   If[gtbn == 7,  res = GB7[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],alsi]];
	      	   If[gtbn == 8,  res = GB8[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]]]];
	      	   If[gtbn == 9,  res = GB9[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]],dataset]];
	      	   If[gtbn == 10,  res = GB10[pt,fname,dataset]];
	      	   If[gtbn == 11,  res = GB11[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]],fname,dataset]];
	      	   If[gtbn == 12,  res = GB12[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 13,  res = GB13[pt,Last[dn[[1,i]]]]];
	      	   If[gtbn == 14,  res = GB14[pt,Last[dn[[1,i]]],Last[dn[[2,i]]]]];
	      	   If[gtbn == 15,  res = GB15[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]]]];
	      	   If[gtbn == 16,  res = GB16[pt,Last[dn[[1,i]]],Last[dn[[2,i]]],Last[dn[[3,i]]]]];
		   ];
	      	           
	         If[res != {}, dat[[i,j]] = ToExpression[ToString[NumberForm[res[[1]],{10,3}]]]];
	         pt = pt + step;
	         ];
	      If[StringTake[gtb, {2, 2}] == "t",
	        dat[[i]] = Append[{int1[[gtbn]],Append[{fname},res[[2]]]},dat[[i]]]];
	      If[StringTake[gtb, {2, 2}] == "b",
	        dat[[i]] = Append[{inb1[[gtbn]],Append[{fname},res[[2]]]},dat[[i]]]];	        
	      ];
	   If[k==1, alldat = dat];
	   If[k>1, alldat = Join[alldat,dat]];
	   ];
	Put[alldat, StringJoin[outputfile,".ptx"]   ];
	Return[alldat]]

End[]
                     
EndPackage[]
