function [eqconstr]=eq(vect1,vect2)
% optVector/eq 
% linear equality constraint

% at least one of vect1 and vect2 is an optVector
eqconstr=LinConstr('==',optVector(vect1)-optVector(vect2));
