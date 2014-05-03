InitOpt;
ov=newOptSpace;
N=11;
re=optSequence(N,ov);
im=optSequence(N,ov);
ct=optSequence(1,ov);
%h=((re+j*im)|1)'+ct+((re+j*im)|1);
h=(re+j*im)|(-(N-1)/2);
delta=optVar(ov);

sb=Process('Box',0.5,[1 0 0 1]);
Psb=pwr(h.*sb);
Hpb=fourier(h,[0.5]);
soln=minimize(delta,{Psb<delta.^2,1<real(Hpb),real(Hpb)<1,0<imag(Hpb),imag(Hpb)==0},ov,'sedumi');
%soln=minimize(delta,{Psb<delta.^2,Hpb==1},ov,'sedumi');

hopt=full(get_h(optimal(h,soln)));
Nf=4000;
f=(0:Nf-1)/Nf;
H=fft(hopt,Nf);
plot(f,20*log10(abs([H])));grid;
