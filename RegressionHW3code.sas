data sales;
	input yearx salesy;
	cards;
	0 98
	1 135
	2 162
	3 178
	4 221
	5 232
	6 283
	7 300
	8 374
	9 395
	;
run;
proc print data=sales;
run;
proc gplot;
 plot yearx*salesy;
run;
proc transreg data=sales ss2 details;
 	title2 'Defaults';
	model boxcox(salesy) = identity(yearx);
	output out=transout residuals;
 run; 
proc transreg data=sales ss2 details;
	title2 'Several Options Demonstrated';
	model boxcox(salesy/ lambda=.3) = identity(yearx);
run;
proc transreg data=sales ss2 details;
	title2 'Several Options Demonstrated';
	model boxcox(salesy/ lambda=.4) = identity(yearx);
run;
proc transreg data=sales ss2 details;
	title2 'Several Options Demonstrated';
	model boxcox(salesy/ lambda=.6) = identity(yearx);
run;
proc transreg data=sales ss2 details;
	title2 'Several Options Demonstrated';
	model boxcox(salesy/ lambda=.7) = identity(yearx);
run;
proc print data=transout;
run;

SYMBOL1 V=circle C=blue I=r;
TITLE 'Estimated regression line transformed data';
PROC GPLOT DATA=transout;
     PLOT tsalesy*yearx;
RUN;
QUIT; 
proc reg data=transout;
	model tsalesy=yearx/ cli clm;
 	output out=outreg predicted=yhat l95=lpred u95=upred l95m=lmean 
	u95m=umean;
run;
quit;
SYMBOL1 V=circle C=blue I=r;
TITLE 'Residuals vs. fitted values ';
PROC GPLOT DATA=outreg;
     PLOT rsalesy*yhat ;
RUN;
QUIT; 
title ' ';
proc univariate data=transout normal plot;
	var Rsalesy;
run;
data bloodpressure;
	input agex bloodpressurey;
	cards;
	5 63
	8 67
	11 74
	7 64
	13 75
	12 69
	12 90
	6 60
	;
run;
proc print data=bloodpressure;
run;
proc reg data=bloodpressure;
	model bloodpressurey=agex;
 	output out=outreg1 r=res;
run;
PROC SQL;
 delete from bloodpressure where bloodpressurey=90;
quit;
proc reg alpha=0.1 plots=fit data=bloodpressure;
	model bloodpressurey=agex;
 	output out=outreg1 lcl=lcl lclm=lclm ucl=ucl uclm=uclm r=res;
run;
quit;

