function [dseq]=rdivide(seq,M)
% optSequnce/rdivide  sequence interpolation by M
% [dseq]=rdivide(seq,M)

if ~isa(M,'double')
  error('Must interpolate by a scalar integer');
end;

if (length(M)~=1 | round(M)~=M)
  error('Must decimate by a scalar integer');
end;

n1=1+seq.noff;
n2=length(seq)+seq.noff;
k1=n1*M;
k2=n2*M;
dseq=optSequence;
dseq.noff=k1-1;
dseq=set_pool(dseq,get_pool(seq));
h1=get_h(seq);
h2=sparse(size(h1,1),k2-k1+1);
h2(:,(n1:n2)*M-dseq.noff)=h1;
dseq=set_h(dseq,h2);
dseq=set_xoff(dseq,get_xoff(seq));
