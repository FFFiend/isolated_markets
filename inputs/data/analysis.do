***********
* Replication of "Competition and Pass-through: Evidence from Isolated Markets"
* Genakos and Pagliero
* May 2021
* Christos Genakos c.genakos@jbs.cam.ac.uk
*************
ssc install estout, replace
ssc install outreg2, replace
ssc install cdfplot, replace
ssc install tabout, replace
ssc install ivreg2, replace
ssc install xtivreg2, replace
ssc install ranktest, replace
ssc install coefplot, replace

set matsize 2000
cd "D:\Dropbox\cg\Research\Fuel_Greece\Tax Passthrough\Stata\replication"

*Figure 1, Panel A
u "main_islands.dta",clear
quietly bys island:  gen island_dup = cond(_N==1,0,_n)
drop if island_dup>1

tw (lfitci gs size) (sc gs size),  ///
legend(off) xtitle("Island size (km sq)") ytitle("Number of gas stations") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelA_1, replace 
            
tw (lfitci gs population) (sc gs population), ///
legend(off) xtitle("Island population") ytitle("Number of gas stations") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelA_2, replace 

*Figure 1, Panel B
u "main_islands.dta",clear
tw(lfitci new_price gs) (sc new_price gs) if month==1&product_type=="Diesel", ///
legend(off) xtitle("Number of gas stations") ytitle("Average price of diesel") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelB_1, replace 

tw(lfitci new_price gs) (sc new_price gs) if month==1&product_type=="Heat", ///
legend(off) xtitle("Number of gas stations") ytitle("Average price of heating oil") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelB_2, replace 

*Figure 1, Panel C
tw(lfitci new_price population) (sc new_price population) if month==1&product_type=="Diesel", ///
legend(off) xtitle("Island population") ytitle("Average price of diesel") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelC_1, replace 

tw(lfitci new_price population) (sc new_price population) if month==1&product_type=="Heat", ///
legend(off) xtitle("Island population") ytitle("Average price of heating oil") ///
graphregion(style(none) color(gs16))
graph save Figure1_PanelC_2, replace 

