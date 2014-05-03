InitOpt;
ov=newOptSpace;
N=12;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
%c=optSequence(1,ov);
%h=(z|1)'+c+(z|1);
h=z|-(6);

rms=optVector(1,ov);
ms=energy(rms);
constr={};
wire=optSequence([1]);
for nu=.05:1/(10*N):.55
  H=fourier(h-wire,nu);
  constr=[constr {energy(H)<ms}];
end;
for nu=0.65:1/(10*N):0.9
  H=fourier(h,nu);
  constr=[constr {energy(H)<10^(-40/10)}];
%  constr=[constr {10^(40/10)*energy(H)<1}];
end;

%soln1=minimize(ms,constr,ov,'loqosocp');    % socp
%soln2=minimize(rms,constr,ov,'loqosocp');    % socp
%soln1=minimize(rms,constr,ov,'loqosoclp');    % socp
%soln1=minimize(rms,constr,ov,'sdppack');   
soln1=minimize(rms,constr,ov,'mosekdual');   
soln2=minimize(rms,constr,ov,'sedumi');   

%plotting
hopt1=full(get_h(optimal(h,soln1)));
hopt2=full(get_h(optimal(h,soln2)));
%hopt3=full(get_h(optimal(h,soln3)));
%hopt4=full(get_h(optimal(h,soln4)));
Nf=4000;
f=(0:Nf-1)/Nf;
H1=fft(hopt1,Nf);
H2=fft(hopt2,Nf);
%H3=fft(hopt3,Nf);
%H4=fft(hopt4,Nf);
plot(f,20*log10(abs([H1;H2])));
%plot(f,20*log10(abs([H1;H2;H3;H4])));
%legend('loqo1','loqo2','boydsocp','spdpack',0);
legend('loqo','sedumi',0);

