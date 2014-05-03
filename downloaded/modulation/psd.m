function [Sxx] = psd(x,arg2,arg3)

% PSD ......... Power spectrum of the input data sequence.
%
%	PSD(X,M,FRANGE) performs FFT analysis of the sequence X using the 
%		Welch method of power spectrum estimation. The X sequence 
%		of N points is divided into K sections of M points each.  
%		Using an M-point FFT, successive sections are windowed, 
%		FFT'd and accumulated.  The resulting power spectrum is
%		plotted over the frequency interval FRANGE = [f1, f2].
%		The interval FRANGE will be restricted to [0,fs/2], where 
%		"fs" is the sampling frequency.  The function PSD_PLOT is
%		used to plot the power spectrum of X.
%
%		REMARK: The parameters M and FRANGE can be specified in any
%			order or even completely omitted.  For example PSD(X)
%			will display the PSD of X over [0, fs/2] where the FFT 
%			size is determined by the number of elements in X.
%
%	Pxx = PSD(X,M) returns the ((M/2)-1) by 1 array Pxx, where Pxx is 
%		the X-vector power spectral density.
%
%		The units on the power spectrum Pxx are such that, using
%		Parseval's theorem,  SUM(X.^2)/M = SUM(Pxx).   
%		The RMS value of the signal is the square root of this.  
%		For example, a pure sine wave with amplitude A has an RMS value
%		of A/sqrt(2), so A = SQRT(SUM(Pxx)*2).
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

if ((nargin ~= 1) & (nargin ~= 2) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help psd'));
   return;
end   


x=x(:);                         % Make sure x and y are column vectors
if(size(x,1)==1) x=x'; end	% MODIF. OCTAVE
n = length(x);			% Number of data points
f_range = [0 SAMPLING_FREQ/2];	% Default frequency range for plotting

%-------------------------------------------------------------------------------
%	Check the consistency of the input parameters
%	and set the FFT size to a power of 2
%-------------------------------------------------------------------------------

if (nargin == 1) 
   m = n;
elseif (nargin == 2) 
   if (length(arg2) == 1)
      m = arg2;			% second argument specifies block size
   else
      f_range = arg2;		% second argument is display range
      m = n;
   end
elseif (nargin == 3) 
   if (length(arg2) == 1)
      m = arg2;
   else
      f_range = arg2;
   end
   if (length(arg3) == 1)
      m = arg3;
   else
      f_range = arg3;
   end
end
   
if (m <= 0)
   error('Block size has to be non-negative')
elseif (m <= 8192)
   fsize = fftsize(m); 
else
   fsize = 1024;
end

%-------------------------------------------------------------------------------
%	Determine the number of windows, normalizing factor and window function
%-------------------------------------------------------------------------------

m = min(fsize,n);
k = fix(n/m);			% Number of windows

index = 1:m;

w   = ones(fsize,1);		% Window specification; change this if you want:
KMU = k*fsize*norm(w)^2/2;	% Normalizing scale factor

Pxx = zeros(fsize,1); 

%-------------------------------------------------------------------------------
%	Start processing and accumulating results
%-------------------------------------------------------------------------------

for i=1:k
     xw    = w.*[detrend(x(index));zeros(fsize-m,1)];
     index = index + m;
     Xx    = abs(fft(xw,fsize)).^2;
     Pxx   = Pxx + Xx;
end

P = Pxx([2:(fsize/2+1)])/KMU; 	% Select first half and eliminate DC value

%-------------------------------------------------------------------------------
%	Output routines
%-------------------------------------------------------------------------------

if( nargout == 0), psd_plot(P,f_range); end
if( nargout == 1), 
    Sxx = P; 
    if(size(Sxx,2)==1) Sxx=Sxx'; end  % MODIF. OCTAVE
end

return
