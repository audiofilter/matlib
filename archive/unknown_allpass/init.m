clear 
N=9;
%[b,a]=butter(7,0.1);
[b,a]=ellip(N,0.5,30,0.1);
gd=grpdelay(b,a,128);
P2=conv(b,b);
D2=conv(fliplr(a),a);
r=P2-D2;
q(1)=sqrt(r(1));q(2)=r(2)/2/q(1);
for i=3:N+1
tmp=q(2:i-1)*fliplr(q(2:i-1))';
q(i)=(r(i)-tmp)/(2*q(1));
end
[h,w]=freqz(q,a,128);
plot(abs(h))
rq=roots(b+q);
rp=roots(b-q);
rq2=[];rp2=[];
for i=1:length(rq)
	if abs(rq(i))>=1
		rq2=[rq2 rq(i)];
	end
	if abs(rp(i))>=1
		rp2=[rp2 rp(i)];
	end
end
coe2=fliplr(real(poly(rq2)));
coe1=fliplr(real(poly(rp2)));
coe2=coe2/coe2(1);
coe1=coe1/coe1(1);
[h1,w]=freqz(fliplr(coe1),coe1,128);
[h2,w]=freqz(fliplr(coe2),coe2,128);
plot(abs(h1+h2))
save coe1 coe1
save coe2 coe2
