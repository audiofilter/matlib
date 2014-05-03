global t ff ffi tau N Nf fc respHand CircHand h beta respdotsHand;
InitOpt;
ov=newOptSpace;

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

Nf=gridDensity*4;
fc=fsb(0.6 <= fsb & fsb <= 0.7);
f=(0:Nf-1)/Nf;
ffi= 0.59 <= f & f <= 0.7;

ff=f(ffi);

delete(gcf);
lim=.01;
originHand=plot3([ 0    -lim    0 ;...
                   0     lim    0 ],...
                 [ 0.59  0.6  0.6 ;...
                   0.7   0.6  0.6 ],...
                 [ 0       0 -lim ;...
                   0       0  lim ]);
set(originHand,'Color',[0 0 0]);
pbaspect([1 5 1]);
%view([6, 20, 4]);
view([1, 40, .25]);
axis off;
SetPLOT(15,10);
SetAXIS(gca,[-lim lim  0.59  0.7  -lim lim],[],[],[]);
hold on;
t=(0:1:360)'/180*pi;
drawnow;
CircHand=plot3([0],[0],[0]);
respHand=plot3([0],[0],[0]);
respdotsHand=plot3([0],[0],[0]);

beta=optVar(ov);
constr={abs(Hpb1)<1-10^(-0.1/20),abs(Hsb)<beta};
%soln=minimize(beta,constr,ov,'sedumi');
%soln=minimize(beta,constr,ov,'loqosoclp');
soln=minimize(beta,constr,ov,'loqosoclp','cheb3dUpdate');

cheb3dUpdate(soln);

hold off;
%print -depsc2 cheb3d.eps
