InitOpt;
ov=newOptSpace;
N=9;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
c=optSequence(1,ov);
h=(z|1)'+c+(z|1);

delta=optVector(1,ov);
dnu=1/(20*N);

for B=0:0.01:0.8
	
nu_pb=0.5+(-B/2:dnu:B/2);
%nu_pb=0.0:dnu:0.2;
nu_sb=[0:dnu:.1 .5:dnu:1];
Hpb=fourier(h,nu_pb);
Hsb=fourier(h,nu_sb);
constr={abs(optVector(z))<1, -1<c, c<1, delta<Hpb};
%soln0=minimize(-delta,constr,ov,'sedumi');    % sedumi LP
soln0=minimize(-delta,constr,ov,'loqosoclp');    % sedumi LP

hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
subplot(2,1,1);
plot(f,20*log10(abs([H0])));
axis([0 1 -60 30]); grid;
subplot(2,1,2);
stem(abs(hopt0));

B
pause;
end;