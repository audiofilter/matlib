InitOpt;
ov=newOptSpace;
N=10;
a=optSequence(N,ov);
b=optSequence(N,ov);
c=optSequence(N,ov);
d=optSequence(N,ov);
y=a+j*b;
z=c+j*d;
c=optSequence(1,ov);
h=((z./3)|2)'+((y./3)|1)'+c+((y./3)|1)+((z./3)|2);

delta=optVector(1,ov);
dnu=1/(40*N);
nu_pb=0.2:dnu:0.5;
nu_sb=[0:dnu:0.16 0.54:dnu:1.0];
Hpb=fourier(h,nu_pb);
Hsb=fourier(h,nu_sb);
constr={10^(-.1/20)<Hpb Hpb<10^(.1/20) -delta<Hsb Hsb<delta};

soln0=minimize(delta,constr,ov,'sedumi');    % loqo LP
%soln0=minimize(delta,constr,ov,'loqo');    % loqo LP
%soln0=minimize(delta,constr,ov,'boydsocp');    % loqo LP
%soln0=minimize(delta,constr,ov,'sdppack');    % sdppack LP

hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf;
H0=fft(hopt0,Nf);
plot(f,20*log10(abs([H0])));
%legend('loqo1','loqo2',0);
