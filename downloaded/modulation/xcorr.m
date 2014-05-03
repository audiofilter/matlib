## Copyright (C) 1999-2000 Paul Kienzle
##
## This program is free software and may be used for any purpose.  This
## copyright notice must be maintained. Paul Kienzle is not responsible
## for the consequences of using this software.


## usage: [R, lag] = xcorr (X [, Y] [, maxlag] [, scale])
##
## Compute correlation of X and Y for various lags.  
## Returns R(m+maxlag+1)=Rxy(m) for lag m=[-maxlag:maxlag].
## Scale is one of:
##    'biased'   for correlation=raw/N, 
##    'unbiased' for correlation=raw/(N-|lag|), 
##    'coeff'    for correlation=raw/(correlation at lag 0),
##    'none'     for correlation=raw
## If Y is omitted, compute autocorrelation.  
## If maxlag is omitted, use N-1 where N=max(length(X),length(Y)).
## If scale is omitted, use 'none'.
##
## If X is a matrix, computes the cross correlation of each column
## against every other column for every lag.  The resulting matrix has
## 2*maxlag+1 rows and P^2 columns where P is columns(X). That is,
##    R(m+maxlag+1,P*(i-1)+j) == Rij(m) for lag m=[-maxlag:maxlag],
## so
##    R(:,P*(i-1)+j) == xcorr(X(:,i),X(:,j))
## and
##    reshape(R(m,:),P,P) is the cross-correlation matrix for X(m,:).

## Ref: Stearns, SD and David, RA (1988). Signal Processing Algorithms.
##      New Jersey: Prentice-Hall.

## 2000-03 pkienzle@kienzle.powernet.co.uk
##     - use fft instead of brute force to compute correlations
##     - allow row or column vectors as input, returning same
##     - compute cross-correlations on columns of matrix X
##     - compute complex correlations consitently with matlab
## 2000-04 pkienzle@kienzle.powernet.co.uk
##     - fix test for real return value

