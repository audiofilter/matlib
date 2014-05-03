function [fx,vx,h1,h2,h3] = fils(r)
% Variable Decimation Rate filters from paper
% IEEE Proc ISCAS'88 pp 1525-1528 June 1998
% "Efficient VLSI-Realizable Decimators for Sigma-Delta
% Analog-to-Digital Converters" - Saramaki & Tenhunen
c1 = (2^-5 - 2^-10);
c2 = (2^-3 - 2^-9);
c3 = (2^-2 - 2^-6);

h1 = [c1 c2 c3 c3 c2 c1];

dg = (1 + 2^-1 - 2^-6);
d1 = (2^-6 + 2^-9);
d2 = -(2^-4 + 2^-5);
d3 = (1 + 2^-6);

h3 = dg*([d1 d2 d3 d2 d1]);


f1 = (2^-4 + 2^-6);
f2 = -(2^-3 + 2^-5 + 2^-6);
f3 = (2^-1 + 2^-3);

f = [f1 f2 f3 f3 f2 f1];

hb = (-2^-2 + 2^-9)*conv(f,f);
s = size(hb,2);
ha = (1 - 2^-2)*[zeros(1,5) 1 zeros(1,5)];

hc = ha + hb;
h2h = conv(hc,f);
h22h = zeropad(h2h,1);
s = size(h22h,2);
h2 = [zeros(1,15) 0.5 zeros(1,s-16)] + h22h;


hh = conv(h2, zeropad(h3,1));
hh = conv(h1, zeropad(hh,1));

SR = 4;
cic = cicimp(SR,4);
cic = cic/sum(cic);
fx = conv(cic, zeropad(hh,SR-1));

K = r/(4*SR);
if (K > 1) 
  acic = cicimp(K,3);
  acic = acic/sum(acic);
  vx = conv(acic, zeropad(fx,K-1));
end

