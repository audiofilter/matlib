function [out] = match(linecode,in)

% MATCH	.......	Creates the "matched" filter structure based on the input
%		pulse shape and determines the output by convolution.
%
%	MATCH(PULSE,X) generates the "matched" filter impulse response based
%		on PULSE and evaluates the output using Y = X * h, where
%		"h" stands for the filter impulse response.  Default values
%		for the "binary data rate" and "sampling frequency" rate are
%		used.  For PULSE the valid entries are the same linecodes
%		used by WAVE_GEN:
%
%		'unipolar_nrz'     'unipolar_rz'     'polar_nrz'
%		'polar_rz'         'bipolar_nrz'     'bipolar_rz'
%		'manchester'       'triangle'        
%
%	MATCH(PULSE) display the impulse response of the matched filter.

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
% 	o	Reduce the output amplitude by a factor of 1/SAMPLING_CONSTANT
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

%----------------------------------------------------------------------------
%	Assign parameter values
%----------------------------------------------------------------------------

if ((nargin ~= 2) & (nargin ~= 1)) 
   error(eval('eval(BELL),eval(WARNING),help match'));
   return;
end

Rb = BINARY_DATA_RATE;
Tb = 1/Rb;
Ts = 1/SAMPLING_FREQ;
fs = 1/Ts;

%----------------------------------------------------------------------------
%	Assign pulse shape based on specified linecode
%----------------------------------------------------------------------------

dig = 1;
if ((strcmp(linecode, 'unipolar_nrz')) | (strcmp(linecode, 'bipolar_nrz')) | ...
    (strcmp(linecode, 'polar_nrz')) | (strcmp(linecode, 'pam')) )
    pulse      = 'rect_nrz(Rb,fs)';  
elseif ((strcmp(linecode,'unipolar_rz')) | (strcmp(linecode,'bipolar_rz')) | ...
    (strcmp(linecode, 'polar_rz')) )
    pulse      = 'rect_rz(Rb,fs)';
elseif  ( strcmp(linecode, 'manchester') )
    pulse      = 'manchest(Rb,fs)'; 
elseif  ( strcmp(linecode, 'triangle') )
    pulse      = 'triangle(Rb,fs)';  dig = 0;
else
	 error('unknown linecode');
end

%----------------------------------------------------------------------------
%	Generate the filter impulse response 
%----------------------------------------------------------------------------

g   = eval(pulse);		% basic pulse shape
h   = g(length(g):-1:1);	% impulse response of the matched filter

%----------------------------------------------------------------------------
%	Output routine:	[output] = [input] * [impulse response]
%----------------------------------------------------------------------------

if(nargin == 1)
    if(dig == 0) h = g; end
    waveplot(h);
else
    out = conv(h,in)*Ts;
    if(size(out,1)==1) out=out'; end  % MODIF. OCTAVE
    out = [out(:)' 0];
end
