function y = remezdd(k, n, m, x)
%REMEZDD Lagrange interpolation coefficients.
 
%   Author: T. Krauss 1993
%       Was Revision: 1.4, Date: 1994/01/25 17:59:44
 
y = 1;
q = x(k);
for l=1:m
        xx = 2*(q - x(l:m:n));
        y = y*prod(xx(xx ~= 0));
end
y=1/y;
