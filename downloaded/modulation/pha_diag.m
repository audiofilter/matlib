function pha_diag(in,frequ,phase,sampling_instant)

% Usage pha_diag(in,frequ,phase,sampling_instant)
%
% phase diagram of the QAM signal 'in'. The local oscilator frequency an +
% phase are 'frequ' and 'phase', respectively. The switch of the correlator
% closed at sampling_instant. 
%
% Example: in = qam_mod(binary(64), 10000, 8, 4); frequ = 10000; phase = 0;
%          sampling_instant = 0.001; 
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

if ( nargin ~= 4 )
   error(eval('eval(BELL),eval(WARNING),help pha_diag'));
   return;
end

%------------------------------------------------------------------------------
%	Demodulation
%------------------------------------------------------------------------------

phase1=2*pi*frequ*[1:size(in,2)]/SAMPLING_FREQ+2*pi*phase/360;
phase2=phase1+pi/2;
carrier1 = cos(phase1);
carrier2 = cos(phase2);

y_cos=in.*carrier1;                y_sin=in.*carrier2;
r_cos=match('polar_nrz',y_cos);    r_sin=match('polar_nrz',y_sin);

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

max_c=max(out_cos); min_c=min(out_cos);
max_s=max(out_sin); min_s=min(out_sin);

% DRAWING THE PHASE DIAGRAM
gset nokey; clg;
hold on; grid;
title('PHASE DIAGRAM');
xlabel('cos'); ylabel('sin');
plot([1.2*min_c,1.2*max_c],[0,0],'-');
plot([0,0],[1.2*min_s,1.2*max_s],'-');
plot(out_cos,out_sin,'*');
hold off;
end
