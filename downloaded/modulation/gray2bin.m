function [out_bin] = gray2bin(in_gray)

% GRAY2BIN ....	GRAY code to natural binary conversion.
%
%	GRAY2BIN(G) operates on the input array G which is a (KxN) binary array
%		with N-bits/sample and K-samples and converts into an equal  
%		size array as:
%
%                  g (1)  ...  g (1)          b (1)  ...  b (1)
%                   N           1              N           1
%                   :           :      ---->   :           :
%                  g (K)  ...  g (K)          b (K)  ...  b (K)
%                   N           1              N           N
%
%		where b_1(j) represents the LSB of the j-th sample and b_N(j)
%               is the MSB of the j-th sample.
%               We use the transformation b_N = g_N and b_n = (g_n XOR b_(n+1)).
%
%	See also BIN2GRAY, BIN_ENC, BIN_DEC.

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

[no_sample, no_bit] = size(in_gray);

out_bin(:,1) = in_gray(:,1);
for ii=2:no_bit
    out_bin(:,ii) = xor(in_gray(:,ii),out_bin(:,ii-1));
end    
