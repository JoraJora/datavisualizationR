%macro words(string);
   %global count;
   %let count=1;
   %let word=%qscan(&string,&count,%str( ));
   %do %while(&word ne);
      %let count=%eval(&count+1);
      %let word=%qscan(&string,&count,%str( ));
   %end;
   %let count=%eval(&count-1);
%mend words;

%macro renameseq(varlist=, stub=v, istart=1);
%words(&varlist);
	rename
%do i=1 %to &count;
	%let var = %scan(&varlist, &i);
	%let j = %eval(&istart - 1 + &i);
		&var=&stub&j
%end;
		;
%mend renameseq;



data example;
	set sashelp.bweight;
	%renameseq(varlist=married boy mom_age);
	run;

data example2;
	set sashelp.bweight;
	%renameseq(varlist=married boy mom_age, stub=hdr_, istart=1997);
	run;

