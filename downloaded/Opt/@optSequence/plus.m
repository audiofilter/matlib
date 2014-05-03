function [pseq]=plus(a,b)
% OPTSEQUENCE/PLUS  sequence addition
% [pseq]=plus(a,b)
% a and b should be of type optSequence

if ~isa(a,'optSequence') | ~isa(b,'optSequence')
  error('in a+b, both a and b must be of class optSequence');
else
  ha=get_h(a);
  hb=get_h(b);        %get the two h-matrices
  xoffa=get_xoff(a);
  xoffb=get_xoff(b);  %get the x-offsets (n-offsets are members)
  [Ma,Na]=size(ha);
  [Mb,Nb]=size(hb);            %get dimensions
  an=a.noff+1; ax=xoffa+1; 
  bn=b.noff+1; bx=xoffb+1;     %min coord in both dimensions
  cx=min([ax bx]);
  cn=min([an bn]);             %superset region of the two sequences
  Mc=max([ax+Ma bx+Mb])-cx;
  Nc=max([an+Na bn+Nb])-cn;    %dimensions of sum
  ai=ax-cx+1; bi=bx-cx+1;
  aj=an-cn+1; bj=bn-cn+1;      % convert to matrix indices
  if issparse(ha) & issparse(hb)
    % if both kernels are sparse, let the new kernel be sparse
    htmpa=spalloc(Mc,Nc,nnz(ha));
    htmpb=spalloc(Mc,Nc,nnz(hb));
  else
    htmpa = zeros(Mc, Nc);
    htmpb = zeros(Mc, Nc);
  end
  htmpa(ai:ai+Ma-1,aj:aj+Na-1)=ha;
  htmpb(bi:bi+Mb-1,bj:bj+Nb-1)=hb;
  hc=htmpa+htmpb;
%
% *Note*: The above code creates two extra variables, htmp[a|b]
% It is MUCH faster than the fragment below, which clearly results in
% some horrible memory allocation loop, possibly a matlab bug
% As is usually the case, this is suboptimal when h[a|b] aren't very sparse
%
%  hc=spalloc(Mc,Nc,max([nnz(ha) nnz(hb)]));
%  hc(ai:ai+Ma-1,aj:aj+Na-1)=ha;
%  hc(bi:bi+Mb-1,bj:bj+Nb-1)=hc(bi:bi+Mb-1,bj:bj+Nb-1)+hb; % all time here

  % assemble the sum
  pseq=a;
  pseq=set_h(pseq,hc);
  pseq=set_xoff(pseq,cx-1);
  pseq.noff=cn-1;              % create the output sequence
  if (get_pool(a)~=get_pool(b))
    if (get_pool(a)==0)
      pseq=set_pool(pseq,get_pool(b));
    elseif (get_pool(b)~=0)
      error('in a+b, a and b must depend on the same optSpace');
    end;
  end;
end;
