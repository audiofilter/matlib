## c = xcorr2(a, b [, 'scale'])
##
## Compute two-dimensional cross-correlation using Fourier transforms.
##	xcorr2(A,B) computes the crosscorrelation of matrices A and B.
##	xcorr2(A) is the autocorrelation function.
##	This routine is functionally equivalent to matlab xcorr2 but 
##      usually faster and less numerically stable.
## Scale is one of:
##      biased   - scales the raw cross-correlation by the maximum number
##                 of elements of A and B involved in the generation of 
##                 any element of C
##      unbiased - scales the raw correlation by dividing each element 
##                 in the cross-correlation matrix by the number of
##                 products A and B used to generate that element 
##      coeff    - normalizes the sequence so that the largest 
##                 cross-correlation element is identically 1.0.
##      none     - no scaling (this is the default).

## Copyright shared by R. Johnson, Dave Cogdell and Paul Kienzle
##    FFT-based xcorr2 by R. Johnson
##    bias correction by Dave Cogdell (cogdelld@asme.org)
##    Brought together for use in octave by Paul Kienzle
## Use it in any way suitable for a work without an explicit
## copyright notice, since none was provided by the first
## two authors.  Keep this notice with all distributions.

function c = xcorr2(a,b,biasflag)

  if (nargin < 1 || nargin > 3)
    usage ("c = xcorr2(A [, B] [, 'scale'])");
  endif
  if nargin==1, b=a, biasflag='none'; endif
  if nargin==2
    if isstr(b), biasflag=b; b=a;
    else biasflag='none';
    endif
  endif

  ## FFT xcorr2 by R. Johnson
  [ma,na] = size(a);
  [mb,nb] = size(b);
  ##	make reverse conjugate of one array
  b = conj(b(mb:-1:1,nb:-1:1));

  ##	use power of 2 transform lengths
  mf = 2^nextpow2(ma+mb);
  nf = 2^nextpow2(na+nb);
  at = fft2(b,mf,nf);
  bt = fft2(a,mf,nf);
  ##	multiply transforms then inverse transform
  c = ifft2(at.*bt);
  ##	make real output for real input
  if isreal(a) && isreal(b)
    c = real(c);
  end
  ##  trim to standard size
  c(ma+mb:mf,:) = [];
  c(:,na+nb:nf) = [];
  
  ## bias routines by Dave Cogdell (cogdelld@asme.org)
  if strcmp(lower(biasflag), 'biased'),
    c = c/(min([ma, mb])*min([na, nb]));
  elseif strcmp(lower(biasflag), 'unbiased'), 
    [mc,nc] = size(c); # == [ma+mb-1, na+nb-1]
    basebias = zeros(mc,nc);
    bri = 1:min([na, nb]);
    basebias(1,bri) = bri;
    basebias(1,nc-length(bri)+1:nc) = fliplr(bri);
    I = find(!basebias(1,:));
    if !isempty(I),
      basebias(1,I) = max(bri)*ones(size(I));
    endif #---------------------------------------------- first row complete
    for i = 2:min([ma, mb]); #----------------- clone & modify for rest of rows
      basebias(i,:) = i*basebias(1,:); 
    endfor
    basebias(mc-i+1:mc,:) = flipud(basebias(1:i,:));
    baseline = basebias(i,:);
    I = find(!basebias(:,1));
    if !isempty(I),
      for i = 1:length(I)
        basebias(I(i),:) = baseline;
      endfor
    endif
    c = c./basebias;
  elseif strcmp(lower(biasflag),'coeff'),
    c = c/max(c(:))'
  endif
endfunction
