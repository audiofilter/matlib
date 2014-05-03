function [y]= BoxFreq(f,scale,freq)

y=zeros(size(f));
i=find( -0.5*scale < f-freq & f-freq <= 0.5*scale );
y(i)=ones(size(i));
