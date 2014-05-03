function [eq,mini] = opt_eqh(raw,rate,nadj,pad)
%function [eq,mini] = opt_eqh(raw,rate,nadj,pad)
% Determine 5 tap equalizer to reduce ISI
% Does successive iterations to determine best equalizer
% Calculated Equalizer should be applied to both TX & RX Filters!
% raw - input vector
% rate - number of samples/symbol
% nadj - number of adjacent symbol to look for ISI
% pad - number of zeros between taps of equalizer
%
% 
count = 0;
mino = 1;
mini = 0.5;
traw = raw;
eq = [1];
[teq,mini] = det_eqh(raw,rate,nadj,pad);
while mini<mino,
	count = count+1;
	mino = mini;
	tteq = conv(teq,teq);
	raw = conv(raw,tteq);
	eq = conv(eq,teq);
	[teq,mini] = det_eqh(raw,rate,nadj,pad);
	mini
end


