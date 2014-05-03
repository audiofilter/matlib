%$Id: sincfir.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
function y = sincfir(isps,npts)
% Fir consisting of sinc function
y = zeros(1,npts);
for t=1:npts
	i = t-npts/2;
	x1 = pi*i/isps;
	y(t) = sinc(x1);
% If Sinc function not available.
%if (x1==0) 
%		y(t) = 1;
%	else 
%		y(t) = sin(x1)/x1;
%	end
end
