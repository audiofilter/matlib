function [y]= BoxFreq(x,d)

y=zeros(size(x));
i=find( -0.5 < x-d & x-d <= 0.5 );
y(i)=ones(size(i));
