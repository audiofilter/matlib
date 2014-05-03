function out = MU_INV(in,mu)

% MU_INV ....... Mu-law expansion
%
%	MU_INV(X) generates an expanded sequence from the input sequence X.
%		The expansion characteristic is determined by the North
%		American standard "mu-law" with parameter MU = 255.
%
%	MU_INV(X,MU) generates a "mu-law" expanded sequence with parameter
%		MU.  Parameter MU has to be a non-negative.  
%		If Y = MU_INV( MU_LAW(X,MU), MU), then Y = X.
%
%	See also MU_LAW, QUANTIZE.

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
%	Input parameter control	
%------------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help mu_inv'));
   return;
end   
if (nargin == 1)
   mu = 255;
else
   if (mu < 0)
      error('The value of the "mu" parameter has to non-negative')
   elseif (mu == 0)
      out = in;
      return
   end
end

%------------------------------------------------------------------------------
%	Set initial parameters and variables.
%------------------------------------------------------------------------------

k = log(1 + mu);
out = zeros(length(in),1);

%------------------------------------------------------------------------------
%	Generate the output sequence OUT by expanding input sequence IN
%------------------------------------------------------------------------------

out(in>=0) =  (exp(    in(in>=0)*k)  - 1)/mu;
out(in< 0) = -(exp(abs(in(in< 0)*k)) - 1)/mu;

out = out(:).';			% output is a row vector.
