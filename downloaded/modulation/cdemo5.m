subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 8;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

subplot(111)
quant_ch(2,'uniform');
pause

x=[0.8, 0.6, 0.2, -0.4, 0.1, -0.9, -0.3, 0.7];
xq=quantize(x,2)
xbin=bin_enc(xq,2)
par2ser(xbin)

pause 

x=sin(2*pi*20*[1:400]/SAMPLING_FREQ);
waveplot(x), hold on, waveplot(quantize(x,2))
hold off

pause

a=0.9;
subplot(111), clg
waveplot(a*x), hold on, waveplot(quantize(a*x,3))
hold off

pause

subplot(111), clg
xq=quantize(x,4), xe=x-xq;
clg, waveplot(xe)

pause

x=sin(2*pi*512*[1:2048]/SAMPLING_FREQ);
subplot(211), clg, psd(x)

pause

xq=quantize(x,4);
subplot(212), clg, psd(xq)

sq2=10*log10(var(x-xq))

pause

% NON-UNIFORM QUANTIZATION

s=speech(100);
subplot(211), clg, waveplot(s)

sq=quantize(s,6);
subplot(212), clg, waveplot(sq)
x=normalize(s,0.01);

pause

xq=quantize(x,6);
subplot(211), clg, waveplot(x)
subplot(212), clg, waveplot(xq);

pause

subplot(111), clg, quant_ch(3,'mu_law')

pause

msq=mu_inv(quantize(mu_law(s),6));
mxq=mu_inv(quantize(mu_law(x),6));

subplot(311), clg, waveplot(s)
subplot(312), clg, waveplot(sq)
subplot(313), clg, waveplot(msq)

pause

a=laplace(2000,0.01);
subplot(111), clg, pdf(a,30);

pause

b=mu_law(a);
hold on ; pdf(b,30)

pause

exp5_c6(1)


