clear
ii=sqrt(-1);
M=128;
dw=pi/M;
NA=5;
NB=6;
tau=3;
pee=0.4;
wp=round(pee*M);
ws=round(0.6*M);

theta1=-tau*(0:wp)*dw;
theta2=-tau*(0:wp)*dw;
%theta1=[theta1 theta1(length(theta1))+(-NA*pi-theta1(length(theta1)))/(M+1-length(theta1))*(1:M-wp)];
%theta2=[theta1(1:wp+1) theta1(wp+2:length(theta1))-pi];
ang=-tau*wp*dw+(tau*wp*dw-(NA+NB)/2*pi)/(pi-wp*dw)*(1-wp:M-2*wp)*dw;
theta1=[theta1 ang];
theta1=[theta1 -fliplr(theta1(2:M))];
cph=ii*theta1;
cph=ifft(cph);
cph=cph.*([0 ones(1,M-1) 0 -ones(1,M-1)]);
cph=fft(cph);
mag=abs(exp(real(cph)));
coe1=ifft(mag.*exp(ii*theta1));

theta2=[theta2 ang];
theta2=[theta2 -fliplr(theta2(2:M))];
cph=ii*theta2;
cph=ifft(cph);
cph=cph.*([0 ones(1,M-1) 0 -ones(1,M-1)]);
cph=fft(cph);
mag=abs(exp(real(cph)));
coe2=ifft(mag.*exp(ii*theta2));
coe1=real(coe1(1:NA+1))/real(coe1(1));
coe2=real(coe2(1:NB+1))/real(coe2(1));
[ha,w]=freqz(coe1,M);
[hb,w]=freqz(coe2,M);
h=abs(cos((angle(ha)-angle(hb))/2));
plot(h)
