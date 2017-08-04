matrix. 
***** define a matrix with the compute command****.
 ***** A is a 2 X 2 matrix********.
compute A={3,2;4,0}.
 ***** B is a 2 X 5 matrix*********.
compute B={1,3,0,5,7;2,4,3,3,3}.
 ***** C is a 2 X 2 matrix*********.
compute C={0,8;9,1}.
***** transpose B******.
compute Btrans=transpos(B).
****** Add *****.
compute AplusC=A+C.
***** multiply****.
compute AB=A*B.
***** multiply****.
compute A4=4*B.
***** inverse*****.
compute inverseA=inv(A).
***** determinant ***.
compute detA=det(A).
compute ind = A * inv(A).
*******print the results ********.
print A /title "Matrix A".
print B /title "Matrix B".
print Btrans /title "B transpose".
print AplusC /title "A + C".
print AB /title "AB".
print inverseA /title "A inverse".
print detA /title "Det A".
print ind /title "Ind orden 2".
end matrix.

matrix.
*compute the mean of X1 and X2.
compute X={-2,-1;
 0,1;
 2,3;
 4,-2;
 -4,-1}.
compute ONE=make(5,1,1). /* (5,1,1) generates a matrix with 5 rows, 1 column, and elements equal to 1.
compute transONE=transpos(ONE).
compute meanX=transONE*X*(1/5).
print meanX /title "mean of X1 and X2"
 /format="F5.2".
end matrix.

matrix.
**** This section computes a variance-covariance matrix, s, for two variables, X1 and X2.
compute X={-2,-1;
 0,1;
 2,3;
 4,-2;
 -4,-1}.
compute Xtrans=transpos(X).
compute Xprod=Xtrans*X.
compute S=(1/(5-1))*Xprod. /* 1/(5-1) is 1/(N-1), the inverse of df */
compute invS=inv(S).
print S /title="Covariance Matrix S".
print invS /title="Inverse of S".
compute diagS = diag(S).
*** This section computes the correlation matrix of X1 and X2.
compute rtdiagS=sqrt(diag(S)). /* take the square root of the diagonal elements of S for standard deviations*/
compute rtD=mdiag(rtdiagS). /* mdiag gives the full matrix diagonal with 0 off diagonal elements */
compute invrtD=inv(rtD). /* invrtD is D raised to the negative one-half giving us the reciprocal of the*/
compute R=invrtD*S*invrtD.
print invrtD /title="invrtD: D raised to the negative one-half".
print R /title="R, the correlation matrix".
end matrix.


matrix.
***This section computes a simple regression with Y regressed on X. The first column of the X matrix must have
ones to obtain the intercept.
compute X={1,-2;
 1,0;
 1,2;
 1,4;
 1,-4}.
compute Y={-1;1;3;-2;-1}.
compute Xtrans=transpos(X).
compute XtransX=Xtrans*X.
compute invXX=inv(XtransX).
compute XtransY=Xtrans*Y.
compute b=invXX*XtransY.
compute yestimado= X* b.
print b /title="b".
print yestimado /title="y estimado".
end matrix.

matrix.
***regresion Kernel (Kernel identidad).
compute X={1,-2;
 1,0;
 1,2;
 1,4;
 1,-4}.
compute Y={-1;1;3;-2;-1}.
compute Lambda =  0.0001 * make(5,1,1).
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





