% -----------------------------------------------------------
% An Example of All Pass filters
% K. Takaya    November 25, 1995
% -----------------------------------------------------------
clear; clf; 
r=0.8; theta=pi/32;
pole=[r]; zero=[1/r]; gain=r;
for i=2:13
pole=[pole, (r^i)*exp(j*theta*(i-1))];
pole=[pole, (r^i)*exp(-j*theta*(i-1))];
zero=[zero, ((1/r)^i)*exp(j*theta*(i-1))];
zero=[zero, ((1/r)^i)*exp(-j*theta*(i-1))];
gain=gain*(r^i)*(r^i);
end;
figure(3); clf;
circle=exp(j*[0:pi/64:2*pi]);
subplot(221); plot(circle,'g-'); hold on;
plot(zero,'yo'); hold on; plot(pole,'wx'); 
title('Allpass Filter');

num=real(poly(zero));
den=real(poly(pole));
[H,W]=freqz(gain*num,den,256);  W=0.5*W/(pi);
subplot(222); plot(W,20*log10(abs(H))); axis([0,0.5,-1,2]);
title('Frequency Response'); ylabel('Gain in dB');
subplot(224); plot(W,angle(H)); axis([0,0.5,-4,4]);
ylabel('Phase in rad (wrapped)'); xlabel('Normalized freq by Fs');
subplot(223); dimpulse(num,den,50);
