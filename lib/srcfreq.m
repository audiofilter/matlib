%$Id: srcfreq.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
function z = srcfreq(f,a)
if (f<0.5*(1-a)) 
	z = 1;
	return;
end
if (f>0.5*(1+a))
	z = 0;
else
	z = cos( (2*f - 1.0 + a)/(4*a)*pi );
end;
	
