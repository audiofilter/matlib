function [out_binary] = bcd(in_integer,no_bit)

% BCD .........	Positive integer to binary-coded-decimal (BCD) conversion
%
%	BCD(IN,N) takes the input integers in the array IN and generates
%		row vectors representing the BCD code for each element of IN.
%		In its present format the M-file BCD is used to establish the
%		(2^N x N) look-up table used by BIN_ENC function where BCD
%		is called with input arguments IN = [0:(2^(N-1)] and N.
%
%	See also BIN_ENC, BIN_DEC.

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

no_sample  = length(in_integer);
out_binary = zeros(no_bit,no_sample);

for jj = 1:no_sample
    for ii = (no_bit-1):(-1):0
	k = 2^(ii);
	if ( fix(in_integer(jj)/k) == 1)
	    out_binary((no_bit-ii),jj) = 1;
	    in_integer(jj) = in_integer(jj) - k;
	end
    end
end
out_binary = out_binary';
