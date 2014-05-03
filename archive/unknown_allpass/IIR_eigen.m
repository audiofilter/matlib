clear
ii=sqrt(-1);
P=128*2;
dw=2*pi/P;

%%%%%% Specification %%%%%%

N=6;  		%length of numerator
M=6; 		%length of denominator
pe=round(0.15*P); 	% normalized 
se=round(0.35*P); 	%    by 2*pi
tau=16; 	% group delay in passband
alpha=1; 	% weight of passband

%%%%%% Initialize %%%%%%

D=[exp(-ii*tau*(0:pe)*dw) zeros(1,P/2-pe)];
W=[alpha*ones(1,pe+1) zeros(1,se-pe-1) ones(1,P/2-se+1)];
D=[D fliplr(conj(D(2:P/2)))];
W=[W fliplr(W(2:P/2))];

WW=W;

sw2=10;

%%%%%% Main Loop %%%%%%

for iterate=0:100
int=[];
for n=0:N-1
int=[int real(sum(W.*exp(-ii*n*(0:P-1)*dw))/P)];
end
int2=sum(W)/P;

%% Construct Orhogonal Function %%

phi=eye(N,N);
for k=1:N
tmp2=0;
for i=1:k-1
tmp=0;
for l=1:i
tmp=tmp+phi(i,l)*int(k-l+1);
end
tmp2=tmp2+tmp*tmp;
phi(k,:)=phi(k,:)-phi(i,:)*tmp;
end
tmp2=sqrt(int2-tmp2);
phi(k,:)=phi(k,:)/tmp2;
end

%% Define Matrices %%

R=(ones(M,1)*(D.*sqrt(W))).*exp(-ii*(0:M-1)'*(0:P-1)*dw);

Q=zeros(N,P);
for i=1:N
	for j=1:i
	Q(i,:)=Q(i,:)+phi(i,j)*sqrt(W).*exp(-ii*(j-1)*(0:P-1)*dw);
	end
end
QQ=real(Q*Q');
QQ=sqrt(QQ(1,1));
Q=Q/QQ;

T=real(R*R'-R*Q'*Q*R');

%% Solve Eigenvalue-Problem %%

[V,DD]=eig(T);
[lambda,indi]=sort(diag(DD));
V=V(:,indi);


dcoe=real(V(:,1)); % coefficients of denominator
ncoe=real(Q*R'*dcoe);

dfreq=fft(dcoe,P);

ncoe2=zeros(N,1); % coefficients of numerator

for i=1:N
ncoe2=real(ncoe2+ncoe(i)*phi(i,:)'/QQ);
end

%% Preparation for Next Iteration %%

nfreq=fft(ncoe2',P);
h=nfreq./dfreq.';
plot(0:P/2,20*log10(abs(h(1:P/2+1))),[se se],[-70 10])
pause(0.2)
W=WW./(dfreq.*conj(dfreq)).';

sw=sum(W);

abs(sw-sw2)/sw;
if abs(sw-sw2)/sw<0.001
break
end
sw2=sw;

end %%%%%% End of Main Loop %%%%%%

%%%%%% Stability Check %%%%%%
s_check=abs(roots(dcoe));
for i=1:M-1
if s_check(i)>=1	
	disp('unstable')
	break
end
if i==M-1
	disp('stable')
end
end
E=(sqrt(WW).*(D-h));
E=E*E'/P %% Mean Square Error

plot(0:P/2,20*log10(abs(h(1:P/2+1))),[se se],[-70 10])
%plot(abs(h(1:pe)))
%plot(unwrap(angle(h(1:P/2))))
%grpdelay(ncoe2,dcoe,P)
%20*log10(abs(h(se+1)))
