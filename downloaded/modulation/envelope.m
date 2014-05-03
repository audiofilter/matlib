function out = envelope(in,fo)

% ENVELOPE ....	Envelope detector.
%
%	Y = ENVELOPE(X,fo) rectifies the input sequence X using a diode and
%		then low-pass filters the rectified sequence.  The bandwidth
%		of the low-pass filter is set to "fo" Hz.

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
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------
%	Input parameter control
%------------------------------------------------------------------------
if (nargin ~= 2)
   error(eval('eval(BELL),eval(WARNING),help envelope'));
   return;
end   

len = length(in);
%
%   apply the input signal to a diode
%

% y = zeros(len,1);
y = zeros(size(in));   % MODIF. OCTAVE
index = (in>0);
y(index) = in(index);
%
%   the output is fed to the LP filter
%
out = lpf(fo,y);
