* Developing macro functions, code within a DATA or
	PROC step;

* Problem, convert agewed variable into
	ten year categories (perhaps to compare
	to published stats);

proc freq data=y.gssage;
	tables agewed;
	run;

/* No parameters */
%macro age10;
	if agewed < 10 then age10 = 0;
	else if agewed <20 then age10 = 1;
	else if agewed <30 then age10 = 2;
	else if agewed <40 then age10 = 3;
	else if agewed <50 then age10 = 4;
	else if agewed <60 then age10 = 5;
	else if agewed <70 then age10 = 6;
	else if agewed <80 then age10 = 7;
	else if agewed <90 then age10 = 8;
	else if agewed <100 then age10 = 9;
	else if agewed <110 then age10 = 10;
%mend age10;

data age; /* Macro in use */
	set y.gssage;
	%age10;
	run;
proc freq;
	tables age10;
	run;




/* More general, takes a variable with any name */	
%macro age10(var);
	if &var < 10 then &var.10 = 0;
	%do i=20 %to 110 %by 10;
	else if &var <&i then &var.10 = (&i/10)-1;
	%end;
	%mend age10;

%macro fmtage10(var=age, lib=work);  /* sidetrack */
	proc format library=&lib;
	%if %length(&var) gt 4 %then %let var = %substr(&var, 1, 4);
	%let var = &var.10f;
		value &var 0 = "< 10"
			1 = "10 - 19"
			2 = "20 - 29"
			3 = "30 - 39"
			4 = "40 - 49"
			5 = "50 - 59"
			6 = "60 - 69"
			7 = "70 - 79"
			8 = "80 - 89"
			9 = "90 - 99"
			10= "100-110";
		run;
%mend fmtage10;

%fmtage10(var=agewed);

data age; /*in use */
	set y.gssage;
	%age10(old1);
	*age10b=floor(age/10); /* more than one solution to this problem! */
	%age10(old2);
	run;

proc freq;
	tables old1 old110;
	tables old1*old110 / nopercent nocol;
	run;



/* More general yet, takes any variable, and bin width, and lets
		you set the ceiling on the distribution */
%macro bins(var, width, max);  /* note this is PART of a data step */
	if &var < &width then &var&width = 0;
	%do i = 2 %to (&max/&width);
	else if &var < &width*&i then &var&width = &i-1;
	%end;
	label &var&width = "&var in &width unit categories";
%mend bins;

%macro maxval(dsn, var);  /* add a macro that finds the maximum value for you */
	%global max&var;
	proc summary data=&dsn;
		var &var;
		output out=max max=;
		run;

	data _null_;
		set max;
		call symput("max&var", &var);
		run;

	proc datasets library=work noprint;
		delete max;
		run;quit;
%mend maxval;

%maxval(y.gssage, agewed);
%put &maxagewed;
%maxval(y.gssage, agekdbrn);

data age; /* Using both pieces */
	set y.gssage;
	%bins(agewed, 10, &maxagewed);
	%bins(agekdbrn, 10, &maxagekdbrn);
	run;



/* An finally, a macro that puts both parts together */
%macro setbins(dsn=, var=, width=); 
	%maxval(&dsn, &var);

	data &dsn;
		set &dsn;
		%bins(&var, &width, &&max&var);
		run;
%mend setbins;

%setbins(dsn=y.gssage, var=agekdbrn, width=7);
