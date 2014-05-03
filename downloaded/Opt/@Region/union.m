function [reg] = union(a, b)
% REGION/UNION  union of regions
% [reg] = union(a, b)
% a and b should be of type Region

global OPT_DATA;

if ~isa(a,'Region') | ~isa(b,'Region')
  error('in union(a, b), both a and b must be of type Region');
end

dima = OPT_DATA.regions(a.ind).param.dim;
if dima ~= OPT_DATA.regions(b.ind).param.dim
  error('in union(a,b), dimension of a and b must match');
end

%ba = OPT_DATA.regions(a.ind).param.bounded;
%bb = OPT_DATA.regions(b.ind).param.bounded;

param.dim = dima;
%param.bounded = ba & bb;
%if both of the regions are bounded, the union is.

reg = Region('composite', param, a.ind, b.ind, 'union');
