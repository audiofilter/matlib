function sseq=or(seq, offset)
% OPTARRAY/OR  overloaded | operator, used as linear shift
% [sseq] = or (seq,offset)
%
% SEQ | OFFSET shifts the array by the offset vector OFFSET

if ~isa(seq,'optArray')
  error('in a|b, a must be an optArray and b must be an offset vector');
end

if min(size(offset)) ~= 1
  error('offset must be a vector.')
end

if length(offset) ~= get_dim(seq)
  error('offset of wrong dimension.')
end

if any(~isreal(offset))
  error('offset must be real.')
end

sseq = seq;
sseq.locs = sseq.locs + repmat(offset, size(sseq.locs,1), 1);
