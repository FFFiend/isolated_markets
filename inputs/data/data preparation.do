***********
* Replication of "Competition and Pass-through: Evidence from Isolated Markets"
* Genakos and Pagliero
* May 2021
* Christos Genakos c.genakos@jbs.cam.ac.uk
* Data preparation file
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

u "station_price_data.dta",clear
*merge with island and station characteristics
merge m:1 island using "island_characteristics.dta"
drop _m
merge m:1 stationnumber using "station_characteristics.dta"
drop _m

*variable creation and manipulation
g excise1       = (date>=18293&date<=18313)
g excise1before = (date>=18293&date<=18302)
g excise1after  = (date>=18303&date<=18313)
g excise2       = (date>=18315&date<=18335)
g excise2before = (date>=18315&date<=18324)
g excise2after  = (date>=18325&date<=18335)
g excise3       = (date>=18375&date<=18395)
g excise3before = (date>=18375&date<=18384)
g excise3after  = (date>=18385&date<=18395)
*price net of vat
g new_price=price/(1+vat)
*dummies for each island
ta gs,g(ngs_dum)
*TSSET
tsset stpro date
qui bys stpro:  gen dup = cond(_N==1,0,_n)
qui bys stpro:  egen maxdup=max(dup)
ta date,g(date_dum)
qui g effective_date = dofc(effective)

g ex_nc1=excise*ngs_dum1
g ex_nc2=excise*ngs_dum2
g ex_nc3=excise*ngs_dum3
g ex_nc4=excise*ngs_dum4
g ex_nc5=excise*ngs_dum5
g ex_nc6=excise*ngs_dum6

*frequency
g low  = ngs_dum1+ngs_dum2+ngs_dum3
g high = ngs_dum4+ngs_dum5+ngs_dum6

ta threeKm,g(threeKm_dum)
g ex_3km1=excise*threeKm_dum1
g ex_3km2=excise*threeKm_dum2
g ex_3km3=excise*threeKm_dum3
g ex_3km4=excise*threeKm_dum4
g ex_3km5=excise*threeKm_dum5
g ex_3km6=excise*threeKm_dum6

ta radius3km,g(radius3km_dum)
g ex_radius3km1=excise*radius3km_dum1
g ex_radius3km2=excise*radius3km_dum2
g ex_radius3km3=excise*radius3km_dum3
g ex_radius3km4=excise*radius3km_dum4
g ex_radius3km5=excise*radius3km_dum5
g ex_radius3km6=excise*radius3km_dum6

ta fiveKm,g(fiveKm_dum)
g ex_5km1=excise*fiveKm_dum1
g ex_5km2=excise*fiveKm_dum2
g ex_5km3=excise*fiveKm_dum3
g ex_5km4=excise*fiveKm_dum4
g ex_5km5=excise*fiveKm_dum5
g ex_5km6=excise*fiveKm_dum6
g ex_5km7=excise*fiveKm_dum7

ta tenMin,g(tenMin_dum)     
g ex_tenMin1=excise*tenMin_dum1
g ex_tenMin2=excise*tenMin_dum2
g ex_tenMin3=excise*tenMin_dum3
g ex_tenMin4=excise*tenMin_dum4
g ex_tenMin5=excise*tenMin_dum5
g ex_tenMin6=excise*tenMin_dum6
g ex_tenMin7=excise*tenMin_dum7

