function [out,t] = qam_mod(binary_sequence,frequ,n1,n2)

% Usage: [out,t] = qam_mod(binary_sequence,frequ,n1,n2)
% 
% QAM modulation of a 'binary_sequence' with a carrier of frequence
% 'frequ' and 'n1' cosine levels and 'n2' sine levels
% bits of the binary sequence are grouped in simbols and then gray encoded
%
% Example: binary_sequence = binary(65); frequ = 10000; n1=8; n2=4;  
%
% Copyright (C) 2000-2001 F. Arguello (http://web.usc.es/~elusive)
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.


global START_OK;
global SAMPLING_CONSTANT;
global SAMPLING_FREQ;
global BINARY_DATA_RATE;
global CARRIER_FREQUENCY;
global NYQUIST_BLOCK;
global NYQUIST_ALPHA;
global DUOBINARY_BLOCK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Set up parameters
%------------------------------------------------------------------------------

if ((nargin ~= 3) & (nargin ~= 4))
   error(eval('eval(BELL),eval(WARNING),help qam_mod'));
   return;
end 

if (nargin == 3) N2=N1; end  

% COMPLETAMOS CON CEROS
N1=log2(n1) ; N2=log2(n2);
reman=rem(size(binary_sequence,2),(N1+N2));
if(reman~=0)  binary_sequence=[binary_sequence, zeros(1,(N1+N2)-reman)]; end

Rb = BINARY_DATA_RATE; 
fs = SAMPLING_FREQ;                     %  Default sampling frequency;
Ts = 1/fs;                              %  Sampling period
Tb = 1/Rb;                              %  Binary data period;
no_symbols = length(binary_sequence)/(N1+N2); 
t    = [0:(no_symbols*Tb/Ts)-1] * Ts;	        %  Sampling instances 

pulse = 'rect_nrz(Rb,fs)';

% SEPARAMOS LOS BITS - GRAY ENCODE
b=ser2par(binary_sequence,N1+N2); 
b_c=b([1:N1],:) ;          b_c=bin2gray(b_c);
b_s=b([N1+1:N1+N2],:) ;    b_s=bin2gray(b_s);

% LOS PASAMOS A DECIMAL
for i=1:N1 weight1(1,i)=2^(i-1); end
for i=1:N2 weight2(1,i)=2^(i-1); end
pam_c=weight1*b_c; pam_s=weight2*b_s;
pam_c=2*(pam_c-mean([0:(2^N1-1)])); pam_s=2*(pam_s-mean([0:(2^N2-1)]));

% GENERAMOS LA SENAL
pam_c= (pam_c' * eval(pulse))'; pam_c= pam_c(:)';
pam_s= (pam_s' * eval(pulse))'; pam_s= pam_s(:)';

% MULTIPLICAMOS POR COSENO Y SENO

phase1=2*pi*frequ*[1:size(pam_c,2)]/SAMPLING_FREQ;
phase2=phase1-pi/2;
carrier1 = cos(phase1);
carrier2 = cos(phase2);

out = pam_c.*carrier1 + pam_s.*carrier2;
end

