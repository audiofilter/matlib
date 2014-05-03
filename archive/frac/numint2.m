function V = numint2(y);
% NUMINT2
% MATLAB m-file for numerical integration using
% Simpson's rule
% Format: V = numint2(y)
% input: y = an odd-length row vector
%
% Timo Laakso  16.03.1992
% Last revised 16.01.1996

% y must be an odd-length row vector
%
Npt=length(y); Npt2=(Npt-1)/2;
cof=2*ones(1,Npt);
cof(1)=1; cof(Npt)=1;  
for k=1:Npt2
  cf(2*k)=4; end    % weight vector for the inner product
V=(cof*y')/(3*Npt);
