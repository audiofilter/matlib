function fir = lagrange(a,n)
% function fir = lagrange(a,n)
% Return n-th order Lagrange polynomial coefficients for offset a
fir = zeros(1,n+1);
a = a+n/2;
for k=0:n
  fir(k+1) = 1;
  for l=0:n
    if (k == l)
    else
      fir(k+1) = fir(k+1)*(a-l)/(k-l);
    end
  end
end
