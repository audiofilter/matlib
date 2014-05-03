function [nyquist_pulse] = nyquist_(alpha,nyq_block,arg1)

% NYQUIST_ .....	Defines a basic truncated Nyquist pulse.
%
%	NYQUIST_(A,NB) generates a Nyquist pulse g(t) truncated to NB blocks 
%		with the number of samples in each block determined by the 
%		current values of "sampling frequency" and "binary data rate".
%		The "roll-off" factor is set to A:
%
%				      cos( 2*pi*(1/2Tb)*A*t )
%		g(t) = sinc(t/Tb) * -----------------------------.
%				      1 - [ 4*(1/2Tb)*A*t ]^2
%
%	NYQUIST_(A,NB,Rb) uses the value of Rb for "binary data rate".
% 
%	See also NYQ_GEN, WAVE_GEN.

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
%	o   Changed name to NYQUIST_ due to conflict with control lab
%		function NYQUIST  01.29.1992 - MZ
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global CARRIER_FREQUENCY;
global NYQUIST_BLOCK;
global NYQUIST_ALPHA;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help nyquist_'));
   return;
elseif (nargin == 2)
   Rb = BINARY_DATA_RATE;
elseif (nargin == 3)
   Rb = arg1;
   SAMPLING_FREQ    = SAMPLING_CONSTANT*Rb;	%  Change sampling frequency;
   BINARY_DATA_RATE = Rb; 			%  Reset global variable
end

Tb = 1/BINARY_DATA_RATE;
Ts = 1/SAMPLING_FREQ;

%------------------------------------------------------------------------------
%	Input consistency control
%------------------------------------------------------------------------------

if ( (alpha < 0) | (alpha > 1) )
   error('Roll-off factor must be in the interval [0,1]');
end

%------------------------------------------------------------------------------
%	Generation of samples
%------------------------------------------------------------------------------
%
%	First define required parameters
%
%------------------------------------------------------------------------------

no_samples_per_block = Tb/Ts;
no_total_samples     = nyq_block * no_samples_per_block;
Bo   = 1/(2*Tb);					% Nyquist bandwidth
beta = alpha*Bo;					% Excess bandwidth
time_index = Ts * [-(no_total_samples/2):(no_total_samples/2 - 1)];

%------------------------------------------------------------------------------
%	Let us first take care of those points where (1-(4*beta*t)^2) = 0
%	Note that at these points the value of PULSE = (pi/4).
%------------------------------------------------------------------------------
%	Here PULSE = [cos(2*pi*beta*t)/(1-(4*beta*t)^2)]
%------------------------------------------------------------------------------

trouble_index = (abs(4*beta*time_index) == 1);
ok_index      = ~trouble_index;
trouble_value = pi/4;
pulse         = trouble_value*ones(size(time_index));

%------------------------------------------------------------------------------
%	Evaluate the value of PULSE at the remaining points in OK_INDEX
%	and then perform a point-by-point multiplication with SINC
%------------------------------------------------------------------------------

pulse(ok_index) = cos(2*pi*beta*time_index(ok_index)) ./  ...
                  (1-(4*beta*time_index(ok_index)).^2);
g = sinc(2*Bo*time_index) .*  pulse;

nyquist_pulse=[g(2:length(g)) 0];
