function [mseq]=mtimes(a,b)
% OPTSEQUENCE/MTIMES  sequence element-wise multiplication
% [mseq]=mtimes(a,b)
% legal inputs are (oseq,s),(oseq,sseq),(sseq,sseq)
%     where oseq is an optimized sequence,
%           sseq is a constant sequence (no variable dependence), and
%           s  is a (constant or optimized) scalar

global OPT_DATA;

% we know at least one of a,b is of class optSequence, but not which
if ~isa(a,'optSequence')
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
  elseif isa(b,'optSequence')
    if isconst(b)
      ha=get_h(a);
      hb=get_h(b);    %get the two h-matrices
      [Ma,Na]=size(ha);
      [Mb,Nb]=size(hb);
      nmin=[a.noff+1 b.noff+1];
      nmax=[a.noff+Na b.noff+Nb];
      % find the overlap region of the two sequences
      cn=[max(nmin) min(nmax)];
      % convert sequence indices to matrix indices
      ai=cn-a.noff;
      bi=cn-b.noff;
      % construct output with new h and noff
      mseq=a;
      mseq=set_h(mseq,ha(:,ai(1):ai(2)).*repmat(hb(1,bi(1):bi(2)),Ma,1));
      mseq.noff=cn(1)-1;
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
