function w = bincof2(N,L)
% BINCOF2
% MATLAB m-file for calculating binomial coefficients
% Format: w = bincof2(N,L)
% w = ( N ) = N!/(L!(N-L)!)
%     ( L )
% Subroutines:standard MATLAB functions
% Timo Laakso   01.11.1990
% Last revision 16.01.1996

prod=1;
for k=1:L
  prod = prod*(N-k+1)/k;
end;
w=prod;
