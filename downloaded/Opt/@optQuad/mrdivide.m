function [c]=mrdivide(a,b)
% OPTQUAD/MRDIVIDE scalar division
% [c]=mrdivide(a,b)

% we know at least one of a,b is of class optQuad, but not which
if isa(a,'optQuad')  % is it a?
  if ~isa(b,'double') | prod(size(b))~=1
    error('an optQuad can only be divided by a scalar');
  end;
  c=a;
  c.kernel=c.kernel/b;
else                  % must be b
  error('cannot divide by an optQuad');
end;
