function [result,I] = sphereIsin(reg, points)
% REGION/PRIVATE/SPHEREISIN  determine if points are in a sphere

global OPT_DATA;
param = OPT_DATA.regions(reg.ind).param;

map = zeros(size(points,1),1);

for qq = 1:size(points,1)
  if norm(points(qq,:)-param.center) <= param.radius
    map(qq) = 1;
  end
end


if OPT_DATA.regions(reg.ind).complement
  map = not(map);
end
I = find(map);
result = points(I,:);

