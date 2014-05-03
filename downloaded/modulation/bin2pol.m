function [polar_sequence] = bin2pol(binary_sequence)

% BIN2POL .....	Binary to polar conversion
%
%	[P] = BIN2POL(B) converts the binary sequence B into a polar sequence
%		using the transformation:
%
%			1 ---->  1
%			0 ----> -1
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

polar_sequence = 2*binary_sequence - ones(size(binary_sequence));
