clear
global D P N M hani Ws
t1=clock;

ii=sqrt(-1);
P=128;
dw=pi*2/P;
N=6; % order of allpass 1
M=N+1; % order of allpass 2
pee=0.2;
pe=round(pee*P);
se=round(0.25*P);
tau=13;
K=sqrt(0.1);
%hani=[1:pe se:P-se+2 P-pe+2:P];
%Ws=[K*ones(1,pe) ones(1,P-2*se+3) K*ones(1,pe-1)];
hani=[1:pe se:P/2+1];
Ws=[K*ones(1,pe) ones(1,P/2+2-se)];
[B,acoe]=butter(N,pee);
[B,bcoe]=butter(M,pee);
%[B,acoe]=cheby1(N,0.5,pee);
%[B,bcoe]=cheby1(M,0.5,pee);
%[B,acoe]=cheby2(N,20,pee);
%[B,bcoe]=cheby2(M,21,pee);
%load ile;
%acoe=[1 x(1:N)];
%bcoe=[1 x(N+1:N+M)];

D=[exp(-ii*tau*(0:se-2)*dw) zeros(1,P/2-se+2)];
D=[D fliplr(conj(D(2:length(D)-1)))];
options(1)=1;
%options(5)=1;
%options(3)=10;
%options(14)=600000;
[x,option]=leastsq('fun',[acoe(2:N+1) bcoe(2:M+1)],options);

[h1,w]=freqz(fliplr([1 x(1:N)]),[1 x(1:N)],P);
[h2,w]=freqz(fliplr([1 x(N+1:N+M)]),[1 x(N+1:N+M)],P);
plot(abs(h1+h2))

t2=clock;
E=fun(x)*fun(x)'/length(hani)
ddd=etime(t2,t1)
save ile x
