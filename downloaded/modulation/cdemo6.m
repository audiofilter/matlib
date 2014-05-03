subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 100;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

% PSK
b=[1 0 1 0 1]; f=wave_gen(b,'polar_nrz',1000);
x=mixer(f,osc(8000,0,length(f))); % PSK MODULATION
subplot(211), clg, waveplot(f);
subplot(212), clg, waveplot(x);
pause

% ASK
b=[1 0 1 0 1]; f=wave_gen(b,'unipolar_nrz',1000);
x=mixer(f,osc(8000,0,length(f))); % ASK MODULATION
subplot(211), clg, waveplot(f);
subplot(212), clg, waveplot(x);
pause

% FSK
b=[1 0 1 0 1]; f=wave_gen(b,'polar_nrz');
x=vco(f,6000,2000); % FSK MODULATION
subplot(211), clg, waveplot(f);
subplot(212), clg, waveplot(x);
pause


% SPECTRUM

b=binary(1000); 
f=wave_gen(b,'polar_nrz');    x=mixer(f,osc(25000,0,length(f))); % PSK
subplot(121), clg, psd(x);  
f=wave_gen(b,'unipolar_nrz'); x=mixer(f,osc(25000,0,length(f))); % ASK
subplot(122), clg, psd(x);
pause

b=binary(1000); f=wave_gen(b,'polar_nrz',1000);
x=vco(f,25000,500);  subplot(121), clg, psd(x); % beta=0.5
x=vco(f,25000,5000); subplot(122), clg, psd(x); % beta=5
pause

b=binary(100); f=wave_gen(b,'polar_nrz',1000);
x=mixer(f,osc(8000,0,length(f)))+mixer(f,osc(15000,0,length(f)))+mixer(f,osc(22000,0,length(f)));
subplot(111), clg, psd(x);
pause


% ASK - ENVELOPE DEMODULATION

b=binary(10); f=wave_gen(b,'unipolar_nrz',1000);
x=mixer(f,osc(8000,0,length(f))); 
% demodulation starts here
g=envelope(x,4000);  % low-pass filter
subplot(211), clg, waveplot(x); 
subplot(212), clg, waveplot(g)
pause


% FSK - ENVELOPE DEMODULATION

b=[1 0 1 0 1]; f=wave_gen(b,'polar_nrz'); 
x=vco(f,6000,2000);  
% demodulation starts here
y2=hpf(6000,x);   % high-pass filter, cut frequence 6000    
y1=lpf(6000,x);   % low-pass filter, cut frecuence 6000
g2=envelope(y2,3000); g1=envelope(y1,3000); g=g2-g1; 
subplot(221) , clg, waveplot(x)  ; 
subplot(223) , clg, waveplot(g) ;
subplot(222) , clg, waveplot(y2) ; 
subplot(224) , clg, waveplot(y1)
pause

% ASK - SYNCHRONOUS DEMODULATION

b=binary(10); f=wave_gen(b,'unipolar_nrz');
x=mixer(f,osc(8000,0,length(f)));
% demodulation starts here
y=mixer(x,osc(8000,0,length(x))); g=match('unipolar_nrz',y);
subplot(211), clg, waveplot(x); 
subplot(212), clg, waveplot(g)
pause

% FSK - SYNCHRONOUS DEMODULATION

b=[1 0 1 0 1]; f=wave_gen(b,'polar_nrz'); 
x=vco(f,6000,500);     
% demodulation starts here
y2=mixer(x,osc(6500,0,length(x))); g2=match('unipolar_nrz',y2);    
y1=mixer(x,osc(5500,0,length(x))); g1=match('unipolar_nrz',y1);    
g=g2-g1; 
subplot(221) , clg, waveplot(x)  ; 
subplot(223) , clg, waveplot(g)
subplot(222) , clg, waveplot(g2) ; 
subplot(224) , clg, waveplot(g1)


% PSK DIFERENCIAL (DPSK)

b=[ 1 0 1 1 0 1 0 0 1]; c(1)=1; 
for i=1:9
   c(i+1)= invert( xor(c(i),b(i)) ); 
