libname y "y:\sas\macros";
libname library (y);

proc contents data=y.nlswages out=vars short;
run;

data _null_;
	set vars end=last;
	call symput(compress("v"||varnum), name);
	if last then call symput("vmax", _n_);
	run;

%put _user_;

%macro vbar;
	%do i = 1 %to &vmax;
	proc sgplot data=y.nlswages;
		vbar &&v&i; *note the double ampersand;
		run;
	%end;
%mend vbar;
options symbolgen;
%vbar;
