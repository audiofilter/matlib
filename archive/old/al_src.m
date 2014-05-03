function y = al_src(beta,isps,npts)
% Allen Edwards Square root raised cosine function
% i.e using Window function on coefficients and Quantize
%
y = src(beta,isps,npts);
y = y/max(y);
mid = npts/2;
for i=1:npts
	y(i) = y(i)*(1 - ( (i-0.5)/mid -1 )^4 );
end
y = round(321*y);
