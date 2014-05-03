function x = la_conv(y,n);
x = y;
lim = 2^n;
mx = 2^(n-1) - 1
for k=1:1024
	if (x(k)>mx) 
		x(k) = x(k)-lim;
	end
end;
