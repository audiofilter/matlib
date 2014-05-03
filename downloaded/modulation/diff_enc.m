function [out] = diff_enc(in,arg1,arg2)

% DIFF_ENC ....	Differential encoding function for binary sequences.
%
%	[Y] = DIFF_ENC(X,DELAY,INITIAL) generates the output sequence Y from X 
%		such that {Y(n) = X(n) (xor) X(n-DELAY), n = 1,2,...}
%		using initial values in INITIAL for X(0),X(-1),...,X(1-DELAY).
%		If X is the input sequence with N data points, Y will be the
%		differentially encoded sequence with (N+DELAY) data points.
%		The input sequence X must be a binary sequence.
%
%	DIFF_ENC(X,DELAY) encodes the sequence using initial conditions all
%		set to 1.
%
%	DIFF_ENC(X) encodes the sequence X with DELAY=1 and with all initial
%		conditions set to 1.
%
%	See also DIFF_DEC.

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

%------------------------------------------------------------------------------
%	Check input sequence and number of input parameters
%------------------------------------------------------------------------------

if (nargin == 1)
   delay = 1;
   initial = ones(delay,1);
elseif (nargin == 2)
   delay = arg1;
   initial = ones(delay,1);
elseif (nargin == 3)
   delay = arg1;
   initial = arg2;
end
if ( any( abs(in)-sign(in) ) ), error('Input sequence is not binary'), end

%------------------------------------------------------------------------------
%	Set up temporary array "TMP' that includes initial conditions.
%------------------------------------------------------------------------------

in  = in(:);
ns  = length(in);
tmp = [initial(:); ones(ns,1)]'; % MODIF. OCTAVE

%------------------------------------------------------------------------------
%	Now we can start encoding the input sequence.
%------------------------------------------------------------------------------

for n = 1:1:(ns)
    tmp(n+delay) = xor(in(n),tmp(n));
end

out = tmp;
