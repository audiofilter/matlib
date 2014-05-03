function [eqconstr]=eq(a,b)
% OPTQUAD/EQ  [eqconstr]=eq(a,b)
% constraint of type a==b, where a is an optQuad and 
% b is an optQuad or a scalar
eqconstr=SOCConstr('==',a,b);
