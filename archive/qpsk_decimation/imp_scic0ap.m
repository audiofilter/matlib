% $Id$
%clear all;
%clf;
dec_rate = 8;
over = dec_rate;
rcv_over = 2*over; % 2 samples/symbol
RX_M = 12*rcv_over + 1
alpha = 0.25;
% Receiver RC Filter used in calc_err
rcf = rc(alpha,rcv_over,RX_M);
norm = sqrt(sum(rcf*rcf'));
orig_rcf = rcf/norm;

%z_rcf = zeroins(orig_rcf,3);

cic_rate = 8;
%cic_rate = dec_rate;
%imp = cicmp(cic_rate,3);
imp = zeros(1,100);
imp(50) = 1;

sss = scicimp(cic_rate,2);
result = conv(sss,orig_rcf);



