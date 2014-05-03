clear
ii=sqrt(-1);
P=256*2;
dw=2*pi/P;

N=15;

t=11;
u=N+1-t;
W=100;
pe=round(0.3*P);
se=round(0.4*P);
delta=0.001;
PP=ones(1,P/2+1);
ww(1:t)=round((0:t-1)*(pe-1)/(t-1))+1;
ww(t+1:N+1)=round((0:u-1)*(P/2-se)/(u-1))+se+1;

while 1
S=sin(ww(1:t)'*(1/2:-1:1/2-N)*dw);
C=cos(ww(t+1:N+1)'*(-1/2:1:N-1/2)*dw);
T=[S;C];
s=delta*(-1).^(0:t-1).*PP(ww(1:t));
c=delta*(-1).^(0:u-1).*PP(ww(t+1:N+1))/W;
b=[s';c'];
x=(inv(T)*b)';
c=x*cos((0:N)'*(0:P/2)*dw);
s=x*sin((0:N)'*(0:P/2)*dw);
PP=sqrt(c.*c+s.*s);
H0=(x*cos((-1/2:1:N-1/2)'*(0:P/2)*dw))./PP;
H1=(x*sin((1/2:-1:1/2-N)'*(0:P/2)*dw))./PP;

Ha0=abs(H0);
Ha1=abs(H1);
Hd0=diff(Ha0);
Hd1=diff(Ha1);
w2=[];j=1;Mp=0;Ms=0;
for i=[2:pe-1 se-1:P/2-2]
	if i<pe
		if Hd1(i)>0&Hd1(i+1)<0
			w2(j)=i+1;
			j=j+1;
			Ms=Ms+1;
		end
	else 
		if Hd0(i)>0&Hd0(i+1)<0	
			w2(j)=i+1;
			j=j+1;
			Mp=Mp+1;
		end
	end
end
plot(Ha0)
plot(1:P/2+1,20*log10(Ha0),[se se],[-100 0])
axis([0 P/2+1 -100 0])
pause
if Mp>=t
ww=[w2 pe];
else ww=[1 w2 pe];
end
if Ms>=u
ww=[ww se];
else ww=[ww se P/2+1];
end
ww=sort(ww);
delta=(sum(Ha1(ww(1:t)))+sum(Ha0(ww(t+1:N+1))/W))/t+u;
end