function x = local_max(c)
% finds location of local maxima

s = size(c); c = [c(:)].'; N = length(c);
b1 = c(1:N-1)<c(2:N); b2 = c(1:N-1)>c(2:N);
x = find(b1(1:N-2)&b2(2:N-1))+1;
if c(1)>c(2), x = [x, 1]; end
if c(N)>c(N-1), x = [x, N]; end
x = sort(x); if s(2) == 1, x = x'; end

