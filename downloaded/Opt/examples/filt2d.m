% filt2d.m - design of 2-D causal error filter for Space-Time Sigma-Delta
% 1st & 2nd quadrant causality (scanning)
global h fs M th u NfH Nth N c dsub deg MHz Hand themovie frame;
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

%Hinf=1.25^2;
Hinf=2;
K=11;  % # of spatial taps
N=11; % # of temporal taps
fs=2*GHz; Ts=1/fs;
%fc=1.5*GHz;   % carrier freq.
fc=fs/4;   % carrier freq.
OSt=4; BW=fs/(2*OSt); % temporal oversampling ratio
OSx=4;  % spatial oversampling ratio (at fc)
d=c/(2*OSx*fc); % single element spacing
x=((0:K-1)-(K-1)/2)*d; % element locations
t=(0:N-1)*Ts;          % tap locations

%column=1;  % which column of the matrix is this
hopt={}; hopt1={};
for column=1:K

InitOpt;
ov=newOptSpace;
% create optArray of taps
[causal_x, causal_t]=ndgrid(x,t(2:end));
acausal_x=x(column+1:end);
acausal_t=zeros(size(acausal_x));
ct=optArray([x(column),0],1);
h=optArray([causal_x(:),causal_t(:); acausal_x(:),acausal_t(:)],ov) + ct;

% frequency grid
dfpb=fs/(15*N);
fpb=(fc-BW/2+dfpb/2):dfpb:(fc+BW/2-dfpb/2);
Npb=length(fpb);
dfsb=fs/(5*N);
%fsb=[(fc-fs/4):df:(fc-BW/2)-df, (fc+BW/2)+df:df:(fc+fs/4)];
fsb=[(fc-fs/4):dfsb:(fc+fs/4)];
Nsb=length(fsb);

% angle grid
du=2/(15*K); dtheta=asin(du);
%dtheta=2*deg; du=sin(dtheta);
theta=-90*deg:dtheta:90*deg;
Ntheta=length(theta);

% spatial fequency grid
dnu=1/(5*K*d); % not normalized spatial frequency
nu=-1/(2*d):dnu:1/(2*d); 

% aux vars
delta=optVar(ov); % linear objective for SeDuMi

toc
% constraints
constr={};

% L2 stopband (over signal passband region)
[f1,theta1]=ndgrid(fpb,theta);
constr=[constr,...
		{L2fnorm(h,[-sin(theta1(:)).*f1(:)/c,f1(:)],1/(Npb*Ntheta))<delta.^2}];
%Apb=fourier(h,[-f1(:)/c.*d.*sin(theta1(:)),f1(:)]);
%constr=[constr, {sum(abs(Apb).^2)/(Npb*Ntheta)<delta.^2}];
%clear Apb;

toc
% Linf over all frequencies
[f1,nu1]=meshgrid(fsb,nu);
Asb=fourier(h,[nu1(:),f1(:)]);
constr=[constr, {abs(Asb)<Hinf}];
clear Asb;

toc
%soln=minimize(delta,...
%              [{Psb<delta.^2},{Pns<1.4/(2*N+1)},constr],...
%              ov,'loqosoclog','wbP');
%soln=minimize(delta,...
%              [{Psb<delta.^2},{Pns<1.9/(2*N+1)},NRLconstr,constr],...
%              ov,'sedumi');
%soln=minimize(delta, constr, ov,'mosekdual');
soln=minimize(delta, constr, ov,'sedumi');
toc
deltaopt=dB(double(optimal(delta,soln)))

hopt{column}=double(optimal(h,soln));
hopt1{column}=zeros(K,N);
hopt1{column}(1:column-1,2:N)=reshape(hopt{column}(1:(column-1)*(N-1)),N-1,column-1)';
hopt1{column}(column:K,1:N)=reshape(hopt{column}((column-1)*(N-1)+1:end),N,K-column+1)';

end; %for column=1:K

% plot the results
Nfplot=500;
fplot=(0:Nfplot-1)/(2*Nfplot)*fs+fc-fs/4;
Nnuplot=1000;
nuplot=(0:Nnuplot-1)/Nnuplot/d-1/(2*d);
[Nu,F]=ndgrid(nuplot,fplot);
%Hopt=reshape(double(fourier(hopt,[Nu(:),F(:)])),Nnuplot,Nfplot);

Hopt1={};
Hsum=zeros(Nnuplot,Nfplot);
for column=1:K
	tmpH=fftshift(fft2(hopt1{column},Nnuplot,2*Nfplot),1);
	Hopt1{column}=tmpH(:,1:Nfplot);
	Hsum=Hsum+abs(Hopt1{column}).^2/K;
end;
clear tmpH;
Hopt1{column+1}=sqrt(Hsum);

figure(1); clf; wysiwyg;
fontname='Times';
fontsize=[14];
set(gcf,'DefaultTextFontName',fontname,'DefaultTextFontSize',fontsize);
set(gcf,'DefaultAxesFontName',fontname,'DefaultAxesFontSize',fontsize);
set(gcf,'DefaultLineLineWidth',2);
for column=1:K+1
	subplot(4,3,column)
	imagesc(nuplot*d,fplot*Ts,dB(Hopt1{column})');
	xlabel('spatial frequency (normalized)');
	ylabel('frequency (normalized)');
	title(['OSR ', num2str(OSx), 'x', num2str(OSt), ', ',...
			num2str(K), 'x', num2str(N), ' taps (space x time)']);
	set(gca,'YDir','normal');
	caxis([-40 7]); hc=colorbar;
	hold on;
	plot([-0.5 0.5],[(fc-BW/2)*Ts (fc-BW/2)*Ts],'w');
	plot([-0.5 0.5],[(fc+BW/2)*Ts (fc+BW/2)*Ts],'w');
	plot([(fc-fs/4)/(2*OSx*fc) (fc+fs/4)/(2*OSx*fc)],...
		[(fc-fs/4)*Ts (fc+fs/4)*Ts],'w');
	plot([-(fc-fs/4)/(2*OSx*fc) -(fc+fs/4)/(2*OSx*fc)],...
		[(fc-fs/4)*Ts (fc+fs/4)*Ts],'w');
	axes(hc); ylabel('dB');
	hold off;
end;
%print -depsc2 filt2d.eps
