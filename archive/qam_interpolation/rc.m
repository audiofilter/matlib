function y = rc(beta,isps,npts)
y = zeros(1,npts);
for t=1:npts
	i = t-(npts+1)/2;
	x1 = pi*i/isps;
	i2 = i*i/(isps*isps);
	x2 = 1-(4*beta*beta*i2);
	if (x1==0) 
		y(t) = 1;
	elseif (abs(x2)<0.00001) 
		x2 = 8*beta*i2;
        	y(t)=sin(x1)*sin(beta*x1)/x2;
	else 
        	y(t)=(sin(x1)*cos(beta*x1))/(x1*x2);
	end
end

