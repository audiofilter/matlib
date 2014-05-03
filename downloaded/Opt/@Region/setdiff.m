function [reg] = setdiff(a, b)
% REGION/SETDIFF  set difference of regions
% Returns region whose members are in a but not b.
% [reg] = setdiff(a, b) has the same effect as
% [reg] = intersect(a, ~b)
% a and b should be of type Region

global OPT_DATA;

if ~isa(a,'Region') | ~isa(b,'Region')
  error('in setdiff(a, b), both a and b must be of type Region');
end

dima = OPT_DATA.regions(a.ind).param.dim;
if dima ~= OPT_DATA.regions(b.ind).param.dim
  error('in setdiff(a,b), dimension of a and b must match');
end

compB = ~b; 
% create the complement of b. Note that this allocates another
% Region.

param.dim = dima;

reg = Region('composite', param, a.ind, compB.ind, 'intersect');
