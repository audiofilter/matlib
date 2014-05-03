function [rpmin]=minus(rpa,rpb)
% CTProcess/minus  process subtraction [rpmin]=minus(rpa,rpb)
%       difference of two random processes.  Any base processes shared by
%       rpa and rpb have their systems combined, the rest are concatenated

rpmin=rpa+(-rpb);
