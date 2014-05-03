function [rc, newparam] = sphereCheck(param, ind)
% REGION/PRIVATE/SPHERECHECK check parameters of new hypersphere
% param is parameter structure from constructor
%
% rc is return message.
% [] for valid parameters.
% also returns newparam, to allow for additional parameters.

rc = [];

if ~isstruct(param)
  rc = [rc char(10) 'parameters must be in a structure'];
  return;
end

if ~isfield(param,'dim')
  rc = [rc char(10) 'dimension parameter not present'];
end

if ~isfield(param, 'center')
  rc = [rc char(10) 'center parameter not present'];
end

if ~isfield(param, 'radius')
  rc = [rc char(10) 'radius parameter not present'];
end

if (param.dim < 1) | (param.dim - floor(param.dim) ~= 0) | ...
      (~isreal(param.dim))
  rc = [rc char(10) 'dimension must be a real nonnegative integer'];
end

if ~isempty(rc)
  return;
end

if prod(size(param.radius)) ~= 1 | ~isreal(param.radius) | ...
      param.radius < 0
  rc = [rc char(10) 'radius must be a positive, real scalar'];
end

if length(param.center) ~= param.dim 
  rc = [rc char(10) 'dimension must match length of center'];
end

param.center = param.center(:)'; % force a row vector
newparam = param;

