InitOpt;
ov=newOptSpace;

N=21;

rt=(optSequence(N,ov)./2)|1;
h=rt'+rt;

df=1/(40*N);
fpb=(0:df:5/6/4)/2;
fsb=(0.5-5/6/4:df:0.5)/2;
Hpb=fourier(h,fpb);
Hsb=fourier(h,fsb);

delta=optVar(ov);
constr={1-delta<Hpb, Hpb<1+delta, -10^(-90/20)<Hsb, Hsb<10^(-90/20)};
soln=minimize(delta,constr,ov,'sedumi');
deltaopt=20*log10(1+double(optimal(delta,soln)))

hopt=double(optimal(h,soln));
Nf=1000; f=2*(0:Nf-1)/Nf-1;
Hopt=fftshift(fft(hopt,Nf));
plot(f,20*log10(Hopt)); 
axis([-0.5 0.5 -100 5]); grid;
xlabel('Normalized Frequency')
ylabel('Magnitude [dB]')
title('Lowpass Filter')

