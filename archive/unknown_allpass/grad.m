function g=grad(x)
global D P N M hani Ws
ii=sqrt(-1);
dw=2*pi/P;
acoe=[1 x(1:N)];
bcoe=[1 x(N+1:N+M)];
A=fft(acoe,P);
A1=exp(-ii*N*dw*(0:P-1)).*conj(A)./A;
A1=A1(hani);
A2=2*ii*exp(-ii*N*dw*(0:P-1))./A./A;
A2=A2(hani);
A=A(hani);
B=fft(bcoe,P);
B1=exp(-ii*M*dw*(0:P-1)).*conj(B)./B;
B1=B1(hani);
B2=2*ii*exp(-ii*M*dw*(0:P-1))./B./B;
B2=B2(hani);
B=B(hani);
DD=(2*D(hani)-A1-B1).*Ws;
E=DD*DD';
E=E/length(hani)
phi=ones(N,1)*(A2.*abs(A).*Ws).*sin((1:N)'*(hani-1)*dw+ones(N,1)*angle(A));
psi=ones(M,1)*(B2.*abs(B).*Ws).*sin((1:M)'*(hani-1)*dw+ones(M,1)*angle(B));

RR=real(phi*phi');
SS=real(psi*psi');
RS=real(phi*psi');
SR=real(psi*phi');

PP=sum(real(ones(N,1)*(DD.*Ws.*Ws).*conj(phi))');
QQ=sum(real(ones(M,1)*(DD.*Ws.*Ws).*conj(psi))');

T=[RR RS;SR SS];
b=[PP QQ];
g=b/T;
