% wbarray10.m - MATLAB Opt toolbox design of wideband, 1-D beams
% add array-of-beams representation for true-L2 stopband
% switch to low frequency (L-band, 1.05-1.45 GHz)
% add noise-gain constraint
% only constrain a single passband angle
% widen Linf collar 
% make beam symmetric by using sin-space constraints
% reference beamwidth to baseband for comparison to NB
% switch to LS passband
tic;        %start counter
InitOpt;
ov=newOptSpace;
 
% units
m=1;
s=1; ms=1e-3*s; us=1e-6*s; ns=1e-9*s; ps=1e-12*s;
Hz=1/s; MHz=1e6*Hz; GHz=1e9*Hz;
rad=1; deg=pi/180*rad;
c=3e8*m/s;

% parameters
N=7;  % # of array elements = 2*N+1
M=10; % # of taps per element = 2*M+1
fs=1*GHz; Ts=1/fs;
fc=1.25*GHz;   % carrier freq.
BW=400*MHz;
del=c/(fc+BW/2)/2; % single element spacing
dsub=1*del;    % subarray spacing
phi=45*deg;    % pointing angle
alpha=0*deg;   % "passband" beamwidth
tran=12*deg;   % transition for Linf collar (referenced to baseband)
collar=90*deg; % Linf collar width (ref. to baseband)
tran2=tran;    % transition for L2 norm (ref. to baseband)

% create cell array of element filters
ct=optSequence(1,ov);
rt=optSequence(M,ov);
h={};
h{1}=(rt|1)'+ct+(rt|1);  % center element is linear phase
for k=2:N+1
  h{k}=optSequence(2*M+1,ov)|-M;
end;

% convert to equivalent array of beams
b={};
for m=0:M
  temp=h{1}(m,m)|(-m);
  for n=1:N
    temp=temp+(h{n+1}(m,m)|(n-m))+(h{n+1}(-m,-m)|(n+m))';
  end;
  b{m+1}=temp;
end;

% frequency grid
df=16*MHz;
f=(fc-BW/2):df:(fc+BW/2);
%f=fc;
Nf=length(f);
fn=f/fs;
H={};
for k=1:N+1
  H{k}=fourier(h{k},fn);
end;

% angle grid
dtheta=1*deg; du=sin(dtheta);
thetapb=[42 43 44 45 46 47 48]*deg; upb=sin(thetapb);
Npb=length(thetapb);
%thetasb=[(phi+alpha/2+tran):2*dtheta:(phi+alpha/2+tran+collar),...
%         (phi-alpha/2-tran):-2*dtheta:(phi-alpha/2-tran-collar)];
u1a=sin(phi)-sin(tran); u1b=sin(-60*deg);
u2a=sin(phi)+sin(tran); u2b=sin(90*deg);
usb=[u1a:-du:u1b, u2a:du:min(u2b,1), 1]; % append 90*deg
thetasb=asin(usb);
Nsb=length(thetasb); 
Apb=beam(H,f,thetapb,dsub);
Asb=beam(H,f,thetasb,dsub);

% funny stopband
theta1=[-10:10]*deg;
f1=(1.1:0.005:1.20)*GHz;
N1=length(theta1);
H1={};
for k=1:N+1
  H1{k}=fourier(h{k},f1/fs);
end;
A1=beam(H1,f1,theta1,dsub);

% aux vars
beta=optVector(Npb,ov);  % individual angle bounds, passband
delta=optVar(ov); % linear objective for SeDuMi

% constraints
constr={};
% funny stopband
for k=1:N1
  constr=[constr {-10^(-45/20)<A1{k} A1{k}<10^(-45/20)}];
end;
% passband L2
for k=1:Npb
%  constr=[constr {10^(-0.02/20)*beta(k)<Apb{k} Apb{k}<10^(0.02/20)*beta(k)}];
  constr=[constr {sum((optVector(Apb{k})-beta(k)).^2)/Nf<10^(-60/10)}];
end;
constr=[constr {1<sum(beta)/Npb}];  % this should be an equality
%constr=[constr {sum(beta)/Npb==1}]; 
% stopband Linf collar
for k=1:Nsb
  constr=[constr {-10^(-25/20)<Asb{k} Asb{k}<10^(-25/20)}];
