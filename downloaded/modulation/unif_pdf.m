function [y,x] = unif_pdf(umin,umax,nx)

% UNIF_PDF .... Evaluates and plots the probability density function of a
%		Uniform random variable.
%
%	UNIF_PDF(A,B)) plots the pdf of the Uniform random variable:
%
%				( 1/(B-A),	A <= x <= B;
%			f (x) = { 
%				(  0,		otherwise.
%		
%	UNIF_PDF(A,B,N), where N is a scalar, plots the pdf evaluated at N bins.
%	UNIF_PDF(A,B,X), where X is a vector, plots the pdf using the bins 
%		specified in X.
%	[f,X] = UNIF_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = UNIF_PDF(...) does not draw a graph, but returns vector "f" which
%		contains computed values of the pdf only.
%
%	See also UNIF_CDF,UNIFORM,PDF.

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
%	o   Changed NX_DEFAULT from 100 to 400, so that misalignment at
%		transition boundaries are better masked........91.08.20. MZ
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

nx_default = 400;
kp_default = 2;

%------------------------------------------------------------------------
%	Check for errors
%------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help unif_pdf'));
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
%	Compute the pdf
%------------------------------------------------------------------------

pdf = (1/(umax-umin))*( (nx >= umin) & (nx <= umax) );

%------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------

if (nargout == 0)
    grid,                                    ...
    axis([xmin xmax 0 1.1*(1/(umax-umin))]); ...
    title('Uniform PDF'),                    ...
    stairs(nx,pdf);
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
