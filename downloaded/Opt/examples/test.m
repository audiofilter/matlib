InitOpt;
ov=newOptSpace;
N=5;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
c=optSequence(1,ov);
h=(z|1)'+c+(z|1);
pb=Process('Box',0,[0 1 1 0 0 0 0 0 0 0 0]);
sb=Process('Box',0,[0 0 0 0 1 1 1 1 1 1 1]);
H0=fourier(h,0.1);
Psb=pwr(h.*sb);
wire=optSequence([1]);
Ppb1=pwr((h-wire*optVector(H0)).*pb);
Ppb2=pwr((h-wire).*pb);

soln0=minimize(Ppb2+Psb,{},ov,'loqo');         %loqo LS
soln1=minimize(Ppb1+Psb,{},ov,'eig');          %eigenfilter
soln2=minimize(Ppb1+Psb,{energy(H0)==1},ov,'geneig'); %generalized eigenfilter
% need to define == for optQuadVector so the following works:
%soln2=minimize(Ppb1+Psb,{abs(H0)==1},ov,'geneig'); %generalized eigenfilter

alpha=optVector(1,ov);
Ppb2=pwr((h-alpha*wire).*pb);
soln3=minimize(Ppb2+Psb,{energy(alpha)==1},ov,'geneig'); %true least-squares

%plotting
hopt0=double(optimal(h,soln0));
hopt1=double(optimal(h,soln1))./double(optimal(H0,soln1));
hopt2=double(optimal(h,soln2));
hopt3=double(optimal(h,soln3));
Nf=4000;
f=(0:Nf-1)/Nf-0.5;
H0=TDLfreq(hopt0,Nf);
H1=TDLfreq(hopt1,Nf);
H2=TDLfreq(hopt2,Nf);
H3=TDLfreq(hopt3,Nf);
plot(f,dB([H0;H1;H2;H3]));
legend('LOQO','Eigenfilter','Gen. Eigenfilter','True LS Eig',0);

