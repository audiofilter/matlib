function out = corr_seq(rho,nsize,power,meanval,seed)

% CORR_SEQ ....	Generates a random data sequence with correlated samples.
%
%	[Y] = CORR_SEQ(RHO,N,POWER,MEAN) generates N samples from the sequence
%
%			Y(n) = RHO Y(n-1) + X(n), n = 1,2,...,N, 
%
%		where X(n) ~ Gaussian(MEAN,POWER).  Thus the sequence Y is a 
%		first order autoregressive type.
%
%	CORR_SEQ(RHO,N,POWER,MEAN,SEED) is the same but uses the value SEED to
%		generate random numbers.		

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

if (nargin == 5 ), randn('seed',seed), end
if (abs(rho) > 1), display('WARNING: output will be unstable'); end
b = [ 1      ];
a = [ 1 -rho ];
out = filter(b,a,(sqrt(power)*(randn(1,nsize)))) + meanval;

