function [out, seed] = laplace(nsize,sigma2,seed)

% LAPLACE .... Generates random variates from a Laplace(MU) distribution.
%
%	LAPLACE(N,MU) Generates N random variates from the Laplace(MU)
%		distribution with scale parameter "MU" such that 
%		variance(X) = MU and the CDF is given:
%
%				( 1 - (1/2)exp(-x/MU),  x >= 0;
%			F(x) =  <
%				(     (1/2)exp( x/MU),  x <  0.
%
%	LAPLACE(N) Generates N random variates from the Laplace(1)
%		distribution.
%	LAPLACE(N,MU,SEED) is the same but starts generating random
%		variates using the value of SEED.
%	[Y, SEED] = LAPLACE(...) will return the current value of SEED for
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
    if (sigma2 <= 0), error('parameter "mu" has to be positive.'), end
elseif (nargin == 3)
    rand('seed',seed)
end

%-------------------------------------------------------------------------
%	First generate NSIZE Y = Uniform(0,1) variates.
%	If Y  = 0  -->  X = -Inf
%	   Y <=0.5 -->  X =  log(2Y)
%	   Y > 0.5 -->  X = -log(2(1-Y))
%	   Y  = 1  -->  X = +Inf	
%-------------------------------------------------------------------------

y       =  rand(1,nsize);		
y(y==0) = -Inf*ones(size(y(y==0)));
y(y==1) =  Inf*ones(size(y(y==1)));
x = y;
x(y<=0.5) =  log( 2*(  y(y<=0.5)) );
x(y> 0.5) = -log( 2*(1-y(y> 0.5)) );

%-------------------------------------------------------------------------
%	Scale output by MU
%-------------------------------------------------------------------------

out = sqrt(sigma2/2) * x;
if (nargout == 2), seed = rand('seed'); end
