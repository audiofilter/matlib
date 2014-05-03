function [P]=pwr(rp)
% PROCESS/PWR  [P]=pwr(rp)
% returns the power in process rp as an optimizable quadratic
% quantity of type optQuad.
global OPT_DATA;
pool=get_pool(rp);
if pool==0
  Q=sparse(0);         % assemble component kernels without offset
else
  % pre-allocate a "full" sparse matrix:
  % this wastes memory (really shouldn't use sparse at all),
  % but this can save a ton of time by avoiding reallocs when many
  % base processes are involved
  Nv=OPT_DATA.pools(pool);
  Q=sparse([],[],[],Nv,Nv,Nv^2); 
end;
for p=1:length(rp.ind)  %loop over processes
  h=get_h(rp.sys{p});
  [M,N]=size(h);
  xoff=get_xoff(rp.sys{p});
  x1=xoff+1; x2=x1+M-1;
  noff=get_noff(rp.sys{p});
  n1=noff+1; n2=n1+N-1;
  coeff=OPT_DATA.procs(rp.ind(p)).coeff;
  Nc=length(coeff);
  basis=OPT_DATA.procs(rp.ind(p)).basis;
  offset=OPT_DATA.procs(rp.ind(p)).offset;
  n=-(N-1):(N-1);
  Rn=coeff(mod(n,Nc)+1).*feval([basis 'Time'],n/Nc,offset);
  %Qt=sparse(M,M); 
  Qt=zeros(M,M); % use a full matrix here for speed
  Rx=sparse([],[],[],M,M,M^2);
  [ih,jh,sh]=find(h); % decompose sparse matrix
  for n=-(N-1):(N-1);         % loop over time indices
    k1=max(n1,n1+n); k2=min(n2,n2+n);
    ind1=find(jh>=k1-noff & jh<=k2-noff);
    ind2=find(jh>=k1-n-noff & jh<=k2-n-noff);
    h1=sparse(ih(ind1),jh(ind1)-k1+noff+1,sh(ind1),M,k2-k1+1);
    h2=sparse(ih(ind2),jh(ind2)-k1+n+noff+1,sh(ind2),M,k2-k1+1);
    Rx=conj(h1)*h2.';
    % original method - is slower for very sparse matrices
    %k=max(n1,n1+n):min(n2,n2+n);
    %Rx=conj(h(:,k-noff))*h(:,k-n-noff).';
    Qt=Qt+real(Rn(n+N)*Rx);
  end;
  if (min(size(Q))<x2+1)  % expand Q if needed
    Q(x2+1,x2+1)=0;
  end;
  Q(x1+1:x2+1,x1+1:x2+1)=Q(x1+1:x2+1,x1+1:x2+1)+sparse(Qt);
end;
if(max(size(Q)))==1
  P=full(Q);
else
  P=optQuad(Q,-1,-1,pool);
end;
