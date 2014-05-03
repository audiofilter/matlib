function [y,x] = exp_pdf(mu,nx)

% EXP_PDF .....	Evaluates and plots the probability density function of an 
%	   	Exponential random variable.
%
%	EXP_PDF(MU) plots the pdf of the Exponential random variable with
%		scale parameter MU, i.e., Exponential(MU).
%	EXP_PDF(MU,N), where N is a scalar, plots the pdf evaluated at N bins.
%	EXP_PDF(MU,X), where X is a vector, plots the pdf using the bins 
%		specified in X.
%	[f,X] = EXP_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = EXP_PDF(...) does not draw a graph, but returns vector "f" which
%		contains computed values of the pdf only.
%
%	See also EXP_CDF,EXPONENT,PDF.

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
%       o       Modified under OCTAVE 2.0.14 2000.08.12
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
   error(eval('eval(BELL),eval(WARNING),help exp_pdf'));
   return;
end   
if (nargin == 2)
    if (mu <= 0), error('parameter "mu" has to be positive.'); end
end

%------------------------------------------------------------------------------
%	Set up initial values and other arrays
%------------------------------------------------------------------------------

if (nargin == 1)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = 0;
    xmax = mu * log(1/kp_default);
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------------
%	Compute the pdf
%------------------------------------------------------------------------------

pdf = (1/mu) * exp( - (nx/mu) );

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
%    if( inquire('axis') == 0), axis([xmin xmax 0 1.25*(1/mu) ]); end
    axis([xmin xmax 0 1.25*(1/mu) ]); 
    title('Exponential PDF'), grid
    plot(nx,pdf);
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
%if( inquire('axis') ~= 0), axis; end
axis; 
