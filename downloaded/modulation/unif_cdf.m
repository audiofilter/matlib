function [y,x] = unif_cdf(umin,umax,nx)

% UNIF_CDF .... Evaluates and plots the cumulative distribution function of a
%		Uniform random variable.
%
%	UNIF_CDF(A,B) plots the cdf of the Uniform random variable U ~ [A,B].
%	UNIF_CDF(A,B,N), where N is a scalar, plots the cdf evaluated at N bins.
%	UNIF_CDF(A,B,X), where X is a vector, plots the cdf using the bins 
%		specified in X.
%	[F,X] = UNIF_CDF(...) does not draw a graph, but returns vectors
%		F and X such that PLOT(X,F) is the cdf.
%	[F] = UNIF_CDF(...) does not draw a graph, but returns vector F which
%		contains computed values of the cdf only.
%
%	See also UNIF_PDF,UNIFORM,CDF.

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
%	Define default values of the parameters
%------------------------------------------------------------------------

nx_default = 100;
kp_default = 2;

%------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help unif_cdf'));
   return;
end   
if (umin > umax)
    error('START parameter is greater than STOP parameter.')
end

%------------------------------------------------------------------------
%	Prepare absicca vector and other parameters
%------------------------------------------------------------------------

if (nargin == 2)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = umin - (kp_default);
    xmax = umax + (kp_default);
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------
%	Compute the cdf
%------------------------------------------------------------------------

cdf = limiter((nx-umin)/(umax-umin),0,1);

%------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------

if (nargout == 0)
    grid,                  ...
    axis;                  ...
    title('Uniform CDF'),  ...
    plot(nx,cdf);
elseif (nargout == 1)
    y = cdf;
else
    y = cdf;
    x = nx;
end
