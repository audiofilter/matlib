InitOpt;
ov=newOptSpace;
N=19;
h=(optSequence(N,ov)+j*optSequence(N,ov))|(-9);

delta=optVector(1,ov);
dnu=1/(20*N);
%dnu=1/(80*N);

Delta=[];
%tau=7.45;
%for B=0:0.1:0.8
%B=0.25;
B=2*sin(15*pi/180)/2;
%for tau=5:0.1:9
for tau=5.1

nu_pb=-B/2:dnu:B/2; Npb=length(nu_pb);
%nu_pb=0.0:dnu:0.2;
nu_sb=[-0.5:dnu:-B/2 B/2:dnu:0.5]; Nsb=length(nu_sb);
nu_sb2=[-0.5:dnu:-0.2, 0.2:dnu:0.5];
Hpb=fourier(h,nu_pb); Hsb=fourier(h,nu_sb); Hsb2=fourier(h,nu_sb2);
Ppb=sum(abs(Hpb).^2)*dnu; Psb=sum(abs(Hsb).^2)*dnu;
constr={abs(h)<1,...		% limit coef. magnitude to 1
		Psb<10^(10/10),...			% limit stopband power (may be inactive)
		abs(Hsb2)<10^(15/20)...		% upper-bound stopband peaks (may be inactive)
		abs(Hpb)<10^(18.5/20),...		% upper-bound passband magnitude (may be inactive)
		abs(optVector(Hpb)-delta*exp(-j*2*pi*abs(nu_pb)*tau))<1.5}; % bound complex passband error
soln0=minimize(-delta,constr,ov,'sedumi');    % sedumi LP
%soln0=minimize(-delta,constr,ov,'loqosoclp');    % sedumi LP
%soln0=minimize(-delta,constr,ov,'mosekdual');    % sedumi LP
Delta=[Delta;[tau,double(optimal(delta,soln0))]]

%end;

hopt0=full(get_h(optimal(h,soln0)));
Nf=4000;
f=(0:Nf-1)/Nf-0.5;

H0=fftshift(fft(hopt0,Nf));
subplot(3,1,1);
plot(f,20*log10(abs([H0])));
axis([-0.5 0.5 -10 20]); grid;
subplot(3,1,2);
stem(abs(hopt0));
subplot(3,1,3);
stem(angle(hopt0)/pi*180);

B
optimal(Ppb,soln0)
optimal(Psb,soln0)
%pause;
end;
