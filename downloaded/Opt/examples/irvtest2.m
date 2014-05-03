InitOpt;
ov=newOptSpace;
N=19;
h=optSequence(N,ov);

delta=optVector(1,ov);
dnu=1/(20*N);

Delta=[];
for B=0:0.01:0.8
%for tau=0:0.1:5	

tau=7.45;
nu_pb=0:dnu:B/2;
%nu_pb=0.0:dnu:0.2;
nu_sb=[0:dnu:.1 .5:dnu:1];
Hpb=fourier(h,nu_pb);
Hsb=fourier(h,nu_sb);
constr={-1<h, h<1, ...
		  abs(optVector(Hpb)-delta*exp(-j*2*pi*nu_pb*tau))<1-10^(-3/20)};
soln0=minimize(-delta,constr,ov,'sedumi');    % sedumi LP
%soln0=minimize(-delta,constr,ov,'loqosoclp');    % sedumi LP
Delta=[Delta;[tau,double(optimal(delta,soln0))]]

hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
subplot(2,1,1);
plot(f,20*log10(abs([H0])));
axis([0 0.5 -60 30]); grid;
subplot(2,1,2);
stem(abs(hopt0));

B
pause;
end;
