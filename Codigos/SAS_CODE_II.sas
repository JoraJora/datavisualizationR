libname new '/folders/myfolders/SQLDatasetsV9';
filename trans '/folders/myfolders/SQLDatasetsV9/SQLDatasetsV9';

proc cimport library=new infile=trans;
run;

/*--- Examinar las propiedades de Data set SAS-----*/
proc contents data=new.countries;
run;

/*--- Lectura de un archivo .DAT -----*/


/*--- Impresion de las bases -----*/
proc print data=new.countries;
run;

/*--- Definición de libref (nombre logico de un directorio) -----*/
libname new '/folders/myfolders/SQLDatasetsV9';
	
/*--- Eliminar nombre logico de una libreria -----*/
libname new clear;

/*--- Ver todas los data set de una libreria -----*/
libname new '/folders/myfolders/SQLDatasetsV9';
proc contents data=new._all_ nods;
run;

/*--- Ejemplo selección y sumarizar variable-----*/
proc print data=new.continents;
 var Name Area;
 sum Area;
run;

/*--- Ejemplo de WHERE (Suprime la columna Obs)-----*/
proc print data=new.continents noobs;
 var Name Area;
 where Area is not missing;
run;

/*--- Ejemplo de distintos operadores logicos -----*/

proc print data=new.continents noobs;
 where Area GT 5500000; *(>);
 sum Area;
run;

proc print data=new.continents noobs;
 where Area LE 5500000; *(<=);
 sum Area;
run;

proc print data=new.continents noobs;
 where Area EQ 11506000; *(=);
 sum Area;
run;

proc print data=new.continents noobs;
 where Area NE 11506000; *(^= o ¬= o ~=);
 sum Area;
run;

proc print data=new.continents noobs;
 where Name in ('Africa', 'Europe', 'Oceania'); *(Comparacion en otros vectores);
 sum Area;
run;


/*--- Ejemplo CONTAINS -----*/
proc print data=new.countries noobs;
 where NAME CONTAINS 'Af';
run;


/*--- Ejemplo (negación, is missing, BETWEEN) -----*/
proc print data=new.continents noobs;
	 var Name Area;
	 where not Area is not missing and Area BETWEEN 5500000 AND  11000000;
	 sum Area;
run;

proc print data=new.continents noobs;
	 var Name Area;
	 where not Area is not missing AND NAME CONTAINS 'Afric';
	 sum Area;
run;

/*--- Ejemplo de WHERE SAME AND -----*/
proc print data=new.continents noobs;
	 var Name Area;
	 where Area is not missing;
	 where same and NAME CONTAINS 'Afric';
	 sum Area;
run;


/*--- Ejemplo de LIKE -----*/

DATA new.exampleName;
	INPUT NAME $50.;
	CARDS;
	ELVISH_Irenie
	Ngan_Christina
	Hotstone_Kimiko
	Daymond_Lucian
	Hofmeister_Fong
	Denny_Satyakam
	Clarkson_Sharryn
	Kletschkus_Monica
RUN;

proc print data=new.exampleName;
	 where NAME like '%_M%';
run;



