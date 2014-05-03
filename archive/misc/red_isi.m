% Determine New FIR coefficients for Reduced ISI
%
clear all;
% Do calculations at 16 samples/symbol
rate = 16;
tx_rate = 4;
nadj = 4;
pad = (rate/tx_rate - 1);
% Assume TX filter is Allens' root raised cosine @ 4 samples/symbol
f = al_src(0.3,tx_rate,32);
% Interpolate this to 16 samples/symbol
f16 = interp(f,4);
% Overall unequalized impulse response
raw = conv(f16,f16);
clear f16;
% Determine sampling point
[m,x] = max(raw);
% normalize amplitude;
raw = raw/m;
% Plot
%stem(raw);
% Calculate ISI for number of adjacent symbols
isi = 0;
for s=1:nadj
	isi = isi + abs(raw(x+s*rate));
end
% Print out current ISI
disp('Current amount of Sum of absolute value of ISI');disp(isi);
% Determine best 5 tap equalizer coefficients for reducing ISI
[eq,new_isi] = det_eqh(raw,rate,nadj,pad);
disp('New amount of ISI (unquantized equalizer)');disp(new_isi);
% New Tx filter at 4 samples/symbol
tx_new = conv(eq,f);
tx_new = round(tx_new);
% New overall impulse response;
f16 = zeropad(tx_new,pad);
new_ov = conv(f16,f16);
% Determine sampling point
[m,x] = max(new_ov);
% normalize amplitude;
new_ov = new_ov/m;
% Calculate ISI for number of adjacent symbols
isi = 0;
for s=1:nadj
	isi = isi + abs(new_ov(x+s*rate));
end
% Print out new ISI after quantization
disp('New amount of ISI (new quantized coefficients)');disp(isi);
[ho,wo] = freqz(f,1,100);
ho = ho/ho(1);
[h,w] = freqz(tx_new,1,100);
h = h/h(1);
w = 0.5*w/pi;
plot(w,20*log10(abs(h)),'y-',w,20*log10(abs(ho)),'g--');
axis([0 0.5 -50 10]);
grid;
clear ho;
clear h;
clear nadj;
clear pad;
clear rate;
clear tx_rate;
clear x
%clear y;
clear w
clear wo;
%clear f
clear f16;
clear m
clear x;
clear s;
clear raw;
%clear new_ov;
clear new_isi;
tx_new


