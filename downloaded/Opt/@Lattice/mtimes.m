function [mlat]=mtimes(a,lat)
% LATTICE/MTIMES  Lattice scaling
%
% A*LAT returns the lattice LAT scaled by the scalar A

if isa(a, 'Lattice') & isa(lat, 'Lattice')
  error('Lattice must be scaled by a scalar.')
end

if isa(a, 'Lattice')
  mlat = mtimes(lat, a);
  return;
end

if prod(size(a)) ~= 1
  error('Lattice must be scaled by a scalar.')
end

% now we are certain A is the scalar and LAT is the lattice.
mlat = Lattice(lat.M, a*lat.scale, lat.off);
