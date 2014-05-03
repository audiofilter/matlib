% $Id$
%clear all;
%clf;
dec_rate = 8;
over = dec_rate;
rcv_over = 2*over; % 2 samples/symbol
RX_M = 12*rcv_over
alpha = 0.25;
% Receiver RC Filter used in calc_err
rcf = rc(alpha,rcv_over,RX_M);
norm = sqrt(sum(rcf*rcf'));
orig_rcf = rcf/norm;

imp = zeros(1,400);
imp(50) = 1;

a1 = 0.25;
a2 = 0.75;
f1 = half_ap(imp,2,a1,a2);
f2 = half_ap(f1,4,a1,a2);
out = half_ap(f2,8,a1,a2);
result = conv(out,orig_rcf);



