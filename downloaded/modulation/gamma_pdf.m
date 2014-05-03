function [y,x] = GAMMA_PDF(aa,bb,nx)

% GAMMA_PDF ... Evaluates and plots the probability density function of a
%		Gamma random variable.
%
%	GAMMA_PDF(P1,P2) plots the pdf of the Gamma random variable with
%		parameters P1 and P2:
%
%		        (   x^(P1)  exp(-x/P2)
%		f (x) = <  --------------------,   x > 0;
%		        (   (P1)! (P2)^(P1+1)
%
%		where P1 > -1 and P2 > 0.
%
%	GAMMA_PDF(P1,P2,N), where N is a scalar, plots the pdf evaluated 
%		at N bins.
%	GAMMA_PDF(P1,P2,X), where X is a vector, plots the pdf using the  
%		bins specified in X.
%	[f,X] = GAMMA_PDF(...) does not draw a graph, but returns vectors
%		f and X such that PLOT(X,f) is the pdf.
%	[f] = GAMMA_PDF(...) does not draw a graph, but returns vector "f" 
%		which contains computed values of the pdf only.

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

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help gamma_pdf'));
   return;
end   
if ( (aa <= -1) | (aa ~= floor(aa)) )
   error('Parameter P1 has to be an integer > -1');
end
if (bb <= 0)
    error('Parameter P2 must be positive')
end

%------------------------------------------------------------------------------
%	Set up initial values and other arrays
%------------------------------------------------------------------------------

if (nargin == 2)
    nx = nx_default;
end
if (length(nx) == 1)
    xmin = 0;
    xmax = (kp_default)*((aa+1)*(bb));
    dx   = (xmax-xmin)/nx;
    nx   = [xmin:dx:xmax];
end

%------------------------------------------------------------------------------
%	Compute the pdf
%------------------------------------------------------------------------------

if ( finite( (gamma(aa+1)*(bb^(aa+1)))) )
   pdf = ( 1/(gamma(aa+1)*(bb^(aa+1))) ) * nx.^aa .* exp(-nx/bb);
else 
   mean_value = (aa+1) * bb;
   pdf = zeros(size(nx));
   index = mean_value/dx+1;
   pdf(index) = 1;
   if (nargout == 0)
      bar(nx,pdf), ...
      title('Gamma PDF'), grid
   end
   return
end

%------------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------------

if (nargout == 0)
    plot(nx,pdf), ...
    title('Gamma PDF'), grid
elseif (nargout == 1)
    y = pdf;
else
    y = pdf;
    x = nx;
end
