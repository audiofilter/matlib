function [result] = setdiffIsin(a, b)
% REGION/PRIVATE/SETDIFFISIN  determine if points are in a union

result = setdiff(a,b,'rows');
