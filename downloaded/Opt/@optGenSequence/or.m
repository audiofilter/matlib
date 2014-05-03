function sseq=or(seq,nshift)
% optGenSequence/or  overloaded | operator, used as linear shift (delay)
% [sseq]=or(seq,nshift)
% seq|nshift shifts the sequence right by (delays by) nshift

if ~isa(seq,'optGenSequence') | ~isa(nshift,'double')
  error('in a|b, a must be a sequence and b must be an integer');
else
  sseq=seq;
  sseq.locs=sseq.locs+nshift;
end;
