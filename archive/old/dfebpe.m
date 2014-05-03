% Mu factor for adaptive equalizer
v = input('Enter mu factor:');
%v = 0.02;

% Initialize Equalizer parameters.
x = zeros(1,M);
wff = x;
wff(:,4) = 1;
xfb = zeros(1,B);
wfb = xfb;

% Initialize BPE
RTD = 57.295781;
nbpe = 8;
oqtstate = 0; 
quad_prev = 0;
bit = zeros(1,nbpe) + i*zeros(1,nbpe);
				

% Equalizer filter data and weights initial conditions
mms = 0;
for j=1:np-3;

% Equalizer implementation
	x = [r(j) x(1:M-1)];
	ff = x*wff';
	fb = xfb*wfb';
	z = ff - fb;
	in = z;
% Block Phase Estimator
	bpe;
	angout(j) = ang;
% End BPE
% Apply BPE phase correction
	if (j>nbpe)
		z = z*exp(-i*angout(j-1));
	end
	d = sign(real(z)) + i*sign(imag(z));
	if (real(z)==0) 
		d = d+1;
	end
	if (imag(z)==0) 
		d = d+i;
	end
	% Output for ploting
	if (j>start) 
		eq(j-start) = z;
		mms = mms + abs(z-d)*abs(z-d);
	end
	f(j) = d-z;
	if (j<nbpe)
		e(j) = 0;
	else
		e(j) = (d - z);
	end
	wff = wff + v*conj(e(j))*x;
	wfb = wfb - v*conj(e(j))*xfb;
	xfb = [x(:,1) xfb(1:B-1)];
end
% Plot signals
subplot(1,1,1), plot(abs(f)/2);
axis([0 64 0 1]);
grid;
mms = mms/(j-start)



