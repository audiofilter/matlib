function [y]= TriangleFreq(f,scale,freq)
% Private function for use in plotting process psd

y=zeros(size(f));
i=find( -scale < f-freq & f-freq <= scale );    % find locations within width of tri.
y(i)= 1-abs(f(i)-freq)/scale;
