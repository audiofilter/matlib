function [soc] = SOCConstr(relop,obj1,obj2)
% SOCConstr class of second-order cone optimization constraints
% [soc] = SOCConstr(relop,obj1,obj2)
%   relop: relational operator {<,==} of constraint
%   obj1 : left side of constraint (optQuad,optQuadVector)
%   obj2 : right side of constraint (optQuad,optQuadVector,optVector)
%
% a canonical second-order cone constraint is of the form
%   ||A*x + b|| < c.'*x + d  or  ||A*x + b||^2 < (c.'*x + d)^2
% or (for gen. eigenfilter)  ||A*x||^2 == d^2
%
% SOCConstr members:
%   relop   : relational operator {<,==} of constraint
%   Mrank   : vector. Mrank(k) is the rank of the kth SOC
%   SOCvect : concatenated optVectors representing the SOC constraints.
%             each SOC is of the form ||A*x + b|| < c.'*x + d
%             each block has a representation of the form h=[d, b.'; c, A.']
%             the k'th block is thus Mrank(k)+1 long
%
% class methods:
% constructor:
%   [soc] = SOCConstr(relop,obj1,obj2);
% insertion/extraction:
%   relop=get_relop(constr);
%   Mrank=get_Mrank(constr);
%   A=get_A(constr);
%   b=get_b(constr);
%   c=get_c(constr);
%   d=get_d(constr);

eigtol=1e-10;           % global const? singular value limit

if (relop~='<' & relop~='==')
  error('unknown operator')
end;
soc.relop=relop;
    
switch lower(class(obj1))
case 'optquad'   % left side is a single, high-rank quadratic
	h1=get_kernel(obj1,'fact');
	soc.Mrank=size(h1,2);
	switch lower(class(obj2))
	case 'optquad'  % right side might be high-rank
		h2=get_kernel(obj2,'fact');
		if (size(h2,2)>1)
			warning('RHS is not rank 1, truncating');
			h2=h2(:,1);
		end;
		rvect=optVector(sparse(h2),get_pool(obj1),get_xoff(obj2));
	case 'optquadvector'  % must be length-1 and real (rank 1)
		if (length(obj2)~=1)
			error('left and right hand sides must have the same length');
		end;
		if ~get_sqflag(obj2) % obj2 is abs(), not ().^2
			error('right-hand side must be quadratic');
		end;
		if any(abs(imag(get_h(obj2)))>eps)  % has imaginary parts
			warning('RHS is not rank 1, truncating');
		end;
		rvect=set_pool(get_optVector(obj2),get_pool(obj1));
		% need to have pool set properly for proper h extraction
	case 'double'
		if any(abs(imag(obj2))>eps)  % has imaginary parts
			warning('Ignoring complex part of RHS');
		end;
		if (length(obj2)~=1)
			error('left and right hand sides must have the same length');
		end;
		rvect=set_pool(optVector(sqrt(obj2)),get_pool(obj1));
		% need to have pool set properly for proper h extraction
	otherwise
		error('unknown SOC constraint argument');
	end;
	soc.SOCvect=[rvect, optVector(h1,get_pool(obj1),get_xoff(obj1))];
case 'optquadvector'  % left side is a vector of rank 1 or 2 quadratics
	switch lower(class(obj2))
	case 'optquadvector'
		if xor(get_sqflag(obj1),get_sqflag(obj2))  % can't mix abs and .^2
			error('illegal constraint - both sides must be abs() or .^2');
		end;
	case {'optvector', 'optgensequence', 'optarray'}
		if get_sqflag(obj1)
			error('illegal constraint - both sides must be abs() or .^2');
		end;
	case 'double'  % should just cast to optVector?
		obj2=optVector(obj2);
	otherwise
		error('unknown SOC constraint argument');
	end;
	% obj2 is optVector-derived.
	M1=length(obj1);  % number of constraints
	M2=length(obj2);
	if (M1~=M2 & M2~=1)
		error('constraint dimension mismatch');
	end;
	pool1=get_pool(obj1); pool2=get_pool(obj2);  
	if pool1~=pool2
		if pool2~=0
			error('both sides of a constraint must come from the same opt pool');
		else
			obj2=set_pool(obj2,pool1);  % bit of an ugly hack to make get_h work below
		end;
	end;
	if any(abs(imag(get_h(obj2,'sparse')))>eps)
		warning('right hand side is complex. ignoring imaginary part');
	end;
	if ~any(abs(imag(get_h(obj1,'sparse')))>eps)
		warning(['Rank-1 cones being expanded to rank 2.',...
				   '  You should probably use linear constraints instead.']);
	end;
	soc.Mrank=repmat([2],1,M1);
	soc.SOCvect=optVector(reshape([repmat(real(get_h(obj2,'full')),1,M1/M2);...
			                         real(get_h(obj1,'full'));...
			                         imag(get_h(obj1,'full'))],[],3*M1),pool1,-1);
otherwise  % left side is illegal
	error('unknown SOC constraint argument');
end;
soc=class(soc,'SOCConstr');
