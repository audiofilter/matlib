% farrow.m - optimize farrow structure for parameterized filter

InitOpt;
ov=newOptSpace;

L=4;  % number of polynomial terms
N=26; % filter lengths

% create filters
h={};
for l=1:L
	h{l}=optSequence(N,ov);
end;

% frequency responses
df=1/(10*N);
fpb=0:df:0.45; Npb=length(fpb);
%pb=Process('Box',0.5,[1 1 0 1 1]);
H={};
for l=1:L
	H{l}=fourier(h{l},fpb);
end;

% constraints
dtau=0.025;
tau=0:dtau:0.5;

delta=optVar(ov);
constr={};
MSE=optQuad(0,-1,-1,ov);   % this hack must be fixed!
for k=1:length(tau)
	Hid=exp(-j*2*pi*fpb*((N-1)/2+tau(k)));
	Htmp=H{1};
	for l=2:L
		Htmp=Htmp+H{l}*tau(k)^(l-1);
	end;
	constr=[constr, {sum(abs(Htmp-Hid).^2)/Npb<delta.^2}];
	MSE=MSE+sum(abs(Htmp-Hid).^2)/(Npb*length(tau));
end;
%constr={MSE<delta.^2};

%soln=minimize(delta,constr,ov,'mosekdual');
soln=minimize(delta,constr,ov,'sedumi');
dB(double(optimal(delta,soln)))

hopt=zeros(L,N);
for l=1:L
	hopt(l,:)=double(optimal(h{l},soln));
end;

Nplot=2000; fplot=(0:Nplot-1)/Nplot-0.5;
Hopt=fftshift(fft(hopt,Nplot,2),2);

tauplot=tau; Ntau=length(tauplot);
Tau=repmat(tauplot.',1,L).^repmat(0:L-1,Ntau,1);
Hsum=Tau*Hopt;

figure(1);
subplot(2,1,1);
plot(fplot,dB(Hopt));
axis([0 0.5 -30 11]); grid;
subplot(2,1,2);
plot(fplot,GroupDelay(Hopt,fplot(2)-fplot(1))-(N-1)/2);
axis([0 0.5 -0.1 0.6]);grid;

figure(2);
subplot(2,1,1);
plot(fplot,dB(Hsum));
axis([0 0.5 -1 0.25]); grid;
subplot(2,1,2);
plot(fplot,GroupDelay(Hsum,fplot(2)-fplot(1))-(N-1)/2);
axis([0 0.5 -0.1 0.6]);grid;
