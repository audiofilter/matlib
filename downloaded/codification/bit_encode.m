function [output, state] = bit_encode(g, input, state)

% Usage: [output, state] = bit_encode(g, input, state)
%
% Takes as an input a single bit to be encoded 'input', 
% the coeficients of the generator polynomials 'g', and
% the current state vector 'state'.
% Returns as output n encoded data bits 'output' (where 1/n 
% is the code rate), and the new state vector 'state'.
%
% Original author: M.C. Valenti
% for academic use only

% the rate is 1/n
% k is the constraint length
% m is the amount of memory

[n,k] = size(g);
m = k-1;

% determine the next output bit
for i=1:n
   output(:,i) = g(i,1)*input;
   for j = 2:k
      output(:,i) = xor(output(:,i),g(i,j)*state(:,j-1));
   end;
end

state = [input, state(:,1:m-1)];

end
