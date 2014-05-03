function [out, seed] = exponent(nsize,mu,seed)

% EXPONENT .... Generates random variates from the Exponential(MU) distribution.
%
%	EXPONENT(N,M) Generates N random variates from the Exponential(MU)
%		distribution with scale parameter MU, such that the CDF is:
%				
%			F(x) =  1 - exp(-x/MU),  x >= 0;
%
%	EXPONENT(N) Generates N random variates from the Exponential(1)
%		distribution.
%	EXPONENT(N,MU,SEED) is the same but starts generating random
%		variates using the value of SEED.
%	[Y, SEED] = EXPONENT(...) will return the current value of SEED for
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
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

%-------------------------------------------------------------------------
%	Check input parameters
%-------------------------------------------------------------------------

if (nargin == 1)
    mu = 1;
elseif (nargin == 2)
    if (mu <= 0), error('parameter "mu" has to be positive.'), end
elseif (nargin == 3)
    rand('seed',seed)
end

%-------------------------------------------------------------------------
%	First generate NSIZE Y = Uniform(0,1) variates.
%	If (  Y )  -->  X = -log(1-Y)
%	   Y  = 1  -->  X = +Inf	
%-------------------------------------------------------------------------

y       =  rand(1,nsize);		
y(y==1) =  Inf*ones(size(y(y==1)));
      x = -log(1-y);

%-------------------------------------------------------------------------
%	Scale output by MU
%-------------------------------------------------------------------------

out = mu*x;
if (nargout == 2), seed = rand('seed'); end
