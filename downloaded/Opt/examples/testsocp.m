InitOpt;
ov=newOptSpace;
N=11;
%a=optSequence(N,ov);
%b=optSequence(N,ov);
%z=a+j*b;
%c=optSequence(1,ov);
%h=(z|1)'+c+(z|1);
h=optSequence(N,ov);
pb=Process('Box',0, [1 0 0 0 0 0 0 0 0 0]);
sb=Process('Box',0, [0 1 1 1 1 1 1 1 1 1]);
%pb=Process('Box',0.5,[1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
%sb=Process('Box',0, [0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1]);
Psb=pwr(h.*sb);
wire=optSequence([1])|((N-1)/2-6);
Ppb=pwr(h.*pb-wire.*pb);      % affine

rms=optVector(1,ov);
soln0=minimize(rms,...
    {Psb<pwr(sb).*rms.^2,Ppb<pwr(pb).*10^(-40/10)},ov,'sedumi');    % sedumi
%soln0=minimize(rms,...
%    {Ppb<pwr(pb)*rms.^2},ov,'loqosoclp');    % sedumi
%soln0=minimize(rms,{sum(h)==1,Psb<ms},ov,'loqosoclp');    % sedumi

dB(double(optimal(rms,soln0)))
%plotting
hopt0=double(optimal(h,soln0));
Nf=4000;
f=(0:Nf-1)/Nf;
D=fft([ones(1,N+1), zeros(1,Nf-2*N-1), ones(1,N)]);
%d1=zeros(1,Nf); d1(2:2:N)=ones(1:
D1=fft([ones(1,N+1), zeros(1,Nf-2*N-1), ones(1,N)]);
H0=fft(hopt0,Nf);
figure(1);
plot(f,20*log10(abs([H0])));
legend('socp');
figure(2);
stem(hopt0);
