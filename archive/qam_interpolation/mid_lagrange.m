function res = mid_lagrange(a,n)
% function res = lagrange(a,n)
% Return n-th order Lagrange polynomial coefficients for offset a
res = zeros(1,n+1)+i*zeros(1,n+1);
res_ang = zeros(1,n+1)+i*zeros(1,n+1);
%fir_ang = zeros(1,n+1);
a = a+n/2;
for k=0:n
  res(k+1) = 1;
  for l=0:n
    if (k != l)
      res(k+1) = res(k+1)*(a-l)/(k-l);
    end
  end
  res_ang(k+1) = exp(i*(pi/2)*(k-a));
  res(k+1) = res(k+1)*res_ang(k+1);
end
return