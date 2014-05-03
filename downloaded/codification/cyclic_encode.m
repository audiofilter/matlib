function y = cyclic_encode(g, x)

% Usage: y = cyclic_encode(g, x)
%
% This function takes as input an entire block of information bits 'x'
% (which are arranged in a row vector), and the coeficients of the 
% generator polynomials 'g', and returns as output an entire 
% convolutionally encoded codeword 'y'.  Tail bits are automatically 
% appended to force the encoder back to the all-zeros state.
%
% The encoder matrix 'g' has n rows and K columns, where the code rate
% is 1/n and the constraint length is K.  Each row corresponds to one
% of the n encoder polynomials and each column of the row is a 
% coeffiecient of the encoder polynomial.
%
% Example:  cyclic_encode ([ 1 0 1 ; 1 1 0], [1 1 1 0 1]) =
%                        = [1 1 1 0 0 0 1 1 0 1 0 1 1 0] 
%
% Original author: M.C. Valenti
% For academic use only

% determine the constraint length (K), memory (m), and rate (1/n)
% and number of information bits.
[n,K] = size(g);
m = K - 1;
[temp,L_info] = size(x);

% initialize the state vector
state = zeros(temp,m);

% zero pad the codeword
x = [x zeros(temp,m)];
L_total = L_info+m;

% generate the codeword
for i = 1:L_total
   input_bit = x(:,i);
   [output_bits, state] = bit_encode(g, input_bit, state);
   y(:,n*(i-1)+1:n*i) = output_bits;
end

end

