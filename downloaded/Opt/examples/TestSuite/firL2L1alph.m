% firL2L1alph.m
% mixed L1/Linf Nonlinear-Phase FIR filter optimization
% Dan Scholnik (scholnik@nrl.navy.mil)

K=101;  % filter length
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
ugrid=optGenSequence(fgrid,ov)+j*optGenSequence(fgrid,ov);
vgrid=Egrid-ugrid;
eta=0.75;
constr={abs(vgrid)<beta, sum(beta)<(1-eta)*nu,...
		  sum(abs(ugrid).^2)<(eta*nu).^2};
soln=minimize(nu,constr,ov,'sedumi_dump_nosolve','firL2L1alph');
%soln=minimize(nu,constr,ov,'sedumi_dump','firL2L1alph');
