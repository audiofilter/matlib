function [reg] = intersect(a, b)
% REGION/INTERSECT  intersection of regions
% [reg] = intersect(a, b)
% a and b should be of type Region


global OPT_DATA;

if ~isa(a,'Region') | ~isa(b,'Region')
  error('in intersect(a, b), both a and b must be of type Region');
end

dima = OPT_DATA.regions(a.ind).param.dim;
if dima ~= OPT_DATA.regions(b.ind).param.dim
  error('in intersect(a,b), dimension of a and b must match');
end

pa = OPT_DATA.regions(a.ind).param;
pb = OPT_DATA.regions(b.ind).param;

param.dim = dima;

reg = Region('composite', param, a.ind, b.ind, 'intersect');

