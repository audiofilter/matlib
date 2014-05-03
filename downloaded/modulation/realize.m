function x = realize(range)

% REALIZE .....	Generates all realizations (sample functions) of the random
%		process X(t) =  cos(2*pi*1000*t + THETA).
%
%	X = REALIZE([a1,a2,...]) uses the values {a1,a2,...} to generate 
%		discrete valued uniformly distributed random variable THETA.
%		For example, if the input parameter is [0 pi/2 pi], then
%		THETA takes the values 0, pi/2, pi with equal probability.
%
%     		X(n,t) represents the nth sample function at time t = 0,1,.. 
%		(in msec.),  Each realization consists of '1000' samples. 
%		Each period has 100 samples.
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
global BINARY_DATA_RATE;

SAMPLING_CONSTANT = 100;
BINARY_DATA_RATE = 1000;
leng = 1000;
fc = BINARY_DATA_RATE;
SAMPLING_FREQ = SAMPLING_CONSTANT*fc;
t = [1:leng]/(SAMPLING_FREQ);
nreal = length(range);
for ii = 1:nreal
  x(ii,:) = cos(2*pi*fc*t + range(ii));
end
