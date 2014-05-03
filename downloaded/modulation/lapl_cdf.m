function [y,x] = lapl_cdf(sigma2,nx)

% LAPL_CDF .... Evaluates and plots the cumulative distribution function of a
%		Laplacian random variable.
%
%	LAPL_CDF(MU) plots the cdf of the Laplacian random variable with
%		variance MU, i.e., Laplace(MU).
%	LAPL_CDF(MU,N), where N is a scalar, plots the cdf evaluated at N bins.
%	LAPL_CDF(MU,X), where X is a vector, plots the cdf using the bins 
%		specified in X.
%	[F,X] = LAPL_CDF(...) does not draw a graph, but returns vectors
%		F and X such that PLOT(X,F) is the cdf.
%	[F] = LAPL_CDF(...) does not draw a graph, but returns vector "F" which
%		contains computed values of the cdf only.
%
%	See also LAPL_PDF,LAPLACE,CDF.

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
kp_default = 1/100;

%------------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help lapl_cdf'));
   return;
end   
if (nargin == 2)
    if (sigma2 <= 0), error('parameter "mu" has to be positive.'), end
end

%------------------------------------------------------------------------------
%	Set up initial values and other arrays
%------------------------------------------------------------------------------
mu = sqrt(sigma2/2);

if (nargin == 1)
    nx = nx_default;
end
if (length(nx) == 1)
    xmax =   mu * log(1/kp_default);
    xmin = - xmax;
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------------
%	Compute the cdf
%------------------------------------------------------------------------------

cdf = zeros(size(nx));
cdf(nx>=0) = 1 - (1/2)*exp(-nx(nx>=0)/mu);
cdf(nx< 0) =     (1/2)*exp( nx(nx< 0)/mu);

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
%    if( inquire('axis') == 0), axis([xmin xmax 0 1 ]); end
    title('Laplacian CDF'),    grid
    axis([xmin xmax 0 1 ]);    plot(nx,cdf);
elseif (nargout == 1)
    y = cdf;
else
    y = cdf;
    x = nx;
end
% if( inquire('axis') ~= 0), axis; end
axis;
