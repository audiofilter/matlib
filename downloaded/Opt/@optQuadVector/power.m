function [quadvec]=power(a,b)
% optQuadVector/power  elementwise power
% [aquad]=power(a,b)   a.^b
% a must be an abs-only optQuadVector, and b must be 2 (for now)

% we know at least one of a,b is of class optVector, but not which
if isa(a,'optQuadVector') % is it a?
  if ~isa(b,'double') | prod(size(b))~=1
    error('an optQuadVector can only be raised to a scalar power');
  end;
  if (b~=2)
    error('an optQuadVector can only be raised to the power 2');
  end;
  if (a.sqflag)
    error('the optQuadVector is already squared');
  end;
  quadvec=set_sqflag(a,1);
else                  % must be b
  error('In a.^b, b must be 2');
end;
