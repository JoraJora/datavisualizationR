* Macro variables;

libname y "y:\sas\macros";
libname library (y);

/* SYMBOLGEN lets you see every time SAS
	resolves a macro variable.  NOSYMBOLGEN
	turns this off */

options symbolgen; 
*options nosymbolgen;

* Assigning values to macro variables;
%let dsn = y.nlswomen;
%let varlist = R0002400 R0133700 R0205100 R0288200 
	R0308300 R0367600 R0455600 R0491300 R0661400 R0666600 R0721700 
	R0869900 R0997700 R1290700 R1664710 R3507200 R4278200 
	R5447500 R6516200;

* Using the macro variables;
proc freq data=&dsn;
	tables &varlist / nocum;
run;
* This is essentially text substitution, pretty simple;


* reassigned macro variable;
%let dsn = y.nlswages;
%let varlist = R0043600 R0107300 R0174800 R0257500 R0303200 R0323900 
	R0407200 R0477200 R0511200 R0623800 R0703400 R0759400 R0856900 
	R0967600 R3388500 R4153500 R5111700 R6204300 R7312300;
proc freq data=&dsn;
	tables &varlist / nocum;
	format &varlist;
run;

proc means data=&dsn;
	var &varlist;
	class R0002400;
	run;


* A nested macro variable;
%let married = &dsn(where=(R0002400=1));
%*let varlist = R0856900 R0967600; /* macro comment */

proc means data=&married; 
	var &varlist;
run;

/* Resolved inside double quotes */
proc means data=&married; 
	title "Means of &varlist in &married"; 
	title2 "On &sysday &sysdate"; /*Automatic macro variables */
	var &varlist;
run;

title;
proc corr data=&dsn;
	var &varlist;
	run;


*More debugging;
%put _user_;
%put _automatic_;
%put _all_;
