* Codigo para calculo kernel gaussiano.
DATA LIST LIST /V1, V2, V3.
BEGIN DATA 
1  2  2
0 -1  1
1  1 -2
END DATA.

MATRIX.
GET X.
COMPUTE sigma = 0.5.
COMPUTE Kernel= mdiag(make(NROW(X),1,1)).
LOOP I = 1 to NROW(X). 
+ LOOP J = 1 to NROW(X). 
+ COMPUTE auxDiff = X({I},:) - X({J},:).
+ COMPUTE norm = SQRT(auxDiff * transpos(auxDiff)).
+ Compute Kernel({I},{J}) = norm . 
+  END LOOP. 
END LOOP. 
COMPUTE Kernel = Kernel * (1/sigma).
PRINT Kernel.
END MATRIX.

* Codigo para calculo de distancia eclidiana
dataset declare dist.
PROXIMITIES V1, V2, V3
/MEASURE = EUCLID
/PRINT = NONE
/MATRIX = OUT('dist').

* Definir una macro para kernel gaussiano.
DEFINE !kernelGauss (sigma=!tokens(1))
MATRIX.
GET X.
COMPUTE sigma = !sigma.
COMPUTE Kernel= mdiag(make(NROW(X),1,1)).
LOOP I = 1 to NROW(X). 
+ LOOP J = 1 to NROW(X). 
+ COMPUTE auxDiff = X({I},:) - X({J},:).
+ COMPUTE norm = SQRT(auxDiff * transpos(auxDiff)).
+ Compute Kernel({I},{J}) = norm . 
+  END LOOP. 
END LOOP. 
COMPUTE Kernel = Kernel * (1/sigma).
PRINT Kernel.
END MATRIX.
!ENDDEFINE.

!kernelGauss sigma=0.5.

DATA LIST LIST /V1, V2, V3.
BEGIN DATA 
1  2  2
0 -1  1
1  1 -2
1  1 -2
1  1 -2
0 -1  1
0 -1  1
END DATA.

!kernelGauss sigma=0.5.

* Definición  alterna de una macro para kernel gaussiano.
define !kernelGauss(!pos= !token(1) /!pos= !charend('%') /!pos= !charend('%') /!pos= !charend(')'))
COMPUTE @X =!2.
COMPUTE @sigma = !3.
COMPUTE !4= mdiag(make(NROW(@X),1,1)).
LOOP I = 1 to NROW(@X). 
+ LOOP J = 1 to NROW(@X). 
+ COMPUTE auxDiff = @X({I},:) - @X({J},:).
+ COMPUTE norm = SQRT(auxDiff * transpos(auxDiff)).
+ Compute !4({I},{J}) = norm . 
+  END LOOP. 
END LOOP. 
COMPUTE !4 = !4 * (1/@sigma).
release @X,@sigma,@i.
!enddefine.

DATA LIST LIST /V1, V2, V3.
BEGIN DATA 
1  2  2
0 -1  1
1  1 -2
END DATA.

MATRIX.
GET X.
!kernelGauss(X%0.5%name).
PRINT X.
PRINT name.
END MATRIX.









