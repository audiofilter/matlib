function z = plotsrc(alpha,points)

if nargin < 2;
  points = 200;
end;  
for i=1:points
  a(i) = srcfreq((i-1)/points, alpha);
  endfor
l = 10*log10(abs(a));
plot(l);	
axis([0 points -60 0]);
grid;
