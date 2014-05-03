function [aquad]=power(a,b)
% OPTVECTOR/POWER  elementwise power
% [aquad]=power(a,b)   a.^b
% a must be an optVector, and b must be 2 (for now)

% we know at least one of a,b is of class optVector, but not which
if isa(a,'optVector') % is it a?
  if ~isa(b,'double') | prod(size(b))~=1
    error('an optVector can only be raised to a scalar power');
  end;
  if (b~=2)
    error('an optVector can only be raised to the power 2');
  end;
  if max(abs(imag(get_h(a)))) > 10*eps
    error('It only makes sense to square a real optVector.')
  end
  % casting here allows it to work for children as well.
  %aquad=optQuadVector(optVector(a),0,1);
  aquad=optQuadVector(real(optVector(a)),0,1);
else                  % must be b
  error('In a.^b, b must be 2');
end;
