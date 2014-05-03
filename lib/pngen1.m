%$Id: pngen1.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
function y = pngen1(npts,taps,fill)
%function y = pngen(npts, taps, fill)
% PNGEN generates "npts" number of points of the psuedo random
% sequence defined by a shift register of length max(taps) with 
% feedback taps 'taps' and initial fill 'fill'. 
% PN(npts, taps, fill) returns a vector of length npts containing this sequence.
% A typical example [1,6,8,14] for R14, fill=[1 zeros(1,13)]
% Another is taps=[3,5,6,89];fill=[1 zeros(1,88)];y = pngen(1000,taps,fill);
% which generates a PN sequence corresp. to R89
% Output is +1 or -1

n=max(taps);
y = zeros(1,npts); 
x = zeros(1,n);
x = fill(length(fill):-1:1);
for i=1:npts
   y(i) = x(n);
   if (y(i)==0) 
	y(i) = -1;
   end
   x=[rem(sum(x(taps)),2), x(1:n-1)];
end
