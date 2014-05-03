clear all;
clf;
% Number of symbols
np = 1000;
% Noise variance
nv = 0.0;
% Raised cosine FIR
fir = [0 13.07 22.175 18.809 0 -27.407 -47.518 -42.026 0 74.332 160.607 229.64 256 229.64 160.607 74.332 0 -42.026 -47.518 -27.407 0 18.809 22.175 13.07 0];
% Tilt FIR
a = -0.44*i;
% Group Delay All-pass
a1 = 0.9;
a2 = 0.55;
off = 2;
% In-home Multipath FIR (11 dB down, 3/2 symbol delay, 30 degrees)
mfir = [1 0 0 0 0 -0.2818*cos(pi/6)-0.2818*sin(pi/6)*i];


%a = 0;
%a1 = 0;
%a2 = 0;
%clear mfir;
%mfir = [1 0];

% Number of points in freq domain
nf = 40;
preamble = 32;
start = 32;
freq = 0.00;
ex_spm;
disp('Push any key .. ');
pause;
% Feedforward span in symbols.
M = 8; 
% Feedback 
B = 3;
dfe_who;
disp('Push any key .. ');
pause;
figure;
post;
