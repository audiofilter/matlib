function [result] = unionIsin(a, b)
% REGION/PRIVATE/UNIONISIN  determine if points are in a union

result = union(a,b,'rows');
