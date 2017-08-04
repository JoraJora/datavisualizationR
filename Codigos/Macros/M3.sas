/* Developing a macro with parameters*/

* In this example:
	We often want to merge group summary statistics back
	on to the original data set.  I start with the example
	of merging group means, then generalize;

libname y "y:\sas\macros";
libname library (y);

options symbolgen mprint=off;
/*Step 1:  Write & debug an example*/
proc means data=y.nlswages noprint; 
	class R0002400;
	types R0002400;
	var R0043600;
	output out=mean mean=R0043600mean;
	run;

proc sort data=y.nlswages out=sorted;
	by R0002400;
	run;

data nlswages;
	merge sorted mean;
	by R0002400;
	label R0043600mean="mean of 67 income"; *otherwise mean inherits its label;
	format R0043600mean ; *otherwise it inherits a format, too;
	run;


/*Steps 2 to 4:  Convert the example to a macro*/
%macro mergestat(dsn, var, group, stat);
proc means data=&dsn noprint;
	class &group;
	types &group;
	var &var;
	output out=&stat &stat=&var&stat;
	run;

proc sort data=&dsn out=sorted;
	by &group;
	run;

data &dsn;
	merge sorted &stat;
	by &group;
	label &var&stat="&stat of &var";
	format &var&stat ;
	run;

%mend mergestat;

/*The macro in action*/
options mprint=on;
%mergestat(nlswages, R6204300, R0002400, mean);
%mergestat(nlswages, R7312300, R0002400, median);


/*Another example, where one macro calls another macro.*/
*  In this example, we not only want to merge group summary
	stats, but we also want to score the original variable
	as greater than or less than that stat.;

/* From this:*/
data nlswages;
	set nlswages;
	R0043600cat=(R0043600>R0043600mean);
	run;

proc freq;
	tables R0043600cat;
	run;

/*To this:*/
%macro aboveaverage(dsn, var, stat);
data &dsn;
	set &dsn;
	&var.cat=(&var>&var&stat);
	run;
%mend aboveaverage; /*It should be pretty obvious that this macro
					requires something like %mergestat first,
					which leads to the next example*/

/*Nested macros, macros that call other macros*/
%macro maa(dsn, var, group, stat);
	%mergestat(&dsn, &var, &group, &stat);
	%aboveaverage(&dsn, &var, &stat)
%mend maa;

/*In action*/
%maa(nlswages, R6204300, R0002400, mean);

proc freq;
	tables R6204300cat;
	run;

%maa(nlswages, R7312300, R0002400, median);

proc freq;
	tables R7312300cat;
	run;
