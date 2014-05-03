global f Nf h handle;
Nf=4000; f=(0:Nf-1)/Nf;
InitOpt;
ov=newOptSpace;
N=21;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
%c=optSequence(1,ov);
%h=(z|1)'+c+(z|1);
h=z|-(5);
wire=optSequence([1]);

% test-input setup
pb=Process('Box',0,[0 0 1 1 1 1 0 0 0 0]);
sb=Process('Box',0,[1 0 0 0 0 0 0 1 1 1]);
Ppb=pwr(pb.*h-pb);
Psb=pwr(sb.*h);

% gridding setup
fpb=[0.15:1/(10*N):0.55];
fsb=[0:1/(20*N):0.05 0.65:1/(20*N):1.0];
Hpb=fourier(h,fpb);
Hpb1=fourier(h-wire,fpb);
Hsb=fourier(h,fsb);
Npb=length(fpb);
Nsb=length(fsb);

% Linf examples - gridded
%delta=optVar(ov);
%constr={abs(Hpb1)<delta abs(Hsb)<10^(-40/20)};
%constr={abs(Hpb1)<delta abs(10^(40/20)*Hsb)<1};
%constr={abs(Hpb1)<1-10^(-0.1/20) abs(Hsb)<delta};
%constr={10^(-0.25/20)<Hpb Hpb<10^(0.25/20) -delta<Hsb Hsb<delta};
%soln=minimize(delta,constr,ov,'sedumi');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln=minimize(delta,constr,ov,'loqosoclp','testPlot'); hold off;

% L1 examples - gridded
%beta=optVector(Nsb,ov);
%constr={abs(Hpb1)<1-10^(-0.05/20) abs(Hsb)<beta};
%soln=minimize(sum(beta),constr,ov,'sedumi');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln=minimize(sum(beta),constr,ov,'loqosoclp','testPlot'); hold off;

% L2 examples - gridded
beta=optVector(Nsb,ov);
delta=optVar(ov);
constr={abs(Hpb1)<1-10^(-0.1/20) abs(Hsb)<beta sum(beta.^2)<delta.^2};
soln=minimize(delta,constr,ov,'sedumi');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln=minimize(delta,constr,ov,'loqosoclp','testPlot'); hold off;

% L2 examples - test input
%delta=optVar(ov);
%constr={Ppb<10^(-60/10) Psb<delta.^2}
%soln=minimize(delta,constr,ov,'sedumi');

hopt=full(get_h(optimal(h,soln)));
H=fft(hopt,Nf);
plot(f,20*log10(abs([H])));grid;
