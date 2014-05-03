function [fx,vx,hb1,hb2,hb3,K] = fils2(r)
% Variable Decimation Rate filters from paper
% IEEE Trans on Signal Processing, Vol 45, No. 2, Feb 1997
% "Application of Filter Sharpening to Decimation Filters"
% - Kwentus et al.

h0 =  -2^-12 - 2^-14 - 2^-16;
h2 =   2^-10 - 2^-13 - 2^-15;
h4 =  -2^-9  + 2^-13 + 2^-14;
h6 =   2^-8  - 2^-11 - 2^-14;
h8 =  -2^-7  + 2^-9  + 2^-14 - 2^-16;
h10 =  2^-7  + 2^-9  - 2^-12 - 2^-16;
h12 = -2^-6  + 2^-11 + 2^-12 - 2^-16;
h14 =  2^-6  + 2^-7  - 2^-11 - 2^-13;
h16 = -2^-5  - 2^-8  + 2^-13 + 2^-15;
h18 =  2^-4  - 2^-7  + 2^-10 + 2^-14;
h20 = -2^-4  - 2^-5  - 2^-7  + 2^-11;
h22 =  2^-2  + 2^-4  + 2^-8  - 2^-12;
h23 =  2^-1  - 2^-10 + 2^-12 - 2^-15;

hb3= [h0 0 h2 0 h4 0 h6 0 h8 0 h10 0 h12 0 h14 0 h16 0 h18 0 h20 0 ...
	  h22 h23 h22 0 h20 0 h18 0 h16 0 h14 0 h12 0 h10 0 h8 0 h6 0 ...
	  h4 0 h2 0 h0];


h0 =  -2^-9 - 2^-11;
h2 =   2^-6 + 2^-10 + 2^-12 + 2^-14;
h4 =  -(2^-4  + 2^-8 + 2^-10 + 2^-12);
h6 =   2^-2  + 2^-4 - 2^-7  -2^-9  + 2^-11;
h7 = 0.5;

hb2= [h0 0 h2 0 h4 0 h6 h7 h6 0 h4 0 h2 0 h0];

h0 =  2^-8 + 2^-9;
h2 =   -2^-5 - 2^-6 - 2^-9;
h4 =  (2^-2  + 2^-5 + 2^-7 + 2^-8);
h5 = 0.5;

hb1= [h0 0 h2 0 h4 h5 h4 0 h2 0 h0];

SR = 4;

hh = conv(hb2, zeropad(hb3,1));
hh = conv(hb1, zeropad(hh,1));
scic = scicimp(SR,2);
scic = scic/sum(scic);
fx = conv(scic, zeropad(hh,SR-1));

K = r/(8*SR);
if (K > 1) 
acic = cicimp(K,3);
acic = acic/sum(acic);
vx = conv(acic, zeropad(fx,K-1));
end