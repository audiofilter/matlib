function [lconstr]=lt(vect1,vect2)
% less-than < constraint involving an optVector
% returns constraint of type LinConstr

% At least one of vect1 and vect2 is an optVector (or a child):
% by casting here the same function will work for all children of optVector.
lconstr=LinConstr('<',optVector(vect1)-optVector(vect2));
% Note this will allow some combinations that don't really make sense,
% like optArray1<optArray2, where they don't line up.....
