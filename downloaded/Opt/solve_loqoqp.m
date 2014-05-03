function [soln,dual]=solve_loqoqp(obj,constr,ov,method,hookfn)

% first do objective
switch lower(class(obj))
case 'optquad'
	H=2*get_kernel(obj,'purequad');
	c=full(get_kernel(obj,'linear'));
case 'optvector'
	H=[];
	c=full(get_h(obj,'linear'));
otherwise
	error('unknown objective type');
end;
A=[];b=[]; neqcstr=0;
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'
		switch get_rel(constr{k})
		case '<'
			A=[A;sparse(get_A(constr{k}))];
			b=[b;full(get_b(constr{k}))];
		case '=='
			A=[sparse(get_A(constr{k}));A];
			b=[full(get_b(constr{k}));b];
			neqcstr=neqcstr+length(constr{k});
		otherwise
			error('illegal linear constraint');
		end;
	otherwise
		error('unknown constraint type');
	end;
end;
soln=loqo(H,c,A,b,[],[],[],neqcstr,2);
dual=[];