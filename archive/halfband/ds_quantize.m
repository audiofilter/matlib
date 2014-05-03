function v = ds_quantize(y,n)
%v = ds_quantize(y,n=2)
%Quantize y to 
% an odd integer in [-n+1, n-1], if n is even, or
% an even integer in [-n, n], if n is odd.
%
%This definition gives the same step height for both mid-rise
%and mid-tread quantizers.
if nargin<2
    n=2;
end

if rem(n,2)==0	% mid-rise quantizer
    v = 2*floor(0.5*y)+1;
else 		% mid-tread quantizer
    v = 2*floor(0.5*(y+1));
end

% Limit the output
L = n-1;
i = v>L; 
if any(i)
    v(i) = L(ones(size(v(i))));
end
i = v<-L;
if any(i)
    v(i) = -L(ones(size(v(i))));
end
