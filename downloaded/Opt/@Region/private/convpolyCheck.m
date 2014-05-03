function [rc, newparam] = convpolyCheck(param, ind)
% REGION/PRIVATE/CONVPOLYCHECK check parameters of new convex polytope
% param is parameter structure from constructor
%
% rc is return message.
% [] for valid parameters.
% also returns newparam, to allow for additional parameters.

global OPT_DATA;

rc = [];

if ~isstruct(param)
  rc = [rc char(10) 'parameters must be in a structure'];
  return;
end

if ~isfield(param,'dim')
  rc = [rc char(10) 'dimension parameter not present'];
end

if ~isfield(param, 'points')
  rc = [rc char(10) 'points parameter not present'];
end

if (param.dim < 1) | (param.dim - floor(param.dim) ~= 0) | ...
      (~isreal(param.dim))
  rc = [rc char(10) 'dimension must be a real nonnegative integer'];
end

if ~isempty(rc)
  return;
end

if size(param.points,2) ~= param.dim 
  rc = [rc char(10) 'dim and dimension of points must match'];
end

newparam = param;
