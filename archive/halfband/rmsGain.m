function g = rmsGain(H,f1,f2)
%function g = rmsGain(H,f1,f2)
%Compute the root mean-square gain of the discrete-time
%tf H in the frequency band (f1,f2)

N = 100;
w = linspace(2*pi*f1,2*pi*f2,N);
g = norm( evalTF(H,exp(j*w)) ) / sqrt(N);
