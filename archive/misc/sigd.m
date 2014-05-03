b = [0 1 1 1 -1 -1 1 -1 1 1 1 1];
f = rc(0.3,4,32);
in = zeropad(b,3);
over = 4;
ou = conv(f,in);
oup = zeropad(ou,over-1);
oup = 128*conv(oup,ones(1,over));
acc=0;
out = zeros(1,size(oup,2));
num = 64;

for i=1:size(oup,2)-1
	acc = acc + oup(i);
	out(i) = floor(acc/num);
	acc = acc - num*out(i);
end
plot(out);
