function [rpsum]=plus(rpa,rpb)
% CTPROCESS/PLUS  process addition [rpsum]=plus(rpa,rpb)
%       sum of two random processes.  Any base processes shared by
%       rpa and rpb have their systems combined, the rest are concatenated
global OPT_DATA;

if ~isa(rpa,'CTProcess') | ~isa(rpb,'CTProcess')
  error('in rpa+rpb, both rpa and rpb must be of class CTProcess');
end

Na=length(rpa.ind);
Nb=length(rpb.ind);
rpsum=rpa;           %initialize sum to the first process
% loop over base processes
for b=1:Nb
  found=0;
  for a=1:Na
    if (rpa.ind(a)==rpb.ind(b))
      rpsum.sys{a}=rpa.sys{a}+rpb.sys{b};
      found=1;
    end;
  end;
  if ~found
    Nsum=length(rpsum.ind);
    rpsum.ind(Nsum+1)=rpb.ind(b);
    rpsum.sys{Nsum+1}=rpb.sys{b};
  end;
end;
