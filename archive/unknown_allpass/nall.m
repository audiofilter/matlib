clear
ii=sqrt(-1);
P=256;
dw=2*pi/P;

N=3;
M=4;
ext=2;
ha1=[1:round(P/2/M)-ext];ha1=[ha1 P-fliplr(ha1(2:length(ha1)))+2];

K=1;
Ws=ones(1,P);
[B,acoe]=cheby2(N,31,0.3);
[B,bcoe]=cheby2(N,12,0.2);
[B,ccoe]=cheby2(N,41,0.1);

E2=10;
while 1

A=acoe*exp(-ii*M*(0:N)'*(0:P-1)*dw);
A1=exp(-ii*dw*(0:P-1)).*conj(A)./A;
A2=2*ii*exp(-ii*dw*(0:P-1))./A./A;

B=bcoe*exp(-ii*M*(0:N)'*(0:P-1)*dw);
B1=exp(-ii*2*dw*(0:P-1)).*conj(B)./B;
B2=2*ii*exp(-ii*2*dw*(0:P-1))./B./B;

C=ccoe*exp(-ii*M*(0:N)'*(0:P-1)*dw);
C1=exp(-ii*3*dw*(0:P-1)).*conj(C)./C;
C2=2*ii*exp(-ii*3*dw*(0:P-1))./C./C;

DD=((M-1)*ones(1,length(ha1))-A1(ha1)-B1(ha1)-C1(ha1)).*Ws(ha1);

E=real(DD*DD');
E=abs(E)/length(DD)
ph1=ones(N,1)*(A2.*abs(A).*Ws).*sin(M*(1:N)'*(0:P-1)*dw+ones(N,1)*angle(A));
ph2=ones(N,1)*(B2.*abs(B).*Ws).*sin(M*(1:N)'*(0:P-1)*dw+ones(N,1)*angle(B));
ph3=ones(N,1)*(C2.*abs(C).*Ws).*sin(M*(1:N)'*(0:P-1)*dw+ones(N,1)*angle(C));

PH=[ph1(:,ha1);ph2(:,ha1);ph3(:,ha1)];

%Q1=sum(real(ones(N,1)*(DD.*Ws.*Ws).*conj(phi))');
T=PH*PH';

%b=sum(ones(3*N,1)*(DD.*Ws(hani).*Ws(hani))*conj(PH)');
b=(PH*DD')';
x=real(b/T);
t=L_Serach(E,[acoe(2:N+1) bcoe(2:N+1) ccoe(2:N+1)],x,N,M,ha1,P,Ws);
acoe=acoe+t*[0 x(1:N)];
bcoe=bcoe+t*[0 x(N+1:2*N)];
ccoe=ccoe+t*[0 x(2*N+1:3*N)];
if t==0|abs(E-E2)/E<0.001
break
end
E2=E;
end

%h0=exp(-ii*(0:P-1)*dw);
h0=ones(1,P);

low=h0+A1+B1+C1;
%plot(abs(low))
w=1:P;
plot(1:P/2+1,abs(low(1:P/2+1)))
%plot(w,unwrap(angle(h0)),w,unwrap(angle(A1)),w,unwrap(angle(B1)),w,unwrap(angle(C1)))
