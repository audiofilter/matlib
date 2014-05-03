function h = heqrip2(L,x,wprot,IP);
% HEQRIP2
% MATLAB m-file for fractional delay approximation
% Initialization ofr EQUIRIPPLE DESIGN
% Format: h = heqrip2(L,x,wprot,IP)
% Input: L = filter length (filter order N = L-1)
%        x = fractional delay (0 < x <= 1)
%        wprot = zeros of the linear-phase prototype filter 
%                from iniheq2.m (K = L/2, L must be even!)
%        IP = inverse P matrix from iniheq2.m
% Output: Filter coefficient vector h(1)..h(L)
% Subroutines: standard MATLAB functions
%
% Timo Laakso   28.12.1992
% Last revision 14.01.1996

N=L-1; K=L/2;
D=x+N/2-0.5;   % even length                 
for k=1:K
  cD(k) = cos(D*wprot(k));
  sD(k) = sin(D*wprot(k));
end % for k
pD=[cD sD]';
h=IP*pD;
