% Mu factor for adaptive equalizer
%v = input('Enter mu factor:');
v = 0.02;

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



