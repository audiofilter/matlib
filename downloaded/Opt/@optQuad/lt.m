function [constr]=lt(obj1,obj2)
% less-than < constraint involving an optQuad
% returns constraint of type SOCConstr

if ~isa(obj1,'optQuad')
  error('in a<b, a must be optQuad if b is')
end;
if ~(isa(obj2,'optQuad') | isa(obj2,'optQuadVector') | isa(obj2,'double'))
  error('illegal argument in a<b')
end;
constr=SOCConstr('<',obj1,obj2);
