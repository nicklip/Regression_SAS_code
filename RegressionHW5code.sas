*Problem 9.10;
data jobpro;
	input jobproscore test1 test2 test3 test4;
	cards;
		88.0   86.0  110.0  100.0   87.0
	   80.0   62.0   97.0   99.0  100.0
	   96.0  110.0  107.0  103.0  103.0
	   76.0  101.0  117.0   93.0   95.0
	   80.0  100.0  101.0   95.0   88.0
	   73.0   78.0   85.0   95.0   84.0
	   58.0  120.0   77.0   80.0   74.0
	  116.0  105.0  122.0  116.0  102.0
	  104.0  112.0  119.0  106.0  105.0
	   99.0  120.0   89.0  105.0   97.0
	   64.0   87.0   81.0   90.0   88.0
	  126.0  133.0  120.0  113.0  108.0
	   94.0  140.0  121.0   96.0   89.0
	   71.0   84.0  113.0   98.0   78.0
	  111.0  106.0  102.0  109.0  109.0
	  109.0  109.0  129.0  102.0  108.0
	  100.0  104.0   83.0  100.0  102.0
	  127.0  150.0  118.0  107.0  110.0
	   99.0   98.0  125.0  108.0   95.0
	   82.0  120.0   94.0   95.0   90.0
	   67.0   74.0  121.0   91.0   85.0
	  109.0   96.0  114.0  114.0  103.0
	   78.0  104.0   73.0   93.0   80.0
	  115.0   94.0  121.0  115.0  104.0
	   83.0   91.0  129.0   97.0   83.0
	   ;
run;
proc print data=jobpro;
run;
proc univariate plots data=jobpro;
	var test1 test2 test3 test4;
run;
quit;
ods graphics on;
proc corr data=jobpro plots=matrix;
	var jobproscore test1 test2 test3 test4;
run;
quit;
ods graphics off;
proc reg data=jobpro;
 model jobproscore = test1 test2 test3 test4;	
 output out=myout r=res p=yhat;
run;
quit;
*Problem 9.11;
proc reg data=jobpro outest=out;
	model jobproscore = test1 test2 test3 test4 / selection = adjrsq b best=4;
run;
quit;
*Problem 9.18;
proc reg data=jobpro;
	model jobproscore = test1 test2 test3 test4 /
	selection=stepwise SLentry=0.05 SLstay=0.1;
run;
quit;
*Problem 9.21;
proc reg data=jobpro outest=out2;
	model jobproscore = test1 test3 test4 / selection = b press;
run;
quit;
proc print data=out2;
run;
proc reg data=jobpro;
	model jobproscore = test1 test3 test4;
run;
quit;	


