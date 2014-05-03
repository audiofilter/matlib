InitOpt;
ov=newOptSpace;
N=25;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
c=optSequence(1,ov);
h=(z|1)'+c+(z|1);
pb=Process('Box',0.5,[0 1 1 0 0 0 0 0 0 0]);
sb=Process('Box',0, [1 0 0 0 1 1 1 1 1 1]);
H0=fourier(h,0.2);
Psb=pwr(h.*sb);
wire=optSequence([1]);
Ppb1=pwr((h-wire*optVector(H0)).*pb);   % linear
Ppb2=pwr((h-wire).*pb);      % affine

soln0=minimize(Ppb2+Psb,{},ov,'loqo');                  %loqo LS
soln1=minimize(Ppb1+Psb,{},ov,'eig');                   %eigenfilter
soln2=minimize(Ppb1+Psb,{energy(H0)==1},ov,'geneig');   %gen. eigenfilter

alpha=optVector(1,ov);
Ppb2=pwr((h-alpha*wire).*pb);
soln3=minimize(Ppb2+Psb,{energy(alpha)==1},ov,'geneig'); %eig true LS

%plotting
hopt0=full(get_h(optimal(h,soln0)));
hopt1=full(get_h(optimal(h,soln1)))./full(get_h(optimal(H0,soln1)));
hopt2=full(get_h(optimal(h,soln2)));
hopt3=full(get_h(optimal(h,soln3)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
H1=fft(hopt1,Nf);
H2=fft(hopt2,Nf);
H3=fft(hopt3,Nf);
plot(f,20*log10(abs([H0;H1;H2;H3])));
legend('LOQO','Eigenfilter','Gen. Eigenfilter','True LS Eig',0);

