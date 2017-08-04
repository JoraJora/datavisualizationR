%macro groupstep(var, groupby, index=_n_, start=1, inc=1);
	&var = (&start - &inc) + (int((&index-1)/&groupby + 1))*&inc;
%mend groupedstep;

data obsdata;
	do n = 1 to 100;
		%groupstep(y, 4, index=n);
		output;
		end;
	run;

data obsdata;	
	set obsdata;
	%groupstep(z, 3, start=25);
	run;


data obsdata;	
	set obsdata;
	%groupstep(w, 10, start=50, inc=10);
	run;
