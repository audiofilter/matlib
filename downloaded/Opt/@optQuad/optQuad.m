function [quad] = optQuad(Q,factored,xoff,pool) 
% OPTQUAD base class for quadratic form optimization expressions
% of form (x^T)Qx, where x represents affine variable [1 y^T]^T
%
% OPTQUAD members:
%    kernel   : quadratic form kernel Q
%    factored : 1 if kernel is in factored form, 0 otherwise
%    xoff     : offset of the rows/cols of Q
%    pool     : optimization pool pointer
% OPTQUAD methods:
% constructor:
%   [quad] = optQuad()
%       creates an empty quadratic
%   [quad] = optQuad(Q,factored,xoff,pool)
%       creates a fully-specified quadratic
% insertion/extraction functions:
%   [Q]=get_kernel(quad) 
%   [quadout]=set_kernel(quad,Q) 
%   [factored]=isfactored(quad);
%   [quadout]=set_factored(quad,factored);
%   [xoff]=get_xoff(quad) 
%   [quadout]=set_xoff(quad,xoff) 
%   [pool]=get_pool(quad) 
%   [quadout]=set_pool(quad,pool) 
% other functions:
%   [pure]=ispure(quad)   test if quad is purely quadratic (no affine terms)
% operators:
%   [qout]=plus(a,b);

global OPT_DATA
if nargin == 0           % null constructor
  quad.kernel = sparse([]);
  quad.factored = 0;
  quad.xoff = -1;
  quad.pool = 0;         % "null" pool
  quad = class(quad,'optQuad');
elseif nargin == 4       % full constructor
  quad.kernel = Q;
  quad.factored = factored;
  quad.xoff = xoff;
  quad.pool = pool;
  quad = class(quad,'optQuad');
else
  error('illegal arguments to optQuad()');
end;
