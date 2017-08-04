/* Local and Global Macro Variable
	name clashes */

/* It is pretty easy to show that SAS keeps track of 
	both local and global variables separately */

%let i = 1; /* a global macro var */

%macro testj(j); /* uses both the global and local */
%put _user_;
data _null_;
         x=&i;
         y=&j;
         put "In use: " x y;
         run;
%mend testj;

%testj(2);

%macro testi(i); /* Both are defined, the local is used */
%put _user_;
         data _null_;
         x=&i;
         put "In use: " x;
         run;
%mend testi;

%testi(2);

/* This shows that SAS always uses the local &i over 
	the global &i. */

/* In fact, SAS says "when a macro variable exists both 
	in the global symbol table and in the local symbol 
	table, you cannot reference the global value from 
	within the macro that contains the local macro 
	variable. In this case, the macro processor finds 
	the local value first and uses it instead of the 
	global value."  (This is in the "SAS 9.3 Macro 
	Language: Reference" in a chapter titled "Scopes of 
	Macro Variables.") */

/* To use a global &i as a local macro, you would 
	have to pass it as a parameter (and give it a local 
	name): */

%let i = 1;

%macro testij(i, j);
%put _user_;
         data _null_;
         x=&i;
         y=&j;
         put "In use: " x y;
         run;
%mend testij;

%testij(2, &i); /* Pass global &i in local &j */
