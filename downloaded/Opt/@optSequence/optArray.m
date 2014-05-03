function [myarr] = optArray(myseq) 
% optSequence/optArray :  cast function from optSequence to optArray
% function [myarr] = optArray(myseq)

global OPT_DATA;

locs = myseq.noff+1:myseq.noff+length(myseq);

% this really should be automatic in matlab.....
if OPT_DATA.casebug
  myarr = optArray(locs(:), myseq.optvector);
else
  myarr = optArray(locs(:), myseq.optVector);
end
