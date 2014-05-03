function [y,x] = gaus_cdf(mean,var,nx)

% GAUS_CDF .... Evaluates and plots the cumulative distribution function of a
%		Gaussian random variable.
%
%	GAUS_CDF(MEAN,VAR) plots the cdf of the Gaussian random variable with
%		parameters MEAN and VARIANCE.  This function uses the error
%		function ERF from the MATLAB library.
%	GAUS_CDF(MEAN,VARIANCE,N), where N is a scalar, plots the cdf 
%		evaluated at N bins.
%	GAUS_CDF(MEAN,VARIANCE,X), where X is a vector, plots the cdf 
%		using the bins specified in X.
%	[F,X] = GAUS_CDF(...) does not draw a graph, but returns vectors
%		F and X such that PLOT(X,F) is the cdf.
%	[F] = GAUS_CDF(...) does not draw a graph, but returns vector F which
%		contains computed values of the cdf only.
%
%	See also GAUSS_PDF,GAUSS,CDF.

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
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

global START_OK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------
%	Define parameters
%------------------------------------------------------------------------

nx_default = 20;
kp_default = 4.0;

%------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help gaus_cdf'));
   return;
end   
if (var < 0)
    error('Variance must be non-negative')
end

%------------------------------------------------------------------------
%	Prepare absicca vector and other parameters
%------------------------------------------------------------------------

if (nargin == 2)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = mean - (kp_default)*sqrt(var);
    xmax = mean + (kp_default)*sqrt(var);
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------
%	Evaluate the pdf with "mean" and "var" parameters at nx
%------------------------------------------------------------------------

cdf = (1/2)*(1-erf((mean-nx)/sqrt(2*var)));

%------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------

if (nargout == 0)
    grid,                     ...
    axis;                     ...
    title('Gaussian CDF'),    ...
    plot(nx,cdf);
elseif (nargout == 1)
    y = cdf;
else
    y = cdf;
    x = nx;
end
