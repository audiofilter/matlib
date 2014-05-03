function h = hgls2(L,x,wp)
% HGLS2
% MATLAB m-file for fractional delay approximation
% using the GENERAL LEAST SQUARES method
% Format: h = hgls2(L,x,wp)
% Input: L = filter length (filter order N = L-1)
%        x = fractional delay (0 < x <= 1)
%        wp = passband edge of approximation (in [0, 1])
% Output: Filter coefficient vector h(1)...h(L)
% Subroutines: standard MATLAB functions
%
% Timo Laakso   27.12.1992
% Last revision 14.01.1996

N = L-1;                         % filter order
M = N/2;                         % middle value
if (M-round(M))==0 D=x+M;        % integer part closest to middle
else D=x+M-0.5; end; 
%
cT=zeros(N+1,1); p1=cT;
%
cT(1)=wp; 
if round(D)==D p1(1)=wp;
else
  p1(1)=( sin(D*wp*pi) )/(D*pi); % p1(1) added 23.2.93! 
end;
for k=1:N           % compute the elements of the Toeplitz matrix (vector)
  k1=k+1;  kD=k-D;
  cT(k1) = ( sin(k*wp*pi) )/(k*pi);
  p1(k1) = ( sin(kD*wp*pi) )/(kD*pi);
end;  % for k
%
P=toeplitz(cT);
%pause
h=P\p1;
%plot(h); pause