*Effective date
g difference=date-effective_date
*FIRST excise duty change
g t0=1    if date==18303 & difference==0
g tp1=1   if date==18304 & difference==0
g tp2=1   if date==18305 & difference==0
g tp3=1   if date==18306 & difference==0
g tp4=1   if date==18307 & difference==0
g tp5=1   if date==18308 & difference==0
g tp6=1   if date==18309 & difference==0
g tp7=1   if date==18310 & difference==0
g tp8=1   if date==18311 & difference==0
g tp9=1   if date==18312 & difference==0
g tp10=1  if date==18313 & difference==0
*prob of change: day 0
g ex1_0day=1 if t0==1
ta ex1_0day if product_type!="Heat"
qui bys stpro:  egen maxex1_0day =max(ex1_0day)  if excise1==1
g prob_ex1_0day=ex1_0day  
replace prob_ex1_0day=0 if product_type=="Heat"
replace prob_ex1_0day=0 if prob_ex1_0day==.
*prob of change: day 1
g ex1_1day=1 if t0==1|tp1==1
ta ex1_1day if product_type!="Heat"
qui bys stpro:  egen maxex1_1day =max(ex1_1day)  if excise1==1
g prob_ex1_1day=ex1_1day  
replace prob_ex1_1day=0 if product_type=="Heat"
replace prob_ex1_1day=0 if prob_ex1_1day==.
*prob of change: day 2
g ex1_2day=1 if t0==1|tp1==1|tp2==1
ta ex1_2day if product_type!="Heat"
qui bys stpro:  egen maxex1_2day =max(ex1_2day)  if excise1==1
g prob_ex1_2day=ex1_2day  
replace prob_ex1_2day=0 if product_type=="Heat"
replace prob_ex1_2day=0 if prob_ex1_2day==.
*prob of change within the first 3 days
g ex1_3day=1 if t0==1|tp1==1|tp2==1|tp3==1
ta ex1_3day if product_type!="Heat"
qui bys stpro:  egen maxex1_3day =max(ex1_3day)  if excise1==1
g prob_ex1_3day=ex1_3day  
replace prob_ex1_3day=0 if product_type=="Heat"
replace prob_ex1_3day=0 if prob_ex1_3day==.
*prob of change: day 4
g ex1_4day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1
ta ex1_4day if product_type!="Heat"
qui bys stpro:  egen maxex1_4day =max(ex1_4day)  if excise1==1
g prob_ex1_4day=ex1_4day  
replace prob_ex1_4day=0 if product_type=="Heat"
replace prob_ex1_4day=0 if prob_ex1_4day==.
*prob of change: day 5
g ex1_5day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1
ta ex1_5day if product_type!="Heat"
qui bys stpro:  egen maxex1_5day =max(ex1_5day)  if excise1==1
g prob_ex1_5day=ex1_5day  
replace prob_ex1_5day=0 if product_type=="Heat"
replace prob_ex1_5day=0 if prob_ex1_5day==.
*prob of change: day 6
g ex1_6day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1
ta ex1_6day if product_type!="Heat"
qui bys stpro:  egen maxex1_6day =max(ex1_6day)  if excise1==1
g prob_ex1_6day=ex1_6day  
replace prob_ex1_6day=0 if product_type=="Heat"
replace prob_ex1_6day=0 if prob_ex1_6day==.
*prob of change within the first 7 days
g ex1_7day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1
ta ex1_7day if product_type!="Heat"
qui bys stpro:  egen maxex1_7day =max(ex1_7day)  if excise1==1
g prob_ex1_7day=ex1_7day  
replace prob_ex1_7day=0 if product_type=="Heat"
replace prob_ex1_7day=0 if prob_ex1_7day==.
*prob of change: day 8
g ex1_8day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1
ta ex1_8day if product_type!="Heat"
qui bys stpro:  egen maxex1_8day =max(ex1_8day)  if excise1==1
g prob_ex1_8day=ex1_8day  
replace prob_ex1_8day=0 if product_type=="Heat"
replace prob_ex1_8day=0 if prob_ex1_8day==.
*prob of change: day 9
g ex1_9day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1
ta ex1_9day if product_type!="Heat"
qui bys stpro:  egen maxex1_9day =max(ex1_9day)  if excise1==1
g prob_ex1_9day=ex1_9day  
replace prob_ex1_9day=0 if product_type=="Heat"
replace prob_ex1_9day=0 if prob_ex1_9day==.
*prob of change within the first 10 days
g ex1_10day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1|tp10==1
ta ex1_10day if product_type!="Heat"
qui bys stpro:  egen maxex1_10day =max(ex1_10day)  if excise1==1
g prob_ex1_10day=ex1_10day  
replace prob_ex1_10day=0 if product_type=="Heat"
replace prob_ex1_10day=0 if prob_ex1_10day==.

qui bys stpro: egen maxt0   = max(t0)   if excise1==1
qui bys stpro: egen maxtp1  = max(tp1)  if excise1==1
qui bys stpro: egen maxtp2  = max(tp2)  if excise1==1
qui bys stpro: egen maxtp3  = max(tp3)  if excise1==1
qui bys stpro: egen maxtp4  = max(tp4)  if excise1==1
qui bys stpro: egen maxtp5  = max(tp5)  if excise1==1
qui bys stpro: egen maxtp6  = max(tp6)  if excise1==1
qui bys stpro: egen maxtp7  = max(tp7)  if excise1==1
qui bys stpro: egen maxtp8  = max(tp8)  if excise1==1
qui bys stpro: egen maxtp9  = max(tp9)  if excise1==1
qui bys stpro: egen maxtp10 = max(tp10) if excise1==1

