N = 20;
thres = 3;
ebno = 10.0;
sc = 10^(-ebno/10);
sam = 16;
y = rc(0.3,sam,128);
np = 16*sam;
e = 383;
t = -232:e-233;
pass = zeros(1,e);
upd = zeros(1,e);
tri = zeros(1,N);

for j=1:N
	d = zeros(1,np);
	nc = sc*randn(size(d));
	r = conv(nc,y);
	off=2*pi*randn;
	for c=1:e
		r(c) = r(c)*cos(0.5*pi*c+off);
	end
	acc = conv([ones(1,16)],abs(r));
	upd(1) = 63;
	for c=2:e
		if (acc(c)>thres) pass(c)=1;
		else
			pass(c)=-1;
		end;
		upd(c) =upd(c-1)+pass(c);
		if (upd(c)<0) upd(c)=0; end;
		if (upd(c)>63) upd(c)=63; end;
	end
	plot(upd);
	hold on;
%	pause;
	tri(j) = upd(232);
end
%xx=0:100;
%h = hist(tri,xx);
%plot(h);
%axis([-150 150 0 100]);
	