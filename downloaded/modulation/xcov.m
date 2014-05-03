## Copyright (C) 1999 Paul Kienzle
##
## This program is free software and may be used for any purpose.  This
## copyright notice must be maintained. Paul Kienzle is not responsible
## for the consequences of using this software.


## usage: [c, lag] = xcov (X [, Y] [, maxlag] [, scale])
##
## Compute covariance at various lags [=correlation(x-mean(x),y-mean(y))].
##
## X: input vector
## Y: if specified, compute cross-covariance between X and Y,
## otherwise compute autocovariance of X.
## maxlag: is specified, use lag range [-maxlag:maxlag], 
## otherwise use range [-n+1:n-1].
## Scale:
##    'biased'   for covariance=raw/N, 
##    'unbiased' for covariance=raw/(N-|lag|), 
##    'coeff'    for covariance=raw/(covariance at lag 0),
##    'none'     for covariance=raw
## 'none' is the default.
##
## Returns the covariance for each lag in the range, plus an 
## optional vector of lags.

function [retval, lags] = xcov (X, Y, maxlag, scale)

  if (nargin < 1 || nargin > 4)
    usage ("[c, lags] = xcov(x [, y] [, h] [, scale])");
  endif

  if nargin==1
    Y=[]; maxlag=[]; scale=[];
  elseif nargin==2
    maxlag=[]; scale=[];
    if isstr(Y), scale=Y; Y=[];
    elseif is_scalar(Y), maxlag=Y; Y=[];
    endif
  elseif nargin==3
    scale=[];
    if isstr(maxlag), scale=maxlag; scale=[]; endif
    if is_scalar(Y), maxlag=Y; Y=[]; endif
  endif
  [retval, lags] = xcorr(center(X), center(Y), maxlag, scale);
  
endfunction