rename maxt0   maxt0ex1
rename maxtp1  maxtp1ex1
rename maxtp2  maxtp2ex1
rename maxtp3  maxtp3ex1
rename maxtp4  maxtp4ex1
rename maxtp5  maxtp5ex1
rename maxtp6  maxtp6ex1
rename maxtp7  maxtp7ex1
rename maxtp8  maxtp8ex1
rename maxtp9  maxtp9ex1
rename maxtp10 maxtp10ex1
*SECOND excise duty change
drop t0-tp10
g t0=1    if date==18325&difference==0
g tp1=1   if date==18326&difference==0
g tp2=1   if date==18327&difference==0
g tp3=1   if date==18328&difference==0
g tp4=1   if date==18329&difference==0
g tp5=1   if date==18330&difference==0
g tp6=1   if date==18331&difference==0
g tp7=1   if date==18332&difference==0
g tp8=1   if date==18333&difference==0
g tp9=1   if date==18334&difference==0
g tp10=1  if date==18335&difference==0

*prob of change: day 0
g ex2_0day=1 if t0==1
ta ex2_0day if product_type!="Heat"
qui bys stpro:  egen maxex2_0day =max(ex2_0day)  if excise2==1
g prob_ex2_0day=ex2_0day  
replace prob_ex2_0day=0 if product_type=="Heat"
replace prob_ex2_0day=0 if prob_ex2_0day==.
*prob of change: day 1
g ex2_1day=1 if t0==1|tp1==1
ta ex2_1day if product_type!="Heat"
qui bys stpro:  egen maxex2_1day =max(ex2_1day)  if excise2==1
g prob_ex2_1day=ex2_1day  
replace prob_ex2_1day=0 if product_type=="Heat"
replace prob_ex2_1day=0 if prob_ex2_1day==.
*prob of change: day 2
g  ex2_2day=1 if t0==1|tp1==1|tp2==1
ta ex2_2day if product_type!="Heat"
qui bys stpro:  egen maxex2_2day =max(ex2_2day)  if excise2==1
g prob_ex2_2day=ex2_2day  
replace prob_ex2_2day=0 if product_type=="Heat"
replace prob_ex2_2day=0 if prob_ex2_2day==.
*prob of change within the first 3 days
g ex2_3day=1 if t0==1|tp1==1|tp2==1|tp3==1
ta ex2_3day if product_type!="Heat"
qui bys stpro:  egen maxex2_3day =max(ex2_3day)  if excise2==1
g prob_ex2_3day=ex2_3day  
replace prob_ex2_3day=0 if product_type=="Heat"
replace prob_ex2_3day=0 if prob_ex2_3day==.
*prob of change: day 4
g ex2_4day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1
ta ex2_4day if product_type!="Heat"
qui bys stpro:  egen maxex2_4day =max(ex2_4day)  if excise2==1
g prob_ex2_4day=ex2_4day  
replace prob_ex2_4day=0 if product_type=="Heat"
replace prob_ex2_4day=0 if prob_ex2_4day==.
*prob of change: day 5
g ex2_5day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1
ta ex2_5day if product_type!="Heat"
qui bys stpro:  egen maxex2_5day =max(ex2_5day)  if excise2==1
g prob_ex2_5day=ex2_5day  
replace prob_ex2_5day=0 if product_type=="Heat"
replace prob_ex2_5day=0 if prob_ex2_5day==.
*prob of change: day 6
g ex2_6day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1
ta ex2_6day if product_type!="Heat"
qui bys stpro:  egen maxex2_6day =max(ex2_6day)  if excise2==1
g prob_ex2_6day=ex2_6day  
replace prob_ex2_6day=0 if product_type=="Heat"
replace prob_ex2_6day=0 if prob_ex2_6day==.
*prob of change within the first 7 days
g ex2_7day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1
ta ex2_7day if product_type!="Heat"
qui bys stpro:  egen maxex2_7day =max(ex2_7day)  if excise2==1
g prob_ex2_7day=ex2_7day  
replace prob_ex2_7day=0 if product_type=="Heat"
replace prob_ex2_7day=0 if prob_ex2_7day==.
*prob of change: day 8
g ex2_8day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1
ta ex2_8day if product_type!="Heat"
qui bys stpro:  egen maxex2_8day =max(ex2_8day)  if excise2==1
g prob_ex2_8day=ex2_8day  
replace prob_ex2_8day=0 if product_type=="Heat"
replace prob_ex2_8day=0 if prob_ex2_8day==.
*prob of change: day 9
g ex2_9day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1
ta ex2_9day if product_type!="Heat"
qui bys stpro:  egen maxex2_9day =max(ex2_9day)  if excise2==1
g prob_ex2_9day=ex2_9day  
replace prob_ex2_9day=0 if product_type=="Heat"
replace prob_ex2_9day=0 if prob_ex2_9day==.
*prob of change within the first 10 days
g ex2_10day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1|tp10==1
ta ex2_10day if product_type!="Heat"
qui bys stpro:  egen maxex2_10day =max(ex2_10day)  if excise2==1
g prob_ex2_10day=ex2_10day  
replace prob_ex2_10day=0 if product_type=="Heat"
replace prob_ex2_10day=0 if prob_ex2_10day==.

