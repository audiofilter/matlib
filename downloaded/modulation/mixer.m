function [out] = mixer(in,fc)

% MIXER ....... Mix (multiply) two input sequences.
%
%	Z = MIXER(X,Y) generates the sequence Z such that: Z(n) = X(n)*Y(n).
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

n = length(in);
dim = length(fc);
if(n > dim )
   eval(BELL)
   fprintf('WARNING\n');
   fprintf('The input waveform is truncated to the miximum allowable\n');
   fprintf('binary data size %5.0f\n', (50000/SAMPLING_CONSTANT));
   carrier = fc;
   x = in(1:dim);
else
   carrier = fc(1:n);
   x = in;
end
x = x(:)';
if(size(x,2)==1) x=x'; end
out = carrier.*x;
