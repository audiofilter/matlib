function int_state = int_state( state )

% Usage: int_state = int_state( state )
%
% Converts a row vector 'state' of m bits into a integer 
% 'int_state' (which is base 10).
% Examples:  int_state([1 1 0]) = 6
%            int_state([1 1 0 ; 1 1 1]) = [6 7]
%
% Original author: M.C. Valenti
% For academic use only

[dummy, m] = size( state );

for i = 1:m
   vect(i) = 2^(m-i);
end

if(size(state)!=size(vect)) vect=vect'; end
int_state = state*vect';

if(size(int_state,2)==1) int_state=int_state'; end

end
