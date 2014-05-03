function  [out] = speech( nsize, seed )

% SPEECH ......	Geenrates a random sampled sequence representing voiced segment 
%		of speech signals.
%
%	SPEECH( N ) generates N samples from such a sequence.
%	SPEECH( N, SEED ) uses the value of SEED to initialize the random number
%		generator.  The function SPEECH serves as a simple front-end for
%		the function CORR_SEQ.
%
%	See also CORR_SEQ.
%

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

if (nargin ~= 1) & (nargin ~= 2)
   error(eval('eval(BELL),eval(WARNING),help speech'));
   return;
end   
if (nsize < 1) | (nsize > 2000)
   error( ...
   'Number of samples must be a positive integer in the interval [1,2000].');
end
nn = ceil(nsize);
if (nargin == 1 )
   out = corr_seq(-0.95,nn,1,0);
elseif (nargin == 2 )
   out = corr_seq(-0.95,nn,1,0,seed);
end

out = normalize(out,1);
