function [out, seed] = binary(nsize,seed)

% BINARY ...... Generates a sequence of random binary digits.
%
%	BINARY(N) Generates N random binary digits, such that the  output
%		sequence is either "0" or "1" with equal probability.
%	BINARY(N,SEED) is the same but starts generating random variates 
%		using the value of SEED.
%	[Y, SEED] = BINARY(...) will return the current value of SEED for
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

if (nargin == 2)
    rand('seed',seed)
end

%-------------------------------------------------------------------------
%	Generate NSIZE uniform random variates and transform into binary
%-------------------------------------------------------------------------

r     = rand(1,nsize);
out   = ones(size(r));
index = (r<0.5);

out(index) = zeros( length( r(index) ), 1 );

%-------------------------------------------------------------------------
%	Output routines
%-------------------------------------------------------------------------

if (nargout == 2)
    seed = rand('seed');
end
