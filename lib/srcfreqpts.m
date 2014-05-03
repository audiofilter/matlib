function z = srcfreqpts(a,fr,pts)
for i=1:pts
f = fr*(i-1)/pts;
z(i) = srcfreq(f,a);
end
