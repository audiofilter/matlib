function fir = lagr4(a)
% Return 4th order Lagrange polynomial coefficients
c = a*(a-1)*(a-2);
cm2 = c*(a+1)/24;
cm1 = -c*(a+2)/6;
c = a*(a+2)*(a+1);
c0 = (a+2)*(a+1)*(a-1)*(a-2)/4;
c1 = -c*(a-2)/6;
c2 = c*(a-1)/24;
fir = [c2  c1  c0  cm1  cm2];
