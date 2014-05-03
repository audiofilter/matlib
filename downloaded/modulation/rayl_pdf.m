function [y,x] = rayl_pdf(aa,nx)

% RAYL_PDF .... Evaluates and plots the probability density function of a
%		Rayleigh random variable.
%
%	RAYL_PDF(MU) plots the pdf of the Rayleigh random variable with 
%		scale parameter MU, i.e., Rayleigh(MU).
%	RAYL_PDF(MU,N), where N is a scalar, plots the pdf evaluated at N bins.
%	RAYL_PDF(MU,X), where X is a vector, plots the pdf using the bins 
%		specified in X.
%	[f,X] = RAYL_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = RAYL_PDF(...) does not draw a graph, but returns vector "f" which
%		contains computed values of the pdf only.
%
%	See also RAYL_CDF,RAYLEIGH,PDF.

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
   error(eval('eval(BELL),eval(WARNING),help rayl_pdf'));
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
%	Compute the pdf
%------------------------------------------------------------------------------

pdf = aa * nx .* exp(-aa*(nx.^2)/2);

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
    title('Rayleigh PDF'), grid
    plot(nx,pdf), ...
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
