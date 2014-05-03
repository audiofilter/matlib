function [locs] = inbox(lat, box)
% LATTICE/INBOX  Points within bounding box.
%
% [LOCS] = INBOX(LAT, BOX) returns the cartesian points on the
% lattice LAT located within the bounding box BOX.
% BOX is expressed as a vector: [xmin xmax ymin ymax ... ]
% and uses coordinates in lattice space.

if prod(size(box)) ~= max(size(box))
  error('bounding box must be a vector')
end
dim = size(lat.M,1);
if length(box) ~= dim*2
  error('box vector wrong length')
end
box = box(:)';

switch dim
 case 1 
  X = (box(1):box(2))';
  locs = lat.scale * lat.M * X';
 case 2
  [X, Y] = meshgrid(box(1):box(2), box(3):box(4));
  locs = lat.scale * lat.M * [X(:) Y(:)]';
 case 3
  [X, Y, Z] = meshgrid(box(1):box(2), box(3):box(4), box(5): ...
		       box(6));
  locs = lat.scale * lat.M * [X(:) Y(:) Z(:)]';
end

locs = locs' + repmat(lat.off, size(locs,2), 1); % apply lattice offset