end
b , c,
pause

% modulation
f=wave_gen(c,'polar_nrz',1000); x=mixer(f,osc(8000,0,length(f))); 
subplot(111), clg, waveplot(x);
pause

% demodulation
x_ret=[ zeros(1,SAMPLING_CONSTANT), x];  
subplot(211), clg, waveplot(x); 
subplot(212), clg, waveplot(x_ret);
pause

y=mixer(x,x_ret); g=lpf(4000,y); 
subplot(211), clg, waveplot(y); 
subplot(212), clg, waveplot(g);
pause

% QPSK

b=[ 1 0 1 1 0 1 0 0 1 0 ]; 
b_par=ser2par(b,2); b1=b_par(1,:); b2=b_par(2,:);
f1=wave_gen(b1,'polar_nrz',1000); 
f2=wave_gen(b2,'polar_nrz',1000);
x1=mixer(f1,osc(10000,0,length(f1))); x2=mixer(f2,osc(10000,-90,length(f2))); x=x1+x2;
subplot(311), clg, waveplot(x1); 
subplot(312), clg, waveplot(x2);
subplot(313), clg, waveplot(x);
pause

% demodulador
y1=mixer(x1,osc(10000,0,length(x1))); y2=mixer(x2,osc(10000,-90,length(x2)));
z1=match('polar_nrz',y1); z2=match('polar_nrz',y2);
subplot(211), clg, waveplot(z1); 
subplot(212), clg, waveplot(z2);
b1=detect(z1,0,0.001); b2=detect(z2,0,0.001); 
b_par=[b1; b2];
b=par2ser(b_par);
b
pause


% PAM
a=dice(20,4);  b=2*a-5;
f1=wave_gen(a,'pam');  f2=wave_gen(b,'pam');
subplot(211), waveplot(f1); subplot(212), waveplot(f2);
pause

g=channel(f2,1,0.05,5000);
h=match('pam',g);
subplot(211), waveplot(g); subplot(212), waveplot(h);
pause

subplot(111), eye_diag(h);
pause

c=detect(h,[-0.002, 0, 0.002],0.001) % da la secuencia recibida
detect(h,[-0.002, 0, 0.002],0.001,a) % compara con la inicial a


% QAM

ac=dice(80,4); bc=2*ac-5; as=dice(80,4); bs=2*as-5;
fc=wave_gen(bc,'pam'); fs=wave_gen(bs,'pam');
x=mixer(fc,osc(8000,0,length(fc)))+mixer(fs,osc(8000,-90,length(fs)));
y=channel(x,1,0.5,50000);
subplot(211), waveplot(x([1:1000])); 
subplot(212), waveplot(y([1:1000]));
pause

subplot(111), pha_diag(y,8000,0,0.001)
pause

zc=mixer(y,osc(8000,0,length(y))); zs=mixer(y,osc(8000,-90,length(y)));
rc=match('polar_nrz',zc); rs=match('polar_nrz',zs); 
subplot(211), waveplot(rc([1:1000])); 
subplot(212), waveplot(rs([1:1000]));
pause

subplot(121), eye_diag(rc); 
subplot(122), eye_diag(rs);
pause

cc=detect(rc,[-0.001, 0, 0.001],0.001) % secuencia detectada
detect(rc,[-0.001, 0, 0.001],0.001,ac) % porcentaje errores
cs=detect(rs,[-0.001, 0, 0.001],0.001)
detect(rs,[-0.001, 0, 0.001],0.001,as)
pause


% QAM
b1=binary(512)
in = qam_mod(b1, 10000, 8, 4); frequ = 10000; phase = 0;
subplot(111), waveplot(in)
pause

sampling_instant = 0.001; 
threshold1 = [-0.003,-0.002,-0.001, 0, 0.001,0.002,0.003];
threshold2 = [-0.001, 0, 0.001];
b2 = qam_dem(in,frequ,phase,sampling_instant,threshold1,threshold2)
