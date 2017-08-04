* Next syntax was saved as "c:\\temp\\test.sps".
define !Path1 ()'C:\\Program Files\\IBM\\SPSS\\Statistics\\22\\Samples\\English'!enddefine.
define !file1 ()'Employee data.sav'!enddefine.


GET FILE= !PATH1 + '\\' + !file1.
SAMPLE .1.
FREQ VAR=jobcat.

* Exportar resultados.
OUTPUT EXPORT
  /CONTENTS  EXPORT=ALL  LAYERS=ALL  MODELVIEWS=ALL
  /REPORT  DOCUMENTFILE='C:\Users\jota9\Documents\SPSS_MACROS\OUTPUT.htm'
     TITLE=FILENAME FORMAT=HTML.
