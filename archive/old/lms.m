% Demonstration of LMS Adaptive Equalizer Using PN code
% generator for data (7-Apr-94).
% Equalizer parameters.
clear all;
close;
v = 0.008;
echo off;
% Feedforward span in symbols.
M = 8; 
% Equalizer input buffer.
x = zeros(1,M) + i*zeros(1,M);
wff = x;
dly = x;
% Number of points in freq domain
nf = 32;

gen_c;
%echo on;
% Equalizer filter data and weights initial conditions
for j=1:500;
% Equalizer implementation
x = [r(j) x(1:M-1)];
ff = x*wff';
d = sign(real(ff)) + i*sign(imag(ff));
if (real(ff)==0) 
	d = d+1;
end
if (imag(ff)==0) 
	d = d+i;
end
dly = [d dly(1:M-1)];
if (j>200) 
	eq(j-200) = ff;
end
e(j) = x(:,M) - ff;
wff = wff + v*conj(e(j))*x;
out(j) = dly(:,1);
end
% Plot signals
subplot(2,1,1), plot(real(e));
subplot(2,1,2), plot(imag(e));
grid;
pause;
figure;
[h, w] = freqz(wff,1,nf);
subplot(1,1,1), plot(abs(h));
grid;



