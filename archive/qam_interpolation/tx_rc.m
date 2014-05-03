function [tx,rcf] = tx_rc(nsym,over,M,alpha,freq,pn,src_offset)
rcf = rc_off(alpha,over,M,src_offset);
norm = sqrt(sum(rcf*rcf'));
rcf = rcf/norm;
% Number of points in freq domain
yz = zeros(1,over*nsym) + i*zeros(1,over*nsym);
yi = zeros(1,over*nsym) + i*zeros(1,over*nsym);
yq = zeros(1,over*nsym) + i*zeros(1,over*nsym);
ydata = zeros(1,over*nsym) + i*zeros(1,over*nsym);
tx = zeros(1,over*nsym) + i*zeros(1,over*nsym);

if (pn==1) 
% PN Generators for I & Q
yi = [pngen1(nsym,[1,6,8,14],[1 zeros(1,13)])];
yq = [pngen1(nsym,[1,6,10,14],[1 zeros(1,13)])];
for j=1:nsym;
  ydata(over*j) = (yi(j) + i*yq(j));
end
else
% DC Case
for j=1:nsym;
  ydata(over*j) = 1;
end
end
% Transmitter
tx = conv(rcf,ydata);
