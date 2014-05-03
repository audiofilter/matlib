function sseq=le(seq,nshift)
% OPTSEQUENCE/LE  overloaded <= operator, used as linear shift
% [sseq]=le(seq,nshift)
% seq<=nshift shifts the sequence left by nshift

if ~isa(seq,'optSequence') | ~isa(nshift,'double')
  error('in a<=b, a must be a sequence and b must be an integer');
else
  sseq=seq;
  sseq.noff=sseq.noff-nshift;
end;
