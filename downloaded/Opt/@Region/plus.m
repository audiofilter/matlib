function [reg] = plus(a, b)
% REGION/PLUS  union of regions
% 
% [reg] = a + b returns the union of regions a and b. Has the same
% effect as union(a,b)

reg = union(a,b);
