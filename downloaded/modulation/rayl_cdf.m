function [y,x] = rayl_cdf(aa,nx)

% RAYL_CDF .... Evaluates and plots the cumulative distribution function of a
%		Rayleigh random variable.
%
%	RAYL_CDF(MU) plots the cdf of the Rayleigh random variable with 
%		scale parameter MU, i.e., Rayleigh(MU).
%	RAYL_CDF(MU,N), where N is a scalar, plots the cdf evaluated at N bins.
%	RAYL_CDF(MU,X), where X is a vector, plots the cdf using the bins 
%		specified in X.
%	[F,X] = RAYL_CDF(...) does not draw a graph, but returns vectors
%		F and X such that PLOT(X,F) is the cdf.
%	[F] = RAYL_CDF(...) does not draw a graph, but returns vector "F" which
%		contains computed values of the cdf only.
%
%	See also RAYL_PDF,RAYLEIGH,CDF.

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

%------------------------------------------------------------------------------
%	Define default values of the parameters
%------------------------------------------------------------------------------

nx_default = 60;
kp_default = 5;

%------------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help rayl_cdf'));
   return;
end   
if (aa <= 0)
    error('Input parameter must be non-negative')
end

%------------------------------------------------------------------------------
%	Set up initial values and other arrays
%------------------------------------------------------------------------------

if (nargin == 1)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = 0;
    xmax = sqrt(aa/4) + (kp_default)*sqrt(1/aa);
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------------
%	Compute the cdf
%------------------------------------------------------------------------------

cdf = 1 - exp(-aa*(nx.^2)/2);

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
    title('Rayleigh CDF'), grid,
    plot(nx,cdf);
elseif (nargout == 1)
    y = cdf;
else
    y = cdf;
    x = nx;
end
