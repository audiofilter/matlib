function h = hlagr2(L,x)
% HLAGR2
% MATLAB m-file for fractional delay approximation
% by LAGRANGE INTERPOLATION method
% h = hlagr2(L,x) returns a length L (real) FIR
% filter which approximates the fractional delay
% of x samples.
% Input: L = filter length (filter order N = L-1)
%        x = fractional delay (0 < x <= 1)
% Output: Filter coefficient vector h(1)...h(L)
% Subroutines: standard MATLAB functions
%
% Timo Laakso 27.12.1992
% Revised 14.01.1996 by Timo Laakso
%         17.01.1996 by Vesa Valimaki
N = L-1;                    % filter order
M = N/2;                    % middle value
if (M-round(M))==0 D=x+M;   % integer part closest to middle
else D=x+M-0.5; end; 
%
h=ones(1,(N+1));
%
for n=0:N          
  n1=n+1;
  for k=0:N
    if (k~=n)
      h(n1) = h(n1)*(D-k)/(n-k);
    end  % if
  end; % for k
end; % for n

