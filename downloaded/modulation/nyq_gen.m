function [out] = nyq_gen(binary_sequence,alpha,arg1)

% NYQ_GEN .....	Binary data representation using Nyquist pulse shape.
%
%	NYQ_GEN(B,ALPHA) generates a waveform where the binary data sequency B
%		is coded using Nyquist pulse shape for each bit. 
%		The "roll-off" factor (excess bandwidth factor) is set to 
%		ALPHA such that 0 <= ALPHA < = 1.
%		Number of samples in each block determined by the current
%		values of "sampling frequency" and "binary data rate".
%
%	NYQ_GEN(B,ALPHA,Rb) uses the value of Rb "binary data rate".
%
%	See also NYQUIST_ and WAVE_GEN 

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
%	o   Changed NYQUIST to NYQUIST_ due to conflict with control 
%		lab function NYQUIST 01.29.1992 - MZ
%	o   Added "checking"  11.30.1992 - MZ
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
   error(eval('eval(BELL),eval(WARNING),help nyq_gen'));
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
if ( NYQUIST_BLOCK ~= 2*floor(NYQUIST_BLOCK/2) )
   error('Number of blocks set in NYQUIST_BLOCK has to be even.');
end
if ( any( abs(binary_sequence)-sign(binary_sequence) ) )
   error('Input sequence is not binary')
end

%------------------------------------------------------------------------------
%	Generation of samples
%------------------------------------------------------------------------------

no_binary = length(binary_sequence);			    % Number of bits
no_block  = NYQUIST_BLOCK;				    % Number of blocks
no_sample = Tb/Ts;					    % samples per block
total     = (no_block*no_sample)+((no_binary-1)*no_sample); % Total samples
polar_seq = bin2pol(binary_sequence);   		    % binary --> polar

sum   = zeros(1,total);
index = [1:no_sample*no_block];
pulse = nyquist_(alpha,NYQUIST_BLOCK,Rb);

for ii = 1:no_binary
   sum(index) = sum(index) + polar_seq(ii)*pulse;
   index = index + no_sample;
end

out = sum( (no_block/2)*no_sample+1 : (total-(no_block/2-1)*no_sample) );