end;
% spatial process inputs for stopband L2
B=TDLbeam(b,f,Ts); % get equivalent narrowband beam for each freq
Np=10000;
v=[(0:Np/2-1)+0.5 (-Np/2+1:0)-0.5]/Np;       % normalized frequency
u1a=sin(-90*deg); u1b=sin(phi)-sin(tran2);   % stopband edges
u2a=sin(phi)+sin(tran2); u2b=sin(90*deg);
for k=1:Nf
  lambda=c/f(k);      % wavelength for current freq
  u=2*lambda*v/dsub;  % direction sine
  S=zeros(1,Np);
  ind=find((u>=u1a & u<=u1b) | (u>=u2a & u<=u2b)); % find stopband region
  S(ind)=2*lambda/dsub./cos(asin(u(ind))); % S=1*dv
  sb=Process('Triangle',0.5,S);    % process with power in sidelobe region
  if(k==1)  
    Psb=pwr(sb.*(B{k}./2)); % interpolation allows process spec. on [0,2)
  else
    Psb=Psb+pwr(sb.*(B{k}./2));
  end;    
end;
% temporal process for noise gain constraint
noise=Process('Box',0,[1]);  % white noise
Pns=pwr(noise.*h{1});
for k=2:N+1
  Pns=Pns+2*pwr(noise.*h{k});
end;

% solve
%soln=minimize(Psb,constr,ov,'loqo'); % L2
soln=minimize(delta,[{Psb<delta.^2}, {Pns<1.4/(2*N+1)}, constr],ov,'sedumi');
%soln=minimize(delta,[{Psb<delta.^2}, {Pns<1.1/(2*N+1)}, constr],ov,'loqosoclp');
%soln=minimize(delta,[{Psb<delta.^2}, {Pns<1.1/(2*N+1)}, constr],ov,'loqosoclp','udplot');
toc
hopt=[];
for k=1:N+1
  hopt(k,:)=double(optimal(h{k},soln));
end;

% plot
th=(-90:1:90)*deg;
u=sin(th);
Nth=length(th);
[Hopt,fH]=TDLfreqM2(hopt,1000,1/fs,-M/fs,0,3000);
%[Hopt,fH]=TDLfreqM2(hopt,1000,1/fs,-M/fs,fc-fs/2,1000);
NfH=length(fH);
A=repmat(Hopt(1,:),Nth,1);
for n=1:N
  A=A+2*real(repmat(Hopt(n+1,:),Nth,1).*exp(-j*2*pi/c*n*dsub*u'*fH));
end;
figure(1);
subplot(1,1,1);
surf(th/deg,fH(1:10:NfH)/MHz,dB(A(1:1:Nth,1:10:NfH)'));
axis([th(1)/deg th(Nth)/deg 1000 1500 -45 0]);
caxis([-45 0]);
shading interp;
colorbar;

tau_id=(0:N)*dsub/c*sin(phi);
Hgd=GroupDelay(Hopt,fH(2)-fH(1));
figure(2);
subplot(2,1,1);
plot(fH/MHz,dB(Hopt));
axis([(fc-fs/4)/MHz (fc+fs/4)/MHz -60 10]);
grid;
subplot(2,1,2);
plot(fH/MHz,Hgd/ns);
hold on;
plot(fH/MHz,repmat(-tau_id'/ns,1,NfH));
hold off;
axis([(fc-fs/4)/MHz (fc+fs/4)/MHz -(tau_id(N+1)+tau_id(2))/ns tau_id(2)/ns]);
%legend('n=0','1','2','3',0);

figure(3);
subplot(2,1,1);
plot(th/deg,dB(A(:,1051:50:1451)));
%plot(th/deg,dB(A(:,301:50:701)));
axis([-90 90 -40 2]); grid;
xlabel('angle (deg)'); ylabel('dB');
title('Beams vs. angle and freq');
subplot(2,1,2);
plot(fH/MHz,dB(A(131:141,:)));
axis([(fc-fs/4)/MHz (fc+fs/4)/MHz -4 0.3]);
grid;
xlabel('freq (MHz)'); ylabel('dB');

