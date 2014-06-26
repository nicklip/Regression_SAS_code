*Problem 9.15;
data kidney;
	input clearance concentration age weight1;
	cards;
	132.0   0.71   38.0   71.0
   53.0   1.48   78.0   69.0
   50.0   2.21   69.0   85.0
   82.0   1.43   70.0  100.0
  110.0   0.68   45.0   59.0
  100.0   0.76   65.0   73.0
   68.0   1.12   76.0   63.0
   92.0   0.92   61.0   81.0
   60.0   1.55   68.0   74.0
   94.0   0.94   64.0   87.0
  105.0   1.00   66.0   79.0
   98.0   1.07   49.0   93.0
  112.0   0.70   43.0   60.0
  125.0   0.71   42.0   70.0
  108.0   1.00   66.0   83.0
   30.0   2.52   78.0   70.0
  111.0   1.13   35.0   73.0
  130.0   1.12   34.0   85.0
   94.0   1.38   35.0   68.0
  130.0   1.12   16.0   65.0
   59.0   0.97   54.0   53.0
   38.0   1.61   73.0   50.0
   65.0   1.58   66.0   74.0
   85.0   1.40   31.0   67.0
  140.0   0.68   32.0   80.0
   80.0   1.20   21.0   67.0
   43.0   2.10   73.0   72.0
   75.0   1.36   78.0   67.0
   41.0   1.50   58.0   60.0
  120.0   0.82   62.0  107.0
   52.0   1.53   70.0   75.0
   73.0   1.58   63.0   62.0
   57.0   1.37   68.0   52.0
   ;
run;
proc print data=kidney;
run;
ods graphics on;
proc freq data=kidney order=freq;
   tables concentration age weight1 / plots=freqplot(type=dot);
run;
proc corr data=kidney plots=matrix;
	var clearance concentration age weight1;
run;
proc corr data=kidney;
	var concentration age weight1;
run;
proc reg plots=none data=kidney;
	model clearance = concentration age weight1;
run;
quit;
*Problem 9.16;
proc means data=kidney;
	var concentration age weight1;
run;
data kidney2;
	set kidney;
	concentration_ = concentration-1.25;
	concentration_2 = concentration_**2;
	age_ = age-55.97;
	age_2 = age_**2;
	weight1_ = weight1-72.5455;
	weight1_2 = weight1_**2;
	conage = concentration_*age_;
	ageweight = age_*weight1_;
	conweight = concentration_*weight1_;
run;
proc print data=kidney2;
run;
proc reg plots=none data=kidney2;
	model clearance = concentration_ age_ weight1_
	concentration_2 age_2 weight1_2 conage ageweight conweight
	/ selection = Cp best=3;
run;
quit;
*Problem 9.19;
proc reg plots=none data=kidney2;
	model clearance = concentration_ age_ weight1_
	concentration_2 age_2 weight1_2 conage ageweight conweight
	/ selection=stepwise SLentry=.1 SLstay=.15;
run;
quit;
*Problem 10.9;
data brand;
	input liking moisture sweetness;
	cards;
		64.0    4.0    2.0
	   73.0    4.0    4.0
	   61.0    4.0    2.0
	   76.0    4.0    4.0
	   72.0    6.0    2.0
	   80.0    6.0    4.0
	   71.0    6.0    2.0
	   83.0    6.0    4.0
	   83.0    8.0    2.0
	   89.0    8.0    4.0
	   86.0    8.0    2.0
	   93.0    8.0    4.0
	   88.0   10.0    2.0
	   95.0   10.0    4.0
	   94.0   10.0    2.0
	  100.0   10.0    4.0
	  ;
run;
proc print data=brand;
run;
proc reg plots=none data=brand;
	model liking = moisture sweetness /influence r;
	output out=myout r=residual rstudent=sdr cookd=cookd dffits=dffits;
	ods output outputstatistics=myout2;
run;
quit;
proc gplot data=brand;
	plot moisture*sweetness;
run;
proc print data=myout2;
run;
data myout3;
   set myout2;
   fstat=finv(0.5,3,13);
   comparetoleverage=2*3/16;
   run;
proc print data=myout3;
run;
proc sql;
	delete * from brand where liking=95.0;
quit;
proc reg data=brand;
	model liking = moisture sweetness /influence r;
	output out=myouta r=residual rstudent=sdr cookd=cookd dffits=dffits;
	ods output outputstatistics=myouta2;
run;
quit;
*Problem 10.15;
data brand2;
	input liking moisture sweetness;
	cards;
		64.0    4.0    2.0
	   73.0    4.0    4.0
	   61.0    4.0    2.0
	   76.0    4.0    4.0
	   72.0    6.0    2.0
	   80.0    6.0    4.0
	   71.0    6.0    2.0
	   83.0    6.0    4.0
	   83.0    8.0    2.0
	   89.0    8.0    4.0
	   86.0    8.0    2.0
	   93.0    8.0    4.0
	   88.0   10.0    2.0
	   95.0   10.0    4.0
	   94.0   10.0    2.0
	  100.0   10.0    4.0
	  ;
run;
proc corr data=brand2 plots=matrix;
	var moisture sweetness;
run;	
proc reg plots=none data=brand2;
	model liking = moisture sweetness / vif;
	output out=myoutb;
run;
quit;
