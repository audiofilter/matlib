function isi = ms_isi(raw,rate,nadj,displ)
% function isi = ms_isi(raw,rate,nadj,displ)
%$Id: ms_isi.m,v 1.2 1997/10/13 16:10:52 kirke Exp kirke $
% Measures Sum of absolute value of ISI for overall impulse
% response where raw is overall (symmetric) impulse response,
% rate is the over sampling rate and nadj is the number of 
% adjacent symbols to consider in calculation
% displ should be 1 to see individual isi

% Determine sampling point
[m,x] = max(raw);
% normalize amplitude;
raw = raw/m;
% Plot
stem(raw);
% Calculate ISI for number of adjacent symbols
isi = 0;
for s=-nadj:nadj
	temp = abs(raw(x+s*rate));
	if (displ) 
	  disp(temp);
	end
	if (s~=0)
	  isi = isi + temp;
	end
end
% Print out current ISI
disp('Current amount of Sum of absolute value of ISI');disp(isi);


