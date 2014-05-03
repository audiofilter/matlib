function [eq,mini] = det_eq(raw,rate,nadj,pad)
%function [eq,mini] = det_eq(raw,rate,nadj,pad)
% Determine 5 tap equalizer to reduce ISI
% raw - input vector
% rate - number of samples/symbol
% nadj - number of adjacent symbol to look for ISI
% pad - number of zeros between taps of equalizer
%
num = 20;
mini = 1;
% Loop through various values for taps
for ii=1:num
	a = (ii-1)/(4*num) - 0.125;
	for jj=1:num
		b = (jj-1)/(4*num) - 0.125;
		% Equalizer
		eq = [b a 1 a b];
		% Equalizer at appropriate sampling rate
		eq = zeropad(eq,pad);
		% New impulse response
		y = conv(eq,raw);
		[m,x] = max(y);
		sum = 0;
		% Calculate ISI
		for s=1:nadj
			sum = sum + abs(y(x+s*rate));
		end
		sum = sum/m;
		% Determine Minimum possible isi case
		if (sum<mini)
			mini = sum;
			save_a = a;
			save_b = b;
		end
	end
end
eq = [save_b save_a 1 save_a save_b];
