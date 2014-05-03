function optseq=optimal(seq,soln)
% optSequence/optimal  return optimal (constant) sequence
% optseq=optimal(opt,soln)

global OPT_DATA;

optseq=optSequence;
if OPT_DATA.casebug
  optseq.optvector=optimal(seq.optvector,soln);
else
  optseq.optVector=optimal(seq.optVector,soln);
end;
optseq.noff=seq.noff;
  
