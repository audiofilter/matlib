function [y]= TriangleFreq(x,d)

y=zeros(size(x));
i=find( -1 < x-d & x-d <= 1 );
y(i)= 1-abs(x(i)-d);
