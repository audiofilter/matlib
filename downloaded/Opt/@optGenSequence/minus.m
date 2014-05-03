function [mseq]=minus(a,b)
% OPTGENSEQUENCE/MINUS  sequence subtraction
% [mseq]=minus(a,b)
% a and b should be of type optGenSequence or optSequence

if isa(a,'optSequence')
    a=optGenSequence(a);
end;
if isa(b,'optSequence')
    b=optGenSequence(b);
end;

if ~isa(a,'optGenSequence') & ~isa(b,'optGenSequence')
  error('in a-b, both a and b must be of class optGenSequence or optSequence');
else
  mseq=a+(-b);
end;
