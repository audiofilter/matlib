%$Id: berplot.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
for s=5:13
pebpsk(s) = erfc(10^(s/20));
pencdpsk(s) = 0.5*exp(-10^(s/10));
pedeqpsk(s) = 2*pebpsk(s);
pedqpsk(s) = erfc(2*sin(pi/8)*10^(s/20));
snr(s) = s;
end
semilogy(snr,pebpsk,snr,pencdpsk,snr,pedeqpsk,snr,pedqpsk);
axis([5 13 0.000000001 0.1]);
grid;