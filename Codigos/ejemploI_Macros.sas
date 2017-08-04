data main;
input ID var1 var2;
cards;
1 2 3
2 4 5
3 6 7
4 8 9
;
run;

proc contents data=main; run;

/* 1. Create a macro variable using the %let statement */
%let newvar = var3;
%put &newvar.;

/* 2. Use the & operator to call a macro variable */
data new_main; set main;
&newvar = var1+var2;
run;

proc contents data=main; run;
proc contents data=new_main; run;

proc print data=new_main;
run;

/* 3. Create a macro to transform a variable */
%MACRO transform_this(x);
&x._squared = &x ** 2;
&x._cubed = &x ** 3;
&x._inverse = 1 / &x;
%MEND transform_this;

data newer_main; set new_main;
%transform_this(var1);
%transform_this(var2);
run;

proc print data=newer_main;
run;

/* 4. Create a macro to run the CONTENTS procedure on any data set */

proc contents data=main; run;
proc contents data=new_main; run;
proc contents data=newer_main; run;

%MACRO contents_of(data_set);
proc contents data=&data_set; 
run;
%MEND contents_of;

%contents_of(main);
%contents_of(new_main);

