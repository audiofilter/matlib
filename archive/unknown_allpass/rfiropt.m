
%% Complex Chebyshev Approximation 
%%%	for FIR Filters 
%%%	(Transforming Error Response) 
%%%	1/30

clear
%t1=clock;
%figure(1)
ii=sqrt(-1);
iftrans=1;

%N=; 			%length of numerator
alpha=1/1;		%Weight (if alpha > 1 , Pass > Stop)
P=2^nextpow2(25*N) ;		%grid dense (2PI / P)
dw=2*pi/P;
wp=0.1;		%PassBand Edge *2PI
ws=wp+3/N;		%StopBand Edge *2PI
tau=round(N/2);	%Group Delay
pe=ceil(wp*P);	
se=floor(ws*P);
epsi=0.001;

D=[exp(-ii*tau*(0:pe-1)*dw) exp(-ii*tau*2*wp*pi) zeros(1,P/2-pe)];
W=[ones(1,pe+1) zeros(1,se-pe-1) ones(1,P/2-se+1)];

DD=D;

tt1=clock;
Wexp=exp(-ii*(0:P/2)*dw);
%Wexp=[exp(-ii*(0:pe)*dw) zeros(1,se-pe-1) exp(-ii*(2*ws*pi+(0:P/2-se)*dw))];
Wexp(pe+1)=exp(-ii*wp*2*pi);
Wexp(se+1)=exp(-ii*ws*2*pi);


phi=gs2(W,Wexp,N);
tt2=clock;

Rmax2=100;
Mmax=[];
Mmin=[];

%%%%
if alpha ~= 1
W2=[ones(1,pe+1) zeros(1,se-pe-1) alpha*alpha*ones(1,P/2-se+1)];
phi2=gs2(W2,Wexp,N);
phicoe=calcoe(DD,Wexp,phi2,pe+1);
H=fft(phicoe,P);
H(pe+1)=phicoe*exp(-ii*2*pi*wp*(0:N-1)');
H(se+1)=phicoe*exp(-ii*2*pi*ws*(0:N-1)');
E=H(1:P/2+1)-DD;
if iftrans == 1
[Ed,Rmax]=trans(E(1:P/2+1),pe,se,P,alpha,N);
else 
[Ed,Rmax]=trans2(E(1:P/2+1),pe,se,P,alpha,N);
%[Ed,Rmax,Rmin]=modEversionup(E(1:P/2+1),pe,se,P,alpha,0,1000);
end
D=DD+Ed;
end

%%%%
Rmax=1000;
Rmin=0;
Pmax=0;
E2=E;

for loop=1:300
%loop
phicoe=calcoe(D.*W,Wexp,phi,P/2+1);
%etime(clock,t1)
H=fft(phicoe,P);
H(pe+1)=phicoe*exp(-ii*2*pi*wp*(0:N-1)');
H(se+1)=phicoe*exp(-ii*2*pi*ws*(0:N-1)');
H=H(1:P/2+1);
E=H-DD;
%etime(clock,t1)

if iftrans==1
[Ed,Rmax]=trans(E(1:P/2+1),pe,se,P,alpha,N,Pmax);
%Pmax=max(abs(Ed));
else
[Ed,Rmax]=trans2(E(1:P/2+1),pe,se,P,alpha,N,Pmax);
%[Ed,Rmax,Rmin]=modEversionup(E(1:P/2+1),pe,se,P,alpha,0,1000);
end
%plot(abs(E(1:P/2+1).*W))
%pause(0.1)
%etime(clock,t1)

if Rmax > Rmax2
disp('shippai')
break
end

Mmax=[Mmax Rmax];
Mmin=[Mmin Rmin];
if abs(Rmax-Rmax2)/Rmax < epsi
	Err=W.*(H-D);
	break;
end
Rmax2=Rmax;

D=DD+Ed;
%etime(clock,t1)

end % end of while
%t2=clock;
%time=etime(t2,t1)
%loop

%cir=max(abs(E(1:pe:1)))*exp(ii*(1:100)*pi/50);

%EW=abs(E(1:P/2+1)).*W(1:P/2+1);
%W2=[ones(1,pe+1) zeros(1,se-pe-1) alpha*alpha*ones(1,P/2-se+1)];
%plot((0:P/2)/(P/2),EW.*sqrt(W2(1:P/2+1)))
%N
%max(EW(1:pe-1).*sqrt(W2(1:pe-1)))
h=phicoe;