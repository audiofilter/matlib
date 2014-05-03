function [tseq]=flip(seq, dim)
% OPTARRAY/FLIP  flip
% [tseq]=flip(seq, dim)
% flips the sequence
%   for example, to flip about the y-axis in 2-D, use flip(seq,1)
%                to flip about the xy-plane in 3-D, use flip(seq,3)

if dim > size(seq.locs, 2)
    error('dim is greater than dimension of sequence.')
end
if (dim < 1) | (~isreal(dim)) | (dim-floor(dim) ~= 0)
    error('dim must be a positive integer.')
end

htmp = get_h(seq);
tseq = seq;             % copy seq
locs = seq.locs;            
locs(:,dim) = locs(:,dim) * (-1); % flip selected dimension
[locs,II] = sortrows(locs);   % resort locs
htmp = htmp(:,II);          % and h matrix accordingly

tseq = set_h(tseq,htmp);
tseq.locs = locs;
