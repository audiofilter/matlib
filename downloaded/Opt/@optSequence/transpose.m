function [tseq]=transpose(seq)
% OPTSEQUENCE/TRANSPOSE  flip
% [tseq]=transpose(seq)
% flips the sequence about the origin

h=get_h(seq);
tseq=seq;
tseq=set_h(tseq,fliplr(h));
tseq.noff=-1-(tseq.noff+size(h,2));

