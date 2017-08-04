*libname new '/folders/myfolders/SQLDatasetsV9';
*filename trans '/folders/myfolders/SQLDatasetsV9/SQLDatasetsV9';

*proc cimport library=new infile=trans;
*run;

proc SQL;
    * Filtro;
	SELECT Name, HighPoint as High FROM new.continents;
	title 'FILTRO POR PAIS';
	select Name, Population  from new.countries
 		where Population gt 5000000
 		order by Population desc;  	
	
	* Filtro y ordenamiento;
	title 'FILTRO POR CONTINENTE';
	select Continent, sum(Population)
		 from new.countries
		 group by Continent
		 order by Continent; 

 	* Agregado y filtro del agregado;
	select Continent, sum(Population)
	 from new.countries
	 group by Continent
	 having Continent in ('Asia', 'Europe')
	 order by Continent; 

    * Creación de tablas;
 	CREATE TABLE new.FILTROINICIAL AS
 	 SELECT Continent, sum(Population)
	 from new.countries
	 group by Continent
	 having Continent in ('Asia', 'Europe')
	 order by Continent;
	
	*Producto cartesiano;	
	 title 'TABLA PAIS X TABLA CONTINENTE';
	 select * from new.countries cou, new.continents con
	 where con.Name = cou.Continent;		
		
quit;
