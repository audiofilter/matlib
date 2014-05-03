function [fre_out,psd_out] = spect_est(x);

% SPECT_EST ...	Spectral estimation.
%
%	SPECT_EST(X) estimates the power spectral density finction of the
%		input sequence X, without explicitly computing its Fourier 
%		transform.  The input sequence X will be successively fed into
%		a center-frequency adjustable, band-pass filter with user 
%		specified bandwidth.  The frequency interval and the filter
%		bandwidth are interactively specified.
%	
%    	[f,Px] = SPECT_EST(X) returns the mean-square value of the sequence X
%		at the output of a band-pass filter centered at f.

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

%-------------------------------------------------------------------------
%	Check input parameters
%-------------------------------------------------------------------------

if (nargin ~= 1)
   error(eval('eval(BELL),eval(WARNING),help spect_est'));
   return;
end

%------------------------------------------------------------------------------
%	Default values
%------------------------------------------------------------------------------

fs2 = SAMPLING_FREQ/2;
min_fractional_bw = 200/5000;
min_fractional_Hz = min_fractional_bw * fs2;

norm_factor = sqrt( length(x) );

fprintf('------------------------------------------------------------------------\n');
fprintf('FOR SPECTRAL ESTIMATION FREQUENCY RANGE SHOULD BE [ 0, %10.2f ] Hz.\n',fs2);
fprintf('------------------------------------------------------------------------\n');

f_start = input('Enter FREQ_START [Hz] ..... = ');
f_stop = input('Enter FREQ_STOP [Hz] ..... = ');

if ( f_start < 0 )
   fprintf(' WARNING: Start frequency should be non-negative.\n');
   fprintf('          Resetting to 0 Hz.\n');
   f_start = 0;
end

if ( f_stop > fs2 )
   fprintf(' WARNING: Stop frequency must be less than %10.2f Hz.\n',fs2);
   fprintf('          Resetting to %10.2f Hz.\n',fs2);
   f_stop = fs2;
end

bw      = input('Enter bandwidth for BPF [Hz] ........................... = ');

if ( bw < 0 )
   error('BPF Bandwidth must be positive.');
end
if ( bw < min_fractional_Hz )
   fprintf(' WARNING: BPF bandwidth must be larger than %8.2f Hz;\n',min_fractional_Hz);
   fprintf('          otherwise the BPF will be unstable.\n');
   fprintf('          Resetting BPF bandwidth to %10.2f Hz.\n',min_fractional_Hz);
   bw = min_fractional_Hz;
end
disp('')

freq_length = f_stop - f_start;
no_bpf      = fix(freq_length/bw);

if ( no_bpf <= 0 )
   error('FREQ_START, FREQ_STOP, and BANDWIDTH values are not compatible.');
end

range = [f_start, f_start+bw];

for k = 1:no_bpf

    if ( min(range) == 0 )				 % LOW-PASS FILTER'
      range_true = max(range);
      f(k) = sum(range)/2;
      range_true = range_true/fs2;
      [b a] = butter(6,range_true);
      y(k) = meansq(filter(b,a,x))/norm_factor;
    elseif ( max(range) == fs2 )			 % HIGH-PASS FILTER
      range_true = min(range);
      f(k) = sum(range)/2;
      range_true = range_true/fs2;
      [b a] = butter(6,range_true,'high');
      y(k) = meansq(filter(b,a,x))/norm_factor;
    else						 % BAND-PASS FILTER
      f(k) = sum(range)/2;
      range_true = range/fs2;
      [b a] = butter(6,range_true);
      y(k) = meansq(filter(b,a,x))/norm_factor;
    end

    range = range + bw;

    fprintf(' o PSD estimate at %10.2f [Hz] is %10.2e [W].\n',f(k),y(k));

end

disp('')
disp('SPECTRAL ESTIMATION process is complete');
input('Hit any key to display the estimated magnitude spectrum.  ');

semilogy(f/1000,y), xlabel('Frequency [kHz]'); ylabel('Power [W]'); 

if (nargout ~= 0)
   freq_out = f;
   psd_out  = y;
end
