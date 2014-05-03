function l=magfir(fir)
[h,w]=freqz(fir,1,200);
h=h/max(h);
plot(abs(h));
axis([0 200 0 1]);
grid;