function [y,q] = bquantize(x,nsd,abstol,reltol)
%[y,q] = bquantize(x,nsd=3,abstol=eps,reltol=10*eps)
% Bidirectionally quantize a n by 1 vector x to nsd signed digits, 
% Terminate early if the error is less than the specified tolerances.
% y is the quantized value, q is a 2n by nsd matrix containing
% the powers of two used (odd rows) and their signs (even rows).
% If terminated early, the remaining elements of q are zero.
% See also bunquantize.m.

if nargin<4
    reltol = 10*eps;
    if nargin<3
	abstol = eps;
	if nargin<2
	    nsd = 3;
	end
    end
end

n = length(x);
q = zeros(2*n,nsd);
y = zeros(n,1);

for i = 1:n
    xp = x(i);
    for j = 1:nsd
	error = abs(y(i)-x(i));
	if error <= abstol | error <= x(i)*reltol;
	    break;
	end
	qp = nextpow2(abs(xp)/sqrt(2)); 
	sx = sign(xp);
	xp = xp- sx*pow2(qp);
	y(i) = y(i) + sx*pow2(qp);
	q(2*i-1:2*i,j) = [qp;sx]; 
    end
end
