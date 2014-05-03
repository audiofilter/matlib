InitOpt;
ov=newOptSpace;

N=35; tau=(N-1)/2+0;
ct=optSequence(1,ov);
rt=optSequence(N,ov)|1;
h=rt'+ct+rt;
%h=optSequence(N,ov);

df=1/(20*N);
fpb=[0:df:0.175]; Npb=length(fpb);
fsb=[0.2:df:0.5]; Nsb=length(fsb);
Hpb=real(fourier(h,fpb));
Hsb=real(fourier(h,fsb));

nu=optVar(ov);

% Linf solution
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  -nu<Hsb, Hsb<nu};
soln1=minimize(nu,constr,ov,'sedumi');

% L2 solution
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  sum(abs(Hsb).^2)/Nsb<nu.^2};
soln2=minimize(nu,constr,ov,'sedumi');

% aux variables for Leps constraint
usb=optGenSequence(fsb,ov);
vsb=Hsb-usb;

epsilon=0.33333;
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  sum(abs(usb).^2)/Nsb<(epsilon*nu).^2,...
		  -(1-epsilon)*nu<vsb, vsb<(1-epsilon)*nu};
soln3=minimize(nu,constr,ov,'sedumi');
%soln3=minimize(nu,constr,ov,'loqosoclp');
% note: LOQO faster than SeDuMi here because sparsity is preserved.
% could use primal problem in SeDuMi for the same effect.

hopt1=optimal(h,soln1);
hopt2=optimal(h,soln2);
hopt3=optimal(h,soln3);
Nplot=1000; fplot=(0:Nplot)/Nplot/2;
Hopt1=freqz(double(hopt1),1,2*pi*fplot);
Hopt2=freqz(double(hopt2),1,2*pi*fplot);
Hopt3=freqz(double(hopt3),1,2*pi*fplot);
plot(fplot,dB([Hopt1;Hopt2;Hopt3])); grid;
axis([0 0.5 -80 5]);
legend('Linf','L2','Leps');
