function [c]=plus(a,b)
% OPTQUAD/PLUS  quadratic addition
% [c]=plus(a,b)
% a and b should be of type optQuad

if ~isa(a,'optQuad') | ~isa(b,'optQuad')
  error('in a+b, both a and b must be of class optQuad');
end;

Ma=size(a.kernel,1);
Mb=size(b.kernel,1);
ar=a.xoff+1; 
br=b.xoff+1;     %min coord in both dimensions
cr=min([ar br]);
Mc=max([ar+Ma br+Mb])-cr;
ai=ar-cr+1; bi=br-cr+1;
if isfactored(a) | isfactored(b)
  Qa=get_kernel(a,'fact');
  Qb=get_kernel(b,'fact');
  Na=size(Qa,2);
  Nb=size(Qb,2);
  if issparse(Qa) & issparse(Qb)
    [iA,jA,sA] = find(Qa);
    [iB,jB,sB] = find(Qb);
     % extract data, and reshape into larger templates
    Qc = sparse([iA+ai-1;iB+bi-1], [jA;jB+Na], [sA;sB], Mc, Na+Nb);
  else
    Qc = zeros(Mc, Na+Nb);
    Qc(ai:ai+Ma-1,1:Na)=Qa;
    Qc(bi:bi+Mb-1,Na+1:Na+Nb)=Qb;
  end
  newpool = a.pool;
  if newpool == 0
    newpool = b.pool;
  end
  c=optQuad(Qc,1,cr-1,newpool);
else
  Qa = get_kernel(a, 'nofact');
  Qb = get_kernel(b, 'nofact');
  if issparse(Qa) & issparse(Qb)
    % if both are sparse, result is sparse
    Qc=spalloc(Mc,Mc, nnz(Qa)+nnz(Qb));
    % allocate result, using greedy number of nonzero
    [iA,jA,sA] = find(Qa);
    [iB,jB,sB] = find(Qb);
    % extract data, and reshape into larger templates
    Qatmp = sparse(iA+ai-1, jA+ai-1, sA, Mc, Mc);
    Qbtmp = sparse(iB+bi-1, jB+bi-1, sB, Mc, Mc);
    Qc = Qatmp + Qbtmp;
  else
    Qc = zeros(Mc, Mc);
    Qc(ai:ai+Ma-1,ai:ai+Ma-1) = Qa;
    Qc(bi:bi+Mb-1,bi:bi+Mb-1) = Qc(bi:bi+Mb-1,bi:bi+Mb-1) + Qb;
  end
  newpool = a.pool;
  if newpool == 0
    newpool = b.pool;
  end
  c=optQuad(Qc,0,cr-1,newpool);
end;
