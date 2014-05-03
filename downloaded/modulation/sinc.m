function [out] = sinc(in)

% SINC ........	Sinc function, sin(pi*x)/(pi*x).
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

[m,n] = size(in);
out   = ones(m,n);
index = (in ~= 0);
x     = pi * in;
out(index) = sin(x(index)) ./ x(index);
