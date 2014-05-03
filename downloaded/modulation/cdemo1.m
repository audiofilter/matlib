subplot(111), clg 
gset nokey;
SAMPLING_CONSTANT  = 10;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

x=binary(8)      % binary sequence with length 8
x=dice(8,4)      % 4-ary sequence with length 8
pause

x=uniform(1,4,8) % sequence with gaussian distribution and length 8
x=gauss(0,1,8)   % gaussian distribution, mean 0 and variance 1
x=gauss(0,4,8)   % gaussian distribution, mean 0 and variance 8
x=gauss(0,1,400); waveplot(x) 
pause

x=dice(2000,4);             % 4-ary sequence with lenght 2000
subplot(121), clg, pdf(x);  % computes probability function
subplot(122), clg, cdf(x);  % computes distribution function
mean(x)                     % computes mean
var(x)                      % computes variance
pause

x=uniform(2,6,2000);        % 2000 experiments with values between 2 and 6
subplot(121), clg, pdf(x);  % computes probability function
subplot(122), clg, cdf(x);  % computes distribution function
mean(x)                     % computes mean
var(x)                      % computes variance
pause

x=gauss(0,1,1000);          % 1000 experiments with mean 0 and variance 1 
subplot(121), clg, pdf(x);  % computes probability function
subplot(122), clg, cdf(x);  % computes dsitribution function
mean(x)                     % computes mean
var(x)                      % computes variance
pause

subplot(121), clg, unif_pdf(2,6);
subplot(122), clg, unif_cdf(2,6);

pause

subplot(121), clg, gaus_pdf(1,1);
subplot(122), clg, gaus_cdf(1,1);

pause

subplot(111), clg,
dart([1 2],[1 1],20)

pause

subplot(111), clg
hold off
integral('x',[0,100],5000);

pause
