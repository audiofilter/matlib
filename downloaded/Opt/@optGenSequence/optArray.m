function [myarr] = optArray(myseq) 
% optGenSequence/optArray :  cast function from optGenSequence to optArray
% function [myarr] = optArray(myseq)

global OPT_DATA;

% this really should be automatic in matlab.....
if OPT_DATA.casebug
  myarr = optArray(myseq.locs, myseq.optvector);
else
  myarr = optArray(myseq.locs, myseq.optVector);
end
