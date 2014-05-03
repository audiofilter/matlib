% LpFIR1c.m
% Real, nonlinear-Phase FIR optimization with Lp norm, 1<=p<=2
% Compare to the duals of Burdakov's epsilon-norm and McClellan's norm
% both mix L2 and Linf

% gridding setup 
K=101;  % filter length
tau=30;
p=1.333333333;   % order of the norm
df=1/(20*K*(1+3/p)); % quasi-empirical guess
fpb=[0:df:0.275];   Npb=length(fpb);
fsb=[0.3:df:0.5]; Nsb=length(fsb);
Dpb=ones(size(fpb));
Dsb=zeros(size(fsb));
fgrid=[fpb,fsb]; Ngrid=length(fgrid);
%Dgrid=[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau);
Dgrid=optGenSequence(fgrid,[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau));
Wgrid=[ones(1,Npb), 10*ones(1,Nsb)];
%Wgrid=[1/100*ones(1,Npb), 1*ones(1,Nsb)];  % need to adjust tols. for this
% plotting grid
Nf=2000; f=(0:Nf-1)/Nf;

%
% now do optimization with epsilon dual norms using SOCP
%

InitOpt;
ov=newOptSpace;
h=optSequence(K,ov);
Hgrid=fourier(h,fgrid);
%Hpb=fourier(h,fpb);
%Hsb=fourier(h,fsb);
Egrid=Wgrid.*(Hgrid-Dgrid);

nu=optVar(ov);

% L2 solution
constr={sum(abs(Egrid).^2)*df<nu.^2};
%soln2=minimize(nu,constr,ov,'mosekdual');
soln2=minimize(nu,constr,ov,'sedumi_dump','firL2');

% L1 solution
beta=optVector(Ngrid,ov);
constr={abs(Egrid)<beta, sum(beta)*df<nu};
%soln1=minimize(nu,constr,ov,'mosekdual');
soln1=minimize(nu,constr,ov,'sedumi_dump','firL1');

% epsilon*L2 + (1-epsilon)*L1 solution
epsilon=0.18; % p=1.33333
%epsilon=0.25; % p=1.33333
%epsilon=0.35; % p=1.5
constr={sum(abs(Egrid).^2)*df<nu.^2, abs(Egrid)<beta};
%soln12=minimize(epsilon*nu+(1-epsilon)*sum(beta)*df,constr,ov,'mosekdual');
soln12=minimize(epsilon*nu+(1-epsilon)*sum(beta)*df,...
	             constr,ov,'sedumi_dump','firL2L1eps');

% gamma*Linf + (1-gamma)*L1 solution
gamma=0.1;
constr={abs(Egrid)<nu, abs(Egrid)<beta};
%soln01=minimize(gamma*nu+(1-gamma)*sum(beta)*df,constr,ov,'mosekdual');
soln01=minimize(gamma*nu+(1-gamma)*sum(beta)*df,...
	             constr,ov,'sedumi_dump','firL1Linfalph');

% epsilon-style combination of L1 and Linf
ugrid=optVector(Ngrid,ov)+j*optVector(Ngrid,ov);
vgrid=Egrid-ugrid;
alpha=0.1;
constr={abs(ugrid)<beta, sum(beta)*df<alpha*nu, abs(vgrid)<(1-alpha)*nu};
%soln3=minimize(nu,constr,ov,'mosekdual');
soln3=minimize(nu,constr,ov,'sedumi_dump','firL1Linfeps');

% epsilon-style combination of L1 and L2
eta=0.75;
%eta=0.85;
constr={abs(vgrid)<beta, sum(beta)*df<(1-eta)*nu,...
		  sum(abs(ugrid).^2)*df<(eta*nu).^2};
%soln4=minimize(nu,constr,ov,'mosekdual');
soln4=minimize(nu,constr,ov,'sedumi_dump','firL2L1alph');

hopt1=double(optimal(h,soln1));
hopt2=double(optimal(h,soln2));
hopt12=double(optimal(h,soln12));
hopt01=double(optimal(h,soln01));
hopt3=double(optimal(h,soln3));
hopt4=double(optimal(h,soln4));

% plotting

% calculate frequency responses
Hopt1=fft(hopt1,Nf);
Hopt2=fft(hopt2,Nf);
Hopt12=fft(hopt12,Nf);
Hopt01=fft(hopt01,Nf);
Hopt3=fft(hopt3,Nf);
Hopt4=fft(hopt4,Nf);

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
Eh01=W.*(Hopt01-D);
Eh3=W.*(Hopt3-D);
Eh4=W.*(Hopt4-D);

figure(1);
subplot(1,1,1);
plot(f,dB([Hopt1;Hopt2;Hopt12])); 
axis([0 0.5 -80 5]); grid;
legend('L1','L2','L1+L2');

figure(2);
plot(f,dB([Eh1;Eh2;Eh12])); 
axis([0 0.5 -60 -20]); grid;
legend('L1','L2','L1+L2');

figure(3);
plot(f,dB([Eh12;Eh4])); 
axis([0 0.5 -60 -20]); grid;
legend('L1+L2','Leps12');
