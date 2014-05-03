function [binary_sequence] = pol2bin(polar_sequence)

% POL2BIN .....	Polar to binary conversion
%
%	[B] = POL2BIN(P) converts the polar sequence P into a binary sequence
%		using the transformation:
%
%			 1 ----> 1
%			-1 ----> 0 
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

binary_sequence = ~( polar_sequence - ones(size(polar_sequence)) );