*take differences at the station level and then aggregate
bys stationnumber date: egen mt=mean(new_price) if treat==1
bys stationnumber date: egen mean_treat=max(mt)
bys stationnumber date: egen md=mean(new_price) if product_type=="Diesel"
bys stationnumber date: egen mean_diesel=max(md)
bys stationnumber date: egen ms=mean(new_price) if product_type=="Super"
bys stationnumber date: egen mean_super=max(ms)
bys stationnumber date: egen mu95=mean(new_price) if product_type=="Unleaded95"
bys stationnumber date: egen mean_un95=max(mu95)
bys stationnumber date: egen mu100=mean(new_price) if product_type=="Unleaded100"
bys stationnumber date: egen mean_un100=max(mu100)
bys stationnumber date: egen mh=mean(new_price) if product_type=="Heat"
bys stationnumber date: egen mean_heat=max(mh)
g diff_treatheat=mean_treat-mean_heat
bys  date: egen mean_diff_treatheat=mean(diff_treatheat)
g diff_dieselheat=mean_diesel-mean_heat
bys  date: egen mean_diff_dieselheat=mean(diff_dieselheat)
g diff_superheat=mean_super-mean_heat
bys  date: egen mean_diff_superheat=mean(diff_superheat)
g diff_u95heat=mean_un95-mean_heat
bys  date: egen mean_diff_u95heat=mean(diff_u95heat)
g diff_u100heat=mean_un100-mean_heat
bys  date: egen mean_diff_u100heat=mean(diff_u100heat)
quietly bys date:  gen date_dup = cond(_N==1,0,_n)
drop if date_dup>1
*Figure 2:treat vs control
tw (lfit mean_diff_treatheat date if (date<18303&date>=18293)) ///
(lfit mean_diff_treatheat date if (date>=18303&date<=18313)) ///
(sc mean_diff_treatheat date if (date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change 1") ///
ytitle("Average price difference (treated vs heating oil)") ///
title("Excise duty change 1") ///
graphregion(style(none) color(gs16))
graph save Figure2_1, replace 

tw (lfit mean_diff_treatheat date if (date<18325&date>=18315)) ///
(lfit mean_diff_treatheat date if (date>=18325&date<=18335)) ///
(sc mean_diff_treatheat date if (date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change 2") ///
ytitle("Average price difference (treated vs heating oil)") ///
title("Excise duty change 2") ///
graphregion(style(none) color(gs16))
graph save Figure2_2, replace 

tw (lfit mean_diff_treatheat date if (date<18385&date>=18375)) ///
(lfit mean_diff_treatheat date if (date>=18385&date<=18395)) ///
(sc mean_diff_treatheat date if (date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change 3") ///
ytitle("Average price difference (treated vs heating oil)") ///
title("Excise duty change 3") ///
graphregion(style(none) color(gs16))
graph save Figure2_3, replace 

*Figure A2
*diesel vs control
tw (lfit mean_diff_dieselheat date if (date<18303&date>=18293)) ///
(lfit mean_diff_dieselheat date if (date>=18303&date<=18313)) ///
(sc mean_diff_dieselheat date if (date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 1 (Diesel vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_1, replace 

tw (lfit mean_diff_dieselheat date if (date<18325&date>=18315)) ///
(lfit mean_diff_dieselheat date if (date>=18325&date<=18335)) ///
(sc mean_diff_dieselheat date if (date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 2 (Diesel vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_2, replace 

tw (lfit mean_diff_dieselheat date if (date<18385&date>=18375)) ///
(lfit mean_diff_dieselheat date if (date>=18385&date<=18395)) ///
(sc mean_diff_dieselheat date if (date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 3 (Diesel vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_3, replace 

*super vs control
tw (lfit mean_diff_superheat date if (date<18303&date>=18293)) ///
(lfit mean_diff_superheat date if (date>=18303&date<=18313)) ///
(sc mean_diff_superheat date if (date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 1 (Super vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_4, replace 

tw (lfit mean_diff_superheat date if (date<18325&date>=18315)) ///
(lfit mean_diff_superheat date if (date>=18325&date<=18335)) ///
(sc mean_diff_superheat date if (date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 2 (Super vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_5, replace 

tw (lfit mean_diff_superheat date if (date<18385&date>=18375)) ///
(lfit mean_diff_superheat date if (date>=18385&date<=18395)) ///
(sc mean_diff_superheat date if (date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 3 (Super vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_6, replace 

*unleaded95 vs control
tw (lfit mean_diff_u95heat date if (date<18303&date>=18293)) ///
(lfit mean_diff_u95heat date if (date>=18303&date<=18313)) ///
(sc mean_diff_u95heat date if (date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 1 (Unleaded 95 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_7, replace 

tw (lfit mean_diff_u95heat date if (date<18325&date>=18315)) ///
(lfit mean_diff_u95heat date if (date>=18325&date<=18335)) ///
(sc mean_diff_u95heat date if (date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 2 (Unleaded 95 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_8, replace 

tw (lfit mean_diff_u95heat date if (date<18385&date>=18375)) ///
(lfit mean_diff_u95heat date if (date>=18385&date<=18395)) ///
(sc mean_diff_u95heat date if (date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 3 (Unleaded 95 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_9, replace 

*unleaded 100 vs control
tw (lfit mean_diff_u100heat date if (date<18303&date>=18293)) ///
(lfit mean_diff_u100heat date if (date>=18303&date<=18313)) ///
(sc mean_diff_u100heat date if (date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 1 (Unleaded 100 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_10, replace 

tw (lfit mean_diff_u100heat date if (date<18325&date>=18315)) ///
(lfit mean_diff_u100heat date if (date>=18325&date<=18335)) ///
(sc mean_diff_u100heat date if (date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 2 (Unleaded 100 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_11, replace 

tw (lfit mean_diff_u100heat date if (date<18385&date>=18375)) ///
(lfit mean_diff_u100heat date if (date>=18385&date<=18395)) ///
(sc mean_diff_u100heat date if (date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change") ///
title("Excise duty change 3 (Unleaded 100 vs. Heating oil)") ///
graphregion(style(none) color(gs16))
graph save FigureA2_12, replace 

*Figure A3
u "main_islands.dta",clear
tw  (lfitci new_price date if product_type=="Diesel"&(date<18303&date>=18293)) ///
(lfitci new_price date if product_type=="Diesel"&(date>=18303&date<=18313)) ///
(scatter new_price date if product_type=="Diesel"&(date<=18313&date>=18293)), ///
legend(off) xtitle("Days around the excise duty change") ///
ytitle("Diesel prices (€ cents per litre)") ///
title("Excise duty change 1") ///
graphregion(style(none) color(gs16))
graph save FigureA3_1, replace 

tw (lfitci new_price date if product_type=="Heat"&(date<18303&date>=18293)) ///
(lfitci new_price date if product_type=="Heat"&(date>=18303&date<=18313)) ///
(scatter new_price date if product_type=="Heat"&(date<=18313&date>=18293) ///
&(new_price>55)&(new_price<67)), legend(off) xtitle("Days around the excise duty change") ///
ytitle("Heating oil prices (€ cents per litre)") ///
title("Excise duty change 1") ///
graphregion(style(none) color(gs16))
graph save FigureA3_2, replace 

tw (lfitci new_price date if product_type=="Diesel"&(date<18325&date>=18315)) ///
(lfitci new_price date if product_type=="Diesel"&(date>=18325&date<=18335)) ///
(scatter new_price date if product_type=="Diesel"&(date<=18335&date>=18315)), ///
legend(off) xtitle("Days around the excise duty change") ///
ytitle("Diesel prices (€ cents per litre)") ///
title("Excise duty change 2") ///
graphregion(style(none) color(gs16))
graph save FigureA3_3, replace 

tw (lfitci new_price date if product_type=="Heat"&(date<18325&date>=18315)) ///
(lfitci new_price date if product_type=="Heat"&(date>=18325&date<=18335)) ///
(scatter new_price date if product_type=="Heat"&(date<=18335&date>=18315)&(new_price<67)), ///
legend(off) xtitle("Days around the excise duty change") ///
ytitle("Heating oil prices (€ cents per litre)") ///
title("Excise duty change 2") ///
graphregion(style(none) color(gs16))
graph save FigureA3_4, replace 

tw  (lfitci new_price date if product_type=="Diesel"&(date<18385&date>=18375)) ///
(lfitci new_price date if product_type=="Diesel"&(date>=18385&date<=18395)) ///
(scatter new_price date if product_type=="Diesel"&(date<=18395&date>=18375) ///
&(new_price>110)&(new_price<125)), legend(off) xtitle("Days around the excise duty change") ///
ytitle("Diesel prices (€ cents per litre)") ///
title("Excise duty change 3") ///
graphregion(style(none) color(gs16))
graph save FigureA3_5, replace 

tw  (lfitci new_price date if product_type=="Heat"&(date<18385&date>=18375)) ///
(lfitci new_price date if product_type=="Heat"  &(date>=18385&date<=18395)) ///
(scatter new_price date if product_type=="Heat"  &(date<=18395&date>=18375)), ///
legend(off) xtitle("Days around the excise duty change") ///
ytitle("Heating oil prices (€ cents per litre)") ///
title("Excise duty change 3") ///
graphregion(style(none) color(gs16))
graph save FigureA3_6, replace 

*Figure 6
u "islands_freq.dta",clear
ksmirnov day, by(low) ex
cdfplot day, by(low) opt1( c(l) lc(black gs5) lp(dash solid) graphregion(style(none) color(gs16)) ///
xtitle("Date")  leg(lab(2 "Low competition") ///
lab(1 "High competition")) title("Cumulative frequency of price changes"))
graph save Figure6, replace 

*Table 1
u "main_islands.dta",clear
tabout date product_type if (date==18263|date==18304|date==18326|date==18386) using Table1.xls, ///
replace style(xls) c(mean excise) f(1c) sum h3(nil) ptotal(none)  

*Table 2 Summary stats Panel A
eststo clear
estpost tabstat new_price if ((date>=18293&date<=18313)|(date>=18315&date<=18335)| ///
(date>=18375&date<=18395)), by(product_type) stat(me sd p50 p10 p90) columns(statistics) nototal
esttab using Table2A.csv,replace cells("mean sd p50 p10 p90") ///
noobs nonumber title("Table 2A. Summary Statistics") 

*Table 2 Summary stats Panel B
quietly bys island:  gen island_dup = cond(_N==1,0,_n)
drop if island_dup>1
eststo clear
estpost tabstat size population ports airports arrivals distance_peiraeus income university, ///
s(me sd p50 p10 p90) columns(stat) 
esttab using Table2B.csv,replace cells("mean sd p50 p10 p90") ///
noobs nonumber title("Table 2B. Island characteristics") 

*Table 3 column 1
u "main_islands.dta",clear
xtreg new_price excise i.date if (date==18302|date==18313) ///
&(maxex1_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table3.xls,replace dec(3) keep(excise) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 1") 
*Table 3, column 2
xtreg new_price excise i.date if (date==18324|date==18335)& ///
(maxex2_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) ///
noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 2")
*Table 3 column 3
xtreg new_price excise i.date if (date==18384|date==18395)& ///
(maxex3_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Excise change 3")
*Table 3, column 4
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 3 column 5
xtreg new_price excise i.date if (date==18302|date==18313)&single_av==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Excise change 1")  
*Table 3 column 6
xtreg new_price excise i.date if (date==18324|date==18335)&single_av==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Excise change 2")
*Table 3 column 7
xtreg new_price excise i.date if (date==18384|date==18395)&single_av==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Excise change 3")
*Table 3, column 8
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using Table3.xls,append  dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes")

*Table 4, Panel A: Conditional
*Table 4, column 1
clear all
u "main_islands.dta",clear
xtreg new_price excise ex_nc  i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
 ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
 &(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table4A.xls, replace dec(3) keep(excise ex_nc) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
*Table 4, column 2
xtreg new_price excise ex_nc ex_inc ex_arriv ex_ports ex_airports ex_edu ex_distp ///
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table4A.xls,append dec(3) keep(excise ex_nc) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 3
xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat"),first fe ///
cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 
matrix fstats = e(first)
scalar first_fstat = fstats[3,1]
outreg2 using Table4A.xls, adds(First stage F-test (Number of competitors), first_fstat) dec(3) ///
keep(excise ex_nc) noas nocons noni nor ct("All excise changes") append
*Table 4, column 4
xtreg new_price excise ex_nc ex_nc_2 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table4A.xls,append dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 5
xtreg new_price excise ex_nc ex_nc_2 ex_inc ex_arriv  ex_distp ex_airports ex_ports  ex_edu  ///
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*  ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using Table4A.xls,append dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 6
xtivreg2 new_price excise (ex_nc ex_nc_2 = ex_pop ex_pop_2) date_dum* ex1_p* ///
ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)| ///
(date==18324|date==18335)|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat"), ///
fe first cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 
matrix fstats = e(first)
scalar first_fstat1 = fstats[3,1]
scalar first_fstat2 = fstats[3,2]
outreg2 using Table4A.xls, adds(First stage F-test (Number of competitors), first_fstat1, ///
First stage F-test (Number of competitors-sq), first_fstat2) dec(3) keep(excise ex_nc ex_nc_2) ///
noas nocons noni nor ct("All excise changes") append

*Table 4, Panel B: Average
clear all
u "main_islands.dta"
*Table 4, column 1
xtreg new_price excise ex_nc i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* /// 
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using Table4B.xls, replace dec(3) keep(excise ex_nc) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
*Table 4, column 2
xtreg new_price excise ex_nc ex_inc ex_arriv ex_ports ex_airports ex_edu ex_distp /// 
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using Table4B.xls,append dec(3) keep(excise ex_nc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 3
xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395)),fe first cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ///
ex1_station* ex2_station* ex3_station*) 
matrix fstats = e(first)
scalar first_fstat = fstats[3,1]
outreg2 using Table4B.xls, adds(First stage F-test (Number of competitors), first_fstat) dec(3) ///
keep(excise ex_nc) noas nocons noni nor ct("All excise changes") append
*Table 4, column 4
xtreg new_price excise ex_nc ex_nc_2 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using Table4B.xls,append dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 5
xtreg new_price excise ex_nc ex_nc_2 ex_inc ex_arriv ex_distp ex_airports ex_ports ex_edu ///
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using Table4B.xls,append dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes")
*Table 4, column 6
xtivreg2 new_price excise (ex_nc ex_nc_2 = ex_pop ex_pop_2) date_dum* ex1_p* ex2_p* /// 
ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)| ///
(date==18324|date==18335)|(date==18384|date==18395)),fe first cl(island) ///
partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 
matrix fstats = e(first)
scalar first_fstat1 = fstats[3,1]
scalar first_fstat2 = fstats[3,2]
outreg2 using Table4B.xls, adds(First stage F-test (Number of competitors), first_fstat1, ///
First stage F-test (Number of competitors-sq), first_fstat2) dec(3) keep(excise ex_nc ex_nc_2) ///
noas nocons noni nor ct("All excise changes") append

*Table 5, column2, conditional
matrix C = J(10,3,.)
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18304)|(date==18324|date==18326)|(date==18384|date==18386)) ///
&(exALLt0==1|exALLtp1==1|product_type=="Heat"),fe cl(island)
matrix C[1,3]=_b[excise]
outreg2 excise using Table5A.xls, replace dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+1") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18305)|(date==18324|date==18327)|(date==18384|date==18387))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|product_type=="Heat"),fe cl(island)
matrix C[2,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+2") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18306)|(date==18324|date==18328)|(date==18384|date==18388)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|product_type=="Heat"),fe cl(island)
matrix C[3,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+3") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18307)|(date==18324|date==18329)|(date==18384|date==18389)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|product_type=="Heat"),fe cl(island)
matrix C[4,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+4") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18308)|(date==18324|date==18330)|(date==18384|date==18390)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|product_type=="Heat"),fe cl(island)
matrix C[5,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+5") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18309)|(date==18324|date==18331)|(date==18384|date==18391)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1|product_type=="Heat"),fe cl(island)
matrix C[6,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+6") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18310)|(date==18324|date==18332)|(date==18384|date==18392))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1| ///
exALLtp7==1|product_type=="Heat"),fe cl(island)
matrix C[7,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Conditional t+7") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18311)|(date==18324|date==18333)|(date==18384|date==18393)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1| ///
exALLtp7==1|exALLtp8==1|product_type=="Heat"),fe cl(island)
matrix C[8,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+8") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18312)|(date==18324|date==18334)|(date==18384|date==18394))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1| ///
exALLtp7==1|exALLtp8==1|exALLtp9==1|product_type=="Heat"),fe cl(island)
matrix C[9,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+9") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1| ///
exALLtp7==1|exALLtp8==1|exALLtp9==1|exALLtp10==1|product_type=="Heat"),fe cl(island)
matrix C[10,3]=_b[excise]
outreg2 excise using Table5A.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Conditional t+10") 

*Table 5, column1, average
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18304)|(date==18324|date==18326)|(date==18384|date==18386),fe cl(island)
matrix C[1,2]=_b[excise]
outreg2 excise using Table5B.xls,replace dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+1") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18305)|(date==18324|date==18327)|(date==18384|date==18387),fe cl(island)
matrix C[2,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+2") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18306)|(date==18324|date==18328)|(date==18384|date==18388),fe cl(island)
matrix C[3,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+3") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18307)|(date==18324|date==18329)|(date==18384|date==18389),fe cl(island)
matrix C[4,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+4") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18308)|(date==18324|date==18330)|(date==18384|date==18390),fe cl(island)
matrix C[5,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+5") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18309)|(date==18324|date==18331)|(date==18384|date==18391),fe cl(island)
matrix C[6,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+6") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18310)|(date==18324|date==18332)|(date==18384|date==18392),fe cl(island)
matrix C[7,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+7") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18311)|(date==18324|date==18333)|(date==18384|date==18393),fe cl(island)
matrix C[8,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+8") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18312)|(date==18324|date==18334)|(date==18384|date==18394),fe cl(island)
matrix C[9,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+9") 
xtreg new_price excise i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if (date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395),fe cl(island)
matrix C[10,2]=_b[excise]
outreg2 excise using Table5B.xls,app dec(3) keep(excise) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Average t+10") 
matrix C[1,1]=1
matrix C[2,1]=2
matrix C[3,1]=3
matrix C[4,1]=4
matrix C[5,1]=5
matrix C[6,1]=6
matrix C[7,1]=7
matrix C[8,1]=8
matrix C[9,1]=9
matrix C[10,1]=10
matrix list C
svmat C, names(c)
*Figure 4
tw line c2 c3 c1,sort legend(off) xtitle("Days since the excise duty changes") ///
ytitle("Estimated coefficients") ///
title("Pass-through and the speed of adjustment") ///
graphregion(style(none) color(gs16))
graph save Figure4, replace 

*Table 6, Panel A, average 
clear all
u "main_islands.dta"
matrix C = J(10,5,.)
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18304)|(date==18324|date==18326)|(date==18384|date==18386),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[1,2]=_b[ex_ncBelow]
matrix C[1,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, replace dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+1") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18305)|(date==18324|date==18327)|(date==18384|date==18387),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[2,2]=_b[ex_ncBelow]
matrix C[2,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+2") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18306)|(date==18324|date==18328)|(date==18384|date==18388),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[3,2]=_b[ex_ncBelow]
matrix C[3,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+3") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18307)|(date==18324|date==18329)|(date==18384|date==18389),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[4,2]=_b[ex_ncBelow]
matrix C[4,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+4") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18308)|(date==18324|date==18330)|(date==18384|date==18390),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[5,2]=_b[ex_ncBelow]
matrix C[5,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+5") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18309)|(date==18324|date==18331)|(date==18384|date==18391),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[6,2]=_b[ex_ncBelow]
matrix C[6,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+6") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18310)|(date==18324|date==18332)|(date==18384|date==18392),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[7,2]=_b[ex_ncBelow]
matrix C[7,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+7") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18311)|(date==18324|date==18333)|(date==18384|date==18393),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[8,2]=_b[ex_ncBelow]
matrix C[8,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+8") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18312)|(date==18324|date==18334)|(date==18384|date==18394),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[9,2]=_b[ex_ncBelow]
matrix C[9,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+9") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if (date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[10,2]=_b[ex_ncBelow]
matrix C[10,3]=_b[ex_ncAbove]
outreg2 using Table6A.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+10") 
*conditional 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18304)|(date==18324|date==18326)|(date==18384|date==18386)) ///
&(exALLt0==1|exALLtp1==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[1,4]=_b[ex_ncBelow]
matrix C[1,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, replace dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+1") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18305)|(date==18324|date==18327)|(date==18384|date==18387)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[2,4]=_b[ex_ncBelow]
matrix C[2,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni nor2 ///
adds(Prob>F, `r(p)') ct("Average t+2") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18306)|(date==18324|date==18328)|(date==18384|date==18388)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[3,4]=_b[ex_ncBelow]
matrix C[3,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+3") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18307)|(date==18324|date==18329)|(date==18384|date==18389)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[4,4]=_b[ex_ncBelow]
matrix C[4,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+4") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18308)|(date==18324|date==18330)|(date==18384|date==18390)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|product_type=="Heat"), ///
fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[5,4]=_b[ex_ncBelow]
matrix C[5,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+5") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18309)|(date==18324|date==18331)|(date==18384|date==18391)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1 ///
|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[6,4]=_b[ex_ncBelow]
matrix C[6,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+6") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18310)|(date==18324|date==18332)|(date==18384|date==18392))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1|exALLtp7==1| ///
product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[7,4]=_b[ex_ncBelow]
matrix C[7,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+7") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18311)|(date==18324|date==18333)|(date==18384|date==18393))& ///
(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1|exALLtp7==1 ///
|exALLtp8==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[8,4]=_b[ex_ncBelow]
matrix C[8,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+8") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18312)|(date==18324|date==18334)|(date==18384|date==18394)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1 ///
|exALLtp7==1|exALLtp8==1|exALLtp9==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[9,4]=_b[ex_ncBelow]
matrix C[9,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons noni ///
nor2 adds(Prob>F, `r(p)') ct("Average t+9") 
xtreg new_price ex_ncBelow ex_ncAbove i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(exALLt0==1|exALLtp1==1|exALLtp2==1|exALLtp3==1|exALLtp4==1|exALLtp5==1|exALLtp6==1| ///
exALLtp7==1|exALLtp8==1|exALLtp9==1|exALLtp10==1|product_type=="Heat"),fe cl(island)
test ex_ncBelow=ex_ncAbove
matrix C[10,4]=_b[ex_ncBelow]
matrix C[10,5]=_b[ex_ncAbove]
outreg2 using Table6B.xls, app dec(3) keep(ex_ncBelow ex_ncAbove) noobs noas nocons ///
noni nor2 adds(Prob>F, `r(p)') ct("Average t+10") 
matrix C[1,1]=1
matrix C[2,1]=2
matrix C[3,1]=3
matrix C[4,1]=4
matrix C[5,1]=5
matrix C[6,1]=6
matrix C[7,1]=7
matrix C[8,1]=8
matrix C[9,1]=9
matrix C[10,1]=10
matrix list C
svmat C, names(c)
*Figure 5
tw line c5 c4 c2 c3 c1,sort legend(label(1 "High competition (conditional)") ///
 label(2 "Low competition (conditional)") label(3 "Low competition (average)") ///
 label(4 "High competition (average)")) lp (solid dash dash solid) ///
 xtitle("Days since the excise duty changes") ///
ytitle("Estimated coefficients") ///
title("Speed of adjustment and competition") ///
graphregion(style(none) color(gs16))
graph save Figure5, replace 

*Table 7: Conditional
clear all
u "main_islands.dta"
*Table 7, column 1
xtreg new_price ex_nc1-ex_nc6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
*Figure 3a
coefplot , drop(_cons ex1_* ex2_* ex3_* *.date) vertical yline(1) ciopts(recast(rcap)) ///
mlabel format(%9.3g) mlabposition(4) mlabgap(*2) 
graph save Figure3a, replace 
outreg2 using Table7.xls, replace dec(3) keep(ex_nc1-ex_nc6) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("Island") 
*Table 7, column 2
xtreg new_price ex_3km1-ex_3km5 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")& gs!=threeKm,fe cl(island)
outreg2 using Table7.xls, append dec(3) keep(ex_3km1-ex_3km5) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("3Km driving distance") 
*Table 7, column 3
xtreg new_price ex_radius3km1-ex_radius3km5 i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&gs!=radius3km,fe cl(island)
outreg2 using Table7.xls, append dec(3) keep(ex_radius3km1-ex_radius3km5) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("3Km radius") 
*Table 7, column 4
xtreg new_price ex_tenMin1-ex_tenMin6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* /// 
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat") &gs!=tenMin,fe cl(island)
outreg2 using Table7.xls, append dec(3) keep(ex_tenMin1-ex_tenMin6) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("10min driving distance") 
*Table 7, column 5
xtreg new_price ex_5km1-ex_5km6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&gs!=fiveKm,fe cl(island)
outreg2 using Table7.xls, append dec(3) keep(ex_5km1-ex_5km6) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("5Km driving distance") 

**********************************************************************************************************
***Appendix tables****************************************************************************************
**********************************************************************************************************
*Figure A1
u "main_islands.dta",clear
keep if month==1
bys product_type date: egen av_p=mean(new_price) 
quietly bys product_type date:  gen id_dup = cond(_N==1,0,_n)
drop if id_dup>1
keep av_p date  product_type
reshape wide av_p, i(date)  j(product_type) s

tw (line av_pUnleaded95 date,lc(gs5) yaxis(1) ytitle("Average price of unleaded 95 gasoline") ysc(r(103(.5) 107.5)) ) ///
(line  av_pHeat date,lc(gs0) lp(dash) yaxis(2) ytitle("Average price of heating oil", axis(2)) ///
 ysc(r(55(.5) 59.5) axis(2))), ///
graphregion(style(none) color(gs16))  xtitle("Date")  leg(lab(1 "Unleaded 95") lab(2 "Heating oil"))
graph save FigureA1_1, replace 

tw (line av_pSuper date, lc(gs5) yaxis(1) ytitle("Average price of super gasoline") ysc(r(106.5(.5) 110))) ///
(line  av_pHeat date,lc(gs0) lp(dash) yaxis(2) ytitle("Average price of heating oil", axis(2)) ///
ysc(r(55(.5) 59.5) axis(2))), ///
graphregion(style(none) color(gs16)) xtitle("Date") ///
leg(lab(1 "Super") lab(2 "Heating oil"))
graph save FigureA1_2, replace 

tw (line av_pUnleaded100 date,lc(gs5) yaxis(1) ytitle("Average price of unleaded 100 gasoline") ysc(r(116.2(.2) 118.4))) ///
(line  av_pHeat date,lc(gs0) lp(dash) yaxis(2) ytitle("Average price of heating oil", axis(2)) ///
ysc(r(55(.5) 59.5) axis(2))), ///
graphregion(style(none) color(gs16))  xtitle("Date") ///
leg(lab(1 "Unleaded 100") lab(2 "Heating oil"))
graph save FigureA1_3, replace 

tw (line av_pDiesel date,lc(gs5) yaxis(1) ytitle("Average price of diesel") ysc(r(91(.5) 96))) ///
(line  av_pHeat date,lc(gs0) lp(dash) yaxis(2) ytitle("Average price of heating oil", axis(2)) ///
ysc(r(55(.5) 59.5) axis(2))), ///
graphregion(style(none) color(gs16))  xtitle("Date") ///
leg(lab(1 "Diesel") lab(2 "Heating oil"))
graph save FigureA1_4, replace 

*Figure A4
u "islands_freq_vat.dta",clear
ksmirnov day, by(low) ex
cdfplot day, by(low) opt1( c(l) lc(black gs5) lp(dash solid) graphregion(style(none) color(gs16)) ///
xtitle("Date")  leg(lab(2 "Low competition") ///
lab(1 "High competition")) title("Cumulative frequency of price changes"))
graph save FigureA4, replace 

*Table A1 Greek islands
u "main_islands.dta",clear
quietly bys island:  gen island_dup = cond(_N==1,0,_n)
drop if island_dup>1
tabout island gs  using TableA1.xls,replace style(xls) h3(nil) ptotal(none) 

*Table A2 Test of sample representativeness
u "main_islands_extra.dta",clear
estpost ttest gs population size arrivals university secondary ports airports ///
shop services carwash lubricants vulcanisateur , by(sample) 
esttab using TableA2.csv,replace cells("mu_2(fmt(2)) mu_1(fmt(2)) p(fmt(3))") ///
collabels("In sample" "Out of sample" "p-value test of equality") ///
 noobs nonumber title("Table 2A. Summary Statistics") 

*Table A3 
u "main_islands.dta",clear
*column 1
areg  new_price date c.date#treat protype_dum*  if (date>=18293&date<18303),a(stationnumber) cl(island)
outreg2 using TableA3.xls,replace dec(3) keep(date c.date#1.treat) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 1") 
*column 2
areg   new_price date c.date#protype_dum1 c.date#protype_dum3  c.date#protype_dum5 ///
protype_dum*  if (date>=18293&date<18303),a(stationnumber) cl(island)
outreg2 using TableA3.xls,app dec(3) keep(date c.date#protype_dum1 c.date#protype_dum3  ///
c.date#protype_dum5) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 1") 
*column 3
areg  new_price date c.date#treat protype_dum*  if (date>=18315&date<18325),a(stationnumber) cl(island)
outreg2 using TableA3.xls,app dec(3) keep(date c.date#1.treat) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Excise change 2") 
*column 4
areg new_price date c.date#protype_dum1 c.date#protype_dum3 c.date#protype_dum5 protype_dum* ///
if (date>=18315&date<18325),a(stationnumber) cl(island)
outreg2 using TableA3.xls,app dec(3) keep(date c.date#protype_dum1 c.date#protype_dum3 ///
c.date#protype_dum5) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 2") 
*column 5
areg new_price date c.date#treat protype_dum* if (date>=18375&date<18385),a(stationnumber) cl(island)
outreg2 using TableA3.xls,app dec(3) keep(date c.date#1.treat) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 3") 
*column 6
areg new_price date c.date#protype_dum1 c.date#protype_dum3 c.date#protype_dum5 ///
protype_dum*  if (date>=18375&date<18385),a(stationnumber) cl(island)
outreg2 using TableA3.xls,app dec(3) keep(date c.date#protype_dum1 c.date#protype_dum3  ///
c.date#protype_dum5) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("Excise change 3") 

*Table A4 
*column 1
reg  new_price i.date i.date#treat protype_dum*  if (date>=18293&date<18303),cl(island)
test  _b[18293.date#1.treat]+_b[18294.date#1.treat]+_b[18295.date#1.treat]+ ///
_b[18296.date#1.treat]+_b[18297.date#1.treat]+ _b[18298.date#1.treat]+_b[18299.date#1.treat]+ ///
_b[18300.date#1.treat]+_b[18301.date#1.treat]=0
outreg2 using TableA4.xls,replace dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 1") 
*column 2
areg new_price i.date i.date#treat protype_dum*  if (date>=18293&date<18303),a(stationnumber) cl(island)
test _b[18293b.date#1.treat]+_b[18294.date#1.treat]+_b[18295.date#1.treat]+ ///
_b[18296.date#1.treat]+_b[18297.date#1.treat]+ _b[18298.date#1.treat]+_b[18299.date#1.treat]+ ///
_b[18300.date#1.treat]+_b[18301.date#1.treat]=0
outreg2 using TableA4.xls,app dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 1") 
*column 3
reg  new_price i.date i.date#treat protype_dum*  if (date>=18315&date<18325),cl(island)
test _b[18315b.date#1.treat]+_b[18316.date#1.treat]+_b[18317.date#1.treat] ///
+_b[18318.date#1.treat]+_b[18319.date#1.treat]+ _b[18320.date#1.treat]+_b[18321.date#1.treat]+ ///
 _b[18322.date#1.treat]+_b[18323.date#1.treat]+_b[18324.date#1.treat]=0
outreg2 using TableA4.xls,app dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 2") 
*column 4
areg new_price i.date i.date#treat protype_dum*  if (date>=18315&date<18325),a(stationnumber) cl(island)
test _b[18315b.date#1.treat]+_b[18316.date#1.treat]+_b[18317.date#1.treat]+ ///
_b[18318.date#1.treat]+_b[18319.date#1.treat]+ _b[18320.date#1.treat]+_b[18321.date#1.treat]+ ///
_b[18322.date#1.treat]+_b[18323.date#1.treat]+_b[18324.date#1.treat]=0
outreg2 using TableA4.xls,app dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 2") 
*column 5
reg  new_price i.date i.date#treat protype_dum*  if (date>=18375&date<18385),cl(island)
test _b[18375b.date#1.treat]+_b[18376.date#1.treat]+_b[18377.date#1.treat] ///
+_b[18378.date#1.treat]+_b[18379.date#1.treat]+ _b[18380.date#1.treat]+_b[18381.date#1.treat]+ ///
_b[18382.date#1.treat]+_b[18383.date#1.treat]=0
outreg2 using TableA4.xls,app dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 3") 
*column 6
areg new_price i.date i.date#treat protype_dum* if (date>=18375&date<18385),a(stationnumber) cl(island)
test _b[18375b.date#1.treat]+_b[18376.date#1.treat]+_b[18377.date#1.treat] ///
+_b[18378.date#1.treat]+_b[18379.date#1.treat]+ _b[18380.date#1.treat]+_b[18381.date#1.treat]+ ///
_b[18382.date#1.treat]+_b[18383.date#1.treat]=0
outreg2 using TableA4.xls,app dec(3) drop(i.date protype_dum*) noas nocons noni nor2 ///
adds(Joint test of significance, r(F),P-value, r(p), Within R-squared,`e(r2)') ct("Excise change 3") 

*Table A5, Robustness conditional
xtreg new_price excise ex_nc i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,replace dec(3) keep(excise ex_nc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_inc i.date ex1_p* ex2_p* ex3_p* ex1_station*  ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_inc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_edu i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384 ///
|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_edu) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_arriv    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))& ///
(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_arriv) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_distp    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_distp) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_ports    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
 ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))& ///
 (maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_ports) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_airports i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_airports) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_inc ex_edu ex_arriv ex_distp ex_ports ex_airports i.date ///
ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)| ///
(date==18324|date==18335)|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat") ///
&single_cond==1,fe cl(island)
outreg2 using TableA5.xls,app dec(3) keep(excise ex_nc ex_inc ex_edu ex_arriv ///
ex_distp ex_ports ex_airports) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ///
ct("All excise changes") 

*Table A6, Robustness conditional (non-linear)
xtreg new_price excise ex_nc ex_nc_2 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))& ///
(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,replace dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_inc i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))& ///
(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_inc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_edu i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_edu) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_arriv    i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_arriv) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_distp    i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384 ///
|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_distp) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_ports i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_ports) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_airports i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat")&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_airports) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_inc ex_edu ex_arriv ex_distp ex_airports ex_ports ///
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313) ///
|(date==18324|date==18335)|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat") ///
&single_cond==1,fe cl(island)
outreg2 using TableA6.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_inc ex_edu ex_arriv ///
ex_distp ex_airports ex_ports) noas nocons noni nor2 adds(Within R-squared,`e(r2)')  ///
ct("All excise changes") 

*Table A7, Robustness average
xtreg new_price excise ex_nc i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))&single_av==1, ///
fe cl(island)
outreg2 using TableA7.xls,replace dec(3) keep(excise ex_nc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_inc i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_inc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_edu      i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_edu) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_arriv    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_arriv) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_distp    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_distp) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_ports    i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_ports) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_airports i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_airports) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_inc ex_edu ex_arriv ex_distp ex_ports ex_airports i.date ///
ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313) ///
|(date==18324|date==18335)|(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA7.xls,app dec(3) keep(excise ex_nc ex_inc ex_edu ex_arriv ex_distp ///
ex_ports ex_airports) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 

*Table A8, Robustness average
xtreg new_price excise ex_nc ex_nc_2 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
outreg2 using TableA8.xls,replace dec(3) keep(excise ex_nc ex_nc_2) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_inc      i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_inc) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_edu      i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_edu) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_arriv    i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_arriv) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_distp    i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_distp) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_ports    i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_ports) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_airports i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_airports) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 
xtreg new_price excise ex_nc ex_nc_2 ex_inc ex_edu ex_arriv ex_distp ex_airports ex_ports ///
i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313) ///
|(date==18324|date==18335)|(date==18384|date==18395))&single_av==1,fe cl(island)
outreg2 using TableA8.xls,app dec(3) keep(excise ex_nc ex_nc_2 ex_inc ex_edu ex_arriv ex_distp ///
ex_ports ex_airports) noas nocons noni nor2 adds(Within R-squared,`e(r2)') ct("All excise changes") 

*Table A9
eststo clear
*Table 4, column 3, conditional
eststo: xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat"),first ffirst savefirst ///
 savefprefix(st1) fe cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
 ex2_station* ex3_station*) 
*Table 4, column 6, conditional
eststo: qui xtivreg2 new_price excise (ex_nc ex_nc_2 = ex_pop ex_pop_2) date_dum* ex1_p* ///
ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)| ///
(date==18324|date==18335)|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat"), ///
fe first savefirst savefprefix(st2) cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station*) 
*Table 4, column 3, average
eststo: qui xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395)),fe first savefirst savefprefix(st3) ///
 cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ///
ex1_station* ex2_station* ex3_station*) 
*Table 4, column 6, average
eststo: qui xtivreg2 new_price excise (ex_nc ex_nc_2 = ex_pop ex_pop_2) date_dum* ex1_p* ex2_p* /// 
ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)| ///
(date==18324|date==18335)|(date==18384|date==18395)),fe first ffirst savefirst savefprefix(st4) ///
cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 

esttab st1* st2* st3* st4* using TableA9.csv, replace se label  nonumber nostar ///
mtitles("All excise changes - conditional" "All excise changes - conditional" ///
"All excise changes - conditional" "All excise changes - average" "All excise changes - average" ///
"All excise changes - average") nonotes 

*Table A10: Average
*Table A10, column 1
xtreg new_price ex_nc1-ex_nc6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* ///
if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395)) ///
&single_av==1,fe cl(island)
*Figure 3b
coefplot , drop(_cons ex1_* ex2_* ex3_* *.date) vertical yline(1) ciopts(recast(rcap)) ///
mlabel format(%9.3g) mlabposition(4) mlabgap(*2) 
graph save Figure3b, replace 
outreg2 using TableA10.xls, replace dec(3) keep(ex_nc1-ex_nc6) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("Island") 
*Table A10, column 2
xtreg new_price ex_3km1-ex_3km5 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))& gs!=threeKm,fe cl(island)
outreg2 using TableA10.xls, append dec(3) keep(ex_3km1-ex_3km5) noas nocons noni nor2 ///
adds(Within R-squared,`e(r2)') ct("3Km driving distance") 
*Table A10, column 3
xtreg new_price ex_radius3km1-ex_radius3km5 i.date ex1_p* ex2_p* ex3_p* ex1_station* ///
ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335) ///
|(date==18384|date==18395))&gs!=radius3km,fe cl(island)
outreg2 using TableA10.xls, append dec(3) keep(ex_radius3km1-ex_radius3km5) noas nocons ///
noni nor2 adds(Within R-squared,`e(r2)') ct("3Km radius") 
*Table A10, column 4
xtreg new_price ex_tenMin1-ex_tenMin6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&gs!=tenMin,fe cl(island)
outreg2 using TableA10.xls, append dec(3) keep(ex_tenMin1-ex_tenMin6) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("10min driving distance") 
*Table A10, column 5
xtreg new_price ex_5km1-ex_5km6 i.date ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ///
ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)| ///
(date==18384|date==18395))&gs!=fiveKm,fe cl(island)
outreg2 using TableA10.xls, append dec(3) keep(ex_5km1-ex_5km6) noas nocons noni ///
nor2 adds(Within R-squared,`e(r2)') ct("5Km driving distance") 

