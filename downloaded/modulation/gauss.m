function [out, seed] = gauss(mean,var,nsize,seed)

% GAUSS ........ Generates random variates from a Gaussian distribution.
%
%	GAUSS(MEAN,VAR,N) Generates N random variates from the Gaussian
%		(normal) distribution such that X ~ Nor(MEAN,VAR) and
%		with the corresponding probability density function:
%
%		f (x) =	1/(sqrt(2*pi*VAR)) * exp(-(x-MEAN)^2/(2*VAR)).
%		 X
%
%	GAUSS(MEAN,VAR,N,SEED) is the same but starts generating random
%		variates using the value of SEED.
%	[Y, SEED] = GAUSS(...) will return the current value of SEED for
%		subsequent calls to the same function.

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

%-------------------------------------------------------------------------
%	Check input parameters
%-------------------------------------------------------------------------

if ((nargin ~= 3) & (nargin ~= 4))
   error(eval('eval(BELL),eval(WARNING),help gauss'));
   return;
elseif (nargin == 4)
   randn('seed',seed);
end
if (var < 0), error('Variance must be non-negative'), end

%-------------------------------------------------------------------------
%	Generate N(0,1) random variates and transform to N(MEAN,VAR)
%	variates using OUT = (sqrt(VAR)*X) + MEAN)
%-------------------------------------------------------------------------

out = sqrt(var)*randn(1,nsize) + mean;
if (nargout == 2), seed = randn('seed'); end
