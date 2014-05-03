function [mseq]=mtimes(a,b)
% OPTARRAY/MTIMES  sequence element-wise multiplication
% [mseq]=mtimes(a,b)
% legal inputs are (oseq,s),(oseq,sseq),(sseq,sseq)
%     where oseq is an optimized sequence,
%           sseq is a constant sequence (no variable dependence), and
%           s  is a (constant or optimized) scalar

global OPT_DATA;

% we know at least one of a,b is of class optArray, but not which
if ~isa(a,'optArray')
  mseq=b*a;
else
  if isa(b,'double')
    mseq=a;
    if OPT_DATA.casebug
      mseq.optvector=mseq.optvector.*b;
    else
      mseq.optVector=mseq.optVector.*b;
    end;
  elseif (~isconst(a) & ~isconst(b))
    error('only one term in a*b can depend on the opt vars');
  elseif isa(b,'optArray')
    if get_dim(a) ~= get_dim(b)
      error('Sequences must be of the same dimension.');
    end
    if isconst(b)
      ha=get_h(a);
      hb=get_h(b);    %get the two h-matrices
      [Ma,Na]=size(ha);
      [Mb,Nb]=size(hb);
      locsAlignFlag = logical(0);
      if size(a.locs) == size(b.locs)
	if all(all(a.locs == b.locs))
	  locsAlignFlag = logical(1);
	end
      end
      if locsAlignFlag
	% no need for this stuff if locs line up
	mseq = a;
	mseq = set_h(mseq, ha.*repmat(hb, Ma, 1));
	mseq.locs = a.locs;
      else
	[biglocs,Is] = sortrows([a.locs;b.locs]); % find overall time index vector
	infs = inf.*ones(1,size(biglocs,2));
	dupid = find(sum(abs(diff([biglocs;infs])), 2) < 10*eps); 
	% only entries at same location have nonzero products
	dupkeep = Is([dupid;dupid+1]);     % finds entries to keep and multiply 
	numdup = length(dupkeep)/2;        % number of entries to keep
	newlocs = a.locs(dupkeep(1:numdup),:); % determine resulting locs
	htmpa = ha(:,dupkeep(1:numdup));   % copy relevant columns to temp. matrices
	htmpb = repmat(hb(:,dupkeep(numdup+1:end)-Na), Ma, 1 );
	
	% construct output with new h and noff
	mseq=a; % wasteful to copy?
	mseq=set_h(mseq,htmpa.*htmpb);
	mseq.locs=newlocs;
	if size(htmpa,2) == 0             % if we have an empty product
          mseq=set_xoff(mseq,-1);       % then mseq doesn't depend on opt vars
	end;
      end
    else 
      mseq=b*a;
    end;
  elseif (isa(b,'optVector') & length(b)==1)
    mseq=a;
    mseq=set_h(mseq,get_h(b)*get_h(a));
    if isconst(b)
      mseq=set_xoff(mseq,get_xoff(a));
      mseq=set_pool(mseq,get_pool(a));
    else
      mseq=set_xoff(mseq,get_xoff(b));
      mseq=set_pool(mseq,get_pool(b));
    end;
  else
    error('incompatible types in a*b');
  end;
end;
