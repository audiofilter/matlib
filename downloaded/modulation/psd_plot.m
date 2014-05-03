function psd_plot(Px,arg1)

% PSD_PLOT ..... Plot the output of the PSD function.
%
%	PSD_PLOT(Pxx) plots the power spectral density Pxx.
%
%	PSD_PLOT(Pxx,[f_start,f_stop]) plots Pxx over the frequency interval
%	  	[f_start, f_stop] such that 0 <= f_start < f_stop <= (fs/2),
%		where "fs" is the sampling frequency.
%

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

if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help psd_plot'));
   return;
end   

[n,m] = size(Px);
Fs    = SAMPLING_FREQ;			% Default sampling frequency.
fmax_default = Fs/2;

if (nargin == 1)

   f = (1:n)/n*(Fs/2);

elseif (nargin == 2)

   Frange = arg1(:);
   if(size(Frange,1)==1) Frange=Frange'; end   % MODIF. OCTAVE

   if (Frange(1) >= Frange(2)),error('f_start >= f_stop'),end
   if (Frange(1) < 0), error('f_start < 0'),end
   if (Frange(2) > Fs/2 ),error('f_stop > f_sampling/2'),end

   bin1 = max(1,round(Frange(1)/(Fs/2) * n ));
   bin2 = min(n,round(Frange(2)/(Fs/2) * n ));
   f = (bin1:bin2)/n*(Fs/2);
   Px = Px(bin1:bin2);

end

% x =  f( f <= fmax_default )/1000;
% y = Px( f <= fmax_default );
index= f <= fmax_default;                   % MODIF. OCTAVE
index= [ index 0]; f= [f 0];  Px= [Px ; 0]; % MODIF. OCTAVE
x =  f( index )/1000;                       % MODIF. OCTAVE
y = Px( index );                            % MODIF. OCTAVE

axis;                       ... 
title('PSD Function'),      ...
xlabel('Frequency [kHz]'),  ...
ylabel('Power [W]'),        ...
grid,                       ...
semilogy(x,y);
