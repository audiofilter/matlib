function res = half_ap(inp,over,a1,a2)
% $Id$
if (nargin < 4)
  a1 = 0.25;
  a2 = 0.75;
  over = 2;
end
a1p = [a1 1];
a2p = [a2 1];
a1_up = zeroins(a1p,over-1);
a2_up = zeroins(a2p,over-1);

a1z = filter(a1_up,rot90(a1_up,2),inp);
a2z = filter([zeros(1,over/2) a2_up],rot90(a2_up,2),inp);
res = 0.5*(a1z + a2z);



