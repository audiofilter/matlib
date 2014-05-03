function odd = isodd(x)

% function odd = isodd(x)
% 
% function yields a matrix odd which is 1 for every odd
% value of abs(x) and 0 else.
% 
% ml, 20.8.1992
%
% Copyright Lehrstuhl fuer Nachrichtentechnik Erlangen, FRG
% e-mail: int@nt.e-technik.uni-erlangen.de

[m,n] = size(x);
odd = zeros(m,n);
ind = find((x-1)/2==fix((x-1)/2));
odd(ind) = 1 + odd(ind);
