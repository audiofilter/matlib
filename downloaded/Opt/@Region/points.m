function [locs] = points(reg, lat)
% REGION/POINTS  Lattice points in region
%
% LOCS = POINTS(REG, LAT) returns the points in the region REG on
% the lattice LAT. LOCS is an array with each row containing the
% the cartesian coordinates of a point.

M = get_M(lat);
if get_dim(reg) ~= size(M,2)
  error('Lattice and Region dimension mismatch.');
end
boundingbox = bb(reg, lat); % find bounding box for region
if boundingbox(1) == inf
  error('Region given is unbounded.')
end
biglocs = inbox(lat, boundingbox);
locs = isin(reg, biglocs);
