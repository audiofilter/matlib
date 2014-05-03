function [out_gray] = bin2gray(in_bin)

% BIN2GRAY ....	Natural binary code to GRAY code conversion.
%
%	BIN2GRAY(B) operates on the input array B which is a (KxN) binary array
%		with N-bits/sample and K-samples and converts into an equal  
%		size array as:
%
%                  b (1)  ...  b (1)              g (1)  ...  g (1)
%                   N           1                  N           1 
%                   :           :        ---->     :           :
%                  b (K)  ...  b (K)              g (K)  ...  g (K)
%                   N           1                  N           1 
%
%		where b_1(j) represents the LSB of the j-th sample and b_N(j)
%               is the MSB of the j-th sample.
%               We use the transformation g_N = b_N and g_n = (b_n XOR b_(n-1)).
%
%	See also GRAY2BIN, BIN_ENC, BIN_DEC.

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

[no_sample, no_bit] = size(in_bin);

array    = [ zeros(no_sample,1) in_bin(:,(1:(no_bit-1))) ];
out_gray = xor(in_bin,array);
