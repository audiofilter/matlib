function [dopt]=mrdivide(a,b)
% OPTVECTOR/MRDIVIDE scalar division
% [dopt]=mrdivide(a,b)

% we know at least one of a,b is of class optVector, but not which
if isa(a,'optVector')  % is it a?
  if ~isa(b,'double') | prod(size(b))~=1
    error('an optVector can only be divided by a scalar');
  end;
  dopt=a;
  dopt.h=dopt.h/b;
else                  % must be b
  error('cannot divide by an optVector');
end;
