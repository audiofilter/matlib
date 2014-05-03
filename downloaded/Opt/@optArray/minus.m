function [mseq]=minus(a,b)
% OPTARRAY/MINUS  sequence subtraction
% [mseq]=minus(a,b)
% a and b should be of type optArray
 
if ~isa(a,'optArray') & ~isa(b,'optArray')
  error('in a-b, both a and b must be of class optArray');
else
  mseq=a+(-b);
end;
