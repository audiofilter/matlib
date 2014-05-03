function [myvector] = optVector(myarray) 
% optArray/optVector :  cast function from optArray to optVector
% function [myvector] = optVector(myarray)

global OPT_DATA;

% this really should be automatic in matlab.....
if OPT_DATA.casebug
  myvector = myarray.optvector;
else
  myvector=myarray.optVector;
end
