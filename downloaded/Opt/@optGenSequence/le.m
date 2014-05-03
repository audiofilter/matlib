function sseq=le(seq,nshift)
% OPTGENSEQUENCE/LE  overloaded <= operator, used as linear shift
% [sseq]=le(seq,nshift)
% seq<=nshift shifts the sequence left by nshift

if ~isa(seq,'optGenSequence') | ~isa(nshift,'double')
  error('in a<=b, a must be a sequence and b must be an integer');
else
  sseq=seq;
  sseq.locs=sseq.locs-nshift;
end;
