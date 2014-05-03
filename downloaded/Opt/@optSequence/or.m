function sseq=or(seq,nshift)
% optSequence/or  overloaded | operator, used as linear shift (delay)
% [sseq]=or(seq,nshift)
% seq|nshift shifts the sequence right by (delays by) nshift

if ~isa(seq,'optSequence') | ~isa(nshift,'double')
    error('in a|b, a must be a sequence and b must be an integer');
elseif nshift-floor(nshift) > 10*eps    % noninteger shift returns optGenSequence
    sseq=optGenSequence(seq)|nshift;
else
    sseq=seq;
    sseq.noff=sseq.noff+nshift;
end;
