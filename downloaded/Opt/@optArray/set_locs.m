function ogs = set_locs(seq, locs)
% OPTARRAY/SET_LOCS
%   allows sequence's location index vector to be set

if size(locs) ~= size(seq.locs)
    error('vector of locations must have same size as original optArray');
end;

ogs = seq;
[locs,II] = sortrows(locs);

if ~isempty( find(sum(abs(diff(locs,1,1)), 2) < 10*eps) ) 
    % since locs is sorted check for neighboring matches
    error('duplicate entries in locations matrix');
end;
if ~isreal(locs)
    error('non-real entries in locations matrix');
end;

ogs.locs = locs;
h = get_h(seq);
ogs = set_h(ogs,h(:,II));