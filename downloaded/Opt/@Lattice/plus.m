function [olat] = plus(lat, off)
% LATTICE/PLUS  Lattice offset
%
% LAT+OFF returns the lattice LAT offset by the vector OFF.

if isa(lat, 'Lattice') & isa(off, 'Lattice')
  error('one argument must be an offset vector')
end

if isa(off, 'Lattice')
  olat = plus(off, lat);
  return;
end

if min(size(off)) ~= 1
  error('offset must be a vector.')
end

if length(off) ~= size(lat.M, 1)
  error('offset is of wrong dimension.')
end

olat = Lattice(lat.M, lat.scale, lat.off + off(:)');

