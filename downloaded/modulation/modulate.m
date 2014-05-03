function [out,t] = modulate( binary_seq, mod_type, fc, arg4)

% MODULATE .... Digital modulation of binary signalling formats.
%
%	X = MODULATE(B,TYPE,fc) generates samples of the time waveform X
%		using TYPE digital modulation.
%		Valid selections for the TYPE parameter are:
%
%		'ask'	On-off keying (also known as amplitude shift keying);
%		'psk'	Binary phase shift keying;
%		'fsk'	Frequency shift keying.
%
%		B  : binary input sequence.
%		fc : carrier frequency.  For fsk, fc is [f0 f1] where f0 and f1
%		     are frequencies used two represent a binary "0" and "1".
%
%		Here, the binary data rate is set to the default value.
%
%	X = MODULATE(B,MODULATON,fc,Rb) is the same but uses the binary data 
%		rate Rb instead of the default. 
%
%	[X,t] = MODULATE(...) returns sampled values of the waveform,
%		where X is the sampled values and "t" is the vector of 
%		time values at 	which the samples in "X" are defined.

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
global CARRIER_FREQUENCY;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 3) & (nargin ~= 4))
   error(eval('eval(BELL),eval(WARNING),help modulate'));
   return;
end   
if (nargin == 3)
    Rb = BINARY_DATA_RATE; 		%  Default binary data rate;
elseif (nargin == 4) 
    Rb = arg4; 				%  User specified data rate;
    fs = SAMPLING_CONSTANT*Rb;		%  Change sampling frequency;
    SAMPLING_FREQ      = fs;		%  Reset global variable
    BINARY_DATA_RATE   = Rb; 		%  Reset global variable
end

fs      = SAMPLING_FREQ;		%  Default sampling frequency;
Ts      = 1/fs;				%  Default sampling period
Tb      = 1/Rb;				%  Binary data period;
nbinary = length(binary_seq);		%  Number of bits to be coded
nsample = nbinary * Tb/Ts;		%  Number of samples to be evaluated
time_t  = [0:(nsample-1)] * Ts;		%  Sampling instances 

%------------------------------------------------------------------------------
%	Input consistency control
%		i. input sequence must be binary.
%------------------------------------------------------------------------------

if ( any( abs(binary_seq)-sign(binary_seq) ) )
   error('Input sequence is not binary')
end
if ( max(fc) >= (fs/2) )
   fprintf('Maximum carrier frequency must be less than %6.2f [kHz].\n', ...
   SAMPLING_FREQ/2000); 
   error('');
end
if ( min(fc) <= 0 )
   error('Carrier frequency must be positive.');
end
if ( min(fc) < Rb )
   fprintf('Carrier frequency must be at least equal to %6.2f [kHz].\n', ...
   Rb/1000);
   error('')
end

CARRIER_FREQUENCY = [ min(fc) max(fc) ];	%  Reset global variable

%------------------------------------------------------------------------------
%	Call the appropriate functions for different modulation types
%------------------------------------------------------------------------------

if  strcmp(mod_type, 'ask')
    x = wave_gen(binary_seq,'unipolar_nrz',Rb);
    out = mixer( x, osc(CARRIER_FREQUENCY(1)) );	
elseif  strcmp(mod_type, 'psk')
    x = wave_gen(binary_seq,'polar_nrz',Rb);
    out = mixer( x, osc(CARRIER_FREQUENCY(1)) );	
elseif  strcmp(mod_type, 'fsk')
    x = wave_gen(binary_seq,'polar_nrz',Rb);
    fc1 = CARRIER_FREQUENCY(2);
    fc0 = CARRIER_FREQUENCY(1);
    f_r = (CARRIER_FREQUENCY(2) + CARRIER_FREQUENCY(1))/2;  % vco free run. freq
    kf  = (CARRIER_FREQUENCY(2) - CARRIER_FREQUENCY(1))/2;  % vco freq. sens.
    out = vco(x,f_r,kf);
else
    error('Unknown modulation type');
end

%-----------------------------------------------------------------------------%
%			Output routines			              	      %
%-----------------------------------------------------------------------------%

if (nargout == 2), t = time_t; end
