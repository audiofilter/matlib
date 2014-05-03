% testenorm3 - try epsilon norm, but mixing L1 and L2

InitOpt;
ov=newOptSpace;

N=205; tau=(N-1)/2+0;
ct=optSequence(1,ov);
rt=optSequence(N,ov)|1;
h=rt'+ct+rt;
%h=optSequence(N,ov);

df=1/(20*N);
fpb=[0:df:0.195]; Npb=length(fpb);
fsb=[0.2:df:0.5]; Nsb=length(fsb);
Hpb=real(fourier(h,fpb));
Hsb=real(fourier(h,fsb));

nu=optVar(ov);

% Linf solution
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  -nu<Hsb, Hsb<nu};
soln0=minimize(nu,constr,ov,'sedumi');
%soln0=minimize(nu,constr,ov,'mosekdual');

% L2 solution
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  sum(abs(Hsb).^2)/Nsb<nu.^2};
soln2=minimize(nu,constr,ov,'sedumi');
%soln2=minimize(nu,constr,ov,'mosekdual');

% L1 solution
beta=optVector(Nsb,ov);
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		  -beta<Hsb, Hsb<beta, sum(beta)/Nsb<nu};
soln1=minimize(nu,constr,ov,'sedumi');
%soln1=minimize(nu,constr,ov,'mosekdual');

% aux variables for Leps constraint
usb=optGenSequence(fsb,ov);
vsb=Hsb-usb;

epsilon=0.1;
constr={10^(-0.1/20)<Hpb, Hpb<10^(0.1/20),...
		sum(abs(usb).^2)<(epsilon*nu).^2,...
		-beta<vsb, vsb<beta,	sum(beta)<(1-epsilon)*nu};
soln3=minimize(nu,constr,ov,'sedumi');
%soln3=minimize(nu,constr,ov,'loqosoclp');
%soln3=minimize(nu,constr,ov,'mosekdual');
% note: LOQO faster than SeDuMi here because sparsity is preserved.
% could use primal problem in SeDuMi for the same effect.

hopt0=optimal(h,soln0);
hopt1=optimal(h,soln1);
hopt2=optimal(h,soln2);
hopt3=optimal(h,soln3);
Nplot=4000; fplot=(0:Nplot)/Nplot/2;
Hopt0=freqz(double(hopt0),1,2*pi*fplot);
Hopt1=freqz(double(hopt1),1,2*pi*fplot);
Hopt2=freqz(double(hopt2),1,2*pi*fplot);
Hopt3=freqz(double(hopt3),1,2*pi*fplot);
plot(fplot,dB([Hopt0;Hopt1;Hopt2;Hopt3])); grid;
axis([0 0.5 -80 5]);
legend('Linf','L1','L2','Leps');
