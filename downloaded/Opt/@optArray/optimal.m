function optseq=optimal(seq,soln)
% optArray/optimal  return optimal (constant) sequence
% optseq=optimal(opt,soln)

global OPT_DATA;

optseq=optArray;
if OPT_DATA.casebug
  optseq.optvector=optimal(seq.optvector,soln);
else
  optseq.optVector=optimal(seq.optVector,soln);
end;
optseq.locs=seq.locs;
  
