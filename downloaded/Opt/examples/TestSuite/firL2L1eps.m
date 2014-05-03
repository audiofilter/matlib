% firL2L1eps.m
% mixed L2/L1 Nonlinear-Phase FIR filter optimization
% Dan Scholnik (scholnik@nrl.navy.mil)

K=201;  % filter length
tau=K/3;
df=1/(40*K);
fpb=[0:df:0.3-2.5/K];   Npb=length(fpb);
fsb=[0.3:df:0.5]; Nsb=length(fsb);
Dpb=ones(size(fpb));
Dsb=zeros(size(fsb));
fgrid=[fpb,fsb]; Ngrid=length(fgrid);
Dgrid=optGenSequence(fgrid,[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau));
Wgrid=optGenSequence(fgrid,[ones(1,Npb), 10*ones(1,Nsb)]);

InitOpt;
ov=newOptSpace;
h=optSequence(K,ov);
Hgrid=fourier(h,fgrid);
Egrid=Wgrid*(Hgrid-Dgrid);
nu=optVar(ov);
beta=optVector(Ngrid,ov);
epsilon=0.18;
constr={sum(abs(Egrid).^2)<nu.^2, abs(Egrid)<beta};
soln=minimize(epsilon*nu+(1-epsilon)*sum(beta),...
	             constr,ov,'sedumi_dump_nosolve','firL2L1eps');
%soln=minimize(epsilon*nu+(1-epsilon)*sum(beta),...
%	             constr,ov,'sedumi_dump','firL2L1eps');
