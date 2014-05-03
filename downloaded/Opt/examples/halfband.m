InitOpt;
ov=newOptSpace;

N=3;

ct=optSequence(0.5);
rt=(optSequence(N,ov)./2)|1;
h=rt'+ct+rt;

df=1/(80*N);
fsb=0.5-5/6/4:df:0.5;
Hsb=fourier(h,fsb);
H0=fourier(h,0.25);

delta=optVar(ov);
constr={-delta<Hsb, Hsb<delta};
%[soln,dual]=minimize(delta,constr,ov,'mosekdual');
[soln,dual]=minimize(delta,constr,ov,'tomlabLP');

hopt=double(optimal(h,soln));
Nf=1000; f=(0:Nf-1)/Nf-0.5;
Hopt=fftshift(fft(hopt,Nf));
plot(f,20*log10(abs(Hopt)));grid;
title('Halfband Filter')
xlabel('Normalized Frequency')
ylabel('Magnitude [dB]')
