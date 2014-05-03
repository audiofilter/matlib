function y = osrc(beta,isps,npts)
y = zeros(1,npts);
for t=1:npts
	i = t - npts/2;
	i2 = i*i/(isps*isps);
	x1 = pi*i/isps;
	x2 = 4*beta*i/isps;
	x3 = x2*x2 - 1;
	if (x3==0)
		x3 = (1-beta)*pi*i/isps;
		x2 = (1+beta)*pix/isps;
		nom  = sin(x2)*(1+beta)*pi - cos(x3)*((1-beta)*PI*isps)/(4*beta*i) + sin(x3)/(4*beta*i2);
		denom = -32*pi*beta*beta*i/isps;
		if (beta==1) 
			nom = 1;
			denom = 4*beta;
		end
	else 
		if (x1==0)
			nom = cos((1+beta)*x1) + (1-beta)*pi/(4*beta);
		else 
			nom = cos((1+beta)*x1) +  sin((1-beta)*x1)/(4*beta*i/isps);
		end
		denom = x3*pi;
	end
	y(t) = -4*beta*nom/denom;
end

