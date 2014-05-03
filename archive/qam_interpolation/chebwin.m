function c = chebwin(nf, ripple)
%CHEBWIN Chebyshev window.
%   CHEBWIN(N,R) returns the N-point Chebyshev window with R decibels
%   of ripple.  N must be odd.  If N is even, an odd N+1 length window
%   is returned.

%   Author(s): L. Shure, 3-4-87
%   	   J.N Little, 4-2-87, revised 
%   Copyright (c) 1988-96 by The MathWorks, Inc.
%   $Revision: 1.8 $  $Date: 1996/07/25 16:39:19 $

dp = 10.^(-ripple/20);
odd = rem(nf,2);
if (~odd)
   disp('Chebwin: N must be odd - N is being increased by 1.')
   odd = 1;
   nf = nf+1;
end
n = fix((nf+1)/2);
nm = fix(nf/2+1);
xn = nf-1;
c1 = acosh((1+dp)/dp);
c2 = cosh(c1/xn);
df = acos(1/c2)/pi;
x0 = (3-cos(2*pi*df))/(1.+cos(2*pi*df));
alpha = (1+x0)/2;
beta = (x0-1)/2;
c2 = xn/2;
xi = (0:nf-1);
f = xi/nf;
x = alpha*cos(2*pi*f) + beta;
tmp = (abs(x) > 1);
p = dp*(tmp.*(cosh(c2.*acosh(x)))+(1-tmp).*cos(c2.*acos(x)))+j*zeros(1,nf);
if (~odd)
   p = real(p)*exp(-j*pi*f);
   p(nm+1:nf) = -p(nm+1:nf);
end
c = real(fft(p));
c = c(1:n)/c(1);
c = [c(n:-1:odd+1) c]';

