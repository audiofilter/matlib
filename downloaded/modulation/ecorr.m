function ecorr(x,t1,t2);

% ECORR .......	Evaluates the ensemble autocorrelation funcion.
%
%	ECORR(X,t1,t2) computes the ensemble autocorrelation function of X,
%		such that the returned value equals E[ X(t1)*X(t2) ].  Note
%		that t1 and t2 are in miliseconds. 
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
%===========================================================================

global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global BELL;
global WARNING;

check;

fs = SAMPLING_FREQ/1000;
n1 = fix(t1*fs + 0.1)+1;
n2 = fix(t2*fs + 0.1)+1;
[dis dumb] = size(x);
x1 = x(:,n1);
x2 = x(:,n2);
cor = x1'*x2/dis;
fprintf('Autocorrelation E(x(%5.3f),x(%5.3f)] = %e.\n',t1,t2,cor);
