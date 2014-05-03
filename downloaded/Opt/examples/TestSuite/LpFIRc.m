% LpFIRc.m
% Real, Nonlinear-Phase FIR optimization with Lp norm, p>=2
% Compare to Burdakov's epsilon-norm and McClellan's epsilon-norm
% both mix L2 and Linf

% gridding setup 
K=201;  % filter length
tau=50;
p=4;   % order of the norm
df=1/(20*K*(1+3/p));
fpb=[0:df:0.285];   Npb=length(fpb);
fsb=[0.3:df:0.5]; Nsb=length(fsb);
Dpb=ones(size(fpb));
Dsb=zeros(size(fsb));
fgrid=[fpb,fsb]; Ngrid=length(fgrid);
%Dgrid=[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau);
Dgrid=optGenSequence(fgrid,[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau));
%Wgrid=[ones(1,Npb), 10*ones(1,Nsb)];
Wgrid=[ones(1,Npb), 5*ones(1,Nsb)];
%Wgrid=[1/100*ones(1,Npb), 1*ones(1,Nsb)];  % need to adjust tols. for this
% plotting grid
Nf=2000; f=(0:Nf-1)/Nf;

% now do optimization with epsilon norms
%

InitOpt;
ov=newOptSpace;
h=optSequence(K,ov);
Hgrid=fourier(h,fgrid);
%Hpb=fourier(h,fpb);
%Hsb=fourier(h,fsb);
Egrid=Wgrid.*(Hgrid-Dgrid);

nu=optVar(ov);

% Linf solution
constr={abs(Egrid)<nu};
%soln1=minimize(nu,constr,ov,'mosekdual');
soln1=minimize(nu,constr,ov,'sedumi_dump','firLinf');

% L2 solution
constr={sum(abs(Egrid).^2)*df<nu.^2};
%soln2=minimize(nu,constr,ov,'mosekdual');
soln2=minimize(nu,constr,ov,'sedumi_dump','firL2a');

% gamma*L2 + (1-gamma)*Linf solution
delta=optVar(ov);
%gamma=0.95; % p=2.5
%gamma=0.8; % p=4
gamma=0.75; % p=4
%hopt12=[];
%for gamma=0:0.1:1
constr={sum(abs(Egrid).^2)*df<delta.^2, abs(Egrid)<nu};
%soln12=minimize(gamma*delta+(1-gamma)*nu,constr,ov,'mosekdual');
soln12=minimize(gamma*delta+(1-gamma)*nu,constr,ov,'sedumi_dump','firL2Linfalph');
%hopt12=[hopt12;double(optimal(h,soln12))];
%end;

% aux variables for Leps constraint
ugrid=optVector(Ngrid,ov)+j*optVector(Ngrid,ov);
vgrid=Egrid-ugrid;

%epsilon=0.7;   % p=2.2
%epsilon=0.5;   % p=2.5
%epsilon=0.32;  % p=3.0
%epsilon=0.2;   % p=4.0
%epsilon=0.18;   % p=4.0
epsilon=0.01;   % p=4.0
constr={0<delta, delta<0,...
		  sum(abs(ugrid).^2)*df<(epsilon*nu).^2,...
		  abs(vgrid)<(1-epsilon)*nu};
%soln3=minimize(nu,constr,ov,'mosekdual');
soln3=minimize(nu,constr,ov,'sedumi_dump','firL2Linfeps');

hopt1=double(optimal(h,soln1));
hopt2=double(optimal(h,soln2));
hopt12=double(optimal(h,soln12));
hopt3=double(optimal(h,soln3));

% plotting

% calculate frequency responses
Hopt1=fft(hopt1,Nf);
Hopt2=fft(hopt2,Nf);
Hopt12=fft(hopt12,Nf);
Hopt3=fft(hopt3,Nf);

% calculate error functions
W=zeros(size(f)); D=zeros(size(f));
ipb=find(f<=max(fpb)); 
W(ipb)=Wgrid(1)*ones(size(ipb)); 
D(ipb)=ones(size(ipb)).*exp(-j*2*pi*f(ipb)*tau);
isb=find(f>=min(fsb)); 
W(isb)=Wgrid(end)*ones(size(isb)); 
D(isb)=zeros(size(isb));
Eh1=W.*(Hopt1-D);
Eh2=W.*(Hopt2-D);
Eh12=W.*(Hopt12-D);
Eh3=W.*(Hopt3-D);

figure(1);
subplot(1,1,1);
plot(f,dB([Hopt1;Hopt2;Hopt3;Hopt12])); 
axis([0 0.5 -80 5]); grid;
legend('Linf','L2','Leps','L2+Linf');

figure(2);
plot(f,dB([Eh1;Eh2;Eh3;Eh12])); 
axis([0 0.5 -60 -20]); grid;
legend('Linf','L2','Leps','L2+Linf');

figure(3);
plot(f,dB([Eh3;Eh12])); 
axis([0 0.5 -60 -20]); grid;
legend('Leps','L2+Linf');
