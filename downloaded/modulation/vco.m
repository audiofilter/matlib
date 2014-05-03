function [out] = vco(in,arg2,arg3)

% VCO .........	Voltage controlled oscillator.
%
%	VCO(X,fc,Kf)  generates a waveform "sin(theta)"  where the 
%		instantaneous frequency of the waveform at time t is:   
%
%			-Kf * x(t) + fc.
%
%   		Kf is the frequency sensitivity and fc is the free_running 
%		frequency.
%
%	VCO(X) is the same except it uses the default values of fc and Kf, 
%		which are 6000 Hz and -2000 Hz/V, respectively.

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

if ((nargin ~= 1) & (nargin ~= 3))
   error(eval('eval(BELL),eval(WARNING),help vco'));
   return;
end   

Ts = 1/SAMPLING_FREQ;
fc = 6000;
kf = -2000;
if(nargin == 3)
   fc = arg2;
   kf = arg3;
end

%
%   Determine the output phase.
%

%lenfc = ones(length(in),1)*fc;
lenfc = ones(size(in))*fc;    % MODIF. OCTAVE
phase = cumsum((lenfc+in*kf)*Ts*2*pi);
out = cos(phase);
