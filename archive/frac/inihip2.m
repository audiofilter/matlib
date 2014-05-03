function Hip=inihip2(L,Q,wp);
% INIHIP2
% MATLAB m-file for fractional delay approximation
% Initialisation for upsampling interpolation design
%
% First version: 28.12.1992 / Timo Laakso
% This  version: 14.01.1996 / Timo Laakso
%
% Subroutines: standard MATLAB functions
LQ=L*Q; %+1;                      % length and order of the prototype filter
wpQ=wp/Q;                         % design a Qth-band lowpass filter
wsQ=wpQ+2*(1-wp)/Q;
f=[0 wpQ wsQ 1];
m=[1 1 0 0];
hpr=remez(LQ,f,m);                % design prototype filter via Remez routine
%
%plot(hpr);pause
%[Hpr,wpr]=freqz(hpr,1,512);
%plot(wpr/pi,abs(Hpr)); pause
%
Hip=zeros(L,Q);                   % read coefficients in a matrix
                                  % with delay filters as column vectors
for k=1:LQ
  k1=k-1;
  l=floor(k1/Q);                  % coefficient index
  q=rem(k1,Q);                    % filter index (mirrored)
  Hip(l+1,q+1)=hpr(k);
end;
