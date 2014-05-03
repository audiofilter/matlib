function [pseq]=plus(a,b)
% OPTARRAY/PLUS  sequence addition
% [pseq]=plus(a,b)
% a and b should be of type optArray

global OPT_DATA; % needed only for casebug check

if ( isa(a,'optVector') & ~isa(a, 'optArray') ) ...
      | (isa(a, 'double') & prod(size(a)) == 1)
  % this allows     const + o.A.
  % must check both conditions since an optArray isa optVector too
  % if either is an optVector, do element-by-el addition
  if (length(a) == length(b)) | (length(a) == 1)
    pseq = b;
    if OPT_DATA.casebug
      pseq.optvector = a + b.optvector;
    else
      pseq.optVector = a + b.optVector;        
    end
  else
    error('in a+b, if a is an optVector, the lengths of a and b must match')
  end
elseif ( isa(b, 'optVector') & ~isa(b, 'optArray') ) ...
      | (isa(b, 'double') & prod(size(b)) == 1)
  if (length(a) == length(b)) | (length(b) == 1)
    pseq = a;
    if OPT_DATA.casebug
      pseq.optvector = a.optvector + b;
    else
      pseq.optVector = a.optVector + b;     
    end
  else
    error('in a+b, if b is an optVector, the lengths of a and b must match')
  end
elseif isa(a, 'optArray') & isa(b, 'optArray')
  if size(a.locs,2) ~= size(b.locs, 2)
    error('in a+b, both must be of the same dimension.')
  end
  ha=get_h(a);
  hb=get_h(b);        %get the two h-matrices
  % decide if result should be sparse or full
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
  ai=ax-cx+1; bi=bx-cx+1;         %convert to matrix indices
  locsAlignFlag = logical(0);
  if size(a.locs) == size(b.locs)
    if all(all(a.locs == b.locs))
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
    [biglocs, Is] = sortrows([a.locs;b.locs]);
	 % now need to "fix" the sort so that in every "identical" pair the a.locs version comes first
	 % this is a dirty hack that should be redone
	 ident1=find(sum(abs(diff(biglocs)), 2)<10*eps);
	 ident=[ident1 ident1+1]; % indices of identical locations
	 Ident=Is(ident);         % indices in unsorted concatenation of a.locs and b.locs
	 [tmp,itmp]=sort(Ident,2);
	 if ~isempty(tmp)
	   iswap=find(itmp(:,1)==2);% indices that are in the "wrong" order
	   tmp=Is(ident(iswap,1));  % do the swapping
	   Is(ident(iswap,1))=Is(ident(iswap,1)+1);
	   Is(ident(iswap,1)+1)=tmp;
	 end;
    % combine locs's
    % find unique entries
    infs = inf.*ones(1,size(biglocs,2));
    dupid2 = find(sum(abs(diff([biglocs;infs])), 2) > 10*eps);    
    % find unique entries
    dupid1 = find(sum(abs(diff([-infs;biglocs])), 2) >10*eps); 
    % repeat, keeping indices on right
    newlocs = biglocs(dupid2,:); % extract unique entries
    Nc=Na+Nb-length(find(sum(abs(diff(biglocs)), 2)<10*eps)); 
    % length of time dimension
 
    if sparseFlag
      % if both addends have sparse kernels, let the sum be sparse
      htmpa=spalloc(Mc,Nc,nnz(ha));
      htmpb=spalloc(Mc,Nc,nnz(hb));
    else
      htmpa = zeros(Mc,Nc);
      htmpb = zeros(Mc,Nc);
    end
    % copy h matrices to larger template
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
else
  error('in a+b, both a and b must be of class optArray or optVector');
end;