qui bys stpro:  egen maxt0   = max(t0)   if excise2==1
qui bys stpro:  egen maxtp1  = max(tp1)  if excise2==1
qui bys stpro:  egen maxtp2  = max(tp2)  if excise2==1
qui bys stpro:  egen maxtp3  = max(tp3)  if excise2==1
qui bys stpro:  egen maxtp4  = max(tp4)  if excise2==1
qui bys stpro:  egen maxtp5  = max(tp5)  if excise2==1
qui bys stpro:  egen maxtp6  = max(tp6)  if excise2==1
qui bys stpro:  egen maxtp7  = max(tp7)  if excise2==1
qui bys stpro:  egen maxtp8  = max(tp8)  if excise2==1
qui bys stpro:  egen maxtp9  = max(tp9)  if excise2==1
qui bys stpro:  egen maxtp10 = max(tp10) if excise2==1

rename maxt0   maxt0ex2
rename maxtp1  maxtp1ex2
rename maxtp2  maxtp2ex2
rename maxtp3  maxtp3ex2
rename maxtp4  maxtp4ex2
rename maxtp5  maxtp5ex2
rename maxtp6  maxtp6ex2
rename maxtp7  maxtp7ex2
rename maxtp8  maxtp8ex2
rename maxtp9  maxtp9ex2
rename maxtp10 maxtp10ex2

*THIRD excise duty change
drop t0-tp10
g t0=1   if date==18385&difference==0
g tp1=1  if date==18386&difference==0
g tp2=1  if date==18387&difference==0
g tp3=1  if date==18388&difference==0
g tp4=1  if date==18389&difference==0
g tp5=1  if date==18390&difference==0
g tp6=1  if date==18391&difference==0
g tp7=1  if date==18392&difference==0
g tp8=1  if date==18393&difference==0
g tp9=1  if date==18394&difference==0
g tp10=1 if date==18395&difference==0

