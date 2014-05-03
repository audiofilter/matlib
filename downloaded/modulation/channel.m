function [out, t] = channel(x,gain,noise_power,f,seed)

% CHANNEL ..... Defines a communications channel and generates the channel
%		output for a given input sequence.
%
%	[Y] = CHANNEL(X,GAIN,NOISE_POWER,BANDWIDTH) generates the
%		sequence Y from the input sequence X based on a transmission
%		channel with frequency response H(f):
%						       Noise
%							 |
%				+-----------+		 v
%		   X  --------->|    H(f)   |----------- + ---->  Y
%				+-----------+
%		where      2
%		     |H(f)|  =  {  GAIN,   |f| in BANDWIDTH;
%		                (  0,	   otherwise.
%		    arg(H(f) =  -2*pi*f,   |f| in BANDWIDTH.
%
%		If BANDWIDTH = [f_cutoff] then channel is low-pass type, and
%		if BANDWIDTH = [fl, fu] then channel is band-pass type.
%		The channel noise is Gaussian(0,NOISE_POWER).
%
%	CHANNEL(...) with no output arguments displays the magnitude and
%		phase response functions of H(f).

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
%	o	Eliminated input parameter for DELAY - 05.25.91 - MZ
%	o	Changed error messages for fc and fu - 06.04.91 - MZ
%	o	Added "checking"                       11.30.92 - MZ
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
%	Default values for parameters used in filter design
%----------------------------------------------------------------------------
if (nargin == 5)
   randn('seed',seed);
end

ripple     = 0.1;			% Allowable ripple, in decibels
filt_order = 8;				% Filter order
fpoints    = 256;			% Used to display channel response
fs         = SAMPLING_FREQ;		% Sampling frequency;
Ts         = 1/fs;			% Sampling period;
no_sample  = length(x);			% Number of input samples;
time_t     = [0:(no_sample-1)]*Ts;	% instances where the samples defined;
if (gain < 0), error('GAIN must be a non-negative parameter.'); end

%----------------------------------------------------------------------------
%	set the cut-off frequencies, and check consistency
%----------------------------------------------------------------------------

if (length(f) == 1) 				% Low-pass type channel
   fc = f;
   passband = [fc]/(fs/2); 
   if ( fc > fs/2 )
      fprintf('Cut-off frequency must be less than %6.2f [kHz].\n', fs/2000 ); 
      error('');
   end
elseif (length(f) == 2)  			% Band-pass type channel
   fl = min(f); fu = max(f);
   passband = [fl, fu]/(fs/2);
   if ( fu >= fs/2 )
      fprintf(...
      'Upper cut-off frequency must be less than %6.2f [kHz].\n', fs/2000 ); 
      error('');
   end
end

%----------------------------------------------------------------------------
%	Determine & modify filter coefficients 
%----------------------------------------------------------------------------

Td      = 0;	% To simplify let delay time Td=0, you can modify by adding
		% Td as the last argument to CHANNEL function.
[Bc,Ac] = cheby1(filt_order, ripple, passband);
delay   = fix(Td/Ts);				% required time delay
Bc      = [zeros(1,delay) Bc];			% modify numerator for "delay"
Bc      = sqrt(gain) * Bc;			% modify numerator for "gain"
x       = [x(:)' zeros(1,delay)];

%----------------------------------------------------------------------------
%				Output routines
%				===============
%	If no output arguments, plot the magnitude response, otherwise
%	compute the channel output vector "y"
%----------------------------------------------------------------------------

if (nargout == 0)

   f     = fs/(2*fpoints) * (0:fpoints-1);
   Hc    = freqz(Bc,Ac,fpoints);
   mag   = abs(Hc);
   phase = angle(Hc);

   title('Magnitude response'),          	 ...
   xlabel('Frequency (Hz)'),                     ...
   ylabel('Mag [dB]'), grid;                     ...
   subplot(121), plot( f, 20*log10(mag) );

   title('Phase response'),              	 ...
   xlabel('Frequency (Hz)'),                     ... 
   ylabel('Phase'), grid;                        ...
   subplot(122), plot( f, unwrap(phase) );

elseif (passband(1)==1)  % fc=fs/2

   r   = randn(size(x));
   out = x + sqrt(noise_power)*r;
   if( nargout == 2), t = time_t; end
   
else

   y   = filter(Bc,Ac,x);
   r   = randn(size(y));
   out = y + sqrt(noise_power)*r;
   if( nargout == 2), t = time_t; end

end
