function acf_plot(Rxx,arg1)

% ACF_PLOT ..... Plot the autocorrelation function from ACF.
%
%	ACF_PLOT(Rxx) plots the autocorrelation function Rxx using normalized 
%		sampling period, Ts = 1.
%
%	ACF_PLOT(Rxx,LAG) plots the acf Rxx defined at the points LAG.
%
%	See also ACF.

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
global BELL;
global WARNING;
gset nokey ; % MODIF. OCTAVE

check;

if ( (nargin ~= 1) & (nargin ~= 2) )
   error(eval('eval(BELL),eval(WARNING),help acf_plot'));
   return;
elseif (nargin == 1)
   [n,m] = size(Rxx);
   lag_no = (n-1)/2;
   t = (-lag_no:lag_no)*(1/SAMPLING_FREQ);
elseif (nargin == 2)
   t = arg1;
end

title('Rxx'),         ...
xlabel('Time [sec]'), ...
grid,                 ...
plot(t,Rxx);
