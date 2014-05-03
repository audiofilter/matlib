function [out, seed] = uniform(start,stop,nsize,seed)

% UNIFORM ..... Generates random variates from Uniform(A,B) distribution.
%
%	UNIFORM(A,B,N) Generates N random variates from a uniform distribution
%		such that each X ~ Uniform(A,B), with the corresponding PDF:
%
%				(  1/(B-A),   B <= x <= A;
%			f (x) = <
%			 X      (  0,         otherwise.
%
%	UNIFORM(A,B,N,SEED) is the same but starts generating random variates 
%		using the value of SEED.
%	[Y, SEED] = UNIFORM(...) will return the current value of SEED for
%		subsequent calls to the same function.

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
global BELL;
global WARNING;

check;

%-------------------------------------------------------------------------
%	Check input parameters
%-------------------------------------------------------------------------

if ((nargin ~= 3) & (nargin ~= 4))
   error(eval('eval(BELL),eval(WARNING),help uniform'));
   return;
end   
if (nargin == 4), rand('seed',seed), end
if (stop < start), error('MIN should be less than or equal MAX'), end

%-------------------------------------------------------------------------
%	Generate Un(0,1) random variates and transform to Un(START,STOP)
%	variates using OUT = (STOP-START)*Un(0,1) + START. 
%-------------------------------------------------------------------------

out = (stop-start)*rand(1,nsize) + start;
if (nargout == 2), seed = rand('seed'); end
