function [quadvec]=times(a,b)
% OPTQUADVECTOR/TIMES  scalar multiplication
% [aquad]=times(a,b)   a .* b
% a must be an optQuadVector, and b must be a scalar

% we know at least one of a,b is of class optVector, but not which
if isa(a,'optQuadVector') % is it a?
  if ~isa(b,'double') | prod(size(b))~=1
    error('an optQuadVector can only be multiplied by a scalar');
  end;
  absflag = get_absflag(a);
  sqflag = get_sqflag(a);
  aff = get_optVector(a);
  if sqflag
    aff = aff .* sqrt(b);
  else
    aff = aff .* b;
  end
  quadvec = optQuadVector(aff, absflag, sqflag);
else                  % must be b
  quadvec = times(b,a);
  %error('In a.*b, b must be a scalar');
end;
