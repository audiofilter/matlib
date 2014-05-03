function [out] = int_dump(in);

% INT_DUMP ....	Integrate and Dump receiver.
%
%       Y = INT_DUMP(X) integrates the input sequence X over one bit period
%		and then dumps the value to the output, i.e., resets the
%		integrator.

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
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

%---------------------------------------------------------------------------
%	Check input parameters
%---------------------------------------------------------------------------

if (nargin ~= 1)
   error(eval('eval(BELL),eval(WARNING),help int_dump'));
   return;
end

np     = SAMPLING_CONSTANT;
no_bit = length(in)/np;
index  = [1:np];
rc     = 0.0025;
[b a]  = butter(1,rc);

out(index) = filter(b,a,in(index));

for k=2:no_bit
  index = index + np;
  out(index) = filter(b,a,in(index));
end
