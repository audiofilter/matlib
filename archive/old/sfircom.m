% Program to calculate equalizer coefficients to compensate for CIC filter
clear all;
% Number of symbols
np = 1000;
nfir = 32;
% Raised cosine FIR
fir = src(0.25001,4,nfir);
% Feedforward span in symbols.
M = 15; 

over = 4;
yz = zeros(1,over*np);
r = zeros(1,np);

% PN Generators for I & Q
fill = [1 zeros(1,13)];
r = pngen1(np,[1,6,8,14],fill);

for j=1:np;
	yz(over*j) = r(j);
	for jj=1:over-1
		yz(over*j+jj) = 0;
	end
end


sf = sum(fir);
% TX FIR
y = filter(fir,1,yz);
yy = filter(fir,1,y);
over2 = 5;
yzz = zeros(1,over*over2*np);
for oo=1:over*np;
	yzz(over2*oo) = yy(oo)/20;
end 
ya = filter([1 3 6 10 15 18 19 18 15 10 6 3 1],1,yzz);
eyediag(ya,40);
% RX FIR
off = 16;
for j=off:np-1;
	r(j-off+1) = ya(j*over*over2+off)/4;
end
sum(abs(r))
pause;

%clear yz;

% Mu factor for adaptive equalizer
v = input('Enter mu factor:');

% Initialize Equalizer parameters.
x = zeros(1,M);
wff = x;
wff(:,M/2) = 1;
dly = x;

% Equalizer filter data and weights initial conditions
for j=1:np-3;

% Equalizer implementation
	x = [r(j) x(1:M-1)];
	xsym = 0.5*(x + fliplr(x));
	z = xsym*wff';
	d = sign(z);
	dly = [d dly(1:M-1)];
	% Output for ploting
	e(j) = d - z;
	wff = wff + v*e(j)*xsym;
	out(j) = dly(:,1);
end
plot(e);
res = zeros(1,over*M);
for ll=1:M
	res(ll*over) = wff(ll);
end
pause;
fin = conv(res,fir);
mf = max(fin);
fin = fin/mf;
stem(fin);
for ll=1:length(fin)
	if (fin(ll)==1)
		ind = ll
	end
end
for pl=1:nfir
new(pl) = fin(pl+ind-nfir/2);
end






