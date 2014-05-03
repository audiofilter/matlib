function [out,t] = wave_gen(binary_sequence,linecode,arg3)

% WAVE_GEN .... Generates a waveform coded in binary signalling formats.
%
%	X = WAVE_GEN(B,LINECODE,Rb) will generate samples of the time 
%		waveform X using LINECODE binary signalling format.  
%		The allowed selections for the LINECODE parameter are:
%
%		'unipolar_nrz'     'unipolar_rz'     'polar_nrz'
%		'polar_rz'         'bipolar_nrz'     'bipolar_rz'
%		'manchester'       'triangle'        'nyquist'
%		'duobinary'	   'mod_duobinary'
%
%		B  : binary input sequence.  
%		Rb : binary data rate specified in Hz, e.g 2000.
%		The pulse amplitude is set to 1 such that any other scaling
%		has to be done externally.
%
%	X = WAVE_GEN(B,LINECODE) is the same but uses the default binary data 
%		rate specified by the variable "BINARY_DATA_RATE".
%	[X,t] = WAVE_GEN(...) returns sampled values of the waveform,
%		where X is the sampled values and "t" is the vector of 
%		time values at 	which the samples in "X" are defined.
%	See alse WAVEPLOT.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
%=========================
%	o Incorporated "SAMPLING_CONSTANT" set during startup - 05.91 - MZ
%	o Eliminated amplitude sacling : Amp = 1; - 05.91 - MZ
%	o Eliminated sampling_period; binary_data_period; - 06.19.91 - MZ
%	o Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

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

no_binary = length(binary_sequence);	%  Number of bits to be coded
no_sample = no_binary * Tb/Ts;		%  Number of samples to be evaluated
time_t    = [0:(no_sample-1)] * Ts;	%  Sampling instances 
binary_sequence = binary_sequence(:);	%  Make sure we have a column vector.
if (size(binary_sequence,1) == 1),      %  MODIF. OCTAVE
  binary_sequence=binary_sequence'; end %  MODIF. OCTAVE

%------------------------------------------------------------------------------
%	Input consistency control
%		i. input sequence must be binary.
%------------------------------------------------------------------------------

if ( ! strcmp(linecode, 'pam') ) % MODIF.
if ( any( abs(binary_sequence)-sign(binary_sequence)) )
   error('Input sequence is not binary')
end
end % MODIF.

%------------------------------------------------------------------------------
%	Now let us determine the basic pulse shapes and amplitude values
%------------------------------------------------------------------------------

if strcmp(linecode, 'pam') % MODIF.

    pulse = 'rect_nrz(Rb,fs)'; 
    b_seq = binary_sequence;

elseif strcmp(linecode, 'unipolar_nrz')

    pulse = 'rect_nrz(Rb,fs)'; 
    b_seq = binary_sequence;

elseif strcmp(linecode, 'unipolar_rz')

    pulse = 'rect_rz(Rb,fs)'; 
    b_seq = binary_sequence;

elseif strcmp(linecode, 'polar_nrz')

    pulse = 'rect_nrz(Rb,fs)'; 
    b_seq = bin2pol(binary_sequence);

elseif strcmp(linecode, 'polar_rz')

    pulse = 'rect_rz(Rb,fs)'; 
    b_seq = bin2pol(binary_sequence);

elseif strcmp(linecode, 'bipolar_nrz')

    pulse = 'rect_nrz(Rb,fs)'; 
    b_seq = bin2bipo(binary_sequence);

elseif strcmp(linecode, 'bipolar_rz')

    pulse = 'rect_rz(Rb,fs)'; 
    b_seq = bin2bipo(binary_sequence);

elseif strcmp(linecode, 'triangle')

    pulse = 'triangle(Rb,fs)'; 
    b_seq = bin2pol(binary_sequence);

elseif strcmp(linecode, 'nyquist')

    out = nyq_gen(binary_sequence,NYQUIST_ALPHA,Rb);
    if (nargout == 2), t = time_t; end
    return

elseif strcmp(linecode, 'duobinary')

    out = duob_gen(binary_sequence,1,Rb);
    if (nargout == 2), t = time_t; end
    return

elseif strcmp(linecode, 'mod_duobinary')

    out = duob_gen(binary_sequence,2,Rb);
    if (nargout == 2), t = time_t; end
    return

elseif strcmp(linecode, 'manchester')

    pulse = 'manchest(Rb,fs)'; 
    b_seq = bin2pol(binary_sequence);

else

    error('Unknown linecode type')

end

%-----------------------------------------------------------------------------%
%				Output routines			              %
%-----------------------------------------------------------------------------%

x   = (b_seq * eval(pulse))';
out = x(:);
if(size(out,2)==1) out=out'; end  % MODIF. OCTAVE
if (nargout == 2), t = time_t; end
