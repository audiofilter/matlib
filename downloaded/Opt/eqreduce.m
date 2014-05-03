function [H, x0]=eqreduce(constr,ov)

% [H, x0]=eqreduce(constr)
% returns the nullspace H of equality constraints and vector x0 such that
% x = H.'*y + x0
% in terms of reduced-dimension vector y

global OPT_DATA;
A=[]; b=[];
for k=1:length(constr)
  if isa(constr{k},'LinConstr')
    if strcmp(get_rel(constr{k}),'==')
      A=[A;full(get_A(constr{k}))];
      b=[b;full(get_b(constr{k}))];
    end;
  end;
end;
if isempty(A)
  H=1;
  x0=zeros(OPT_DATA.pools(ov),1);
else
  if size(A,1)>=size(A,2)
    error('overdetermined equality constraints');
  end;
  if rank(A)<size(A,1)
    error('inconsistent equality constraints');
  end;
  H=null(A).';
  x0=[A;H]\[b;zeros(size(H,1),1)];
end;
