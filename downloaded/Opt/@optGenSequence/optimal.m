function optseq=optimal(seq,soln)
% optGenSequence/optimal  return optimal (constant) sequence
% optseq=optimal(opt,soln)

global OPT_DATA;

optseq=optGenSequence;
if OPT_DATA.casebug
  optseq.optvector=optimal(seq.optvector,soln);
else
  optseq.optVector=optimal(seq.optVector,soln);
end;
optseq.locs=seq.locs;
  
