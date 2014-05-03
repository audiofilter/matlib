function [result] = intersectIsin(a,b)
% REGION/PRIVATE/INTERSECTISIN  determine if points are in an intersection

result = intersect(a,b, 'rows');
