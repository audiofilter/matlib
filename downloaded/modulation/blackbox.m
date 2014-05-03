function y = blackbox(x)

% BLACKBOX ...... Generates the output from a "blackbox" representing
%		  some transfer characteristics.
%
%	Y = BLACKBOX(X) will generate the output sequence Y from the
%		input sequence X.
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
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

global SAMPLING_CONSTANT;
global SAMPLING_FREQ;

SAMPLING_FREQ = 10000;
n = 2;
fc = [1500 2500];
[b a] = butter(n,fc*2/SAMPLING_FREQ);
y = filter(b,a,x);
