%clear all;
clf;
% Number of symbols
np = 1000;

start = 100;
yz = zeros(1,np);
r = zeros(1,np);

% PN Generators for I & Q
y = pngen1(np,[1,6,8,14],[1 zeros(1,13)]);
isps = 4;
yz = zeros(1,isps*np);

% PN Case
for j=1:np;
	yz(isps*j) = y(j);
end
% Feedforward span in symbols.
M = 4; 
Ns = 10;
ii=0;
for ii=0:Ns;
	offset = -0.5 + ii/Ns;
%offset= 0;
	% Raised cosine FIR
	fir = rc_off(0.25,isps,32,offset);
	nr = filter(fir,1,yz);

	ang2 = 0;
	init_ang2 = 0;
	for j=1:size(r,2)
	  ang2 = ang2 + pi/2;
	  if (ang2 > 2*pi) 
	    ang2 = ang2 - 2*pi;
	  end
	  r(j) = real(nr(j)*exp(-i*(ang2+init_ang2)));
	end

	% Mu factor for adaptive equalizer
	%v = input('Enter mu factor:');
	v = 0.02;

	% Initialize Equalizer parameters.
	x = zeros(1,M);

	wff = hlagr2(M,offset);

	% Equalizer filter data and weights initial conditions
	mms = 0;
	for j=1:isps:np-3;
	% Equalizer implementation
		x = [r(j+3) r(j+2) r(j+1) r(j)]; % this needs to change with isps!
		z = x*wff';
		d = sign(z);
		% Output for ploting
		if (j>start) 
			mms = mms + abs(z-d)*abs(z-d);
		end
		tmpe((j+2)/4) = z;
	end
	mms = isps*mms/(j-start);
	mmsl = 10*log(mms);
	taps(1:M,ii+1) = wff(1:M)';
	o(ii+1) = offset;
	err(ii+1) = mms;
	n(ii+1) = wff*wff';
	stem(wff);
%	hold on;
end
