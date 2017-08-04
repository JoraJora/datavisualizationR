* Next syntax was saved as "c:\\temp\\test.sps".
define !Path1 ()'C:\\Program Files\\IBM\\SPSS\\Statistics\\22\\Samples\\English' !enddefine.
define !file1 ()'Employee data.sav' !enddefine.

GET FILE= !PATH1 + '\\' + !file1.
SAMPLE .1.

* read matrix data from a regular spss sav file.
MATRIX.
GET X /VARIABLES= jobtime educ.
get Y /variables = salary.
compute Lambda =  0.0001 * make(48,1,1).
compute diagc = mdiag (Lambda).
print diagc /title="diagc".
compute Xtrans=transpos(X).
compute XXtrans=X*Xtrans.
compute invXX=inv(XXtrans + diagc).
compute a=invXX*Y.
compute yestima= XXtrans * a.
print a /title="a".
print yestima /title="y estim".
end matrix.
