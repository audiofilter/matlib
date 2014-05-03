function out = diff_dec(in,delay)

% DIFF_DEC ....	Differential decoding function.
%
%	[Y] = DIFF_DEC(X,DELAY) generates the output sequence Y from X such that
%		{Y(n) = X(n) (xor) X(n+DELAY), n = 1,2,...}.
%		If X is the input sequence with (N+DELAY) data points, Y will be
%		the differentially decoded sequence with (N) data points.
%		The input sequence X must be a binary sequence.
%
%	DIFF_DEC(X) decodes the sequence using DELAY = 1.
%
%	See also DIFF_ENC.

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
end

if ( any( abs(in)-sign(in) ) ), error('Input sequence is not binary'), end

%------------------------------------------------------------------------------
%	Set up initial parameters
%------------------------------------------------------------------------------

ns = length(in);

%------------------------------------------------------------------------------
%	Now we can start decoding the input sequence.
%------------------------------------------------------------------------------

sequence1 = in(1:(ns-delay));
sequence2 = in((1+delay):ns);
out       = xor(sequence1,sequence2);
