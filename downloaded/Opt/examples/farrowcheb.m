% farrowlp.m - optimize farrow structure for parameterized filter
% lowpass and delta filter

InitOpt;
ov=newOptSpace;

L=8;  % number of polynomial terms
N=13; % filter lengths
T=ChebMat(L);

% create filters
h={};
for l=1:L
	h{l}=optSequence(N,ov);
end;

% constraints
df=1/(10*N);  %frequency grid spacing
dfc=0.025;    %center freuency step size
fc=0.0:dfc:0.5; Nfc=length(fc);

delta=optVar(ov);
constr={};
MSE=optQuad(0,-1,-1,ov);   % this hack must be fixed!
for k=1:Nfc
	fpb=fc(k)+(-0.05:df:0.05); fpb=fpb(find(fpb>=0 & fpb<=0.5));
	fsb=[0:df:fc(k)-0.1, fc(k)+0.1:df:0.5];
	Hid=exp(-j*2*pi*fpb*(N-1)/2);
	Htpb=fourier(h{1},fpb);
	Htsb=fourier(h{1},fsb);
	for l=2:L
		Htpb=Htpb+fourier(h{l},fpb)*polyval(T(l,:),2*fc(k));
		Htsb=Htsb+fourier(h{l},fsb)*polyval(T(l,:),2*fc(k));
	end;
	MSEtmp=sum(abs(Htpb-Hid).^2)/Npb+sum(abs(Htsb).^2)/Nsb;
	constr=[constr, {MSEtmp<delta.^2}];
	MSE=MSE+MSEtmp;
end;
%constr={MSE<delta.^2};

soln=minimize(delta,constr,ov,'sedumi');
%soln=minimize(delta,constr,ov,'mosekdual');
dB(double(optimal(delta,soln)))

hopt=zeros(L,N);
for l=1:L
	hopt(l,:)=double(optimal(h{l},soln));
end;

Nplot=2000; fplot=(0:Nplot-1)/Nplot-0.5;
Hopt=fftshift(fft(hopt,Nplot,2),2);

%fcplot=fc; 
fcplot=0:0.01:0.5;
Nfcplot=length(fcplot);

Fc=zeros(Nfcplot,L);
for l=1:L
	Fc(:,l)=polyval(T(l,:),2*fcplot');
end;
Hsum=Fc*Hopt;

figure(1);
subplot(2,1,1);
plot(fplot,dB(Hopt));
axis([0 0.5 0 120]); grid;
subplot(2,1,2);
plot(fplot,GroupDelay(Hopt,fplot(2)-fplot(1))-(N-1)/2);
axis([0 0.5 -0.1 0.6]);grid;

figure(2);
subplot(2,1,1);
plot(fplot,dB(Hsum));
axis([0 0.5 -60 5]); grid;
subplot(2,1,2);
plot(fplot,GroupDelay(Hsum,fplot(2)-fplot(1))-(N-1)/2);
axis([0 0.5 -0.1 0.6]);grid;

figure(3);
surf(fplot,fcplot,dB(Hsum));
top; shading interp;
caxis([-60 20]); colorbar;

if(0);
figure(4);
for k=1:Nfcplot
subplot(2,1,1);
plot(fplot,dB(Hsum(k,:)));
axis([0 0.5 -60 5]); grid;
subplot(2,1,2);
plot(fplot,GroupDelay(Hsum(k,:),fplot(2)-fplot(1))-(N-1)/2);
axis([0 0.5 -1 1]); grid;
pause;
end;
end;
