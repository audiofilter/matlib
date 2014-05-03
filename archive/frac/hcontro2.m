function h = hcontro2(L,x,hprot);
% HCONTRO2
% MATLAB m-file for fractional delay approximation
% CONTINUOUS TUNING BY SINC INTERPOLATION
% Format: h = hcontro2(L,x,hprot)
% Input: L = filter length (filter order N = L-1)
%        x = fractional delay (0 < x <= 1)
%        hprot = linear-phase prototype filter (any FIR filter!) 
% Output: Filter coefficient vector h(1)...h(L)
% Subroutines: standard MATLAB functions
%
% Timo Laakso   29.12.1992
% Last revision 14.01.1996

N = L-1;  % filter order
cvec = 0:1:N; ccvec = pi*(cvec-x);
cT = sin(ccvec)./ccvec;
rvec = 0:-1:-N; rrvec = pi*(rvec-x);
rT = sin(rrvec)./rrvec;
Sdx = toeplitz(cT,rT);
h = Sdx*hprot;