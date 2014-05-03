% testgrid.m - demonstrate Linf passband and Linf, L2, and L1 stopbands in a
% complex, nonlinear-phase FIR filter using frequency gridding

  % plotting setup (for loqo calls to intermediate result plotting routine)
global f Nf h handle;
Nf=4000; f=(0:Nf-1)/Nf;

  % toolbox initialization
InitOpt;
ov=newOptSpace;
  % define filters
N=11;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;   % z is causal response
h=z|-7;   % adjust approximated delay by shifting h
wire=optSequence([1]);

% frequency gridding setup
fpb=[0.15:1/(10*N):0.55];                 Npb=length(fpb);
fsb=[0:1/(20*N):0.05 0.65:1/(20*N):1.0];  Nsb=length(fsb);
Hpb=fourier(h,fpb);
Hpb1=fourier(h-wire,fpb);
Hsb=fourier(h,fsb);

% Linf examples - gridded
delta=optVar(ov);
constr={abs(Hpb1)<1-10^(-0.1/20) abs(Hsb)<delta};
%constr={abs(Hpb1)<delta abs(Hsb)<10^(-40/20)};
%soln0=minimize(delta,constr,ov,'boydsocp');
soln0=minimize(delta,constr,ov,'sedumi');
%soln0=minimize(delta,constr,ov,'mosek2dual');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln0=minimize(delta,constr,ov,'loqosoclog','testPlot'); hold off;

pause;

% L2 examples - gridded
constr={abs(Hpb1)<1-10^(-0.1/20) sum(abs(Hsb).^2)/Nsb<delta.^2};
%soln2=minimize(delta,constr,ov,'mosek2dual');
soln2=minimize(delta,constr,ov,'sedumi');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln2=minimize(delta,constr,ov,'loqosoclog','testPlot'); hold off;

pause;

% L1 examples - gridded
beta=optVector(Nsb,ov);
constr={abs(Hpb1)<1-10^(-0.1/20) abs(Hsb)<beta};
soln1=minimize(sum(beta)/Nsb,constr,ov,'sedumi');
%soln1=minimize(sum(beta)/Nsb,constr,ov,'mosek2dual');
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln1=minimize(sum(beta),constr,ov,'loqosoclog','testPlot'); hold off;

pause;

hopt0=double(optimal(h,soln0));
hopt1=double(optimal(h,soln1));
hopt2=double(optimal(h,soln2));
H0=fft(hopt0,Nf);
H1=fft(hopt1,Nf);
H2=fft(hopt2,Nf);
plot(f,20*log10(abs([H0;H2;H1])));grid;
axis([0 1 -60 5]);
Linf=dB(double(optimal(delta,soln0)));
L2=dB(double(optimal(delta,soln2)));
L1=dB(double(optimal(sum(beta)/Nsb,soln1)));
legend(['L_\infty=' num2str(Linf,3) ' dB'],...
       ['L_2=' num2str(L2,3) ' dB'],...
       ['L_1=' num2str(L1,3) ' dB']);
