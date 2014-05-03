function  [out] = lpf(fc,in)

% LPF ......... Low-pass filter design and filtering.
%
% 	LPF(Fc) specifies a Chebychev low-pass filter of order N with
%		cut-off frequency Fc, such that  0 < Fc < Fs/2, where
%		Fs is the sampling frequency.  The magnitude and phase
%		response functions are plotted.
%
% 	[Y] = LPF(Fc,X) returns vector Y obtained through low-pass filtering 
%		the input sequence X.
%
% 	See also BPF, FREQZ and FILTER.

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
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

if ((nargin < 1) | (nargin > 2))
   error(eval('eval(BELL),eval(WARNING),help lpf'));
   return;
end

%----------------------------------------------------------------------------
%	set the sampling frequency fs, and check its consistency
%----------------------------------------------------------------------------

fs = SAMPLING_FREQ;			% Default sampling frequency.
if ( fc >= (fs/2) )
   fprintf('Cut-off frequency must be less than %6.2f [kHz].\n', ...
          SAMPLING_FREQ/2000); 
   error('');
end

%----------------------------------------------------------------------------
%	determine filter coefficients
%----------------------------------------------------------------------------

passband   = [fc/(fs/2)];			% Passband specification
ripple     = .1;				% Allowable ripple, in decibels
filt_order = 8;
[Bc,Ac]    = cheby1(filt_order, ripple, passband);

%----------------------------------------------------------------------------
%				Output routines
%				===============
%	If no output arguments, plot the magnitude response, otherwise
%	compute the channel output vector "y"
%----------------------------------------------------------------------------

if (nargin == 1)

   fpts  = 256;
   f     = fs/(2*fpts) * (0:fpts-1);
   Hc    = freqz(Bc,Ac,fpts);
   mag   = abs(Hc);
   phase = angle(Hc);

   title('LPF magnitude response'),              ...
   xlabel('Frequency (Hz)'),                     ...
   ylabel('Mag [dB]'), grid;                     ...
   axis([0 fs/2 -100 0]);                        ...
   subplot(211), plot( f, 20*log10(mag) );

   title('LPF phase response'),                  ...
   xlabel('Frequency (Hz)'),                     ... 
   ylabel('Phase'), grid;                        ...
   axis;                                         ...
   subplot(212), plot( f, unwrap(phase) );

else

   out = filter(Bc,Ac,in);

end
