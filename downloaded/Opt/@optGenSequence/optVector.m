function [myvector] = optVector(myseq) 
% optGenSequence/optVector :  cast function from optGenSequence to optVector
% function [myvector] = optVector(myseq)

global OPT_DATA;

% this really should be automatic in matlab.....
if OPT_DATA.casebug
  myvector = myseq.optvector;
else
  myvector=myseq.optVector;
end
