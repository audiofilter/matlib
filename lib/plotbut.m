%$Id: plotbut.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
function y = plotbut(order,fpass)
pts = 100;
y = [1 zeros(1,2*pts)];
[b,a] = butter(order,fpass);
x = filter(b,a,y);
%plot(x);
%pause;
z = 10*log(abs(fft(x)));
plot(z);
axis([0 100 -40 0]);
grid;
b
a