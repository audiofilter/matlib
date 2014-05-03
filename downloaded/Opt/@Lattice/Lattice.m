function [lat] = Lattice(arg1,arg2,arg3,arg4,arg5) 
% LATTICE Class to describe lattices
%
% child members:
%   M     : basis matrix of lattice
%   scale : lattice scale factor
%   off   : offset vector
%
% child methods:
% constructor:
%   [lat] = Lattice()
%      creates empty Lattice object
%   [lat] = Lattice(M) 
%      creates a Lattice object with basis matrix M
% extraction functions:
%   [M] = get_M(lat)
%   scale = get_scale(lat)
%   [off] = get_off(lat)
% lattice maniplulation methods:
%   [lat] = sublat(a,b)
%      sublattice
% operators:
%   [lat] = mtimes(a,b) 
%      lattice scaling
%   [lat] = plus(a,b)
%      lattice offset
% other methods:
%   [locs] = inbox(lat, box)
%      Lattice points within bounding box

global OPT_DATA;

if nargin==0 
  lat.M = [];
  lat.scale = [];
  lat.off = [];
  lat = class(lat, 'Lattice');
elseif (nargin==1) % called with Lattice(M)
  if size(arg1,1) ~= size(arg1,2)
    error('Basis matrix must be square')
  end
  if det(arg1) == 0
    error('Basis matrix not invertible')
  end
  lat.M = arg1;
  lat.scale = 1;
  lat.off = zeros(1, size(arg1,1));
  lat = class(lat, 'Lattice');
elseif (nargin==3) % fully specified Lattice for internal use
  if size(arg1,1) ~= size(arg1,2)
    error('Basis matrix must be square')
  end
  if det(arg1) == 0
    error('Basis matrix not invertible')
  end
  if min(size(arg3)) ~= 1
    error('offset must be a vector.')
  end
  if size(arg1,1) ~= length(arg3)
    error('offset is of wrong dimension.');
  end
  lat.M = arg1;
  lat.scale = arg2;
  lat.off = arg3(:)';
  lat = class(lat, 'Lattice');
else
  error('illegal arguments to Lattice()');
end;
