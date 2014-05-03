function [out] = tx( in_binary, flag_type, arg3, arg4, arg5)

% TX ..........	Transmitter function.
%
%	TX(B,LINECODE) will generates samples of the waveform for baseband 
%		transmission in LINECODE binary signalling format using default
%		value for Rb.  Allowed choices for the LINECODE parameter are:
%		--------------------
%		'unipolar_nrz'  'unipolar_rz'  'polar_nrz'   'polar_rz'
%		'bipolar_nrz'   'bipolar_rz'   'manchester'  'triangle'        
%
%	TX(B,MODULATION,fc) generates samples of a band-pass waveform using 
%		MODULATION type digital modulation with fc representing 
%		carrier frequency.  For FSK, fc must be of the form [f0 f1]. 
%		Allowed choices for the MODULATION parameter are:
%		----------------------
%		'ask'		'psk'          'fsk'
%
%		B    : binary input sequence. 
%
%		There are two optional flags that specify:
%		Rb   : binary data rate (default=BINARY_DATA_RATE) ;
%		FLAG : if FLAG = 'no_diff" no differential encoding (default),
%		       if FLAG = 'diff' differential encoding is used.
%
%	See alse WAVE_GEN, MODULATE, DIFF_ENC.

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

%------------------------------------------------------------------------------
%	Check input parameters and assign function parameters.
%------------------------------------------------------------------------------
if ( (nargin ~= 2) & (nargin ~= 3) & (nargin ~= 4) & (nargin ~= 5) )
   error(eval('eval(BELL),eval(WARNING),help tx'));
   return;
end
flag_diff = 'no_diff';
Rb = BINARY_DATA_RATE;

if (strcmp(flag_type,'ask') | strcmp(flag_type,'psk') | strcmp(flag_type,'fsk'))

   signal_type = 'band_pass';
   if ( nargin == 3 )
      fc = arg3;
   elseif ( nargin == 4 )
      fc = arg3;
      if (isstr(arg4))
         flag_diff = arg4;
      else
         Rb = arg4;
      end
   elseif ( nargin == 5 )
      fc = arg3;
      if (isstr(arg4))
         flag_diff = arg4;
      else
         Rb = arg4;
      end
      if (isstr(arg5))
         flag_diff = arg5;
      else
         Rb = arg5;
      end
   else
      error('Band-pass Signalling: not sufficient input arguments');
   end
   
else

   signal_type = 'baseband';
   if ( nargin == 2 )
      %
      % everything is o.k.
      %
   elseif ( nargin == 3 )
      if (isstr(arg3))
         flag_diff = arg3;
      else
         Rb = arg3;
      end
   elseif ( nargin == 4 )
      if (isstr(arg3))
         flag_diff = arg3;
      else
         Rb = arg3;
      end
      if (isstr(arg4))
         flag_diff = arg4;
      else
         Rb = arg4;
      end
   else
      error('Baseband signalling: insufficient input parameters.');
   end
end

fs = SAMPLING_CONSTANT*Rb;		%  Change sampling frequency;
SAMPLING_FREQ      = fs;		%  Reset global variable
BINARY_DATA_RATE   = Rb; 		%  Reset global variable

%------------------------------------------------------------------------------
%	[1].  Check whether we need differential encoding
%------------------------------------------------------------------------------

fprintf('\no PERFORMING CHANNEL CODING : \n');

if (strcmp(flag_diff,'no_diff'))
   x_binary = in_binary;
elseif (strcmp(flag_diff,'diff'))
   fprintf('\t Differential encoding;\n');
   x_binary = diff_enc(in_binary);
   fprintf('\t\t Differential encoding complete;\n');
else
   error('Unknown request');
end

%------------------------------------------------------------------------------
%	[2].  Let us generate the waveform
%------------------------------------------------------------------------------

fprintf('\t Generating waveform in the selected format;\n');
if (strcmp(signal_type, 'band_pass'))
   out = modulate( x_binary, flag_type, fc, Rb);
elseif (strcmp(signal_type, 'baseband'))
   out = wave_gen( x_binary, flag_type, Rb);
end

fprintf('\t Channel coding complete.\n');
