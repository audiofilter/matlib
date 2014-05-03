function [mseq]=mtimes(a,b)
% OPTGENSEQUENCE/MTIMES  sequence element-wise multiplication
% [mseq]=mtimes(a,b)
% legal inputs are (oseq,s),(oseq,sseq),(sseq,sseq)
%     where oseq is an optimized sequence,
%           sseq is a constant sequence (no variable dependence), and
%           s  is a (constant or optimized) scalar

global OPT_DATA;

if isa(a,'optSequence')
    a=optGenSequence(a);
end;
if isa(b,'optSequence')
    b=optGenSequence(b);
end;

% we know at least one of a,b is of class optGenSequence, but not which
if ~isa(a,'optGenSequence')
  mseq=b*a;
else
  if isa(b,'double')
    mseq=a;
    if OPT_DATA.casebug
      mseq.optvector=mseq.optvector*b;
    else
      mseq.optVector=mseq.optVector*b;
    end;
  elseif (~isconst(a) & ~isconst(b))
    error('only one term in a*b can depend on the opt vars');
  elseif isa(b,'optGenSequence')
    if isconst(b)
      ha=get_h(a);
      hb=get_h(b);    %get the two h-matrices
      [Ma,Na]=size(ha);
      [Mb,Nb]=size(hb);

      biglocs = sort([a.locs;b.locs]); % find overall time index vector
      newlocs = biglocs(find(abs(diff([biglocs;inf]))>eps)); % extract duplicate entries
      Nc=Na+Nb-length(find(abs(diff(biglocs))<eps)); % length of time dimension
      
      aidx=zeros(Na,1); bidx=zeros(Nb,1);
      for qq=1:Na
          aidx(qq) = find(abs(newlocs-a.locs(qq))<eps);
      end; % find locations for columns of  small h's in resulting h matrix
      for qq=1:Nb
          bidx(qq) = find(abs(newlocs-b.locs(qq))<eps);
      end; 
      htmpa=spalloc(Ma,Nc,nnz(ha));  % copy a into larger template
      htmpb=spalloc(Ma,Nc,Ma*nnz(hb));
      htmpa(:,aidx) = ha;
      htmpb(1,bidx) = hb;            % copy b into first row of larger template
      htmpb=repmat(htmpb(1,:),Ma,1); % replicate constant vector as many times 
                                     % as there are variables
      
      % construct output with new h and noff
      mseq=a; % wasteful to copy?
      mseq=set_h(mseq,htmpa.*htmpb);
      mseq.locs=newlocs;
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
