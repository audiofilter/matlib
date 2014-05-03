function [tseq]=ctranspose(seq)
% OPTARRAY/CTRANSPOSE  conjugate-flip
% [tseq]=ctranspose(seq)
% flips the sequence about the origin and conjugates it

h=get_h(seq);
tseq=seq;
tseq=set_h(tseq,fliplr(conj(h)));
tseq.locs = flipud(-seq.locs);