*prob of change: day 0
g ex3_0day=1 if t0==1
ta ex3_0day if product_type!="Heat"
qui bys stpro:  egen maxex3_0day =max(ex3_0day)  if excise3==1
g prob_ex3_0day=ex3_0day  
replace prob_ex3_0day=0 if product_type=="Heat"
replace prob_ex3_0day=0 if prob_ex3_0day==.
*prob of change: day 1
g ex3_1day=1 if t0==1|tp1==1
ta ex3_1day if product_type!="Heat"
qui bys stpro:  egen maxex3_1day =max(ex3_1day)  if excise3==1
g prob_ex3_1day=ex3_1day  
replace prob_ex3_1day=0 if product_type=="Heat"
replace prob_ex3_1day=0 if prob_ex3_1day==.
*prob of change: day 2
g  ex3_2day=1 if t0==1|tp1==1|tp2==1
ta ex3_2day if product_type!="Heat"
qui bys stpro:  egen maxex3_2day =max(ex3_2day)  if excise3==1
g prob_ex3_2day=ex3_2day  
replace prob_ex3_2day=0 if product_type=="Heat"
replace prob_ex3_2day=0 if prob_ex3_2day==.
*prob of change within the first 3 days
g ex3_3day=1 if t0==1|tp1==1|tp2==1|tp3==1
ta ex3_3day if product_type!="Heat"
qui bys stpro:  egen maxex3_3day =max(ex3_3day)  if excise3==1
g prob_ex3_3day=ex3_3day  
replace prob_ex3_3day=0 if product_type=="Heat"
replace prob_ex3_3day=0 if prob_ex3_3day==.
*prob of change: day 4
g ex3_4day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1
ta ex3_4day if product_type!="Heat"
qui bys stpro:  egen maxex3_4day =max(ex3_4day)  if excise3==1
g prob_ex3_4day=ex3_4day  
replace prob_ex3_4day=0 if product_type=="Heat"
replace prob_ex3_4day=0 if prob_ex3_4day==.
*prob of change: day 5
g ex3_5day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1
ta ex3_5day if product_type!="Heat"
qui bys stpro:  egen maxex3_5day =max(ex3_5day)  if excise3==1
g prob_ex3_5day=ex3_5day  
replace prob_ex3_5day=0 if product_type=="Heat"
replace prob_ex3_5day=0 if prob_ex3_5day==.
*prob of change: day 6
g ex3_6day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1
ta ex3_6day if product_type!="Heat"
qui bys stpro:  egen maxex3_6day =max(ex3_6day)  if excise3==1
g prob_ex3_6day=ex3_6day  
replace prob_ex3_6day=0 if product_type=="Heat"
replace prob_ex3_6day=0 if prob_ex3_6day==.
*prob of change within the first 7 days
g ex3_7day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1
ta ex3_7day if product_type!="Heat"
qui bys stpro:  egen maxex3_7day =max(ex3_7day)  if excise3==1
g prob_ex3_7day=ex3_7day  
replace prob_ex3_7day=0 if product_type=="Heat"
replace prob_ex3_7day=0 if prob_ex3_7day==.
*prob of change: day 8
g ex3_8day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1
ta ex3_8day if product_type!="Heat"
qui bys stpro:  egen maxex3_8day =max(ex3_8day)  if excise3==1
g prob_ex3_8day=ex3_8day  
replace prob_ex3_8day=0 if product_type=="Heat"
replace prob_ex3_8day=0 if prob_ex3_8day==.
*prob of change: day 9
g ex3_9day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1
ta ex3_9day if product_type!="Heat"
qui bys stpro:  egen maxex3_9day =max(ex3_9day)  if excise3==1
g prob_ex3_9day=ex3_9day  
replace prob_ex3_9day=0 if product_type=="Heat"
replace prob_ex3_9day=0 if prob_ex3_9day==.
*prob of change within the first 10 days
g ex3_10day=1 if t0==1|tp1==1|tp2==1|tp3==1|tp4==1|tp5==1|tp6==1|tp7==1|tp8==1|tp9==1|tp10==1
ta ex3_10day if product_type!="Heat"
qui bys stpro:  egen maxex3_10day =max(ex3_10day)  if excise3==1
g prob_ex3_10day=ex3_10day  
replace prob_ex3_10day=0 if product_type=="Heat"
replace prob_ex3_10day=0 if prob_ex3_10day==.

qui bys stpro: egen maxt0   =max(t0)   if excise3==1
qui bys stpro: egen maxtp1  =max(tp1)  if excise3==1
qui bys stpro: egen maxtp2  =max(tp2)  if excise3==1
qui bys stpro: egen maxtp3  =max(tp3)  if excise3==1
qui bys stpro: egen maxtp4  =max(tp4)  if excise3==1
qui bys stpro: egen maxtp5  =max(tp5)  if excise3==1
qui bys stpro: egen maxtp6  =max(tp6)  if excise3==1
qui bys stpro: egen maxtp7  =max(tp7)  if excise3==1
qui bys stpro: egen maxtp8  =max(tp8)  if excise3==1
qui bys stpro: egen maxtp9  =max(tp9)  if excise3==1
qui bys stpro: egen maxtp10 =max(tp10) if excise3==1

rename maxt0   maxt0ex3
rename maxtp1  maxtp1ex3
rename maxtp2  maxtp2ex3
rename maxtp3  maxtp3ex3
rename maxtp4  maxtp4ex3
rename maxtp5  maxtp5ex3
rename maxtp6  maxtp6ex3
rename maxtp7  maxtp7ex3
rename maxtp8  maxtp8ex3
rename maxtp9  maxtp9ex3
rename maxtp10 maxtp10ex3

**ALL CHANGES TOGETHER********************************************************************************
*************************************************************************************************************
*********************************************************************************************************
g exALL_10day=1    if ex1_10day==1|ex2_10day==1|ex3_10day==1
g maxALL_10day=1   if maxex1_10day==1|maxex2_10day==1|maxex3_10day==1
g prob_ALL_10day= prob_ex1_10day+prob_ex2_10day+prob_ex3_10day

