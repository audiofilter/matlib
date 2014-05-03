function [yo,ye] = odd(x)
n = size(x,1);
for j=1:n/2
yo(j) = x(2*j-1);
ye(j) = x(2*j);
end