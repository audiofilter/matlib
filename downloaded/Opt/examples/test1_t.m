% test1_t.m - demonstrate trick to bound linear-phase passband by
% 1/t < H < t

  % toolbox initialization
InitOpt; tic;
ov=newOptSpace;
  % define filters
N=10;
rt=optSequence(N,ov);
ct=optSequence(1,ov);
h=(rt|1)'+ct+(rt|1);

% frequency gridding setup
df=1/(50*N);
fpb=[0:df:0.25];   Npb=length(fpb);
fsb=[0.35:df:0.5];  Nsb=length(fsb);
Hpb=fourier(h,fpb);
Hsb=fourier(h,fsb);

% Linf examples using 1-t<H<t and 1/t<H<t
t=optVar(ov);
constr0={1-t<Hpb, Hpb<1+t, -10^(-50/20)<Hsb, Hsb<10^(-50/20)};
soln0=minimize(t,constr0,ov,'sedumi');
u=optVar(ov);
constr1={u<Hpb, Hpb<t, abs(u-t+2*j)<u+t, -10^(-50/20)<Hsb, Hsb<10^(-50/20)};
soln1=minimize(t,constr1,ov,'sedumi');
topt0=double(optimal(t,soln0))
topt1=double(optimal(t,soln1))
uopt=double(optimal(u,soln1))
toc
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln0=minimize(delta,constr,ov,'loqosoclp','testPlot'); hold off;

Nf=2000; f=(0:Nf-1)/Nf;
hopt0=double(optimal(h,soln0));
hopt1=double(optimal(h,soln1));
H0=fft(hopt0,Nf);
H1=fft(hopt1,Nf);
plot(f,20*log10(abs([H0;H1])));grid;
axis([0 1 -60 5]);
