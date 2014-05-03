function [dseq]=ldivide(seq,M)
% optSequnce/ldivide  sequence decimation by M
% [dseq]=ldivide(seq,M)

if ~isa(M,'double')
  error('Must decimate by a scalar integer');
end;

if (length(M)~=1 | round(M)~=M)
  error('Must decimate by a scalar integer');
end;

n1=ceil((1+seq.noff)/M);
n2=floor((length(seq)+seq.noff)/M);
dseq=optSequence;
dseq=set_pool(dseq,get_pool(seq));
h=get_h(seq);
dseq=set_h(dseq,h(:,(n1:n2)*M-seq.noff));
dseq=set_xoff(dseq,get_xoff(seq));
dseq.noff=n1-1;
