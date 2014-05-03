function y=zeroins(x,n)
%function y=zeroins(x,n)
%$Id: zeroins.m,v 1.1 1997/10/13 16:13:24 kirke Exp $
%
% This function adds n zeros after each entry (except the last) of the vector x (row or column).
% For example:    zeroins([1,2,3],3)=[1 0 0 0 2 0 0 0 3].  The 
% resulting vector will have its length increased by the factor n.
%
[a,b]=size(x);
if a ~= 1 & b~=1, 
	error('This routine only works on vectors, not matrices.');end
if a>b, x=x';end
x=[x;zeros(n,length(x))];
y1=x(:);
y = y1(1:length(y1)-n);
if b>a,y=y';end
