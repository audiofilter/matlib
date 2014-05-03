function [mseq]=minus(a,b)
% OPTSEQUENCE/MINUS  sequence subtraction
% [mseq]=minus(a,b)
% a and b should be of type optSequence
if ~isa(a,'optSequence') & ~isa(b,'optSequence')
  error('in a-b, both a and b must be of class optSequence');
else
  mseq=a+(-b);
end;
