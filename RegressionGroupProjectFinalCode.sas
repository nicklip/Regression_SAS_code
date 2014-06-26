data cohortall;
	infile "C:\Users\Nicholas\Documents\Documents\My SAS Files(32)\cohortall.csv" dsd dlm="," firstobs=2;
	input id: 6.
		year: 4.
		gender: $2.
		race: $2.
		cohort: $8.
		cohortnum: 6.
		fouryear: 3.3
		sixyear: 3.3
		;
		if year ^=2010 then delete;
		if gender ^="B" then delete;
		if race ^="X" then delete;
		if cohort ^= "4y bach" then delete;
	run;
data graduate;
	infile "C:\Users\Nicholas\Documents\Documents\My SAS Files(32)\Big College Data.csv" dsd dlm="," firstobs=2;
	input id : 6.
			school: $30.
			city: $30.
			state: $15.
			level: $10.
			type: $30.
			basic: $30.
			enrollment: 6.
			spending: 6.
			fulltime: 3.3
			SAT: 4.
			aid: 3.3
			endowment: 3.3
			fouryear: 3.3
			sixyear: 3.3
			pell: 3.3
		;
run;
proc sort data=graduate; by id;
run;
proc sort data=cohortall; by id;
run;
data all;
	merge cohortall graduate;
	by id;
	run;
data fouryearonly;
	set all;
if level='2-year' then delete;
length region $10;
length collegecategory $10;
if state="Alabama" then region="South";
if state="Arizona" then region="West";
if state="Alaska" then region="West";
if state="Arkansas" then region="South";
if state="California" then region="West";
if state="Colorado" then region="West";
if state="Connecticut" then region="NorthEast";
if state="Delaware" then region="Atlantic";
if state="Distict of Col" then region="Atlantic";
if state="Florida" then region="South";
if state="Georgia" then region="South";
if state="Hawaii" then region="West";
if state="Idaho" then region="West";
if state="Illinois" then region= "Midwest";
if state="Indiana" then region= "Midwest";
if state="Iowa" then region="Midwest";
if state="Kansas" then region="Midwest";
if state="Kentucky" then region="South";
if state="Louisiana" then region="South";
if state="Maine" then region="NorthEast";
if state="Maryland" then region="Atlantic";
if state="Massachusetts" then region="NorthEast";
if state="Michigan" then region="Midwest";
if state="Minnesota" then region="Midwest";
if state="Mississippi" then region="South";
if state="Missouri" then region="Midwest";
if state="Montana" then region="West";
if state="Nebraska" then region="Midwest";
if state="Nevada" then region="West";
if state="New Hampshire" then region="NorthEast";
if state="New Jersey" then region="Atlantic";
if state="New Mexico" then region="West";
if state="New York" then region="Atlantic";
if state="North Carolina" then region="Atlantic";
if state="North Dakota" then region="Midwest";
if state="Ohio" then region="Midwest";
if state="Oklahoma" then region="South";
if state="Oregon" then region="West";
if state="Pennsylvania" then region= "Atlantic";
if state="Rhode Island" then region= "NorthEast";
if state="South Carolina" then region="Atlantic";
if state="South Dakota" then region="Midwest";
if state="Tennessee" then region="South";
if state="Texas" then region="South";
if state="Utah" then region="West";
if state="Vermont" then region="NorthEast";
if state="Virginia" then region="Atlantic";
if state="Washington" then region="West";
if state="West Virginia" then region="Atlantic";
if state="Wisconsin" then region="Midwest";
if state="Wyoming" then region="West"; 
if basic="Doctoral and Research Universi"
then collegecategory="Research";
else if basic="Research Universities--high re"
then collegecategory="Research";
else if basic="Research Universities--very hi"
then collegecategory="Research";
else if basic="Schools of art- music- and des"
then collegecategory="Other";
else if basic="Schools of business and manage"
then collegecategory="Other";
else if basic="Schools of engineering"
then collegecategory="Other";
else if basic="Masters Colleges and Universit"
then collegecategory="General";
else collegecategory="General";
drop basic;
enrollmentinthousands=enrollment/1000;
spendinginthousands=spending/1000;
run;
data indata;
	set fouryearonly;
	if sixyear=. then delete;
	if fouryear=. then delete;
	if sixyear=0 then delete;
	if fouryear=0 then delete;
	if fouryear<1 then fouryear=(fouryear*1000);
	if sixyear<1 then sixyear=(sixyear*1000);		
	if cohortnum<20 then delete;
	if pell<1 then pell=(pell*1000);
	if fulltime<1 then fulltime=(fulltime*1000);
	if pell>100 then delete;
	if fulltime>100 then delete;
	if sixyear>100 then delete;
	if fouryear>100 then delete;
	SAT2=SAT/100;
	pell2=pell/10;
	fulltime2=fulltime/10;
	spending2=spendinginthousands/10;
	fouryeargraduates=(cohortnum*fouryear)/100;
	sixyeargraduates=(cohortnum*sixyear)/100;
	if fouryeargraduates=. then delete;
	if sixyeargraduates=. then delete;
	run;
proc print data=indata;
run;
proc corr;
	var enrollmentinthousands spending2 fulltime2 SAT2 aid endowment pell2;
	run;
