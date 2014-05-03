function  [out] = bpf(f1,f2,in)

% BPF ......... Band-pass filter design and filtering of the input sequence.
%
% 	BPF(F1,F2) specifies a Chebychev band-pass filter with lower cut-off 
%		frequency = min(F1,F2) and upper cut-off frequency = max(F1,F2).
%		Here, 0 < F1, F2 < Fs/2, where Fs is the sampling frequency.
%		Magnitude and phase responses are plotted.
%
% 	[Y] = BPF(F1,F2,X) returns vector Y obtained through band-pass 
%		filtering the input sequence X.
%
% 	See also LPF, FREQZ and FILTER.

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

if ((nargin < 2) | (nargin > 3))
   error(eval('eval(BELL),eval(WARNING),help bpf'));
   return;
end

%----------------------------------------------------------------------------
%	set the sampling frequency fs, lower cut-off frequency fl, and
%	the upper cut-off frequency fu.
%----------------------------------------------------------------------------

fs = SAMPLING_FREQ;			% Default sampling frequency.
fl = min(f1,f2);
fu = max(f1,f2);

%----------------------------------------------------------------------------
%	check the consistency of fl, fu and fs.
%----------------------------------------------------------------------------

if ( fl < 0 )
   error('Lower cut-off frequency must be positive')
end
if ( fu >= fs/2 )
   fprintf('Upper cut-off frequency must be less than %6.2f [kHz].\n',SAMPLING_FREQ/2000); 
   error('');
end

%----------------------------------------------------------------------------
%	determine filter coefficients
%----------------------------------------------------------------------------

passband   = [fl/(fs/2) fu/(fs/2)];		% Passband specification
ripple     = .1;				% Allowable ripple, in decibels
filt_order = 8;
[Bc,Ac]    = cheby1(filt_order, ripple, passband);

%----------------------------------------------------------------------------
%				Output routines
%				===============
%	If no output arguments, plot the magnitude response, otherwise
%	compute the channel output vector "y"
%----------------------------------------------------------------------------

if (nargin == 2)

   fpts  = 256;
   f     = fs/(2*fpts) * (0:fpts-1);
   Hc    = freqz(Bc,Ac,fpts);
   mag   = abs(Hc);
   phase = angle(Hc);

   title('BPF magnitude response'), 		 ...
   xlabel('Frequency (Hz)'),                     ...
   ylabel('Mag [dB]'), grid;                     ...
   axis([0 fs/2 -100 0]);                        ...
   subplot(211), plot( f, 20*log10(mag) );

   title('BPF phase response'),     		 ...
   xlabel('Frequency (Hz)'),                     ... 
   ylabel('Phase'), grid;                        ...
   axis;                                         ...
   subplot(212), plot( f, unwrap(phase) );

else

   out = filter(Bc,Ac,in);

end
