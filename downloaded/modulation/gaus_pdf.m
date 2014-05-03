function [y,x] = gaus_pdf(mean,var,nx)

% GAUS_PDF .... Evaluates and plots the probability density function of a
%		Gaussian random variable.
%
%	GAUS_PDF(MEAN,VAR) plots the pdf of the Gaussian random variable with
%		parameters MEAN and VARIANCE.
%	GAUS_PDF(MEAN,VARIANCE,N), where N is a scalar, plots the pdf 
%		evaluated at N bins.
%	GAUS_PDF(MEAN,VARIANCE,X), where X is a vector, plots the pdf 
%		using the bins specified in X.
%	[f,X] = GAUS_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = GAUS_PDF(...) does not draw a graph, but returns vector "f" which
%		contains computed values of the pdf only.
%
%	See also GAUS_CDF,GAUSS,PDF.

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

nx_default = 40;
kp_default = 4.0;

%------------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help gaus_pdf'));
   return;
end   
if (var <= 0)
    error('Variance must be non-negative')
end

%------------------------------------------------------------------------------
%	Set up initial values and other arrays
%------------------------------------------------------------------------------

if (nargin == 2)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = mean - (kp_default)*sqrt(var);
    xmax = mean + (kp_default)*sqrt(var);
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------------
%	Compute the pdf
%------------------------------------------------------------------------------

pdf = (1/sqrt(2*pi*var))*exp(-(nx-mean).^2/(2*var));

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
    grid,                   ...
    axis;                   ...
    title('Gaussian PDF'),  ...
    plot(nx,pdf);
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
