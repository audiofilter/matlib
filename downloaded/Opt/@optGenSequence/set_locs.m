function ogs = set_locs(seq, locs)
% OPTGENSEQUENCE/SET_locs 
%   allows sequence's time index vector to be set

if length(locs) ~= size(get_h(seq), 2)
    error('vector of time indices must have same length as optGenSequence');
end;

ogs = seq;
[locs,II] = sort(locs);

if ~isempty(find(abs(diff(locs))<10*eps)) % since locs is sorted check for neighboring matches
    error('duplicate entries in vector of time indices');
end;
if ~isreal(locs)
    error('non-real entries in vector of time indices');
end;

ogs.locs = locs(:);
h = get_h(seq);
ogs = set_h(ogs,h(:,II));
