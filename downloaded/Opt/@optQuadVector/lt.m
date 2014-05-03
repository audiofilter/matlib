function [constr]=lt(obj1,obj2)
% less-than < constraint involving an optQuadVector
% returns constraint of type SOCConstr

% check if left is an optQuadVector
if ~isa(obj1,'optQuadVector')
  error('in a<b, a must be optQuadVector if b is');
end;

if (isa(obj2,'optQuadVector') | isa(obj2,'optVector')) % isa not appropriate?
  constr=SOCConstr('<',obj1,obj2);
elseif  isa(obj2,'double')
  constr=SOCConstr('<',obj1,optVector(obj2));
else
  error('illegal argument in a<b');
end;
