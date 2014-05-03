thres = 3;
ebno = 10.0;
sc = 0; 
sam = 16;
y = rc(0.3,sam,128);
ref = [1 1 1 -1 -1 1 -1];
brki = [0 0 0 0 0 0 ref 1 1 1];
np = length(brki)*sam;
for j=1:1
	d = zeros(1,np);
	for c=1:np/sam
		d(c*sam) = brki(c);
	end
	for c=1:np
		d(c) = d(c) + sc*randn;
	end
	r = conv(d,y);
	e = size(r,2);
	off=2*pi*randn;
	for c=1:e
		r(c) = r(c)*cos(0.5*pi*c+off);
	end
	az = abs(r);
	acc = conv([ones(1,16)],az);
	pass = zeros(1,e);
	upd = zeros(1,e);
	for c=2:e
		if (acc(c)>thres) pass(c)=1;
		else
			pass(c)=-1;
		end;
		upd(c) =upd(c-1)+pass(c);
		if (upd(c)<0) upd(c)=0; end;
	end
	plot(az);
%	pause;
end
	