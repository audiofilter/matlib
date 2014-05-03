function Tn=tchebyshev(n);
% function Tn=tchebyshev(n);
% $Id: tchebyshev.m,v 1.1 1997/10/13 16:13:44 kirke Exp $
%
% This function returns the nth order Tchebyshev polynomial Tn
% Normalized so the maximum magnitude of Tn in [-1,1] is 1.
index=1:n;
r=cos((2*index-ones(size(index)))*pi/2/n);
Tn=poly(diag(r))*2^(n-1);
