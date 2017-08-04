%macro lsmeansat(effect, cov, min, max, by);
	%do i = &min %to &max %by &by;
		lsmeans &effect / at &cov=&i cl;
		%end;
%mend lsmeansat;

%macro groupstep(var, groupby, index=_n_, start=1, inc=1);
	&var = (&start - &inc) + (int((&index-1)/&groupby + 1))*&inc;
%mend groupedstep;

*options mprint=off;

proc glm data=sashelp.class;
	class sex;
	model weight = height|sex|age;
	ods output lsmeancl=lsmeans;
	%lsmeansat(sex, height, 50, 80, 3);
	run; quit;
	/*
	lsmeans sex / at height=50 cl out=lsm50;
	lsmeans sex / at height=55 cl out=lsm55;
	lsmeans sex / at height=60 cl;
	lsmeans sex / at height=65 cl;
	lsmeans sex / at height=70 cl;
	lsmeans sex / at height=75 cl;
	lsmeans sex / at height=80 cl;
	lsmeans sex / at height=85 cl;
	run;quit;*/

data lsmeans;
	set lsmeans;
	%groupstep(var=height, groupby=2, start=50, inc=3);
	run;

proc sgpanel data=lsmeans;
	panelby sex;
	band x=height upper=uppercl lower=lowercl;
	series x=height y=lsmean;
	run;
	