g exALLt0  =1  if  maxt0ex1==1  |maxt0ex2==1  |maxt0ex3==1
g exALLtp1 =1  if  maxtp1ex1==1 |maxtp1ex2==1 |maxtp1ex3==1
g exALLtp2 =1  if  maxtp2ex1==1 |maxtp2ex2==1 |maxtp2ex3==1
g exALLtp3 =1  if  maxtp3ex1==1 |maxtp3ex2==1 |maxtp3ex3==1
g exALLtp4 =1  if  maxtp4ex1==1 |maxtp4ex2==1 |maxtp4ex3==1
g exALLtp5 =1  if  maxtp5ex1==1 |maxtp5ex2==1 |maxtp5ex3==1
g exALLtp6 =1  if  maxtp6ex1==1 |maxtp6ex2==1 |maxtp6ex3==1
g exALLtp7 =1  if  maxtp7ex1==1 |maxtp7ex2==1 |maxtp7ex3==1
g exALLtp8 =1  if  maxtp8ex1==1 |maxtp8ex2==1 |maxtp8ex3==1
g exALLtp9 =1  if  maxtp9ex1==1 |maxtp9ex2==1 |maxtp9ex3==1
g exALLtp10=1  if  maxtp10ex1==1|maxtp10ex2==1|maxtp10ex3==1
drop effective effective_date
qui ta product_type,g(protype_dum)

g ex1_p95	=excise1*protype_dum5
g ex1_p100	=excise1*protype_dum4
g ex1_pd	=excise1*protype_dum1
g ex1_ph	=excise1*protype_dum2
g ex1_ps	=excise1*protype_dum3

g ex2_p95	=excise2*protype_dum5
g ex2_p100	=excise2*protype_dum4
g ex2_pd	=excise2*protype_dum1
g ex2_ph	=excise2*protype_dum2
g ex2_ps	=excise2*protype_dum3

g ex3_p95	=excise3*protype_dum5
g ex3_p100	=excise3*protype_dum4
g ex3_pd	=excise3*protype_dum1
g ex3_ph	=excise3*protype_dum2
g ex3_ps	=excise3*protype_dum3

g ex_p95	=excise*protype_dum5
g ex_p100	=excise*protype_dum4
g ex_pd	    =excise*protype_dum1
g ex_ph	    =excise*protype_dum2
g ex_ps	    =excise*protype_dum3

qui ta stationnumber, g(station_dum)
	forval i = 1/81{
	g ex1_station`i'=excise1*station_dum`i'
	}
forval i = 1/81{
	g ex2_station`i'=excise2*station_dum`i'
	}
forval i = 1/81{
	g ex3_station`i'=excise3*station_dum`i'
	}

g trend_95	= date*protype_dum5
g trend_100	= date*protype_dum4
g trend_d	= date*protype_dum1
g trend_s	= date*protype_dum3

g ex_ncBelow=ex_nc1+ex_nc2+ex_nc3
g ex_ncAbove=ex_nc4+ex_nc5+ex_nc6

g gs2        = gs^2
g ex_nc        = excise* gs
g ex_nc_2      = excise* gs2
g ex_popd      = excise* population_density
g ex_arriv     = excise* arrivals
g ex_distp     = excise* distance_peiraeus
g ex_pop       = excise* population
g ex_pop_2     = excise* (population^2)
g ex_size      = excise* size
g ex_size_2    = excise* (size^2)
g ex_distl     = excise* dist_land
g ex_inc       = excise* income
g ex_edu       = excise* university
g ex_ports     = excise* ports
g ex_airports  = excise* airports

*********************************************************************************************************
xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))&(maxALL_10day==1|product_type=="Heat"),fe first cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 
g used=e(sample)
qui bys stpro used:  g s = cond(_N==1,0,_n) 
g single_cond=used
replace single_cond=0 if s==0&used==1
drop used s
xtivreg2 new_price excise (ex_nc = ex_pop) date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station* if ((date==18302|date==18313)|(date==18324|date==18335)|(date==18384|date==18395))                                       ,fe first cl(island) partial(date_dum* ex1_p* ex2_p* ex3_p* ex1_station* ex2_station* ex3_station*) 
g used=e(sample)
qui bys stpro used:  g s = cond(_N==1,0,_n) 
g single_av=used
replace single_av=0 if s==0&used==1
drop used s
g treat=1
replace treat=0 if product_type=="Heat"

save "main_islands.dta",replace

