function b = qam_dem(in,frequ,phase,sampling_instant,threshold1,threshold2)

% Usage b = qam_dem(in,frequ,phase,sampling_instant,threshold1,threshold2)
%
% QAM demodulation of the signal 'in'. The local oscilator frequency an +
% phase are 'frequ' and 'phase', respectively. The switch of the correlator
% closed at sampling_instant. The threshold set in the cosine and sine 
% correlators are 'threshold1' and 'threshold2', repectively.
% Symbols are assumed gray encoded.
% The demodulated binary sequence is 'b'.
%
% Example: in = qam_mod(binary(65), 10000, 8, 4); frequ = 10000; phase = 0;
%          sampling_instant = 0.001; 
%          threshold1 = [-0.003,-0.002,-0.001, 0, 0.001,0.002,0.003];
%          threshold2 = [-0.001, 0, 0.001];  
%
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
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------------
%	Check input parameter consistency
%------------------------------------------------------------------------------

if ( (nargin ~= 5)&(nargin ~= 6))
   error(eval('eval(BELL),eval(WARNING),help qam_dem'));
   return;
end

if (nargin == 5) threshold2=threshold1; end

%------------------------------------------------------------------------------
%	Demodulation
%------------------------------------------------------------------------------

phase1=2*pi*frequ*[1:size(in,2)]/SAMPLING_FREQ+2*pi*phase/360;
phase2=phase1-pi/2;
carrier1 = cos(phase1);
carrier2 = cos(phase2);

y_cos=in.*carrier1;                y_sin=in.*carrier2;
r_cos=match('polar_nrz',y_cos);    r_sin=match('polar_nrz',y_sin);

figure(0); subplot(121), clg, eye_diag(r_cos);
           subplot(122), clg, eye_diag(r_sin);

%------------------------------------------------------------------------------
%	Now let us determine the basic pulse shapes and amplitude values
%------------------------------------------------------------------------------

Ts = 1/SAMPLING_FREQ;
Tb = 1/BINARY_DATA_RATE;

samples_delay   = fix(sampling_instant/Ts);
no_samples      = length(in);
no_decision     = fix((no_samples-samples_delay)/SAMPLING_CONSTANT);
if (no_decision <= 0)
  error('Initial sampling instant exceeds input waveform duration.');
end
% index_test      = SAMPLING_CONSTANT * [0:(no_decision-1)] + samples_delay;
index_test      = SAMPLING_CONSTANT * [0:(no_decision)] + samples_delay;

out_cos=r_cos(index_test);
out_sin=r_sin(index_test);

% DECODIFICAMOS EL COSENO
a=out_cos; threshold=sort(threshold1); b=[];
n_th=size(threshold,2);
b(1,:)=(a<threshold(1));
for i=2:n_th
b(1,:)=b(1,:)+i*((a>=threshold(i-1))&(a<threshold(i)));
end
b(1,:)=b(1,:)+(n_th+1)*(a>=threshold(n_th));

b=b-1; b1=[];
for i=1:log2(n_th+1)
   b1(i,:)=rem(b,2);
   b=floor(b/2);
end

b1=gray2bin(b1);

% DECODIFICAMOS EL SENO
a=out_sin; threshold=sort(threshold2); b=[];
n_th=size(threshold,2);
b(1,:)=(a<threshold(1));
for i=2:n_th
b(1,:)=b(1,:)+i*((a>=threshold(i-1))&(a<threshold(i)));
end
b(1,:)=b(1,:)+(n_th+1)*(a>=threshold(n_th));

b=b-1; b2=[];
if(n_th==1) b2=b; end
for i=1:log2(n_th+1)
   b2(i,:)=rem(b,2);
   b=floor(b/2);
end

b2=gray2bin(b2);

b=[b1 ; b2];
b=par2ser(b);

max_c=max(out_cos); min_c=min(out_cos);
max_s=max(out_sin); min_s=min(out_sin);

figure(1), clg,
hold on, grid;
title('PHASE DIAGRAM');
xlabel('cos'); ylabel('sin');
plot([1.2*min_c,1.2*max_c],[0,0],'-');
plot([0,0],[1.2*min_s,1.2*max_s],'-');
plot(out_cos,out_sin,'*');
hold off;
end
