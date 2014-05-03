function h = hsincw2(L,d,wp,win)
% HSINCW2
% MATLAB m-file for sinc windowing method for FD filter design
% h = hsincw2(L,d,wp,win) designs an (L-1)th-order FIR
% filter to approximate a fractional delay of d samples,
% where 0 <= d < 1, wp is the passband of approximation and
% win is a length-L window function 
% (e.g., win = chebwin(L,ripple), with sidelope ripple in dB).
% Output: length-L filter coefficient vector h
% Function Calls: standard MATLAB functions and sinc.m
%
% Timo Laakso 23.12.1992
% Revised by Vesa Valimaki 19.10.1995
% Last modified 14.01.1996

N = L-1;                 % filter order
M = N/2;                 % middle value
if (M-round(M))==0       % if L is even...
        D = M + d;           % D = M + d
        else D = M + d -0.5; % ...otherwise
end;
b = (0:N)-D;    % sample instants
%h = sinc(wp*b); % shifted & sampled sinc function
h = sin(wp*b)/(wp*b); % shifted & sampled sinc function
h = h.*win;     % windowing by the given window function



