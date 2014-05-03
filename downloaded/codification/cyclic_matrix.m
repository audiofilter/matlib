function G_M = cyclic_matrix(g, L_info)

% Usage: G_M = cyclic_matrix(g, L_info)
%
% makes a generator matrix for a (nonrecursive, nonsystematic)
% convolutional code with generator vectors stored in g and
% block length L (not including tail bits).  Size of G_M should be
% L rows and n*(L+m) columns.
%
% Original author: M.C. Valenti
% For academic use only

% determine size of g
[n,K] = size(g);
m = K - 1;
L_total = L_info + m;

% initialize G_M matrix
G_M = zeros( L_info, n*L_total );

% determine 1st row
first_row = [];
for j = 1:K
   for i = 1:n
      first_row = [first_row g(i,j)];
   end
end

% now the rows of the generator matrix are the first row
% shifted to the right
for row = 1:L_info
   G_M(row, n*(row-1)+1:n*(row+m)) = first_row;
end

end
