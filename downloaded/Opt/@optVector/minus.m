function [maff]=minus(a,b)
% OPTVECTOR/MINUS  affine subtraction
% [maff]=minus(a,b)
% a and b should be of type optVector
if ~isa(a,'optVector') & ~isa(b,'optVector')
  error('in a-b, both a and b must be of class optVector');
else
  maff=a+(-b);
end;
