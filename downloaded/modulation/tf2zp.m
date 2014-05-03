## Copyright (C) 1999 Paul Kienzle
##
## This program is free software and may be used for any purpose.  This
## copyright notice must be maintained.  Paul Kienzle is not responsible
## for the consequences of using this software.

## usage: [z, p, g] = tf2zp(b,a)
##
## Convert transfer function f(x)=sum(b*x^n)/sum(a*x^n) to
## zero-pole-gain form f(x)=g*prod(1-z*x)/prod(1-p*x)

## TODO: See if tf2ss followed by ss2zp gives better results.  These
## TODO: are available from the control system toolbox.  Note that
## TODO: the control systems toolbox doesn't bother, but instead uses
## TODO: roots(b) and roots(a) as we do here (though they are very
## TODO: long-winded about it---must ask why).
function [z, p, g] = tf2zp(b, a)
  if nargin!=2 || nargout!=3,
    usage("[z, p, g] = tf2zp(b, a)");
  endif
  if isempty(b) || isempty(a)
    error("tf2zp b or a is empty. Perhaps already in zero-pole form?");
  endif
  g = b(1)/a(1);
  z = roots(b);
  p = roots(a);
endfunction
