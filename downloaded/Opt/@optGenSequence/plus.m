function [pseq]=plus(a,b)
% OPTGENEQUENCE/PLUS  sequence addition
% [pseq]=plus(a,b)
% a and b should be of type optGenSequence or optSequence

if isa(a,'optSequence')
    a=optGenSequence(a);
end;
if isa(b,'optSequence')
    b=optGenSequence(b);
end;

if isa(a, 'optGenSequence') & isa(b, 'optGenSequence')
  ha=get_h(a);
  hb=get_h(b);        %get the two h-matrices
  if issparse(ha) & issparse(hb)
    sparseFlag = logical(1); % true
  else
    if any([issparse(ha) issparse(hb)]) & ...
	  any([size(ha,2) size(hb,2)] == 1)
      sparseFlag = logical(1);
    else
      sparseFlag = logical(0);
    end
  end
  xoffa=get_xoff(a);
  xoffb=get_xoff(b);  %get the x-offsets
  [Ma,Na]=size(ha);
  [Mb,Nb]=size(hb);            %get dimensions
  ax=xoffa+1; bx=xoffb+1;      %min coords
  cx=min([ax bx]);             %superset region of the two sequences
  Mc=max([ax+Ma bx+Mb])-cx;
  %dimensions of sum
  ai=ax-cx+1; bi=bx-cx+1;        % convert to matrix indices
  locsAlignFlag = logical(0);
  if size(a.locs) == size(b.locs)
    if all(a.locs == b.locs)
      locsAlignFlag = logical(1);
    end
  end
  if locsAlignFlag
    % no need for this stuff if locs line up
    newlocs = a.locs;
    Nc = Na;  
    % copy h matrices to larger template
    if sparseFlag
      % if both addends are sparse
      htmpa = [sparse(ai-1, Nc); ha; sparse(Mc-(ai+Ma-1), Nc)];
      htmpb = [sparse(bi-1, Nc); hb; sparse(Mc-(bi+Mb-1), Nc)];
    else
      htmpa = [zeros(ai-1, Nc); ha; zeros(Mc-(ai+Ma-1), Nc)];
      htmpb = [zeros(bi-1, Nc); hb; zeros(Mc-(bi+Mb-1), Nc)];
    end
  else
    [biglocs, Is] = sort([a.locs;b.locs]);   
    % combine locs's
    dupid2 = find(abs(diff([biglocs;inf]))>10*eps);    
    % find unique entries
    dupid1 = find(abs(diff([-inf;biglocs]))>10*eps); 
    % repeat, keeping indices on right
    newlocs = biglocs(dupid2); % extract unique entries
    Nc=Na+Nb-length(find(abs(diff(biglocs))<10*eps));
    % length of time dimension
    % copy h matrices to larger template
    if sparseFlag
      % if both addends are sparse, let the sum be sparse too
      htmpa=spalloc(Mc,Nc,nnz(ha));
      htmpb=spalloc(Mc,Nc,nnz(hb));
    else
      htmpa = zeros(Mc, Nc);
      htmpb = zeros(Mc, Nc);
    end
    aidx = find(Is(dupid1) <= Na);    % determine locations for columns of ha and hb 
    bidx = find(Is(dupid2) >  Na);    %   in larger template
    htmpa(ai:ai+Ma-1,aidx) = ha;      % copy columns of ha and hb into larger template
    htmpb(bi:bi+Mb-1,bidx) = hb;
  end
 
  hc=htmpa+htmpb;    

  pseq=a;
  pseq=set_h(pseq,hc);
  pseq=set_xoff(pseq,cx-1);
  pseq.locs=newlocs;              % create the output sequence
  if (get_pool(a)~=get_pool(b))
    if (get_pool(a)==0)
      pseq=set_pool(pseq,get_pool(b));
    elseif (get_pool(b)~=0)
      error('in a+b, a and b must depend on the same optSpace');
    end;
  end;
elseif isa(b, 'double') & ...
      (prod(size(b)) == 1 | (length(b) == length(a) & min(size(b)) == 1) )
  xoffa = get_xoff(a);
  if xoffa == -1
    hc = get_h(a);
  else
    ha = get_h(a);
    Nc = length(a);
    if issparse(ha)
      hc = spalloc(xoffa + size(ha, 1) + 1, Nc, nnz(ha) + Nc);
    else
      hc = zeros(xoffa + size(ha,1) + 1, Nc);
    end
    hc(xoffa+2:end,:) = hc(xoffa+2:end,:) + ha;
  end
  hc(1,:) = hc(1,:) + b(:).';
  pseq = optGenSequence;
  pseq = set_h(pseq, hc);
  pseq = set_xoff(pseq, -1);
  pseq.locs = support(a);
  pseq = set_pool(pseq, get_pool(a));
elseif isa(a, 'double') & ...
      (prod(size(a)) == 1 | (length(b) == length(a) & min(size(a)) == 1) )
  pseq = plus(b,a);
else
  error('in a+b, both a and b must be of class optGenSequence or optSequence');
end;
