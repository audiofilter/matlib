InitOpt;
ov=newOptSpace;

global handle f h Nf;

%N=50;
N=11;
gridDensity=N*25;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
%tau=25;
tau=5;
h=z|-tau;

%fpb=[0.03:1/(gridDensity):0.45];
fpb=[0.1:1/(gridDensity):0.4];
Hpb=fourier(h,fpb);
delta=optSequence([1]);
Hpb1=fourier(h-delta,fpb);
Npb=length(fpb);

%fsb=[-.45:1/(gridDensity):-0.03];
%fsb=[.55:1/(gridDensity):0.97;]
fsb=[.6:1/(gridDensity):0.9];
Hsb=fourier(h,fsb);
Nsb=length(fsb);

beta=optVar(ov);
%constr={abs(Hpb1)<1-10^(-0.1/20),abs(Hsb)<beta};
constr={abs(Hpb1)<1-10^(-1/20),abs(Hsb)<beta;}

Nf=gridDensity*4;

f=(0:Nf-1)/Nf;

delete(gca);
hold on;

handle=plot(f,zeros(1,Nf));

SetAXIS(gca,[0 1  -90 10],[0 .5 1],[(-90:10:10)]);

%soln=minimize(beta,constr,ov,'loqosoclp','replot');
%hold off;

soln=minimize(beta,constr,ov,'sedumi');
replot(soln)
hold off;


