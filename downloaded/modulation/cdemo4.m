subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 10;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

f=wave_gen(1,'polar_nrz',1000); 
subplot(311), clg, waveplot(f);
subplot(312), clg, match('polar_nrz');  % display matched filter
g=match('polar_nrz',f);                 % output signal
subplot(313), clg, waveplot(g)          % 

pause

f=wave_gen(1,'triangle',100);
subplot(311), clg, waveplot(f)
subplot(312), clg, match('triangle');
g=match('triangle',f);
subplot(313), clg, waveplot(g)
pause


% MATCHED-FILTER RECEIVER

b=[1 0 1 1 0 1 0 0]; f=wave_gen(b,'unipolar_nrz',1000); 
subplot(211), clg, waveplot(f);  % display input
g=match('unipolar_nrz',f);       % matched filter
subplot(212), clg, waveplot(g);  % display output
pause

b=[1 0 1 1 0 1 0 0];  f=wave_gen(b,'polar_nrz',1000); 
subplot(211), clg, waveplot(f);  % display input
g=match('polar_nrz',f);          % matched filter
subplot(212), clg, waveplot(g);  % display output
pause


% EYE DIAGRAM

b=[1 0 1 1 0 1 0 0 1 0];
f=wave_gen(b,'polar_nrz',1000); 
subplot(311), waveplot(f); 
g=channel(f,1,0.5,3000); subplot(312), clg, waveplot(g)
h=match('polar_nrz',g);  subplot(313), clg, waveplot(h)
pause

b=binary(1000);  f=wave_gen(b,'polar_nrz');  
g=channel(f,1,0.5,3000);
h=match('polar_nrz',g); 
subplot(111), clg, eye_diag(h);
pause

detect(h,0,0.0006,b);   % incorrect time, BER=0.5
detect(h,0,0.00125,b);  % correct time,   BER=0 
pause

% ANOTHER EXAMPLE

b=binary(1000); f=wave_gen(b,'polar_nrz');
g=channel(f,1,2,3000); h=match('polar_nrz',g);
subplot(211), clg, waveplot(f([1:200]))
subplot(212), clg, waveplot(h([1:200]))
pause

subplot(111), clg, eye_diag(h);
detect(h,0,0.00125,b);
pause


% LOW-PASS FILTER RECEIVER

r=wave_gen(1,'unipolar_nrz');
r_lpf=rc(1000,r)
subplot(211), clg, waveplot(r)
subplot(212), clg, waveplot(r_lpf);
n=gauss(0,0.5,2000);
meansq(rc(1000,n))
pause


