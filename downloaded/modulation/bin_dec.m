function [out_quantized] = bin_dec(in_bin)

% BIN_DEC .....	Natural binary source decoding. 
%
%	BIN_DEC(B) operates on the binary input array B that is in the form:
%
%			BIN-sample(1)   .....  BIN-sample(K)
%                        +--------+----       ----+--------+
%                        |  MSB   |     .....     |  LSB   |
%                        |     1  |               |     1  |
%                        +--------+----       ----+--------+
%                        |    .   |               |    .   |
%                             .         .....          .
%                             .                        .
%                        |        |               |        |
%                        +--------+----       ----+--------+
%                        |  MSB   |     .....     |  LSB   |
%                        |     K  |               |     K  |
%                        +--------+----       ----+--------+
%
%		and generates the corresponding quantization levels used by an
%		N-bit quantizer.  Number of bits, N, information is obtained
%		from the number of columns in B.
%
%	See also BCD, BIN_ENC.

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

in_bin = in_bin';
[no_bit, no_sample] = size(in_bin);

%-------------------------------------------------------------------------------
%	First let us determine the quantization levels { q(1),...,q(2^N) }.
%-------------------------------------------------------------------------------

qn    = 2^no_bit;
qstep = 2/qn;
for ii = 1:1:(2^(no_bit-1))
   q(    ii   ) = -1 + (ii-1)*qstep + qstep/2;
   q(qn-(ii-1)) =  1 - (ii-1)*qstep - qstep/2;
end

%-------------------------------------------------------------------------------
%	Weighting vector: [MSB,...,LSB] -> [2^(N-1),...,2^0].
%-------------------------------------------------------------------------------

for ii = (no_bit-1):(-1):0
   weight((no_bit-ii)) = 2^(ii);
end

if(size(weight,2)==1) weight=weight'; end; % MODIF. OCTAVE

%-------------------------------------------------------------------------------
%	Determine the index vector into the quantization level array "q"
%	by computing the innner product with the "weight" vector.
%-------------------------------------------------------------------------------

index   = (weight * in_bin) + 1;

%-------------------------------------------------------------------------------
%	Use the array of "index" to transform BIN --> Q.
%-------------------------------------------------------------------------------

out_quantized = q(index);
