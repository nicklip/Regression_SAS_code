data weather;
	input day year $ calls fhigh flow high low rain $ weekday $ subzero;
 	cards;
23  93	1752 47	35	46	40	2	1	1
16	93	2298 38	31	39	31	2	1	1
18	93	2395 33	26	38	24	2	1	1
22	94	6454 33	19	32	15	2	1	1
17	93	1709 41	27	41	30	2	1	0
24	93	1776 53	34	55	38	2	1	0
23	94	4619 32	18	32	18	2	1	0
16	94	6375 17	9	15	3	2	1	0
27	93	1674 39	27	44	31	2	0	1
28	93	1692 34	28	40	27	2	0	1
25	93	1812 38	32	43	31	2	0	1
21	93	1842 44	30	43	29	2	0	1
26	93	1842 35	21	35	25	2	0	1
20	93	1849 40	19	43	27	2	0	1
29	93	1879 46	28	41	23	2	0	1
22	93	2100 46	40	53	41	2	0	1
19	93	2486 29	19	36	21	2	0	1
25	94	4692 38	32	42	32	2	0	1
24	94	6476 48	30	49	31	2	0	1
18	94	7218 30	32	35	4	2	0	1
17	94	8827 35	15	47	12	1	1	1
26	94	3638 26	23	32	5	1	0	1
28	94	6564 48	34	55	31	1	0	1
20	94	7841 15	6	15	0	1	0	1
29	94	5613 31	40	36	36	0	1	1
21	94	7745 24	12	21	6	0	0	1
19	94	8810 10	4	10	-2	0	0	1
27	94	8947 29	14	31	0	0	0	1
;	
run;
proc print data=weather;
run;	
data weather2;
	set weather;
	yesrain=0;
	yessnow=0;
	onenineninethree=0;
	noholiday=0;
	if year=93 then onenineninethree=1;
	if rain=1 then yesrain=1;
	if rain=0 then yessnow=1;
	if weekday=0 then noholiday=1;
run;
proc print data=weather2;
run;
proc reg data=weather2;
	model calls = fhigh flow high low / r partial;
run;
quit; 
proc transreg data=weather2;
	model boxcox(calls) = identity(subzero yesrain yessnow onenineninethree noholiday fhigh flow high low);
	output out=transout residuals;
run;
quit;
data weather3;
	set weather2;
	transcalls = calls**(-0.5);
run;
proc print data=weather3;
run;
proc reg data=weather3;
	model transcalls = subzero yesrain yessnow onenineninethree noholiday fhigh flow high low;
	output out=myout;
run;
quit;
proc reg data=weather3;
	model transcalls = subzero yesrain yessnow 
	onenineninethree noholiday fhigh flow high low /
	selection=adjrsq aic best=3;
run;
quit;
proc reg data=weather3;
	model transcalls = subzero yesrain yessnow 
	onenineninethree noholiday fhigh flow high low /
	selection=stepwise SLentry=0.05 SLstay=0.05;
run;
quit;
proc reg data=weather3 alpha=0.05 ;
	model transcalls = onenineninethree / lackfit;
run;
quit;
data weather4;
	set weather3;
	fstat=finv(0.95,0,26);
run;
proc print data=weather4;
run;
proc reg data=weather3;
	model transcalls = onenineninethree;
	output out=myout r=residual;
run;
proc univariate normal data=myout;
	var residual;
run;
proc model data=weather3;
	parms const inc1;
	transcalls = const +inc1*onenineninethree;
	fit  / breusch=(1 onenineninethree); 	
run;
quit;
PROC SQL;
	INSERT INTO weather3(onenineninethree, transcalls)
    VALUES(0,.);
QUIT;
proc print data=weather3;
run;
proc reg data=weather3 alpha=0.02;
	model transcalls = onenineninethree;
	output out=myout p=pred lclm=lclm uclm=uclm stdi=stdi stdp=stdp;
run;
quit;
proc print data=myout; 
run;
*STDI--standard error of the individual predicted value
STDP--standard error of the mean predicted value;
data myout2;
	set myout;
	transformlclm = lclm**(-2);
	transformuclm = uclm**(-2);
run;
proc sql;
	select transformuclm, transformlclm from myout2
	where transcalls=.;
quit;
proc reg data=weather3;
	model transcalls = onenineninethree / influence r;
	output out=myout r=residual rstudent=sdr cookd=cookd dffits=dffits;
	ods output outputstatistics=myout2;
run;
quit;
proc print data=myout2;
run;
