function  [data_out] = normalize( data_in, arg2 )

% NORMALIZE ...	Normalize the input sequence.	
%
%	NORMALIZE(X,K) normalizes the input sequence X such that |X| <= K.
%	NORMALIZE(X) uses the scaling factor K = 1.
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

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help normalize'));
   return;
end   
if (nargin == 1)
   scaling = 1;
else
   scaling = arg2;
end

x = data_in;

%---------------------------------------------------------------------------
%	To prevent overload distortion check for overload conditions
%	and normalize if necessary: |x(n)| <= 1.
%---------------------------------------------------------------------------

x = x / max( abs(max(x)), abs(min(x)) ); 
x = scaling * x;

data_out = x;
