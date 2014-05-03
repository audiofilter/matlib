function [c]=vertcat(varargin)
% OPTVECTOR/VERTCAT  vertical concatenation
% [c] = vertcat(a,b, ...)
%  c = [a; b; ...]
% a, b, ... should be of type optVector

sparse_threshold=0.25;  % make a global constant?

if nargin==1
	c=varargin{1};
	return;
end;

% evil recursion
if nargin>2
	c=vertcat(vertcat(varargin{1},varargin{2}),varargin{3:end});
	return;
end;

if ~isa(varargin{1},'optVector') | ~isa(varargin{2},'optVector')
  %error('in a+b, both a and b must be of class optVector');
  c=vertcat(optVector(varargin{1}),optVector(varargin{2})); % let cast do type checking
  return;
end;

% assemble new vector
%density=(nnz(varargin{1}.h)+nnz(varargin{2}.h))/...
%	(prod(size(varargin{1}.h))+prod(size(varargin{2}.h)));
%if density<=sparse_threshold

aissparse=issparse(varargin{1}.h); asize=prod(size(varargin{1}.h));
bissparse=issparse(varargin{2}.h); bsize=prod(size(varargin{2}.h));
cissparse=((aissparse & (bissparse | sparse_threshold*asize>bsize)) | ...
           (bissparse & (aissparse | sparse_threshold*bsize>asize)) );
c=optVector;   % empty optVector
if cissparse
	c.h=[sparse(get_h(varargin{1},'full')), sparse(get_h(varargin{2},'full'))];
	nz=find(any(c.h,2));
	c.h=c.h(min(nz):max(nz),:);
	c.xoff=min(nz)-2;		  
else
	[Ma,Na]=size(varargin{1}.h);
	[Mb,Nb]=size(varargin{2}.h);  % get dimensions of a and b
	Nc=Na+Nb;                     % length of new vector
	ax=varargin{1}.xoff+1;
	bx=varargin{2}.xoff+1;
	cx=min([ax bx]);              % starting variable position
	Mc=max([ax+Ma bx+Mb])-cx;     % extent in variable direction
	ai=ax-cx+1; bi=bx-cx+1;
	c.h=zeros(Mc,Nc);
	c.h(ai:ai+Ma-1,1:Na)=varargin{1}.h;
	c.h(bi:bi+Mb-1,Na+1:Na+Nb)=varargin{2}.h;
	c.xoff=cx-1;
end;

if (varargin{1}.pool==varargin{2}.pool | varargin{2}.pool==0)
	c.pool=varargin{1}.pool;
elseif (varargin{1}.pool==0)
	c.pool=varargin{2}.pool;
else
	error('in a+b, a and b depend on different optimization spaces');
end;
