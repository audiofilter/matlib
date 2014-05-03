% firL2a.m
% L2 Nonlinear-Phase FIR filter optimization
% Dan Scholnik (scholnik@nrl.navy.mil)

K=1001;  % filter length
tau=K/3;
df=1/(40*K);
fpb=[0:df:0.3-2.5/K];   Npb=length(fpb);
fsb=[0.3:df:0.5]; Nsb=length(fsb);
Dpb=ones(size(fpb));
Dsb=zeros(size(fsb));
fgrid=[fpb,fsb]; Ngrid=length(fgrid);
Dgrid=optGenSequence(fgrid,[Dpb,Dsb].*exp(-j*2*pi*fgrid*tau));
Wgrid=optGenSequence(fgrid,[ones(1,Npb), 5*ones(1,Nsb)]);

InitOpt;
ov=newOptSpace;
h=optSequence(K,ov);
nu=optVar(ov);
constr={L2fnorm(h,fgrid,Wgrid,Dgrid)<nu.^2};
soln=minimize(nu,constr,ov,'sedumi_dump_nosolve','firL2a');
%soln=minimize(nu,constr,ov,'sedumi_dump','firL2a');
