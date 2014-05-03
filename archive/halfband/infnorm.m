function [Hinf,wmax] = infnorm(H)
% [Hinf,fmax] = infnorm(H)	 Find the infinity norm of a z-domain transfer function.

% Get a rough idea of the location of the maximum.
N = 129;
w = linspace(0,pi,N);	dw = pi/(N-1);
Hval = evalTF(H,exp(j*w));
[Hinf wi] = max(abs(Hval));

% Home in using the "fmin" function.
options=zeros(1,18);
options(2)=1e-8;
options(3)=1e-6;
wmax = fmin('nabsH',w(wi)-dw,w(wi)+dw,options,H);

Hinf = -nabsH(wmax,H);
fmax = wmax/(2*pi);
