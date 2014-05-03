function [out] = duob_gen(binary_sequence,duobinary_type,arg1)

% DUOB_GEN ....	Generates waveforms conforming Duobinary or Modified Duobinary
%		type signalling formats.
%
%	DUOB_GEN(B,K) generates a waveform where the binary data sequency B
%		is coded using Duobinary type (K=1), or Modified Duobinary
%		type (K=2) signalling format.  The number of samples in each 
%		block determined by the current values of "sampling frequency"
%		and "binary data rate".
%
%	DUOB_GEN(B,K,Rb) uses the value of Rb for "binary data rate".
%
%	See also DUOBINAR and WAVE_GEN. 

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
global DUOBINARY_BLOCK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help duob_gen'));
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

if ( DUOBINARY_BLOCK ~= 2*floor(DUOBINARY_BLOCK/2) )
   error('Number of blocks set in DUOBINARY_BLOCK has to be even.');
end
if ( any( abs(binary_sequence)-sign(binary_sequence) ) )
   error('Input sequence is not binary')
end
if ((duobinary_type ~= 1) & (duobinary_type ~= 2))
   error('Parameter must be 1(duobinary) or 2(modified duobinary).');
end

%------------------------------------------------------------------------------
%	Generation of samples
%------------------------------------------------------------------------------

no_binary = length(binary_sequence);			    % Number of bits
no_block  = DUOBINARY_BLOCK;				    % Number of blocks
no_sample = Tb/Ts;					    % samples per block
total     = (no_block*no_sample)+((no_binary-1)*no_sample); % Total samples
polar_seq = bin2pol(binary_sequence);   		    % binary --> polar

sum   = zeros(1,total);
index = [1:no_sample*no_block];
pulse = duobinar(duobinary_type,no_block,Rb);

for ii = 1:no_binary
   sum(index) = sum(index) + polar_seq(ii)*pulse;
   index = index + no_sample;
end

out = sum( (no_block/2)*no_sample+1 : (total-(no_block/2-1)*no_sample) );
