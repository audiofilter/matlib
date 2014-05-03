function answ = isempty(arr)
% OPTARRAY/ISEMPTY  True for empty optArray
%
% ISEMPTY(ARR) returns 1 if ARR is an empty optArray and 0
% otherwise.

if isempty(arr.locs)
  answ = logical(1);
else
  answ = logical(0);
end
