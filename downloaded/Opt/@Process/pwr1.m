function [P]=pwr(rp)
% PROCESS/PWR  [P]=pwr(rp)
% returns the power in process rp as an optimizable quadratic
% quantity of type optQuad.
global OPT_DATA;
Q=sparse(0);         % assemble component kernels without offset
for p=1:length(rp.ind)  %loop over processes
  h=get_h(rp.sys{p});
  pool=get_pool(rp);
  [M,N]=size(h);
  xoff=get_xoff(rp.sys{p});
  x1=xoff+1; x2=x1+M-1;
  noff=get_noff(rp.sys{p});
  n1=noff+1; n2=n1+N-1;
  coeff=OPT_DATA.procs(rp.ind(p)).coeff;
  Nc=length(coeff);
  basis=OPT_DATA.procs(rp.ind(p)).basis;
  offset=OPT_DATA.procs(rp.ind(p)).offset;
  Qt=sparse(M,M);
  for n=-(N-1):(N-1)   % loop over time indices
    Rn=coeff(mod(n,Nc)+1)*feval([basis 'Time'],n/Nc,offset);
    k=max(n1,n1+n):min(n2,n2+n);
    Rx=conj(h(:,k-noff))*h(:,k-n-noff).';
%    Rx=h(:,k-noff)*h(:,k-n-noff)';
    Qt=Qt+real(Rn*Rx);
  end;
  if (min(size(Q))<x2+1)  % expand Q if needed
    Q(x2+1,x2+1)=0;
  end;
  Q(x1+1:x2+1,x1+1:x2+1)=Q(x1+1:x2+1,x1+1:x2+1)+Qt;
end;
if(max(size(Q)))==1
  P=full(Q);
else
  P=optQuad(Q,-1,-1,pool);
end;
