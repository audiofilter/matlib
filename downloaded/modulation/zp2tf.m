## Copyright (C) 1999 Paul Kienzle
##
## This program is free software and may be used for any purpose.  This
## copyright notice must be maintained.  Paul Kienzle is not responsible
## for the consequences of using this software.

## usage: [b, a] = zp2tf(z, p, g)
##
## Convert to transfer function f(x)=sum(b*x^n)/sum(a*x^n) from
## zero-pole-gain form f(x)=g*prod(1-z*x)/prod(1-p*x)

function [b, a] = zp2tf(z, p, g)
  if nargin != 3 || nargout != 2
    usage("[b, a] = zp2tf(z, p, g)");
  endif
  b = g*real(poly(z));
  a = real(poly(p));
endfunction
