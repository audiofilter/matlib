function [cseq]=times(a,b)
% OPTGENSEQUENCE/TIMES  sequence convolution
% [cseq]=times(a,b)
% [cseq]=a.*b
% one of a,b must not depend on the optimization variables

if isa(a,'optSequence')
  a=optGenSequence(a);
end;
if isa(b,'optSequence')
  b=optGenSequence(b);
end;

global OPT_DATA;
%disp('hi there')
% we know at least one of a,b is of class optSequence, but not which
if isa(a,'optGenSequence') & isa(b,'optGenSequence')
  if isconst(b)
    ha=get_h(a);
    hb=full(get_h(b));
    [Ma,Na]=size(ha);
    [Mb,Nb]=size(hb);  
    
    % conv sum exists at (a.locs \times b.locs) locations
    Locs = repmat(b.locs', length(a.locs),1) + ...
	   repmat(a.locs, 1, length(b.locs));
    locs = sort(Locs(:));
    newlocs = locs(find(abs(diff([locs(:);inf]))>10*eps));   % desired locs
    
    if issparse(ha) & Nb == 1
      hc = spalloc(Ma, length(newlocs), length(newlocs)*Nb);
    else
      hc = zeros(Ma, length(newlocs));
    end
    for qq=1:length(newlocs)
      shiflocs = -b.locs+newlocs(qq);
      aidx = wherein(a.locs, shiflocs); % find matching time indices
      htmp = repmat(hb(:,find(~isnan(aidx))) , Ma, 1) ...
	     .* ha(:,aidx(find(~isnan(aidx))));
      hc(:,qq) = sum(htmp,2); % convolution sum
    end
    cseq=a;
    cseq=set_h(cseq,hc);
    cseq.locs = newlocs;
  elseif isconst(a)
    cseq=times(b,a);
  else
    error('only one of the variables in a.*b can depend on opt vars');
  end;
elseif isa(a, 'double')
  warning('DAN!!! for optGenSeqence .* double, casting o.G.S. to optVector');
  cseq = times(a, optVector(b));
elseif isa(b, 'double')
  warning('DAN!!! for optGenSeqence .* double, casting o.G.S. to optVector');
  cseq = times(optVector(a), b);
else
  error('optGenSequence can only be convolved with another optGenSequence');
  %warning('automatically casting argument to optGenSequence in times.m');
  %cseq=times(optGenSequence(a),optGenSequence(b));
end;  
