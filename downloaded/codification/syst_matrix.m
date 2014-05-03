function B = syst_matrix( A );

% Usage: B = syst_matrix( A );
% 
% Performs Gaussian row reduction MODULO-2 on the matrix A
%
% Original author: M.C. Valenti
% For academic use only

[rows, cols] = size(A);

for i = 1:min(rows,cols)
   % check to see if leading element is a one or not
   if A(i,i) == 0
      % swap with some other column
      for j = i+1:cols
         if A(i,j) == 1
            temp = A(:,i);
            A(:,i) = A(:,j);
            A(:,j) = temp;
            break;
         end
      end
   end
   % check again
   if A(i,i) == 0
      fprintf( 1, 'ERROR; matrix not full rank');
      return;
   end
   % make all elements below the leading element zero
   for j = i+1:rows
      if A(j,i) == 1
         A(j,:) = xor( A(j,:), A(i,:) );
      end
   end
end

for i = rows:-1:1
   % make all elements above zero
   for j = i-1:-1:1
      if A(j,i) == 1
         A(j,:) = xor( A(j,:), A(i,:) );
      end
   end
end

rank = min(rows,cols);
B = A;
   
end
      
