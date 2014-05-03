function [c]=mtimes(a,b)
% OPTQUAD/MTIMES scalar multiplication
% [c]=mtimes(a,b)

% we know at least one of a,b is of class optQuad, but not which
if ~isa(a,'optQuad')
  c=b*a;
else
  if isa(b,'double')
    c=a;
    c.kernel=c.kernel*b;
  else
    error('an optQuad can only be multiplied by a scalar');
  end;
end;
