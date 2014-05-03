function [y]= TriangleTime(x,d)
% y	 elementwise on a vector or matrix x: \sinc^2(x)*e^{j2\pi d x}
%	 d is scalar (normalized) freq offset,
%	 where 2 corresponds to triangle width

% allocate space
   y=zeros(size(x));
% for nonzero arguments
   i= find(x~=0);
   px= pi*x(i);
   y(i)=(sin(px)./px).^2.*exp(j*2*pi*d*x(i));
% for zero arguments
   i= find(x==0);
   y(i)= ones(size(i));
