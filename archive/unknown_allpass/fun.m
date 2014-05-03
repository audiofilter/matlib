function f=fun(x)
global D P N M hani Ws
[h1,w]=freqz(fliplr([1 x(1:N)]),[1 x(1:N)],P,'whole');
[h2,w]=freqz(fliplr([1 x(N+1:N+M)]),[1 x(N+1:N+M)],P,'whole');
E=(2*D(hani)-h1(hani).'-h2(hani).').*Ws;
%
%f=E*E'/length(hani);
f=sqrt(E.*conj(E));
%f=E;