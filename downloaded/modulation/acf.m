function [Rout, xout] = acf(in1,in2,in3);

% ACF .........	Computes the autocorrelation function (acf) of a sequence.
%
%	ACF(X,LAG) displays the acf of the input sequence X for time 
%		lags over the interval [-LAG, LAG].  If the input sequence
%		contains more samples than to calculate the acf, the set of
%		operations are performed on successive segments of X, each
%		(2*LAG) samples long.  Power(X) correspond to Rxx(0) and
%		DC-Power(X) corresponds to Rxx(LAG) as LAG --> Infinity. 
%
%	ACF(X) uses a default value of LAG = 30.
%
%	ACF(X,LAG,'norm') and ACF(X,'norm') will perform the same function, but 
%		Rxx(t) will be normalized such that Rxx(0) = 1.
%
%	[Rxx,Xlag] = ACF(...) does not draw a graph, but returns vectors 
%		Rxx and Xlag, such that PLOT(Xlag, Rxx) is the same display.
%		For a better display of Rxx use the plotting function AC_PLOT.
%
%	See also ACF_PLOT.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up the input parameters
%------------------------------------------------------------------------------

lag_default = 20;
norm = 0;
x = in1(:);
if (size(x,1)==1) x=x'; end  % MODIF. OCTAVE

n_lag = lag_default;
if (nargin == 2)
   if(isstr(in2))
	  norm = 1;
   else
	  n_lag = in2;
   end
end
if (nargin == 3)
   if(isstr(in2))
	  n_lag = in3;
   else
      n_lag = in2; 
   end
   norm = 1; 
end

%------------------------------------------------------------------------------
%	Evaluate initial parameters
%------------------------------------------------------------------------------

n     = length(x);					% Number of data points
k     = fix((n)/(2*n_lag));	% Number of windows
nsize = 2*n_lag;					% Number of data points 
							%        for N_lag
umin  = nsize/2; umax = 3*nsize/2;
x0    = 1:(2*nsize-1);
x_lag = x0 - nsize;
sel   = x0( (x0 >= umin) & (x0 <= umax) );
index = 1:nsize;
R_xx  = zeros(2*nsize-1,1);

%------------------------------------------------------------------------------
%	Begin to evaluate R_xx 
%------------------------------------------------------------------------------

for i=1:k
     rx = xcorr(x(index),'unbiased');
     index = index + (nsize);
     R_xx = R_xx + rx;
end

R_xx = R_xx/k;
mR = R_xx(nsize);
if(norm == 1)
  R_xx = R_xx/mR;
end

%------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------
if (nargout == 0)
     t_lag = x_lag / SAMPLING_FREQ; 
     acf_plot(R_xx(sel),t_lag(sel));
else
     Rout = R_xx(sel);
     if( nargout == 2), xout = x_lag(sel); end
end
