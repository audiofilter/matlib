function vol = volume(reg)
% REGION/VOLUME  volume of region
%
% vol = volume(reg)
%
% returns inf if volume is infinite

type = OPT_DATA.regions(reg.ind).type;
param = OPT_DATA.regions(reg.ind).param;

if type ~= 'composite'
  vol = feval([type 'Volume'], param);
  return;
else
  ;
  ;
end


