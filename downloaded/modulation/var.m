function y = var(x)

% VAR ......... Sample variance. 
%
%	VAR(X) returns the variance of the vector X.  If X is a matrix
%		VAR(X) is a row vector containing the variance of each column. 
%		See also STD.  Derived from the MATLAB M-function STD.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================


[m,n] = size(x);
if (m == 1) + (n == 1)
	m = max(m,n);
	y = norm(x-sum(x)/m);
else
	avg = sum(x)/m;
	y = zeros(size(avg));
	for i=1:n
		y(i) = norm(x(:,i)-avg(i));
	end
end
if m == 1
	y = 0;
else 
	y = y.^2/m;
end
