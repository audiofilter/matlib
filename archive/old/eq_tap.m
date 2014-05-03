% Program to calculate equalizer coefficients to compensate for ISI given 
% overall impulse response and sampling time
function f = eq_tap(all,off,M)
% Number of symbols
np = 200;
% Feedforward span in symbols.
over=16; 
% PN Generators for I & Q
fill = [1 zeros(1,13)];
r = pngen1(np,[1,6,8,14],fill);

for j=1:np;
	yz(over*j) = r(j);
	for jj=1:over-1
		yz(over*j+jj) = 0;
	end
end
sf = sum(all);
% FIR
ya = filter(all,1,yz);
eyediag(ya,16);
% RX Sampling
for j=off:np-1;
	r(j-off+1) = ya(j*over+off);
end
sum(abs(r));

%clear yz;

% Mu factor for adaptive equalizer
v = 0.02;
%v = input('Enter mu factor:');

% Initialize Equalizer parameters.
x = zeros(1,M);
wff = x;
wff(:,M/2) = 1;
dly = x;

% Equalizer filter data and weights initial conditions
for j=1:np-3;

% Equalizer implementation
	x = [r(j) x(1:M-1)];
	z = x*wff';
	d = sign(z);
	if (z==0) 
		d = 1;
	end
	dly = [d dly(1:M-1)];
	% Output for ploting
%	e(j) = x(:,M) - z;
	e(j) = d - z;
	wff = wff + v*e(j)*x;
	out(j) = dly(:,1);
end
figure;
plot(e);
f = wff;



