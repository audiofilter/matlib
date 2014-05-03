function out = manchest(arg1,arg2)

% MANCHEST .... Generates the pulse for the "Manchester" linecode.
%
%			+=======+           +1
%			|       |       
%			+       +=======+   -1
%
%		--------+-------+-------+-----------> time
%			0      Tb/2     Tb   
%
%		There will be "SAMPLING_CONSTANT" samples to represent this 
%		pulse shape.  This function is used by the M-function WAVE_GEN.	

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

if (nargin == 0)
   Rb = BINARY_DATA_RATE;
   fs = SAMPLING_FREQ;
elseif (nargin == 1)
   Rb = arg1;
   fs = SAMPLING_FREQ;
elseif (nargin == 2)
   Rb = arg1;
   fs = arg2;
end

Tb = 1/Rb;
Ts = 1/fs;
no_sample = Tb/Ts;
no_middle = no_sample./2;
out       = ones(1,no_sample);
out((no_middle + 1):(no_sample)) = -ones(1,(no_sample-no_middle));
