function y=zeropad(x,n)
%function y=zeropad(x,n)
%$Id: zeropad.m,v 1.2 1997/10/13 16:11:56 kirke Exp $
%
% This function adds n zeros after each entry of the vector x (row or column).
% For example:    zeropad([1,2,3],3)=[1 0 0 0 2 0 0 0 3 0 0 0].  The 
% resulting vector will have its length increased by the factor n+1.
%
[a,b]=size(x);
if a ~= 1 & b~=1, 
	error('This routine only works on vectors, not matrices.');end
if a>b, x=x';end
x=[x;zeros(n,length(x))];
y=x(:);
if b>a,y=y';end