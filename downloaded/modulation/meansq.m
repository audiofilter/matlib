function y = meansq(x)

% MEANSQ ...... Mean-Square value, E[X^2].  
%
%	MEANSQ(X)  For vectors,  MEANSQ(X)  is the mean-square
%		value of the elements in vector  X.  
%		For matrices,  MEANSQ(x) is a row vector containing 
%		the mean-square value of each column.
%
%	See also MEAN. VAR, STD.

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

y = var(x) + (mean(x).^2);
