﻿data devnorm;
   input X @@;
   datalines;
-7 -2 1 3 6 10 15 21 30 21 4 15 3 69 21 0 -3 -6 -12 -52 32 1 0 -10
;
 
proc means data=devnorm maxdec=3 n mean           
           std stderr t probt;
		   output out=meansdevnorm;
run;

options nodate pageno=1 linesize=80 pagesize=60;

libname mylib 'C:\Users\jota9\Documents\Jalpc\Codigos\Macros';
data mylib.cake;
   input LastName $ 1-12 Age 13-14 PresentScore 16-17
         TasteScore 19-20 Flavor $ 23-32 Layers 34 ;
   datalines;
Orlando     27 93 80  Vanilla    1
Ramey       32 84 72  Rum        2
Goldston    46 68 75  Vanilla    1
Roe         38 79 73  Vanilla    2
Larsen      23 77 84  Chocolate  .
Davis       51 86 91  Spice      3
Strickland  19 82 79  Chocolate  1
Nguyen      57 77 84  Vanilla    .
Hildenbrand 33 81 83  Chocolate  1
Byron       62 72 87  Vanilla    2
Sanders     26 56 79  Chocolate  1
Jaeger      43 66 74             1
Davis       28 69 75  Chocolate  2
Conrad      69 85 94  Vanilla    1
Walters     55 67 72  Chocolate  2
Rossburger  28 78 81  Spice      2
Matthew     42 81 92  Chocolate  2
Becker      36 62 83  Spice      2
Anderson    27 87 85  Chocolate  1
Merritt     62 73 84  Chocolate  1
;

proc freq data=mylib.cake;
      tables flavor*layers /chisq exact;
run;

proc univariate data=mylib.cake modes plot normal cibasic(alpha=.1);
      var presentscore;
        histogram /normal (color=red);
        qqplot;
run;

