function [result,I] = halfspaceIsin(reg, points)
% REGION/PRIVATE/HALFSPACEISIN  determine if points are in a halfspace

global OPT_DATA;
param = OPT_DATA.regions(reg.ind).param;

map = zeros(size(points,1),1);

for qq = 1:size(points,1)
  if (param.a' * points(qq,:)' >= param.b)
    map(qq) = 1;
  end
end


if OPT_DATA.regions(reg.ind).complement
  map = not(map);
end
I = find(map);
if isempty(I)
	I=zeros(0,1); % needs to have extent 1
end;
result = points(I,:);
if isempty(I)
  % if there are no points  in  the region
  I=zeros(0,1); % needs to have extent 1 for concatenation
		% of composite region
end;
