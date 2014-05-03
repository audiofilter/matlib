function z = rrs(f,n)
z = 1;
if (f==0) return;end
rrs = sin(0.5*pi*f*n)/sin(0.5*f*pi);
z = rrs/n;
