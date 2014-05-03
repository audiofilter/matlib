clear all;
clf;
% Number of symbols
np = 5000;

start = 1000;
yz = zeros(1,np);
r = zeros(1,np);

% PN Generators for I & Q
yz = pngen1(np,[1,6,8,14],[1 zeros(1,13)]);

% Feedforward span in symbols.
M = 5; 
isps = 4;
Ns = 10;
ii=0;
%for ii=0:Ns;
offset = -0.5/isps + ii/(isps*Ns);
% Raised cosine FIR
	fir = rc_off(0.5,1,8,offset);
	r = filter(fir,1,yz);

% Mu factor for adaptive equalizer
%v = input('Enter mu factor:');
v = 0.04;

% Initialize Equalizer parameters.
x = zeros(1,M);
wff = x;
wff(:,floor((M+1)/2)) = 1;
dly = x;

% Equalizer filter data and weights initial conditions
mms = 0;
for j=1:np-3;
% Equalizer implementation
	x = [r(j) x(1:M-1)];
	z = x*wff';
	d = sign(z);
%	d = (exp(2*z) - 1)/(exp(2*z)+1);
	dly = [d dly(1:M-1)];
	% Output for ploting
	if (j>start) 
		mms = mms + abs(z-d)*abs(z-d);
	end
	e(j) = d-z;
	wff = wff + v*(e(j))*x;
	end
% Plot signals
%plot(abs(e));
%axis([0 200 0 1]);
%grid;
mms = mms/(j-start);
mmsl = 10*log(mms);


	taps(1:M,ii+1) = wff(1:M)';
	o(ii+1) = offset;
	err(ii+1) = mms;
	n(ii+1) = wff*wff';
%	stem(wff);
%	hold on;
%end
