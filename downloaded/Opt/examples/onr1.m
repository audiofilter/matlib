clear all
tic
%addpath('./Lib');
global handle pbhandle hLevel f fsb h Nf beta themovie frame bottomhandle tophandle;
InitOpt; ov=newOptSpace;

N=25;
gridDensity=N*25;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
tau=5;
h=z|-tau;

fpb=[0.05:1/(gridDensity):0.5];
delta=optSequence([1]);
Hpb1=fourier(h-delta,fpb);
Npb=length(fpb);

fsb=[.6:1/(gridDensity):0.9];
Hsb=fourier(h,fsb);
Nsb=length(fsb);

beta=optVector(Nsb,ov);
constr={abs(Hpb1)<1-10^(-0.1/20),abs(Hsb)<beta;}

Nf=gridDensity*4;
f=(0:Nf-1)/Nf;
delete(gcf);

%subplot(2,1,1);
tophandle=subplot('Position',[.05 .8 .9 .15] );
hold on;
plot(fpb.',dB(ones(size(fpb)).'*(1+[1 -1]*(1-10^(-0.1/20)))),'c.');
SetAXIS(gca,[0.39 .51  -.12 .12],[.4 .5],[-.1 0 .1]);
pbhandle=plot(fpb.',zeros(Npb,1));
set(gca,'XGrid','on')

%subplot(2,1,2);
bottomhandle=subplot('Position',[0.05 0.05 .9 .7] );
hold on;
plot(fpb.',dB(ones(size(fpb)).'*(1+[1 -1]*(1-10^(-0.1/20)))),'c.');
SetAXIS(gca,[0 1  -80 10],[.05 .4 .5 .6 .9],[-80 -70 -60 -50 -40 -30 -20 -10 0 10]);
handle=plot(f,zeros(1,Nf));
grid on;

set(gcf,'Position',[0 0 900 700]);
frame=0;

toc
soln=minimize(sum(beta),constr,ov,'loqosoclp','onr1Plot');
toc

%double(optimal(sum(beta),soln))

mpgwrite(themovie,colormap,'onr1.mpg');
%delete(gcf);
