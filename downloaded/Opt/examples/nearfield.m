% nearfield.m - optimize near-field receive pattern

InitOpt;
ov=newOptSpace;

% units
m=1;
s=1; ms=1e-3*s; us=1e-6*s; ns=1e-9*s; ps=1e-12*s;
Hz=1/s; MHz=1e6*Hz; GHz=1e9*Hz;
rad=1; deg=pi/180*rad;
c=3e8*m/s;

% parameters
fc=24*MHz;
d=c/(2*24*MHz);
K=81; k=(0:K-1)-(K-1)/2; 
x0=-2000; y0=2000;   % pointing direction
a=optVector(K,ov)+j*optVector(K,ov);  % allocate weights
delta=optVar(ov);

% spatial gridding
dgrid=50*m;
xgrid=-5000*m:dgrid:5000*m;
ygrid=100*m:dgrid:10000*m;
% calculate distance function over grid and elements
[Xgrid,Ygrid]=ndgrid(xgrid,ygrid);
[XDgrid,KDgrid]=ndgrid(Xgrid(:),k*d);
[YDgrid]=ndgrid(Ygrid(:),k*d);
Dgrid=sqrt((XDgrid-KDgrid).^2+YDgrid.^2);
clear XDgrid YDgrid KDgrid;

% beam over whole grid
A=100*(exp(-j*2*pi*fc/c*Dgrid)./Dgrid)*a; % form beam
clear Dgrid;
Ams=sum(abs(A).^2)/length(A); % mean-square beam energy

% beam at pointing direction
D0=sqrt((x0-k*d).^2+y0^2);
A0=100*(exp(-j*2*pi*fc/c*D0)./D0)*a;

%soln=minimize(delta,...
%	{Ams<delta.^2,1<real(A0),0<imag(A0),imag(A0)<0},ov,'mosekdual');
soln=minimize(delta,...
	{Ams<delta.^2,1<real(A0),0<imag(A0),imag(A0)<0},ov,'sedumi');

dB(double(optimal(delta,soln)))
aopt=double(optimal(a,soln));

Aopt=reshape(double(optimal(A,soln)),length(xgrid),length(ygrid));
clear A;

figure(1); subplot(1,1,1);
surf(xgrid,ygrid,dB(Aopt)');
top; shading interp; colorbar;
