clear
n=200;
f=[0 1];
w=[1 ];

b=remez(n,f,w,'differentiator');
[h,w]=freqz(b,1,128);
hani=round(128*f(1)):round(128*f(2));
%plot(w(hani+1),abs(h(hani+1)))
plot(w,abs(h))
