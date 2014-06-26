data breakage;
	input transfer broken;
	datalines;
	1 16
	0 9
	2 17
	0 12 
	3 22
	1 13
	0 8
	1 15
	2 19
	0 11
	;
run;
proc print data=breakage;
run;
proc reg;
	model broken=transfer;
run;
quit;
