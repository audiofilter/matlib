function y=env(E,aa,bb)
Ed=diff(E);
j=1;
w=[];err=abs(E(aa));
for i=aa+2:bb-1
        %if Ed(i)<0&Ed(i-1)>0
	if Ed(i)*Ed(i-1)<0
		if err>2*abs(E(i))
			err=abs(E(i));
		else
                	w(j)=i;
                	j=j+1;
			err=abs(E(i));
		end
        end
end
E=abs(E);
w=[aa w bb];
dw=pi/(length(E)-1);
for i=1:length(w)-1
	a=(E(w(i))-E(w(i+1)))/((w(i)-w(i+1))*dw);
	b=E(w(i))-a*w(i)*dw;
	y(w(i):w(i+1))=a*((w(i):w(i+1))*dw)+b;
end
