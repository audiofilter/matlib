function out = limiter(in,xmin,xmax)

% LIMITER .....	Limiting function
%
%	[Y] = LIMITER(X,A,B) generates the output sequence Y from X such that:
%
%			      ( A,	if      X <= A; 
%			Y   = < X,	if  A < X <= B;
%			      ( B,	if  B < X.

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

out = in;
nmin = length(out(out<xmin));
nmax = length(out(out>xmax));
out(out<xmin) = xmin*ones(1,nmin);
out(out>xmax) = xmax*ones(1,nmax);

