## Copyright (C) 1999 Paul Kienzle
##
## This program is free software and may be used for any purpose.  This
## copyright notice must be maintained.  Paul Kienzle is not responsible
## for the consequences of using this software.

## Generate a chebyshev filter with Rp dB of stop band ripple (type II).
## 
## [b,a] = cheby2(n, Rs, Wc)
##    low pass filter with stop band cut-off of -Rs dB at pi*Wc radians
##
## [b,a] = cheby2(n, Rs, Wc, 'high')
##    high pass filter with stop band cutoff of -Rs dB at pi*Wc radians
##
## [b,a] = cheby2(n, Rs, [Wl, Wh])
##    band pass filter with stop band edges at pi*Wl and pi*Wh radians
##
## [b,a] = cheby2(n, Rs, [Wl, Wh], 'stop')
##    band reject filter with pass band edges at pi*Wl and pi*Wh radians
##
## [z,p,g] = cheby2(...)
##    return filter as zero-pole-gain rather than coefficients of the
##    numerator and denominator polynomials.

## TODO: For odd order low-pass filters, the S-plane gain Sg has a much
## TODO:    larger imaginary component than the real component.  Can the
## TODO:    computation be reordered so that the imaginary component is
## TODO:    approximately zero, and the real component is correspondingly larger?
## TODO:    That way, sftrans can be fixed to return real(Sg) again, rather than
## TODO:    returning a complex value.

## Author: pkienzle@cs.indiana.edu

function [Zz, Zp, Zg] = cheby2(n, Rs, W, stype)

  if (nargin>4 || nargin<3) || (nargout>3 || nargout<2)
    usage ("[b, a] or [z, p, g] = cheby2 (n, Rs, W, [, 'ftype'])");
  end

  stop = nargin==4;
  if stop && !(strcmp(stype, 'high') || strcmp(stype, 'stop'))
    error ("cheby2: ftype must be 'high' or 'stop'");
  end
  
  [r, c]=size(W);
  if (!(length(W)<=2 && (r==1 || c==1)))
    error ("cheby2: frequency must be given as w0 or [w0, w1]");
  elseif (!all(W >= 0 & W <= 1))
    error ("cheby2: critical frequencies must be in (0, 1)");
  elseif (!(length(W)==1 || length(W) == 2))
    error ("cheby2: only one filter band allowed");
  elseif (length(W)==2 && !(W(1) < W(2)))
    error ("cheby2: first band edge must be smaller than second");
  endif
  if (Rs < 0)
    error("cheby2: passband ripple must be positive decibels");
  end

  ## Prewarp to the band edges to s plane
  T = 2;       # sampling frequency of 2 Hz
  Ws = 2/T*tan(pi*W/T);

  ## Generate splane poles and zeros for the chebyshev type 2 filter
  ## From: Stearns, SD; David, RA; (1988). Signal Processing Algorithms. 
  ##       New Jersey: Prentice-Hall.
  C = 1;			# default cutoff frequency
  lambda = 10^(Rs/20);
  phi = log(lambda + sqrt(lambda^2-1))/n;
  theta = pi*([1:n]-0.5)/n;
  alpha = -sinh(phi)*sin(theta);
  beta = cosh(phi)*cos(theta);
  Sz = 1i*C./cos(theta);
  Sp = C./(alpha.^2+beta.^2).*(alpha-1i*beta);

  ## compensate for amplitude at s=0
  Sg = prod(Sp)/prod(Sz);

  ## splane frequency transform
  [Sz, Sp, Sg] = sftrans(Sz, Sp, Sg, Ws, stop);

  ## Use bilinear transform to convert poles to the z plane
  [Zz, Zp, Zg] = bilinear(Sz, Sp, Sg, T);

  if nargout==2, [Zz, Zp] = zp2tf(Zz, Zp, Zg); endif

endfunction