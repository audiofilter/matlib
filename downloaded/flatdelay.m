
function [b,a] = flatdelay(K,L,t)
% [b,a] = flatdelay(K,L,t)
% K : number of constraints at w=0
% L : number of constraints at w=pi
% t : group delay
% b/a : all-pole digital filter of degree K+L
%
% % example
% K = 6; L = 4; t = 3.2;
% [b,a] = flatdelay(K,L,t);

% Ivan W. Selesnick
% Rice University
% December, 1996

N = K+L;
a = zeros(1,N+1);
c = 1;
for i = 0:L
   n = i:N-1;
   v = (n-N) ./ (n-i+1) .* (2*t+n+i) ./ (2*t+N+1+n);
   a = a + [zeros(1,i), cumprod([c, v])];
   c = c * 4 * (t+i) * (L-i) / (2*t+N+1+i) / (i+1);
end
b = sum(a);

