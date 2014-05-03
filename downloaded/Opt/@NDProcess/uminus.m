function [rpmin]=uminus(rp)
% NDProcess/uminus  process negation [rpmin]=minus(rp)
global OPT_DATA;
N=length(rp.ind);
rpmin=rp;
for n=1:N
  rpmin.sys{n}=-rpmin.sys{n};
end;
