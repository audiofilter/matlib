function [tseq]=rot(seq, ang, dims)
% OPTARRAY/ROT  rotate sequence
% [tseq]=rot(seq, ang, dims)
%
% Rotates the sequence by ang radians in dimensions dims
% dims is a length-2 vector indicating the subspace in which
% the rotation is performed.
% If dims is omitted, a default of dims=[1 2] is used.
% For example, rot(seq, pi/4, [1 3]) will rotate seq 45 degrees 
% in the xz-subspace.

if size(seq.locs, 2) < 2
    error('sequence must be at least 2-D.')
end

if nargin < 3
  dims = [1 2];
end

dims = sort(dims(:));
if (any(~isreal(dims))) | (length(dims) ~= 2) | ...
        (size(dims,2) ~= 1) | (any(dims-floor(dims))) | ...
        (any(dims < 1))
    error('dims must be a length-2 vector of positive integers.')
end
if dims(end) > size(seq.locs,2)
    error('dims is greater than dimension of sequence.')
end

htmp = get_h(seq);
tseq = seq;             % copy seq
locs = seq.locs;            

Q = [cos(ang) -sin(ang); sin(ang) cos(ang)];
locs(:,dims) = locs(:,dims) * Q'; % rotate selected dimensions

[locs,II] = sortrows(locs);   % resort locs
htmp = htmp(:,II);          % and h matrix accordingly

tseq = set_h(tseq,htmp);
tseq.locs = locs;