function [R, lags] = xcorr (X, Y, maxlag, scale)
  
  if (nargin < 1 || nargin > 4)
    usage ("[c, lags] = xcorr(x [, y] [, h] [, scale])");
  endif

  ## assign arguments from list
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

  ## assign defaults to arguments which were not passed in
  if is_vector(X) 
    if isempty(Y), Y=X; endif
    N = max(length(X),length(Y));
  else
    N = rows(X);
  endif
  if isempty(maxlag), maxlag=N-1; endif
  if isempty(scale), scale='none'; endif

  ## check argument values
  if is_scalar(X) || isstr(X) || isempty(X)
    error("xcorr: X must be a vector or matrix"); 
  endif
  if is_scalar(Y) || isstr(Y) || (!isempty(Y) && !is_vector(Y))
    error("xcorr: Y must be a vector");
  endif
  if !is_vector(X) && !isempty(Y)
    error("xcorr: X must be a vector if Y is specified");
  endif
  if !is_scalar(maxlag) && !isempty(maxlag) 
    error("xcorr: maxlag must be a scalar"); 
  endif
  if maxlag>N-1, 
    error("xcorr: maxlag must be less than length(X)"); 
  endif
  if is_vector(X) && is_vector(Y) && length(X) != length(Y) && \
	!strcmp(scale,'none')
    error("xcorr: scale must be 'none' if length(X) != length(Y)")
  endif
    
  P = columns(X);
  M = 2^nextpow2(N + maxlag);
  if !is_vector(X) 
    ## For matrix X, compute cross-correlation of all columns
    R = zeros(2*maxlag+1,P^2);
    ## Precompute the pre-padded and transformed `X(j)' vectors
    pre = zeros(M,P); 
    for i=1:P
      pre(:,i) = fft(postpad(prepad(X(:,i),N+maxlag),M)); 
    endfor
    ## For each i, generate xcorr(i,j) and by symmetry xcorr(j,i).
    for i=1:P
      post = conj(fft(postpad(X(:,i),M)));
      for j=i:P
    	cor = ifft(post.*pre(:,j));
      	R(:,(i-1)*P+j) = conj(cor(1:2*maxlag+1));
	if (i!=j), R(:,(j-1)*P+i) = flipud(cor(1:2*maxlag+1)); endif
      endfor
    endfor
  elseif isempty(Y)
    ## compute autocorrelation of a single vector
    post = fft(postpad(X,M));
    cor = reshape(ifft(conj(X).*X),M,1);
    R = [ conj(cor(maxlag+1:-1:2)) ; cor(1:maxlag+1) ];
  else 
    ## compute cross-correlation of X and Y
    post = fft(postpad(X,M));
    pre = fft(postpad(prepad(Y,N+maxlag),M));
    cor = conj(ifft(reshape(conj(post),M,1).*reshape(pre,M,1)));
    R = cor(1:2*maxlag+1);
  endif

  ## if inputs are real, outputs should be real, so ignore the
  ## insignificant complex portion left over from the FFT
  if isreal(X) && (isempty(Y) || isreal(Y))
    R=real(R); 
  endif

  ## correct for bias
  if strcmp(scale, 'biased')
    R = R ./ N;
  elseif strcmp(scale, 'unbiased')
    for i=1:columns(R)
      R(:,i) = R(:,i) ./ [ N-maxlag:N-1, N, N-1:-1:N-maxlag ]';
    endfor
  elseif strcmp(scale, 'coeff')
    for i=1:columns(R)
      R(:,i) = R(:,i) ./ R(maxlag+1,i);
    endfor
  elseif !strcmp(scale, 'none')
    error("xcorr: scale must be 'biased', 'unbiased', 'coeff' or 'none'");
  endif
    
  ## correct the shape so that it is the same as the input vector
  if is_vector(X) && P > 1
    R = R'; 
  endif
  
  ## return the lag indices if desired
  if nargout == 2
    lags = -maxlag:maxlag;
  endif

endfunction

##------------ Use brute force to compute the correlation -------
##if !is_vector(X) 
##  ## For matrix X, compute cross-correlation of all columns
##  R = zeros(2*maxlag+1,P^2);
##  for i=1:P
##    for j=i:P
##      idx = (i-1)*P+j;
##      R(maxlag+1,idx) = X(i)*X(j)';
##      for k = 1:maxlag
##  	    R(maxlag+1-k,idx) = X(k+1:N,i) * X(1:N-k,j)';
##  	    R(maxlag+1+k,idx) = X(k:N-k,i) * X(k+1:N,j)';
##      endfor
##	if (i!=j), R(:,(j-1)*P+i) = conj(flipud(R(:,idx))); endif
##    endfor
##  endfor
##elseif isempty(Y)
##  ## reshape X so that dot product comes out right
##  X = reshape(X, 1, N);
##    
##  ## compute autocorrelation for 0:maxlag
##  R = zeros (2*maxlag + 1, 1);
##  for k=0:maxlag
##  	R(maxlag+1+k) = X(1:N-k) * X(k+1:N)';
##  endfor
##
##  ## use symmetry for -maxlag:-1
##  R(1:maxlag) = conj(R(2*maxlag+1:-1:maxlag+2));
##else
##  ## reshape and pad so X and Y are the same length
##  X = reshape(postpad(X,N), 1, N);
##  Y = reshape(postpad(Y,N), 1, N);
##  
##  ## compute cross-correlation
##  R = zeros (2*maxlag + 1, 1);
##  R(maxlag+1) = X*Y';
##  for k=1:maxlag
##  	R(maxlag+1-i) = X(k+1:N) * Y(1:N-k)';
##  	R(maxlag+1+i) = X(k:N-i) * Y(k+1:N)';
##  endfor
##endif
##--------------------------------------------------------------
