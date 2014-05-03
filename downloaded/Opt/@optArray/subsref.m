function sgs=subsref(seq,S)
%OPTARRAY/SUBSREF subscript operator
%
% Returns subsequence and elements of a sequence.
%
% subs = seq(locs) returns a subsequence at locations given in
% locs, where locs is a matrix.
% 
% subs = seq([xmin xmax ymin ymax ... ]) 
% returns a subsequence located in hypercube, with intervals given
% in a vector as above.
%
% subs = seq(n, 'i') returns a subsequence using 'Matlab' indices. For
% example, seq(1:4, 'i') returns a sequence containing the first
% through fourth elements of seq.
%
% subs = seq(reg) returns a subsequence with only those elements
% within a region indicated by the Region object reg.

global OPT_DATA;
if length(S) ~= 1
  error('illegal arguments to subsref()')
end;
sgs=[];
dim = size(seq.locs, 2);
switch S.type
 case '()'
  if length(S.subs) > 2*dim+1 
    error('illegal arguments to subsref()')
  elseif length(S.subs)==2 & S.subs{2} == 'i'     % reference by raw index
    sgs = optArray;
    sgs.locs = seq.locs(S.subs{1},:);  
    if OPT_DATA.casebug
      sgs.optvector=seq.optvector(S.subs{1});  % call optVector subsref
    else
      sgs.optVector=seq.optVector(S.subs{1});  % call optVector subsref
    end;
  elseif (length(S.subs) == 1) & isa(S.subs{1}, 'Region') % reference by Region
    sgs = optArray;
    [sgs.locs, keepidx] = isin(S.subs{1}, seq.locs);
    if ~isempty(keepidx)
      htmp = get_h(seq);
      sgs = set_xoff(sgs, get_xoff(seq));
      sgs = set_h(sgs, htmp(:,keepidx));
    else
      sgs = set_xoff(sgs, -1);
    end
  elseif (length(S.subs) == 1) & (size(S.subs{1},2)==2*dim) & ...
	(size(S.subs{1},1) == 1)
    % reference by range of space (hypercube)
    sgs = optArray;
    ranges = S.subs{1};
    stt = ranges(1:2:end); fih = ranges(2:2:end);
    keepidx = [];   % index of locations to keep (be extracted)
    for qq = 1:size(seq.locs,1)
      if (seq.locs(qq,:) <= fih) & (seq.locs(qq,:) >= stt)
	keepidx = [keepidx; qq];
      end
    end
    if ~isempty(keepidx)
      sgs.locs = seq.locs(keepidx,:);
      htmp = get_h(seq);
      sgs = set_h(sgs, htmp(:,keepidx));
      sgs  = set_xoff(sgs, get_xoff(seq));
    else % if empty seq is returned, it doesn't depend on opt vars
    sgs = set_xoff(sgs, -1);
    end;
  elseif (length(S.subs) == 1) & (size(S.subs{1},2) == dim)
    % reference by locations (locs)
    sgs = optArray;
    slocs = S.subs{1};
    [slocs,II] = sortrows(slocs);
    if ~isempty( find(sum(abs(diff(slocs,1,1)), 2) < 10*eps) ) 
      % since slocs is sorted check for neighboring matches
      error('duplicate entries in locations matrix');
    end;
    if ~isreal(slocs)
      error('non-real entries in locations matrix');
    end;
    keepidx = wherein(seq.locs, slocs);
    keepidx = keepidx(find(~isnan(keepidx)));
    if ~isempty(keepidx)
      sgs.locs = seq.locs(keepidx,:);
      htmp = get_h(seq);
      sgs = set_h(sgs, htmp(:,keepidx));
      sgs = set_xoff(sgs, get_xoff(seq));
    else    % return empty optArray which doesn't depend on opt vars
    sgs = set_xoff(sgs, -1);
    end;
    
  else
    error('illegal arguments to subsref()')
  end;
  
 case '.'
  % note-- allows access to hidden members; only here for debugging
  switch S.subs
   case 'locs'
    sgs = seq.locs;
   otherwise
    ;
  end;
 otherwise
  error('illegal arguments to subsref()');
end;
