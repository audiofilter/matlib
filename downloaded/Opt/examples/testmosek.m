InitOpt;
ov=newOptSpace;
N=10;
a=optSequence(N,ov);
c=optSequence(1,ov);
h=(a|1)'+c+(a|1);
%pb=Process('Box',0,[0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0]);
sb=Process('Box',0,[0 1]);
Psb=pwr(h.*sb);
%wire=optSequence([1]);
%Ppb=pwr((h-wire).*pb);      % affine
H0=fourier(h,0);

rms=optVar(ov);
ms=rms.^2;
%ms=energy(rms);
%soln0=minimize(rms,{Psb<ms,1<H0},ov,'sedumi');    % sedumi
soln0=minimize(rms,{Psb<ms,1<H0},ov,'mosekdual');    % new mosek solver

%plotting
hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
plot(f,20*log10(abs([H0])));
legend('socp');

