function S=mfactor(Q,eigtol)
% S=mfactor(Q,eigtol)
% factors a symmetric, PD matrix into S*S'

if nargin<2
  eigtol=1e-10;
end;
[S,p]=chol(Q);  % first try Cholesky (much faster)
if p==0
  S=S.';
else            % it's not full-rank
  % SVD version - slow
  %[U,D,V]=svd(full(Q));
  % eigenvector version - somewhat faster than svd (always?)
  [U,D]=eig(full(Q));
  iU=find(diag(D)>eigtol);
  S=real(U(:,iU)*sqrt(D(iU,iU)));
end;
