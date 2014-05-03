%
rate = 4;
nadj = 6;
% Assume TX filter is Allens' root raised cosine @ 4 samples/symbol
f = al_src(0.3,rate,32);
% Overall unequalized impulse response
raw = conv(f,f);
% Determine sampling point
[m,x] = max(raw);
% normalize amplitude;
raw = raw/m;
% Plot
stem(raw);
% Calculate ISI for number of adjacent symbols
isi = 0;
for s=1:nadj
	temp = abs(raw(x+s*rate))
	isi = isi + temp;
end
% Print out current ISI
disp('Current amount of Sum of absolute value of ISI');disp(isi);


