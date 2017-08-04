if not exist "BASES\SAS" mkdir BASES\SAS
if not exist "output\SAS" mkdir output\sas

@ECHO off
IF [%1] == [] goto Alerta1

"C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -sysin EjemploLectura.sas -ICON -NOSPLASH -sysparm ""

goto Alerta2

:Alerta1
ECHO OjO...... Se debe pasar algun parametro

:Alerta2
ECHO El proceso finalizo, el parametro fue --%1--
