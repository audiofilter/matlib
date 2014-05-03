subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 10;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;


b=[0 1];
f=wave_gen(b,'unipolar_nrz')   % 00000000001111111111
f=wave_gen(b,'unipolar_rz')    % 00000000001111100000
pause

subplot(111);
b=[1 0 0 1 0 1 0 1 1 0];         % sequence of 10 bits
f= wave_gen(b,'polar_nrz',1000); % baseband signal, 1000 bps
g=channel(f,1,0.05,5000);        % noise 0.05 W
subplot(211), clg, waveplot(g)   %
g=channel(f,1,0.2,5000);         % noise 0.2 W
subplot(212), clg, waveplot(g)   %
pause

b=[1 0 0 1 0 1 0 1 1 0];         % sequence of 10 bits
f= wave_gen(b,'polar_nrz',1000); % baseband signal, 1000 bps
g=channel(f,1,0,4000);           % channel with 4 kHz
subplot(211), clg, waveplot(g)   % 
g=channel(f,1,0,1000);           % channel with 1 kHz
subplot(212), clg, waveplot(g)   % 
pause

b=binary(1000);                          % binary sequence, 1000 bits
f= wave_gen(b,'unipolar_nrz',1000);      % baseband signal, 1000 bps
subplot(211), clg, waveplot(f([1:100])); % 
subplot(212), clg, psd(f);               % power spectrum
pause

b=binary(10);
f= wave_gen(b, 'manchester',1000);
subplot(211), clg, waveplot(f);
b=binary(1000);
f= wave_gen(b, 'manchester',5000);
subplot(212), clg,  psd(f);
pause


% CHANNEL WITH GAUSSIAN NOISE


b=binary(1000);
x=wave_gen(b,'polar_nrz',1000);
subplot(121), psd(x)
subplot(122), clg, psd(channel(x,1,0.01,5000))
pause

subplot(122), clg, psd(channel(x,1,1,5000))
pause

subplot(122), clg, psd(channel(x,1,5,5000))
pause


% CHANNEL WITH LIMITED BANDWIDTH

subplot(122), clg, psd(channel(x,1,0,3000))
pause

subplot(122), clg, psd(channel(x,1,0,2000))
pause

subplot(122), clg, clg, psd(channel(x,1,0,1000))
pause

subplot(122), clg, psd(channel(x,1,0,500))
pause


% PROBABILITY FUNCTION OF SIGNAL

b=binary(1000); f=wave_gen(b,'polar_nrz',1000);
subplot(121), clg, pdf(f);  % prob. function of baseband signal
n=gauss(0,0.05,1000);       % gausian noises, mean 0, and var 0.05 W
subplot(122), clg, pdf(n);  % prob. function of noise
pause

b=binary(1000); f=wave_gen(b,'polar_nrz',1000);
g=channel(f,1,0.05,5000);  % noise, variance 0.05 W
subplot(121), clg, pdf(g); % 
g=channel(f,1,0.2,5000);   % noise, variance 0.05 W
subplot(122), clg, pdf(g); % 
pause


% EYE DIAGRAM


b=[ 1 0 0 1 0 1 1 0 ];;
f=wave_gen(b,'polar_nrz',1000);
subplot(221), clg, waveplot(f)
subplot(223), clg, eye_diag(f)
g=channel(f,1,0.2,4000);
subplot(222), clg, waveplot(g)
subplot(224), clg, eye_diag(g)

