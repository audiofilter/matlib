% Demonstration of Decision Feedback Equalizer (using example in DSP Handbook page 871-873).
clear all;
% Equalizer parameters.
v = 0.05
% Feedforward span in symbols.
M = 4;
% Feedback span in symbols.
B = 8;
% Equalizer input buffer.
x = zeros(1,M);
y = zeros(1,M);
wff = x;
xfb = zeros(1,B);
wfb = xfb;
% Number of points in freq domain
nf = 32;

% Equalizer filter data and weights initial conditions.
for j=1:64;
f = j/125;
pin(j) = 0.5*sin(2*pi*25*f+75/57) + sin(2*pi*10*f + 63/57);
py(j) = sin(2*pi*25*f + 18/57);
%
% Equalizer implementation
x = [pin(j) x(1:M-1)];
ff = x*wff';
fb = xfb*wfb';
dy = ff - fb;
e(j) = x(:,1) - dy;
wff = wff + v*e(j)*x;
wfb = wfb - v*e(j)*xfb; 
xfb = [x(:,1) xfb(1:B-1)];
% for 3-D plot
if (j>1) 
	[hh, ww] = freqz(wff,wfb,nf);
	for list=1:nf
		m(j,list) = abs(hh(list));
	end
end
end
% Plot signals
subplot(3,1,1), plot(pin);
subplot(3,1,2), plot(py);
subplot(3,1,3), plot(e);
grid;
% Plot spectrum
pause;
%subplot(1,1,1);
%mesh(m);
%view([130 20]);
pause;
plot(abs(hh));
grid;


