function h = hsplin2(L,x,wp,ws,P)
% HSPLIN2
% MATLAB m-file for fractional delay approximation
% using SPLINE TRANSITION BAND method
% Format: h = hsplin2(L,x,wp,ws,P)
% Input: L = filter length (filter order N = L-1)
%        x = fractional delay (0 < x <= 1)
%        wp = passband edge of approximation (0 < wp < 1)
%        ws = stopband edge of approximation (wp < ws < 1)
%        P = order of spline
% Output: Filter coefficient vector h(1)...h(L)
% Subroutines: standard MATLAB functions
%
% Timo Laakso   23.12.1992
% Last revision 14.01.1996

N = L-1;                   % filter order
M = N/2;                   % middle value
if (M-round(M))==0 D=x+M;  % integer part closest to middle
else D=x+M-0.5; end; 
%
b=(0:1:N)-D; pib=pi*b'; dw=ws-wp; sw=ws+wp; IP2=1/(2*P);
%h=sin(dw*pib*IP2)./(dw*pib*IP2);
h=sinc(dw*pib*IP2);     % TLa 14.01.1996
h=(h.^P).*sin(sw*pib*0.5)./(pib*IP2); 
               % impulse response (NOTE: avoid b=0!)
