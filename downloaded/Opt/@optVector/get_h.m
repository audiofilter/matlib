function h=get_h(opt,format)
% optVector/get_h h-matrix extraction function
% h=get_h(opt,format)
% format can be 'sparse', 'full', 'linear', or 'const'
% 'sparse' returns nonzero portion as a sparse matrix
% 'full' returns the whole h as a sparse matrix
% 'linear' and 'const' return just the pure linear/constant portions

global OPT_DATA;
if nargin==1
  format='sparse';
end;

if isconst(opt)  % need to test if this is a constant sequence
  Mf=1;
else
  Mf=OPT_DATA.pools(opt.pool)+1;
end;
[M,N]=size(opt.h);
switch format
 case 'sparse'
  h=opt.h;
 case 'const'
  if opt.xoff>-1
    h=sparse(1,N);
  else
    h=opt.h(-opt.xoff,:);
  end;
 case {'full', 'linear'}
  if issparse(opt.h)
    h = [sparse(1+opt.xoff, N); opt.h; sparse(Mf-(1+opt.xoff+M), N)];
  else
    %h = [zeros(1+opt.xoff, N); opt.h; zeros(Mf-(1+opt.xoff+M),N)];
    h = zeros(Mf, N);
    h((2+opt.xoff):(1+opt.xoff+M),:)=opt.h;
  end
  if strcmp(format,'linear')
    h=h(2:Mf,:);
  end;
 otherwise
  error('illegal format');
end;
