function t=L_Serach(Mpq,q,dq,NA,NB,hani,M,DES,mp,mdp,Ws)
%Line Search Program
ii=sqrt(-1);
dw=2*pi/M;
T=min(1,mp/mdp);
step=T/10;
ls=0;
lsmax=10;
epsilon=1.0e-8;

while 1
i=0;
ep=Mpq;
while (ep(i+1)-Mpq)/Mpq<=0.1 & i<=9
i=i+1;
t=i*step;
qq=q+t*dq;
acoe=[1 q(1:NA)]+t*[0 dq(1:NA)];
bcoe=[1 q(NA+1:NA+NB)]+t*[0 dq(NA+1:NA+NB)];
A=fft(acoe,M);
A1=exp(-ii*NA*dw*(0:M-1)).*conj(A)./A;
A1=A1(hani);
B=fft(bcoe,M);
B1=exp(-ii*NB*dw*(0:M-1)).*conj(B)./B;
B1=B1(hani);
DD=(2*DES(hani)-A1-B1).*Ws;
E=DD*DD';
E=E/length(hani);

ep=[ep E];
end
[Y,I]=min(ep);
if I>2
%	disp('E1')
	break
end
step=step/10;
if mdp*step/mp<epsilon
%	disp('E2')
	break
end
ls=ls+1;
if ls>lsmax
%	disp('E3')
	break
end
end	
t=(I-1)*step;
