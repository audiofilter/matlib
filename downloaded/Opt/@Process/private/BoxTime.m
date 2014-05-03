function [y]= BoxTime(x,d)
%y	 elementwise on a vector or matrix x: \sinc(x)*e^{j2\pi d x}
%	 d is scalar (normalized) freq offset,
%	 where 1 corresponds to rectangle width

%allocate space
   y=zeros(size(x));
%for nonzero arguments
   i= find(x~=0);
   px= pi*x(i);
   y(i)=(sin(px)./px).*exp(j*2*pi*d*x(i));
%for zero arguments
   i= find(x==0);
   y(i)= ones(size(i));
