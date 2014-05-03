function  [out] = invert(in)

% INVERT ......	Inverts a binary sequence such that {1,0,1} becomes {0,1,0}.

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

if ( any( abs(in)-sign(in)) )
   error('Input sequence is not binary')
end

out = ~in;
