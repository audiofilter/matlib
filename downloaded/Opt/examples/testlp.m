InitOpt;
ov=newOptSpace;
N=3;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
c=optSequence(1,ov);
h=(z|1)'+c+(z|1);

delta=optVector(1,ov);
dnu=1/(10*N);
nu_pb=0.2:dnu:.4;
nu_sb=[0:dnu:.1 .5:dnu:1];
Hpb=fourier(h,nu_pb);
Hsb=fourier(h,nu_sb);
constr={1<fourier(h,[0.3]) -delta<Hsb Hsb<delta};
%constr={fourier(h,[0.3])==1 -delta<Hsb Hsb<delta};
%constr={10^(-.1/20)<Hpb Hpb<10^(.1/20) -delta<Hsb Hsb<delta};

%soln0=minimize(delta,constr,ov,'loqo');    % loqo LP
soln0=minimize(delta,constr,ov,'loqosoclp');    % loqo LP
%soln0=minimize(delta,constr,ov,'sedumi');    % sedumi LP
%soln0=minimize(delta,constr,ov,'boydsocp');    % socp LP
%soln0=minimize(delta,constr,ov,'sdppack');    % sdppack LP
%[soln0,dual0]=minimize(delta,constr,ov,'mosekdual');    % sdppack LP

hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
plot(f,20*log10(abs([H0])));
%legend('loqo1','loqo2',0);
