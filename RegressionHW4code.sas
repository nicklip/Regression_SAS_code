data brandpref;
	infile "D:\Documents and Settings\stsc\My Documents\Downloads\CH06PR05.txt";
	input @1 brandliking
			@11 moisturecont
			@18 sweetness;
	format brandliking 3.;
run;
proc print data=brandpref;
run;
ODS GRAPHICS ON;
PROC CORR DATA=brandpref PLOTS=MATRIX;
	VAR brandliking moisturecont sweetness;
RUN;
ODS GRAPHICS OFF;
proc reg data=brandpref alpha=0.05;
	model brandliking = moisturecont sweetness / lackfit;
	output out=myout r=res p=yhat;
run;
quit;
proc univariate data=myout plots;
	var res;
run;
data myout2;
	set myout;
	x1x2 = moisturecont*sweetness;
run;
proc print data=myout2;
run;
proc gplot data=myout2;
	plot res*yhat;
	plot res*moisturecont;
	plot res*sweetness;
	plot res*x1x2;
run;
quit;
proc model data=brandpref;
	parms const inc1 inc2;
	brandliking = const +inc1*moisturecont
	+inc2*sweetness;
	fit brandliking / breusch=(1 moisturecont sweetness); 	
run;
quit;
PROC SQL;
  INSERT INTO brandpref(brandliking, moisturecont, sweetness)
    VALUES(	., 5, 4);
QUIT;
* Spred using stdi  - PI for new observation;
* S^ Y using stdp   - CI for the mean; 
proc reg data=brandpref alpha=0.01;
	model brandliking = moisturecont sweetness;
	output out=myout3 r=res2 p=yhat2 lcl=lcl ucl=ucl lclm=lclm uclm=uclm stdi=stdi stdp=stdp ;
run;
quit;
proc print data=myout3;
run;
*lclm=lowerCI 
uclm=upperCI lcl=lowerPI ucl=upperPI
