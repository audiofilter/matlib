% firLinf.m
% L2 Nonlinear-Phase FIR filter optimization
% Dan Scholnik (scholnik@nrl.navy.mil)

K=401;  % filter length
tau=K/3;
df=1/(20*K);
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
Hgrid=fourier(h,fgrid);
Egrid=Wgrid*(Hgrid-Dgrid);
nu=optVar(ov);
constr={abs(Egrid)<nu};
clear Hgrid Egrid;
soln=minimize(nu,constr,ov,'sedumi_dump_nosolve','firLinf');
%soln=minimize(nu,constr,ov,'sedumi_dump','firLinf');
