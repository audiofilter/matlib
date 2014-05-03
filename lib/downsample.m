function y=downsample(x,n)
%function y=downsample(x,n)
%
[a,b]=size(x);
if (a ~= 1 & b~=1)
  error('This routine only works on vectors, not matrices.');
endif
if (a>b) 
  x=x';
end
m = floor(length(x)/n);
j = 0;
for i=1:m
j = j+1;
y(j) = x(n*j);
end