proc logistic data=indata;
	class type region collegecategory;
	model fouryeargraduates/cohortnum = type collegecategory region enrollmentinthousands spending2 fulltime2 SAT2 aid endowment pell2 /selection=backward slentry=0.15 slstay=0.1 lackfit noint;
	run;
	quit;
proc logistic data=indata;
	class region type collegecategory;
	model sixyeargraduates/cohortnum = type collegecategory region enrollmentinthousands spending2 fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc genmod data=indata;
	class region type collegecategory;
	model fouryeargraduates/cohortnum= type collegecategory region enrollmentinthousands spending2 fulltime2 SAT2 aid endowment pell2/ dist=bin link=logit noint;
	output out=genmodout1 p=pred1;
	run;
	quit;
proc sgscatter data=indata;
	matrix enrollment spending fulltime SAT aid endowment pell;
run;
proc sgscatter data=indata;
	matrix enrollment spending fulltime SAT aid endowment pell /group=type;
run;
proc sgscatter data=indata;
	matrix fouryear pell  /group=type;
	run;
proc sgscatter data=indata;
	matrix sixyear pell /group=type;
	run;
proc sgscatter data=indata;
	matrix fulltime sixyear /group=type;
	run;
proc sgscatter data=indata;
	matrix endowment fouryear /group=type;
	run;
proc sgscatter data=indata;
	matrix sixyear endowment /group=type;
	run;
proc sgscatter data=indata;
	matrix sat fouryear /group=type;
	run;
proc sgscatter data=indata;
	matrix sixyear sat /group=type;
	run;
proc sgscatter data= indata;
	matrix aid fouryear  /group=type;
	run;
proc sgscatter data=indata;
	matrix spending fouryear /group=type;
	run;
****ANALYSIS OF COLLEGES BY PUBLIC/PRIVATE****;

	*seperating colleges by type**;
proc sql;
	create table privateforprofitonly as
		select * from indata where type="Private for-profit";
		quit;
proc sql;
	create table privatenotforprofitonly as
		select * from indata where type="Private not-for-profit";
		quit;
proc sql;
	create table publiconly as
		select * from indata where type="Public";
		quit;
proc logistic data=privatenotforprofitonly;
	class region collegecategory;
	model fouryeargraduates/cohortnum = collegecategory region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /selection=backward slentry=0.15 slstay=0.1 lackfit noint;
	run;
	quit;
proc logistic data=privateforprofitonly;
	class region collegecategory;
	model fouryeargraduates/cohortnum = enrollmentinthousands spendinginthousands fulltime2 aid pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=publiconly;
	class region collegecategory;
	model fouryeargraduates/cohortnum = collegecategory region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=privatenotforprofitonly;
	class region collegecategory;
	model sixyeargraduates/cohortnum = collegecategory region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /selection=backward slentry=0.15 slstay=0.1 lackfit noint;
	run;
	quit;
proc logistic data=privateforprofitonly;
	class region collegecategory;
	model sixyeargraduates/cohortnum = enrollmentinthousands spendinginthousands fulltime2 aid pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run; 
	quit;
proc logistic data=publiconly;
	class region collegecategory;
	model sixyeargraduates/cohortnum = collegecategory region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
		**seperating colleges, research/general**;
proc sql;
	create table research as
		select * from indata where collegecategory="Research";
		quit;
proc sql;
	create table general as
		select * from indata where collegecategory="General";
		quit;
proc logistic data=research;
	class region type;
	model fouryeargraduates/cohortnum = type region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=general;
	class region type;
	model fouryeargraduates/cohortnum = type region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=research;
	class region type;
	model sixyeargraduates/cohortnum = type region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=general;
	class region type;
	model sixyeargraduates/cohortnum = type region enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc sgscatter data=indata;
	matrix pell fouryear /group=collegecategory;
	run;
**region analysis**;
proc sql;
	create table south as
		select * from indata where region="South";
		quit;
		***dividing into regions***;
proc sql;
	create table Midwest as
		select * from indata where region="Midwest";
		quit;
proc sql;
	create table South as
		select * from indata where region="South";
		quit;
proc sql;
	create table West as
		select * from indata where region="West";
		quit;
proc sql;
	create table NorthEast as
		select * from indata where region="NorthEast";
		quit;
proc sql;
	create table Atlantic as
		select * from indata where region="Atlantic";
		quit;
		****REGION ANALYSIS****;
proc logistic data=atlantic;
	class collegecategory type;
	model fouryeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=Midwest;
	class collegecategory type;
	model fouryeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=Northeast;
	class collegecategory type;
	model fouryeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=South;
	class collegecategory type;
	model fouryeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=West;
	class collegecategory type;
	model fouryeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=atlantic;
	class collegecategory type;
	model sixyeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=Midwest;
	class collegecategory type;
	model sixyeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=Northeast;
	class collegecategory type;
	model sixyeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=South;
	class collegecategory type;
	model sixyeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
proc logistic data=West;
	class collegecategory type;
	model sixyeargraduates/cohortnum = type collegecategory enrollmentinthousands spendinginthousands fulltime2 SAT2 aid endowment pell2 /lackfit rsq selection=backward slentry=0.15 slstay=0.1 noint;
	run;
	quit;
