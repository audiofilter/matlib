% testdelay.m - demonstrate effect of varying the approximate delay of a
%               complex, nonlinear-phase FIR filter 

  % plotting setup (for loqo calls to intermediate result plotting routine)
global f Nf h handle;
Nf=4000; f=(0:Nf-1)/Nf;

  % toolbox initialization
InitOpt;
ov=newOptSpace;
  % define filters
N=21;
a=optSequence(N,ov);
b=optSequence(N,ov);
h=a+j*b;   % h is causal response
delta=optVar(ov);  % auxiliary variable

% frequency gridding setup
df=1/(10*N);
fpb=[0.15:df:0.55];           Npb=length(fpb);
fsb=[0:df:0.05 0.65:df:1.0];  Nsb=length(fsb);
Hpb=fourier(h,fpb);
Hsb=fourier(h,fsb);

Delta=[];
for tau=0:0.25:10
  Href=exp(-j*2*pi*tau*fpb);
  
  % Linf stopband
  constr={abs(Hpb-Href)<1-10^(-0.1/20) abs(Hsb)<delta};
  soln0=minimize(delta,constr,ov,'sedumi');
  %hold on; handle=plot(0); axis([0 1 -80 5]);
  %soln0=minimize(delta,constr,ov,'loqosoclp','testPlot'); hold off;
  
  % L2 stopband
  constr={abs(Hpb-Href)<1-10^(-0.1/20) sum(abs(Hsb).^2)/Nsb<delta.^2};
  %constr1={sum(abs(Hpb-Href).^2)/Npb+sum(abs(Hsb).^2)/Nsb<delta.^2};
  %constr2={sum(abs(Hpb-Href).^2)/Npb<(1-10^(-0.1/20))^2,...
  %         sum(abs(Hsb).^2)/Nsb<delta.^2};
  soln2=minimize(delta,constr,ov,'sedumi');
  %hold on; handle=plot(0); axis([0 1 -80 5]);
  %soln2=minimize(delta,constr,ov,'loqosoclp','testPlot'); hold off;
  
  Delta=[Delta;...
	 [dB(double(optimal(delta,soln0))) dB(double(optimal(delta,soln2)))]];
  plot(0:0.25:tau,Delta); drawnow;
end;


if(0)
hopt0=double(optimal(h,soln0));
hopt2=double(optimal(h,soln2));
H0=fft(hopt0,Nf);
H2=fft(hopt2,Nf);
plot(f,20*log10(abs([H0;H2])));grid;
axis([0 1 -60 5]);
Linf=dB(double(optimal(delta,soln0)));
L2=dB(double(optimal(delta,soln2)));
legend(['L_\infty=' num2str(Linf,3) ' dB'],...
       ['L_2=' num2str(L2,3) ' dB']);
end;