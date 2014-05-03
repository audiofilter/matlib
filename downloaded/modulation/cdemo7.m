subplot(111), clg
gset nokey;
SAMPLING_CONSTANT  = 100;
BINARY_DATA_RATE   = 1000;
SAMPLING_FREQ      = BINARY_DATA_RATE * SAMPLING_CONSTANT;

% A/D and D/A conversion

s = speech(100);
s_binary = a2d(s,6);
s_analog = d2a(s_binary,6);
subplot(211), clg, waveplot(s)
subplot(212), clg, waveplot(s_analog)
pause


%  DIFFERENTIAL ENCODING

x = sin ( 2*pi*400*[1:100]/SAMPLING_FREQ );
x_pcm = a2d(x,6);
xw = tx(x_pcm, 'manchester','no_diff',1000);
y = -channel(xw,1,0.01,19000);
pause

x_digital = rx(y,'manchester');
x_analog = d2a(x_digital,6);
subplot(211), clg, waveplot(x)
subplot(212), clg, waveplot(x_analog)
pause

u = tx(x_pcm,'manchester','diff',1000);
z = -channel(u,1,0.01,19000);
u_digital = rx(z,'manchester','diff');
u_analog = d2a(u_digital,6);
subplot(211), clg, waveplot(x)
subplot(212), clg, waveplot(u_analog)
pause


% BASEBAND COMMUNICATION

b = binary(1000)
Rb = 1000;
u = tx(b,'unipolar_nrz',Rb);
m = tx(b,'manchester',Rb);
pause

ch_input = u; A=1; linecode='unipolar_nrz';
ch_output = channel (A*ch_input,1,1,19000);
rx(ch_output,linecode,b);


