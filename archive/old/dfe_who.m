% Demonstration of DFE Equalizer Using PN code
% generator for data (7-Apr-94).

% Mu factor for adaptive equalizer
%v = input('Enter mu factor:');
v = 0.02;

% Initialize Equalizer parameters.
x = zeros(1,M);
wff = x;
wff(:,4) = 1;
xfb = zeros(1,B);
wfb = xfb;
dly = x;

% Equalizer filter data and weights initial conditions
mms = 0;
for j=1:np-3;

% Equalizer implementation
	x = [r(j) x(1:M-1)];
	ff = x*wff';
	fb = xfb*wfb';
	z = ff - fb;
	d = sign(real(z)) + i*sign(imag(z));
	if (real(z)==0) 
		d = d+1;
	end
	if (imag(z)==0) 
		d = d+i;
	end
	dly = [d dly(1:M-1)];
	% Output for ploting
	if (j>start) 
		eq(j-start) = z;
		mms = mms + abs(z-d)*abs(z-d);
	end
	f(j) = d-z;
	if (j<64)
%		e(j) = y(j) - z;
		e(j) = d - z;
	else  
		e(j) = d - z;
%		e(j) = 0;
	end
	wff = wff + v*conj(e(j))*x;
	wfb = wfb - v*conj(e(j))*xfb;
	xfb = [x(:,1) xfb(1:B-1)];
	if (j<64)
		for list=1:M
			w(list,j) = wff(list);
		end
	end
end
% Plot signals
subplot(1,1,1), plot(abs(f)/2);
axis([0 200 0 1]);
grid;
%subplot(2,1,2), plot(imag(e));
%axis([0 np -1 1]);
%grid;
%pause;
%close;
%figure;
%[h, w] = freqz(wff,wfb,nf);
%subplot(1,1,1), plot(20*log10(abs(h)));
%grid;
mms = mms/(j-start)



