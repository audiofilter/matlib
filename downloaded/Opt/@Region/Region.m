function [reg] = Region(arg1,arg2,arg3,arg4,arg5) 
% REGION Class to describe regions of space
%
% child members:
%   ind   : index of Region in global pool of Regions
%
% contained in the global OPT_DATA is a structure
% with the following information:
%   type  : indicates primitive type of Region
%   param : parameters of region type primitive
%   op1, op2 : pointers to operands of a composite Region
%   oper  : operator which created composite Region
%
% param is a structure containing the parameters for the various
% region types. All region types must contain the field param.dim, which
% indicates their dimension. All region primitive objects contain
% the field param.complement, which indicates whether a NOT
% operation was performed on that region. param.complement is not
% checked at construction time; rather, it is an internally-set
% flag. Further, type can be one of
%   'halfspace' is a halfspace, containing all points x such that
%      a'x >= b. param must contain the fields dim, a and b, where a
%      is a vector of length dim, and b is a scalar.
%   'sphere' is a hypersphere, containing all points x such that
%      norm(x) <= radius. param must contain the fields dim, center
%      and radius, where center is a vector of length dim which
%      indicates the center point of the hypersphere, and radius is
%      a positive, real scalar.
%   'convpoly' is a bounded convex polytope. Its constructor
%      requires param to contain the fields dim and points, where
%      points is a list of points describing the polytope. The
%      convex hull of the points is then determined, and fields A
%      and b are added to param, which describe the intersecting
%      halfspaces a'x >= b which determine the polytope.
%   'composite' is a region formed by set operations upon
%      primitive-type regions or other composite regions. A
%      composite Region object contains an additional field
%      param.primitiveChildren which indicates which primitive
%      regions are used to form the composite.
%   
% child methods:
% constructor:
%   [reg] = Region()
%      creates empty Region object
%   [reg] = Region(index)
%      pointer dereference. Returns the previously-allocated Region
%      object.
%   [reg] = Region(type, param) 
%      creates a Region object of the given type, with parameters
%      given in the structure param
%   [reg] = Region('composite', param, op1, op2, oper)
%      creates composite Region in param.dim-D space, composed of
%      operands op1 and op2, as a result of operation "oper"
% extraction methods:
%   dim = get_dim(reg)
%   type = get_type(reg)
% other methods:
%   [reg] = union(a,b) -or- plus(a,b)
%      union of regions
%   [reg] = intersect(a,b) -or- mtimes(a,b)
%      intersection of regions
%   [reg] = setdiff(a,b)
%      difference of regions
%   [rreg] = rot(reg, ang, dims)
%      region rotation
%   [locs] = points(reg, lat)
%      lattice points in region
%   [locs] = isin(reg, points)
%      points in region
% operators:
%   [reg] = not(a)     
%      region complement
%   [rreg] = or(reg, offset)
%      region shift

global OPT_DATA;

N = length(OPT_DATA.regions);

if nargin==0 
  error('too few input arguments for region type');
elseif (nargin==1) % dereference pointer
  if arg1>N
    error('cryptic error 6: trying to dereference unallocated region');
  end
  reg.ind = arg1;
  reg = class(reg, 'Region');
elseif (nargin==2) % called with (type,param)
  reg.ind = N+1;
  if exist([arg1 'Check']) ~= 2
    error (['primitive type ' arg1 ' not supported']);
  end
  [rc, newparam] = feval([arg1 'Check'], arg2, N+1); 
  % check parameters for given type
  if ~isempty(rc)
    error(rc);
  end
  OPT_DATA.regions(N+1).type = arg1;
  OPT_DATA.regions(N+1).param = newparam;
  OPT_DATA.regions(N+1).op1 = [];
  OPT_DATA.regions(N+1).op2 = [];
  OPT_DATA.regions(N+1).oper = '';
  OPT_DATA.regions(N+1).complement = 0;
  reg = class(reg, 'Region');
elseif (nargin==5) % called with (type,param,op1,op2,oper)
  % no param checking done, only for internal use.
  param = arg2; prims = [];
  if strcmp(arg1, 'composite')
    % determine primitives in operation tree
    % This will be used to calculate the tree's truth table
    if strcmp(OPT_DATA.regions(arg3).type, 'composite')
      prims = [prims OPT_DATA.regions(arg3).param.primitiveChildren];
    else
      prims = [prims arg3];
    end
    if strcmp(OPT_DATA.regions(arg4).type, 'composite')
      prims = [prims OPT_DATA.regions(arg4).param.primitiveChildren];
    else
      prims = [prims arg4];
    end
    param.primitiveChildren = unique(prims);
  end
  reg.ind = N+1;
  OPT_DATA.regions(N+1).type = arg1;
  OPT_DATA.regions(N+1).param = param;
  OPT_DATA.regions(N+1).op1 = arg3;
  OPT_DATA.regions(N+1).op2 = arg4;
  OPT_DATA.regions(N+1).oper = arg5;
  OPT_DATA.regions(N+1).complement = 0;
  reg = class(reg, 'Region');
else
  error('illegal arguments to Region()');
end;
