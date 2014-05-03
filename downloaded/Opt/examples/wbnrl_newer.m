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
N=10;  % # of array elements = 2*N+1
M=11; % # of taps per element = 2*M+1
fs=1*GHz; Ts=1/fs;
fc=1.25*GHz;   % carrier freq.
BW=400*MHz;
del=c/(fc+BW/2)/2; % single element spacing
dsub=1*del;    % subarray spacing
phi=45*deg;    % pointing angle
alpha=0*deg;   % "passband" beamwidth
tran=9*deg;   % transition for Linf collar (referenced to baseband)
collar=90*deg; % Linf collar width (ref. to baseband)
tran2=tran;    % transition for L2 norm (ref. to baseband)

% create array taps, one filter (array element) at a time
ct=optArray([0,0],ov);
rt=optArray([zeros(M,1),(1:M).'],ov);
for k=1:N
  rt=rt+optArray([repmat(k,2*M+1,1),(-M:M).'],ov);
end;
h=rt'+ct+rt;  % array is linear phase

% frequency grid for Linf constraints
df1=fs/(2*M+1)/5;
f1=(fc-BW/2):df1:(fc+BW/2);
Nf1=length(f1);
fn1=f1/fs;

% tighter frequency grid for L2 constraints
df2=fs/(2*M+1)/15;
f2=(fc-BW/2):df2:(fc+BW/2);
Nf2=length(f2);
fn2=f2/fs;

% angle grid - passband and Linf stopband collar
%dtheta=1*deg; du=sin(dtheta);
du=2/(2*N+1)/5; 
dtheta=asin(du);
thetapb=[42 43 44 45 46 47 48]*deg; upb=sin(thetapb);
Npb=length(thetapb);
%thetasb=[(phi+alpha/2+tran):2*dtheta:(phi+alpha/2+tran+collar),...
%         (phi-alpha/2-tran):-2*dtheta:(phi-alpha/2-tran-collar)];
u1a=sin(phi)-sin(tran); u1b=sin(-90*deg);
u2a=sin(phi)+sin(tran); u2b=sin(90*deg);
usb=[u1a:-du:u1b, u2a:du:min(u2b,1), 1]; % append 90*deg
thetasb=asin(usb);
Nsb=length(thetasb); 

% aux vars
beta=optVector(Npb,ov);  % individual angle bounds, passband
delta=optVar(ov); % linear objective for SeDuMi

toc
% constraints
constr={};

% passband L2
for k=1:Npb
	Apb=fourier(h,[-f2.'/c*dsub.*sin(thetapb(k)),f2.'/fs]);
	constr=[constr {sum((Apb-beta(k)).^2)/Nf2<10^(-50/10)}];
end;
constr=[constr {1<sum(beta)/Npb}];  % this should be an equality
clear Apb;  % free up some memory

% stopband Linf collar
[f0,theta0]=meshgrid(f1,thetasb);
Asb=fourier(h,[-f0(:)./c*dsub.*sin(theta0(:)),f0(:)/fs]);
constr=[constr {-10^(-25/20)<Asb Asb<10^(-25/20)}];
clear Asb f0 theta0;
toc

% funny Linf stopband
load nrl.coords
%theta0=-70*deg+nrl(:,1)*90*deg;
%f0=1.4*GHz-nrl(:,2)*0.2*GHz;
theta0=-80*deg+nrl(:,1)*100*deg;
f0=1.35*GHz-nrl(:,2)*0.2*GHz;
A0=fourier(h,[-f0./c*dsub.*sin(theta0),f0/fs]);
constr=[constr {-10^(-50/20)<A0 A0<10^(-50/20)}];
clear A0 f0 theta0;
toc

% stopband L2: 
%      uniform gridding in frequency
%      uniform gridding in theta, sin(theta), or spatial frequency?
du2=2/(2*N+1)/15; 
u1b=sin(-90*deg); u1a=sin(phi)-sin(tran2);   % stopband edges
u2a=sin(phi)+sin(tran2); u2b=sin(90*deg);
usb=[u1a:-du2:u1b, u2a:du2:u2b]; % uniform in sin(theta)
[f0,u0]=meshgrid(f2,usb);
Wsb=ones(size(f0));
%Psb=sum((fourier(h,[-f0(:)./c*dsub.*u0(:),f0(:)/fs])).^2)/length(f0(:));
Psb=L2fnorm(h,[-f0(:)./c*dsub.*u0(:),f0(:)/fs],1/length(f0(:)));
%sbproc=NDProcess('Impulse',[],[-f0(:)./c*dsub.*u0(:),f0(:)/fs],[Wsb(:)]);
%Psb=pwr(sbproc.*h);

% noise gain constraint - simple sum-of-squares of coefficients
Pns=sum(h.^2); % works via auto-cast to optVector then to optQuadVector

%toc
%soln=minimize(delta,...
%              [{Psb<delta.^2},{Pns<1.4/(2*N+1)},constr],...
%              ov,'loqosoclp');

%path(reorder_path('SeDuMi'));
%soln=minimize(delta,...
%              [{Psb<delta.^2},{Pns<1.4/(2*N+1)},constr],...
%              ov,'sedumi');

path(reorder_path('SDPT'));
soln=minimize(delta,...
              [{Psb<delta.^2},{Pns<1.4/(2*N+1)},constr],...
              ov,'sdpt3');
path(reorder_path('SeDuMi'));
			  
toc

% plot the results
hopt=optimal(h,soln);
fplot=(fc-fs/4):2*MHz:(fc+fs/4); 
Nfplot=length(fplot);
thetaplot=-90*deg:1*deg:90*deg;
Nthetaplot=length(thetaplot);
[F,Theta]=ndgrid(fplot,thetaplot);
Aopt=reshape(double(fourier(hopt,[-F(:)./c*dsub.*sin(Theta(:)),F(:)/fs])),...
	Nfplot,Nthetaplot);
imagesc(thetaplot/deg,fplot,dB(Aopt));
set(gca,'YDir','normal');
caxis([-50,0]);
colorbar;

%wbP(soln);
%mpgwrite(themovie,colormap,'nrl.mpg');
%delete(gcf);
