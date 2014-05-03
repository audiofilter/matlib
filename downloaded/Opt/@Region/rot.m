function [rreg]=rot(reg, ang, dims)
% REGION/ROT  rotate region
% [rreg]=rot(reg, ang, dims)
%
% Rotates the region by ang radians in dimensions dims
% dims is a length-2 vector indicating the subspace in which
% the rotation is performed.
% If dims is omitted, a default of dims=[1 2] is used.
% For example, rot(reg, pi/4, [1 3]) will rotate reg 45 degrees 
% in the xz-subspace.

global OPT_DATA;

if get_dim(reg) < 2
    error('Region must be at least 2-D.')
end

if nargin < 3
  dims = [1 2];
end

dims = sort(dims(:));
if (any(~isreal(dims))) | (length(dims) ~= 2) | ...
        (size(dims,2) ~= 1) | (any(dims-floor(dims))) | ...
        (any(dims < 1))
    error('dims must be a length-2 vector of positive integers.')
end
if dims(end) > get_dim(reg)
    error('dims is greater than dimension of Region.')
end

if strcmp(OPT_DATA.regions(reg.ind).type, 'composite')
  % for composite, rotate every Region in the tree
  switch regdata.oper
   case 'union'
    reg = union( rot(Region(regdata.op1), ang, dims), ...
		 rot(Region(regdata.op2), ang, dims) );
   case 'intersect'
    reg = intersect( rot(Region(regdata.op1), ang, dims), ...
		     rot(Region(regdata.op2), ang, dims) );
  end
else
  % execute rotation for specific primitive type (private fcn)
  rreg = feval([OPT_DATA.regions(reg.ind).type 'Rot'], reg, ang, dims);
end
