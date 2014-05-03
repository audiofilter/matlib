function [out,t] = pam(N,face,arg3)

% PAM .... Generates a waveform coded in pam signalling formats.
%
%	X = PAM(N,FACE,Rb) will generate samples of the time 
%		waveform X using PAM signalling format.  
%
%		Rb : binary data rate specified in Hz, e.g 2000.
%		The pulse amplitude is set to 1 such that any other scaling
%		has to be done externally.
%
%	X = PAM(N,FACE) is the same but uses the default binary data 
%		rate specified by the variable "BINARY_DATA_RATE".
%	[X,t] = WAVE_PAM(...) returns sampled values of the waveform,
%		where X is the sampled values and "t" is the vector of 
%		time values at 	which the samples in "X" are defined.
%	See alse WAVEPLOT.

%	AUTHOR : F. Arguello
%             Department of Electronic & Computer Science
%             Santiago University
%             Santiago de Compostela, SPAIN
%
%	DATE    : August 2000.
%	VERSION : 1.0
%       TESTED  : under OCTAVE 2.0.14 2000.08.12


global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global CARRIER_FREQUENCY;
global NYQUIST_BLOCK;
global NYQUIST_ALPHA;
global DUOBINARY_BLOCK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help wave_gen'));
   return;
end   
if (nargin == 2), 			%  Default binary data rate;
    Rb = BINARY_DATA_RATE; 
    fs = SAMPLING_FREQ;			%  Default sampling frequency;
end
if (nargin == 3), 			%  User specified data rate;
    Rb = arg3; 
    fs = SAMPLING_CONSTANT*Rb;		%  Change sampling frequency;
    SAMPLING_FREQ      = fs;			%  Reset global variable
    BINARY_DATA_RATE   = Rb; 			%  Reset global variable
end

Ts = 1/fs;				%  Sampling period
Tb = 1/Rb;				%  Binary data period;

dice=ceil(rand([1 N])*face);
% pam_sequence=2*dice(N,face)-face-1;
pam_sequence=2*dice-face-1;
no_binary = length(pam_sequence);	%  Number of bits to be coded
no_sample = no_binary * Tb/Ts;		%  Number of samples to be evaluated
time_t    = [0:(no_sample-1)] * Ts;	%  Sampling instances 
pam_sequence = pam_sequence(:);	%  Make sure we have a column vector.
if (size(pam_sequence,1) == 1),      %  MODIF. OCTAVE
  pam_sequence=pam_sequence'; end    %  MODIF. OCTAVE

%------------------------------------------------------------------------------
%	Now let us determine the basic pulse shapes and amplitude values
%------------------------------------------------------------------------------

    pulse = 'rect_nrz(Rb,fs)'; 
    b_seq = pam_sequence;

%-----------------------------------------------------------------------------%
%				Output routines			              %
%-----------------------------------------------------------------------------%

x   = (b_seq * eval(pulse))';
out = x(:);
if (size(out,2) == 1), out=out'; end  % MODIF. OCTAVE
if (nargout == 2), t = time_t; end
