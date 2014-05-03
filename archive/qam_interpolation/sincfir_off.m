function y = sincfir_off(isps,npts,off)
% Fir consisting of sinc function with a fractional offset of off 
y = zeros(1,npts);
mid = (npts + rem(npts,2))/2;
for t=1:npts
	i = t-mid+(off/isps);
	y(t) = sinc(i);
%	x1 = pi*i/isps;
% If Sinc function not available.
%if (x1==0) 
%		y(t) = 1;
%	else 
%		y(t) = sin(x1)/x1;
%	end
end
