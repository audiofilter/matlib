function [gd]=GroupDelay(x,df);
% [gd]=GroupDelay(x,df)
% calculates group delay of freq. data x with spacing df
gd=zeros(size(x));
lx=size(x,2);
gd(:,2:lx-1)=angle(x(:,1:lx-2).*conj(x(:,3:lx)))/(4*pi*df);
gd(:,1)=angle(x(:,1).*conj(x(:,2)))/(2*pi*df);
gd(:,lx)=angle(x(:,lx-1).*conj(x(:,lx)))/(2*pi*df);
