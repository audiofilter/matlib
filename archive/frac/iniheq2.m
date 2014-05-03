function [IP,wprot] = iniheq2(L,wp);
% INIHEQ2
% MATLAB m-file for fractional delay approximation
% Initialisation for equiripple design:
% Design an odd-length halfband filter for the prototype
% (find zeros and scale them by multiplying by 2).
% Format: [IP,wprot] = iniheq2(L,wp);
% Input: L = filter length (filter order N = L-1)
%        wp = passband edge of approximation (0 < wp < 1)
% Output: IP = inverse P matrix
%         wprot = zeros of the linear phase prototype filter 
% Subroutines: standard MATLAB functions
%
% First version: 28.12.1992 / Timo Laakso
% This version:  14.01.1996 / Timo Laakso

LP=2*L-1; N=L-1; K=L/2;           % L should be even
Npt=1024;                         % number of frequency points for zero search
wp2=wp/2;                         % frequency band of halfband filter
f=[0 wp2 1-wp2 1];
m=[1 1 0 0];                      % design prototype halfband
hpr=remez(LP-1,f,m);              % filter via Remez routine
% modified 14.10.95 TLA
[Hpr,wpr]=freqz(hpr,1,Npt); absHpr=abs(Hpr);
perr=absHpr-1;                    % passband error
% Search approximate zeros in the passband
NV=round(Npt/2)+1;                % search only in passband
wprot=zeros(1,K);zprot=ones(1,K);l=1;
for i=1:NV
  if (perr(i)*perr(i+1)<=0) wprot(l)=i*pi/Npt; l=l+1; end; % new zero
end;
% plot(wpr/pi,absHpr,'-g',wprot/pi,zprot,'or');grid;
% title('PROTOTYPE HALFBAND FILTER');pause;
wprot=2*wprot;                    % scale the zeros
% Construct P matrix and invert it
d=0.3;D=d+(N-1)/2;
Co=zeros(K,L);So=Co;Po=zeros(L,L);IP=Po; % initialize matrices
for k=1:K
  for n=0:N
    n1=n+1;
    Co(k,n1)=cos(n*wprot(k));
    So(k,n1)=sin(n*wprot(k));
  end;
end;
Po=[Co;So];
IP=inv(Po);
