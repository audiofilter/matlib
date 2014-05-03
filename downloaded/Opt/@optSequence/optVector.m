function [myvector] = optVector(myseq) 
% optSequence/optVector :  cast function from optSequence to optVector
% function [myvector] = optVector(myseq)

global OPT_DATA;

% this really should be automatic in matlab.....
if OPT_DATA.casebug
  myvector = myseq.optvector;
else
  myvector=myseq.optVector;
end
