function result = mult_mod2(x,G)
% Usage: result = mult_mod2(x,G)
%
% Performs a matrix multiply between vector 'x'
% and matrix 'G' using MODULO-2 operations
%
% Original author: M.C. Valenti
% For academic use only

[rows, cols] = size(G);

% trim x (in case its already zero-padded)
x = x(:,1:rows);

for i = 1:cols
   result(:,i) = rem( x(:,1:rows)*G(:,i), 2);
end

