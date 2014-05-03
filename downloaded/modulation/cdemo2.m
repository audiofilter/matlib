subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 10;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

x=cos((2*pi/100)*[1:1000]);      % make a sinusoidal signal  
subplot(121), clg, waveplot(x);   
subplot(122), clg, acf(x,100);   % computes autocorrelation
pause

ecorr(x,0,0.7)
ecorr(x,0,2)
mean(x)
meansq(x)
pause

subplot(111), clg
psd(x)   % computes power spectrum of x
pause

x=gauss(0,1,1000);         % gaussian, mean 0 and varizance 1, length 1000
subplot(211); waveplot(x)  
subplot(212); psd(x)       % power spectrum
pause


a=person_data(1000);
subplot(131), clg,
stat_plot(a,'weight','height');
subplot(132), clg, 
stat_plot(a,'age','height');
subplot(133), clg,
stat_plot(a,'age','weight');

pause

subplot(111), clg, temperature(1)
pause

subplot(111), clg, new_born(1)

pause

z=corr_seq(0.85,4096,3,0);
subplot(211), clg, waveplot(z)
subplot(212), clg, psd(z);
pause

% subplot(111), clg,
% wn=gauss(0,1,1024);
% cn=blackbox(wn);
% spect_est(cn)
% psd(cn)
% pause
% start

