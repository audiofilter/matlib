function y = requant(x,m)
n = size(x,1);
for j=1:n
  if (x(j) >= m) 
	y(j) = x(j) - 2*m;
  else
	y(j) = x(j);
  endif
endfor
