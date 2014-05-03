function sgs=subsref(seq,S)
%OPTGENSEQUENCE/SUBSREF subscript operator
%returns subsequence and elements of a sequence
%
% usage:  subs=seq(n) returns a subsequence at times given in n
%         subs=seq(n1,n2) returns a subsequence between times n1 and n2
%         subs=seq(n,'i') returns subsequence using matlab indices

global OPT_DATA;
if length(S) ~= 1
    error('illegal arguments to subsref()')
end;
sgs=[];
switch S.type
case '()'
    if length(S.subs) > 3 
        error('illegal arguments to subsref()')
    elseif length(S.subs)==2 & S.subs{2} == 'i'
      % reference by raw index
        sgs = optGenSequence;
        sgs.locs = seq.locs(S.subs{1});  
        if OPT_DATA.casebug
            sgs.optvector=seq.optvector(S.subs{1});  % call optVector subsref
        else
            sgs.optVector=seq.optVector(S.subs{1});  % call optVector subsref
        end;
    elseif (length(S.subs)==3 & S.subs{3}=='t') | ...
           (length(S.subs)==2 & ...
           (length(S.subs{1})==1 & length(S.subs{2}==1)) & isa(S.subs{2},'double') )
        % reference by range of time
        stt = S.subs{1}; fih = S.subs{2};
        if (stt >= fih)
            error ('start of range must be less than end of range')
        end;
        sgs = optGenSequence;
        sidx = find(seq.locs>=stt);
        if isempty(sidx)
            sidx = 1
        else
            sidx = sidx(1);
        end;
        fidx = find(seq.locs<=fih);
        if isempty(fidx)
            fidx = length(seq)
        else
            fidx = fidx(end);
        end;
        sgs.locs = seq.locs(sidx:fidx);
        if OPT_DATA.casebug
            sgs.optvector = seq.optvector(sidx:fidx);
        else
            sgs.optVector = seq.optVector(sidx:fidx);
        end        
    elseif (length(S.subs)==2 & S.subs{2}=='t') | ...
            (length(S.subs)==1 & isa(S.subs{1},'double') )
        % reference by locations
        sgs = optGenSequence;
        locs = sort(S.subs{1}(:));
        newlocs = locs(find(abs(diff([locs;inf]))>10*eps));    % desired locs
        keepidx = wherein(seq.locs, newlocs);   % find locations in sequence
	keepidx = keepidx(find(~isnan(keepidx)));
        ha = get_h(seq);
	if ~isempty(keepidx)
	  sgs.locs = seq.locs(keepidx);
	  htmp = get_h(seq);
	  sgs = set_h(sgs, htmp(:,keepidx));
	  sgs = set_xoff(sgs, get_xoff(seq));
	else
	  % return empty o.G.S. which doesn't depend on opt vars
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
    error('illegal arguments to o.G.S./subsref()');
end;
