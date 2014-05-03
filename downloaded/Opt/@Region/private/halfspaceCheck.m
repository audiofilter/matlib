function [rc, newparam] = halfspaceCheck(param, ind)
% REGION/PRIVATE/HALFSPACECHECK check parameters of new halfspace
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

if ~isfield(param, 'a')
  rc = [rc char(10) 'a parameter not present'];
end

if ~isfield(param, 'b')
  rc = [rc char(10) 'b parameter not present'];
end

if (param.dim < 1) | (param.dim - floor(param.dim) ~= 0) | ...
      (~isreal(param.dim))
  rc = [rc char(10) 'dimension must be a real nonnegative integer'];
end

if ~isempty(rc) % enough errors for now!
  return;
end

if prod(size(param.b)) ~= 1 | ~isreal(param.b)
  rc = [rc char(10) 'b must be a real scalar'];
end

if length(param.a) ~= param.dim
  rc = [rc char(10) 'dimension must match length of a'];
end

newparam = param;
