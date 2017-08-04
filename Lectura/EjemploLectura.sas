DATA cars1;
 INPUT make $ model $ mpg weight price;
CARDS;
AMC Concord 22 2930 4099
AMC Pacer   17 3350 4749
AMC Spirit  22 2640 3799
Buick Century 20 3250 4816
Buick Electra 15 4080 7827
;
RUN; 
title "cars1 data";
PROC PRINT DATA=cars1(obs=5);
RUN; 

DATA cars2;
  INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
CARDS;
AMC  Concord2229304099
AMC  Pacer  1733504749
AMC  Spirit 2226403799
BuickCentury2032504816
BuickElectra1540807827
;
RUN;

TITLE "cars2 data";
PROC PRINT DATA=cars2(obs=5);
RUN; 


DATA cars3;
  INFILE "C:\Users\jota9\Google Drive\Trabajos_Afuera\SantoTomas\Lectura\cars3.dat";
  INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
RUN;

TITLE "cars3 data";
PROC PRINT DATA=cars3(obs=5);
RUN; 

