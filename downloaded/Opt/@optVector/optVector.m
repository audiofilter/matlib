function [opt] = optVector(n,pool,xoff) 
% OPTVECTOR base class of affine optimization data types
% not meant to be used directly; provides low-level structure and
% functionality for inheriting classes
%
% OPTVECTOR members:
%    h    : matrix which describes a generic vector y=[1 x.']*h,
%           where each element is an affine combination of the opt vars
%           child classes can assign physical meaning to this vector,
%           primarily the N-dimensional tap location
%    xoff : index of the new optimization variables into pool
%    pool : pointer to corresponding variable pool
%
% OPTVECTOR methods:
% constructor:
%   [opt] = optVector(n,pool) 
%       creates n new optimization variables in pool
%   [opt]=optVector(svec) 
%       creates a constant (non-optimized) vector
%   [opt]=optVector(otheropt) 
%       creates a copy of otheropt (to make casting transparent)
%   [opt]=optVector(h,pool,xoff) 
%       assembles an optVector from its parts in one step
%       assumes that variables are already allocated
%   [opt]=optVector() 
%       creates an empty constant vector
%   [opt]=optVector('fullzero',pool) 
%       creates an empty constant vector with the full dimension of pool
%       use this before a loop to reduce iteration time substantially in some cases
% insertion/extraction functions:
%   [h]=get_h(opt) 
%   [optout]=set_h(opt,h) 
%   [xoff]=get_xoff(opt) 
%   [optout]=set_xoff(opt,xoff) 
%   [pool]=get_pool(opt) 
%   [optout]=set_pool(opt,pool)
% vector manipulation
%   [subvec]=subsref(vec,s);
% conversion functions:
%   [q]=energy(opt);      sum of squares
%   [aquad]=abs(opt);     elementwise absolute value
%   [aquad]=power(opt);   elementwise power (.^2 only)
% test functions
%   [sc]=isscalar(opt);   test for a scalar (length-1) vector
%   [lin]=isconst(opt);   test for a constant vector
%   [lin]=islinear(opt);  test for a pure linear vector
% unary operators:
%   [ropt]=real(opt);
%   [iopt]=imag(opt);
%   [copt]=conj(opt);
%   [mopt]=uminus(opt);
% binary operators
%   [mopt]=mtimes(a,b);   *scalar mult only*
%   [dopt]=mrdivide(a,b); *scalar div only*
% elementwise quadratic ops
%   [aquad]=abs(opt);     elementwise absolute value
%   [aquad]=power(opt);   elementwise power (.^2 only)

global OPT_DATA;
switch nargin
case 0 % null constructor
	opt.h = sparse([]); 
	opt.xoff = -1;
	opt.pool = 0;
	opt = class(opt, 'optVector'); 
case 1
	switch lower(class(n))
		% better to look at the lower case for MSDOS compatibility
	case 'optvector' % copy constructor
		opt = n;
	case 'double'    % cast from matlab vector to optVector
		%opt.h = sparse(n(:).');
		opt.h = n(:).';
		opt.xoff = -1;
		opt.pool = 0;
		opt = class(opt,'optVector');		
	otherwise
		error('A single argument to optVector() must be a double or an optVector');
	end;
case 2
	if ~isa(pool, 'optSpace')
		error('in optVector(n,pool), pool must be a valid optSpace.');
	end
	poolnum = get_poolnum(pool);
	if strcmp(n,'fullzero')
		opt.h=sparse(OPT_DATA.pools(poolnum)+1,1);
		opt.xoff = -1;
		opt.pool = pool; % using a nonzero pool for a constant seems icky
	else
		if (n < 0) | ~isreal(n) | ~iswhole(n)
			error('optVector size must be a nonnegative integer.')
		end
		opt.h = speye(n,n);
		if n>0
			opt.xoff = OPT_DATA.pools(poolnum);
			opt.pool = pool;
		else % n==0
			opt.xoff = -1;
			opt.pool = 0;
		end
		OPT_DATA.pools(poolnum)=OPT_DATA.pools(poolnum)+n;
	end;
	opt = class(opt,'optVector');
case 3
	opt.h = n;
	opt.xoff=xoff;
	opt.pool=pool;
	opt = class(opt,'optVector');  
otherwise
	error('too many arguments to optVector()');
end;
