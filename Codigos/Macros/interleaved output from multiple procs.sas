libname y "y:\sas\data";
libname library (y);

%let varlist = R0002400 R0133700 R0205100 R0288200 
	R0308300 R0367600 R0455600 R0491300 R0661400 R0666600 R0721700 
	R0869900 R0997700 R1290700 R1664710 R3507200 R4278200 
	R5447500 R6516200;

%macro freqchart(dsn, var);  /* Define the table & chart macro */
	proc freq data=&dsn;
		tables &var;
		run;

	proc gchart data=&dsn;
		vbar &var/discrete type=percent;
		run;quit;
%mend freqchart;

%freqchart(y.nlswomen, R0002400); /* Then use (or "call") the macro */

%macro vlist(varlist);
%* tokenizes a variable list and returns the parts
	as "v" macro variables, and returns the word count;
%global words; * This counts how many words are in the varlist;
%let words = 1;
%do %while(%index(&varlist,%str( )) gt 0);
	%global v&words;  * This gives us convenient macro vars referrring to the varlist;
	%let v&words = %substr(&varlist, 1, %index(&varlist,%str( ))-1);
	%let varlist = %substr(&varlist, %index(&varlist,%str( ))+1);
	%let words = %eval(&words + 1);
	%end;
%global v&words;
%let v&words = &varlist;
%mend vlist;

%vlist(&varlist); /* puts global varlist in local varlist */
%put _user_;

%macro freqsncharts(dsn, varlist); /* now combine the two parts */
	%vlist(&varlist);
	%do i = 1 %to &words;
		%freqchart(&dsn, &&v&i);
		%end;
%mend freqsncharts;

options nosymbolgen mprint=off;
ods pdf file="u:\interleaved output.pdf";

%freqsncharts(y.nlswomen, &varlist);

ods pdf close;
