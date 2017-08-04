libname new '/folders/myfolders/SQLDatasetsV9';
filename trans '/folders/myfolders/SQLDatasetsV9/SQLDatasetsV9';

proc cimport library=new infile=trans;
run;

/*--- Ejemplo (Operacion Division) -----*/
LIBNAME new '/folders/myfolders/SQLDatasetsV9';
DATA new.RDATA;
INPUT A $ B $;
CARDS;
a1 b1
a1 b2
a2 b1
a2 b2
a2 b3
a2 b4
a3 b1
a3 b3
RUN;	

DATA new.SDATA;
INPUT B $;
CARDS;
b1
b2
b3
RUN;

* Datos para el operador de division;
PROC SQL;
    select * from new.RDATA;
    select * from new.SDATA;
quit;

* Haciendo las tres operaciones ;
PROC SQL;
  * (R(A) x S);
  TITLE 'Table R x S';
  SELECT R.A, S.B FROM new.RDATA R, new.SDATA S;
  CREATE TABLE T2 as SELECT R.A, S.B FROM new.RDATA R, new.SDATA S;
  
  * (R(A) x S) - R;
  SELECT T2.A FROM T2 
  WHERE compress(T2.A || T2.B) not in (
  	SELECT compress(A || B) FROM new.RDATA R
  );

  * R(A) - (R(A) x S) - R;
  SELECT DISTINCT R.A FROM new.RDATA R
  WHERE R.A not in (
	  SELECT T2.A FROM T2 
	  WHERE compress(T2.A || T2.B) not in (
	  	SELECT compress(A || B) FROM new.RDATA R
	  )
  );
QUIT;


/*--- Ejemplo producto cartesiano -----*/
PROC SQL;
	 title 'TABLA PAIS X TABLA CONTINENTE';
	 select * from new.countries cou, new.continents con;
QUIT;

/*--- Ejemplo (operador diferencia) -----*/
PROC SQL;
 *Creacion de nuevas tablas;
 CREATE TABLE T1 AS 
 SELECT * FROM new.countries
  where Continent in ('Asia', 'Europe');
  
 * Haciendo operador diferencia;
 CREATE TABLE T2 AS
 SELECT * FROM new.continents CONT
 WHERE CONT.Name not in (SELECT Continent From T1);
QUIT;

/*--- Ejemplo (Inner Join) -----*/
PROC SQL;
	 title 'TABLA PAIS X TABLA CONTINENTE';
	 select * from new.countries cou, new.continents con;
	 where con.Name = cou.Continent and con.Name = 'Asia' and cou.Continent = 'Asia';		
QUIT;

PROC SQL;
	 title 'TABLA PAIS X TABLA CONTINENTE';
	 select * from new.countries cou inner join new.continents con;
	 on con.Name = cou.Continent;		
QUIT;

proc sql;
 title 'Table R inner join S';
 select R.A, R.B from new.RDATA R inner join new.SDATA S
 ON R.B = S.B;
QUIT;

/*--- Ejemplo (Left Outer Join) -----*/
proc sql outobs=10;
	 title 'Coordinates of Capital Cities';
	 select Capital format=$20., Name 'Country' format=$20.,
	 Latitude, Longitude
	 from new.countries a left join new.worldcitycoords b
	 on a.Capital = b.City and
	 a.Name = b.Country
	 where b.Latitude is not missing and b.Longitude is not missing
	 order by Capital;
quit; 	

/*--- Ejemplo (Right Outer Join) -----*/
proc sql outobs=10;
	 title 'Populations of Capitals Only';
	 select City format=$20., Country 'Country' format=$20.,
	 Population
	 from new.countries right join new.worldcitycoords
	 on Capital = City and
	 Name = Country
	 order by City;
quit;


/*--- Ejemplo (Full Outer Join)-----*/

proc sql outobs=10;
 title 'Populations and/or Coordinates of World Cities';
 select City '#City#(WORLDCITYCOORDS)' format=$20.,
Capital '#Capital#(COUNTRIES)' format=$20.,
 Population, Latitude, Longitude
 from new.countries full join new.worldcitycoords
 on Capital = City and
 Name = Country; 


/*--- Ejemplo (Special Join)-----*/

data one;
  input X Y $;
  datalines;
	1 2
	2 3
;

data two;
  input W Z $;
  datalines;
   2 5
   3 6
   4 9
;
run;

proc sql;
 title 'Table One';
 select * from one;
 title 'Table Two';
 select * from two;
title;
quit;


proc sql;
 title 'Table One and Table Two';
 select *
 from one cross join two;
quit;

proc sql;
 title 'Table One and Table Two';
 select *
 from one union join two;
quit;

proc sql;
 title 'Table One and Table Two';
 select *
 from one union join two;
quit;

proc sql outobs=6;
 title 'Oil Production/Reserves of Countries';
 select country, barrelsperday 'Production', barrels 'Reserve'
 from sql.oilprod natural join sql.oilrsrvs
 order by barrelsperday desc;
quit;
