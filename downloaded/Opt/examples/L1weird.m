global handle f h Nf;
InitOpt; ov=newOptSpace;

N=25;
gridDensity=N*25;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
tau=5;
h=z|-tau;

fpb=[0.05:1/(gridDensity):0.5];
delta=optSequence([1]);
Hpb1=fourier(h-delta,fpb);
Npb=length(fpb);

fsb=[.6:1/(gridDensity):0.9];
Hsb=fourier(h,fsb);
Nsb=length(fsb);

beta=optVector(Nsb,ov);
constr={abs(Hpb1)<1-10^(-0.1/20),abs(Hsb)<beta;}

Nf=gridDensity*4;
f=(0:Nf-1)/Nf;
delete(gca); hold on;
handle=plot(f,zeros(1,Nf));
SetAXIS(gca,[0 1  -80 10],[.05 .5 .6 .9],[(-80:10:10)]); grid;

soln=minimize(sum(beta),constr,ov,'loqosoclp','replot'); hold off;
