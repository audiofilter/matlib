function [init_phase,rcv,orig_rcf] = sim_tx(nsym,over,M,alpha,freq,pn,src_offset)
% function [rcv,orig_rcf,freq] = sim_tx(nsym,over,M,alpha,freq,pn)
% Transmitter setup for Symbol timing discriminator to avoid
% recalculating random data for each gain, freq etc, simulation 
%
% Number of symbols
% Noise variance
%nv = 0.0;
% FREQ ERROR
%freq = 4*pi/(2*pi*over);
% gain
%gain = 0.0005;
% Square-root Raised cosine FIR
rcf = src(alpha,over,M);
%rcf = rc(alpha,over,M);
norm = sqrt(sum(rcf*rcf'));
orig_rcf = rcf/norm;
rcf = src_off(alpha,over,M,src_offset);
rcf = rcf/norm;
% Number of points in freq domain
yz = zeros(1,over*nsym) + i*zeros(1,over*nsym);
yi = zeros(1,over*nsym) + i*zeros(1,over*nsym);
yq = zeros(1,over*nsym) + i*zeros(1,over*nsym);
ydata = zeros(1,over*nsym) + i*zeros(1,over*nsym);
tx = zeros(1,over*nsym) + i*zeros(1,over*nsym);


% Random initial phase;
init_phase = 0; %2.4096;
%init_phase = rand*2*pi;
ph_deg = init_phase*180/pi;

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
ang = init_phase;
sz = size(tx,2);
for j=1:sz;
  ang = ang + freq;
  if (ang > 2*pi) 
    ang = ang - 2*pi;
  end
  rcv(j) = tx(j)*exp(i*ang);
end
