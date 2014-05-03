% $Id$
%clear all;
%clf;
dec_rate = 8;
over = 4*dec_rate;
rcv_over = 2*over; % 2 samples/symbol
RX_M = 12*rcv_over
alpha = 0.25;
% Receiver RC Filter used in calc_err
rcf = rc(alpha,rcv_over,RX_M);
norm = sqrt(sum(rcf*rcf'));
orig_rcf = rcf/norm;

%z_rcf = zeroins(orig_rcf,3);

cic_rate = 8;
%cic_rate = dec_rate;
%imp = cicmp(cic_rate,3);
imp = zeros(1,1000);
imp(50) = 1;


a1 = 0.25;
a2 = 0.75;
a1p = [a1 1];
a2p = [a2 1];
a1_up = zeroins(a1p,1);
a2_up = zeroins(a2p,1);

a1z = filter(a1_up,rot90(a1_up,2),imp);
a2z = filter([0 a2_up],rot90(a2_up,2),imp);
res1 = 0.5*(a1z + a2z);

a11z = zeroins(a1p,3);
a12z = zeroins(a2p,3);

z11 = filter(a11z,rot90(a11z,2),res1);
z12 = filter([0 0 a12z],rot90(a12z,2),res1);
res2 = 0.5*(z11 + z12);

up = zeropad(res2,cic_rate-1);

imp2 = cicimp(cic_rate,3);

out = conv(up,imp2);

result = conv(out,orig_rcf);



