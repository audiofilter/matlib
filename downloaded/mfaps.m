function [a1,a2,p,q] = mfaps(K,L,d)
% Design of a maximally flat lowpass filter H(z) as the
% sum of two allpass filters: H(z) = z^(-d) A2(z) + A1(z).
%
% SYNTAX: [a1,a2,p,q] = mfaps(K,L,d)
% K : number of conditions at w=0
% L : number of conditions at w=pi
% d : degree of delay
% Note: two conditions must be satisfied
%   (1) abs(K-L)+1 <= d <= K+L+1
%   (2) d must be same parity as K+L+1
% a1, a2 : the denominators of the allpass filters A1(z), A2(z)
% p/q : overall transfer function
%
% % example
% K = 6; L = 3; d = 6;
% [a1,a2,p,q] = mfaps(K,L,d);

% Ivan W. Selesnick
% Rice University
% December, 1996

% check input for validity:
b1 = (abs(K-L)+1 <= d) & (d <= K+L+1);
b2 = rem(K+L+1-d,2)==0;
if ~(b1 & b2)
   disp('For this K and L, d must be one of the following:');
   disp((abs(K-L)+1):2:(K+L+1));
   break
end

[tmp,a] = flatdelay(K,L,(d-K-L)/2);
rts = roots(a);
v = abs(rts)<1;
r1 = rts(v);                 	% roots inside unit circle
r2 = rts(~v);                	% roots outside unit circle
a1 = real(poly(r1));
a2 = real(poly(1./r2));

% compute overall transfer function p/q
p = [zeros(1,d), a] + [a(K+L+1:-1:1) zeros(1,d)];
q = conv(a1,a2);
p = p*sum(q)/sum(p);		% normalize


