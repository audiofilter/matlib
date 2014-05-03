function x = cmpi(name);
filename = [name '.dat'];
eval(['load ' filename]);
y = eval(name);
x = y(:,2);
for k=1:1024
	if (x(k)>2047) 
		x(k) = x(k)-4096;
	end
end;
xq = y(:,3);
for k=1:1024
	if (xq(k)>2047) 
		xq(k) = xq(k)-4096;
	end
end;
x = x + i*xq;
clear y;
clear xq;