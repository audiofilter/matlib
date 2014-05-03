function [reg] = mtimes(a, b)
% REGION/MTIMES  intersection of regions
% 
% [reg] = a * b returns the intersection of regions a and b. 
% Has the same effect as intersect(a,b)

reg = intersect(a,b);
