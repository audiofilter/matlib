function [y,x] = lapl_pdf(sigma2,nx)

% LAPL_PDF .... Evaluates and plots the probability density function of a
%		Laplacian random variable.
%
%	LAPL_PDF(MU) plots the pdf of the Laplacian random variable with
%		variance MU, i.e., Laplace(MU).
%	LAPL_PDF(MU,N), where N is a scalar, plots the pdf evaluated at N bins.
%	LAPL_PDF(MU,X), where X is a vector, plots the pdf using the bins 
%		specified in X.
%	[f,X] = LAPL_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = LAPL_PDF(...) does not draw a graph, but returns vector "f" which
%		contains computed values of the pdf only.
%
%	See also LAPL_CDF,LAPLACE,PDF.

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
   error(eval('eval(BELL),eval(WARNING),help lapl_pdf'));
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
%	Compute the pdf
%------------------------------------------------------------------------------

pdf = (1/(2*mu)) * exp( - abs(nx)/mu );

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
%    if( inquire('axis') == 0), axis([xmin xmax 0 1.5*(1/(2*mu)) ]); end
    axis([xmin xmax 0 1.5*(1/(2*mu)) ]);
    title('Laplacian PDF'), grid;
    plot(nx,pdf);
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
% if( inquire('axis') ~= 0), axis; end
axis;
