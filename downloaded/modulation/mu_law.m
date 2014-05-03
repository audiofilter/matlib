function out = mu_law(in,mu)

% MU_LAW ....... Mu-law companding
%
%	MU_LAW(X) generates a companded sequence from the input sequence X.
%		The compression characteristic is determined by the North
%		American standard "mu-law" with parameter MU = 255.
%		A typical application of this function would be, to quantize
%		the companded sequence by a subsequent call to the function 
%		QUANTIZE.
%
%	MU_LAW(X,MU) generates a "mu-law" companded sequence with compression
%		parameter MU.  Parameter MU has to be a non-negative.  Note
%		that MU = 0 corresponds to unity transformation.
%
%	See also MU_INV, QUANTIZE.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%============================================================================
% Modifications history:
% ----------------------
%	o Deleted scaling no [-1,1].  06.08.91 -- MZ.
%	o Output is a row vector instead of a column vector. 06.10.91 -- MZ.
%	o Added "checking"  11.30.1992 MZ
%	o Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%============================================================================

global START_OK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Input parameter control	
%------------------------------------------------------------------------------

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help mu_law'));
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
%	Set initial parameters and normalize input sequence if necessary
%------------------------------------------------------------------------------

k = log(1 + mu);
out = zeros(length(in),1);

%------------------------------------------------------------------------------
%	Generate the output sequence OUT by companding input sequence IN
%------------------------------------------------------------------------------

out(in>=0) =  log(1 + mu*in(in>=0))/k;
out(in< 0) = -log(1 + mu*abs(in(in< 0)))/k;

out = out(:).';			% output is a row vector.
