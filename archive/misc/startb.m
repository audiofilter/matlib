N = 400;
thres = 3;
ebno = 10.0;
sc = 10^(-ebno/10); 
sam = 16;
y = rc(0.3,sam,128);
ref = [1 1 1 -1 -1 1 -1];
brki = [0 0 0 0 0 0 ref 1 1 1];
np = length(brki)*sam;
e = 383;
t = -232:e-233;
pass = zeros(1,e);
upd = zeros(1,e);
tri = zeros(1,N);

for j=1:N
	d = zeros(1,np);
	for c=1:np/sam
		d(c*sam) = brki(c);
	end
	for c=1:np
		d(c) = d(c) + sc*randn;
	end
	r = conv(d,y);
	off=2*pi*randn;
	for c=1:e
		r(c) = r(c)*cos(0.5*pi*c+off);
	end
	acc = conv([ones(1,16)],abs(r));
	upd(1) = 0;
	for c=2:e
		if (acc(c)>thres) pass(c)=1;
		else
			pass(c)=-1;
		end;
		upd(c) =upd(c-1)+pass(c);
		if (upd(c)<0) upd(c)=0; end;
	end
%	plot(t,upd);
%	hold on;
%	pause;
	tri(j) = upd(232);
end
xx=0:100;
h = hist(tri,xx);
plot(h);
%axis([-150 150 0 100]);
	