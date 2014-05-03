% dsNRL.m
% 2-D delta-sigma loop filter optimization
% Dan Scholnik (scholnik@nrl.navy.mil)

InitOpt;
ov=newOptSpace;
 
% units
m=1;
s=1; ms=1e-3*s; us=1e-6*s; ns=1e-9*s; ps=1e-12*s;
Hz=1/s; MHz=1e6*Hz; GHz=1e9*Hz;
rad=1; deg=pi/180*rad;
c=3e8*m/s;

% parameters

Hinf=2;
K=10;  % # of spatial taps
Kx=K; % # of nonzero rows of taps
N=41; % # of temporal taps
theta0=0*deg; % center of noise notch
thetaW=180*deg; % width of noise notch
fs=2*GHz; Ts=1/fs;
fc=fs/4;   % carrier freq.
OSt=4; BW=fs/(2*OSt); % temporal oversampling ratio
OSx=4;  % spatial oversampling ratio (at fc)
d=c/(2*OSx*fc); % single element spacing
x=((K-Kx:K-1)-(K-1)/2)*d; % element tap locations
t=(0:N-1)*Ts;          % tap locations

column=5;  % which column of the matrix is this

InitOpt;
ov=newOptSpace;
% create optArray of taps
[causal_x, causal_t]=ndgrid(x,t(2:end));
acausal_x=x(column+Kx-K+1:end);
acausal_t=zeros(size(acausal_x));
ct=optArray([x(column+Kx-K),0],1);
g=optArray([causal_x(:),causal_t(:); acausal_x(:),acausal_t(:)],ov);
h=g+ct;

% frequency grid
dfpb=fs/(15*N);
fpb=(fc-BW/2+dfpb/2):dfpb:(fc+BW/2-dfpb/2);
Npb=length(fpb);
dfsb=fs/(5*N);
fsb=[(fc-fs/4):dfsb:(fc+fs/4)];
Nsb=length(fsb);

% angle grid
du=2/(15*K); dtheta=asin(du);
theta=theta0-thetaW/2:dtheta:theta0+thetaW/2;
Ntheta=length(theta);

% spatial fequency grid
dnu=1/(5*K*d); % not normalized spatial frequency
nu=-1/(2*d):dnu:1/(2*d); 

% aux vars
delta=optVar(ov); % linear objective for SeDuMi

% constraints
constr={};

% L2 stopband (over signal passband region)
[f1,theta1]=ndgrid(fpb,theta);
constr=[constr,...
		{L2fnorm(h,[-sin(theta1(:)).*f1(:)/c,f1(:)],1/(Npb*Ntheta))<delta.^2}];

% Linf over all frequencies
[f1,nu1]=meshgrid(fsb,nu);
Asb=fourier(h,[nu1(:),f1(:)]);
constr=[constr, {abs(Asb)<Hinf}];
clear Asb;

soln=minimize(delta, constr, ov,'sedumi_dump_nosolve','dsNRL');
