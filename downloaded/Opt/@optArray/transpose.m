function [tseq]=transpose(seq)
% OPTARRAY/TRANSPOSE  flip
% [tseq]=transpose(seq)
% flips the sequence about the origin

h=get_h(seq);
tseq=seq;
tseq=set_h(tseq,fliplr(h));
tseq.locs = flipud(-seq.locs);
