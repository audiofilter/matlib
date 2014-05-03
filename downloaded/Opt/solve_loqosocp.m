function [soln,dual]=solve_loqosocp(obj,constr,ov,method,hookfn)

% first do objective
switch lower(class(obj))
case 'optquad'
	H=2*get_kernel(obj,'purequad');    % should be sparse
	c=full(get_kernel(obj,'linear'));  % should be full
case 'optvector'
	H=[];
	c=full(get_h(obj,'linear'));       % should be full
otherwise
	error('unknown objective type');
end;
% now do constraints
A=[]; b=[]; neqcstr=0;
C={};
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
	case 'socconstr'
		C=[C get_Abcd(constr{k},'loqo')];
	otherwise
		error('unknown constraint type');
	end;
end;
%save loqo.mat H c A b C;
switch lower(method)
case 'loqosoclp'           % matlab interface for SOCP/LP using loqo
	%if we ever provide initial values, they should be used instead
	%of zeros (and the name should be changed)
	xxx=zeros(size(c));
	[soln,dual_lin,dual_soc]=loqosoclp(C,H,c,-A,-b,[],[],xxx, ...
		neqcstr,hookfn,'verbose=2');
	dual.lin=dual_lin;
	dual.soc=dual_soc;
case 'loqosoclog'           % matlab interface for SOCP/LP/log using loqo
	xxx=zeros(size(c));
	L={}; % for now
	[soln,dual_lin,dual_soc]=loqosoclog(C,H,L,c,-A,-b,[],[],xxx, ...
		neqcstr,hookfn,'verbose=2');
	dual.lin=dual_lin;
	dual.soc=dual_soc;
	%      case 'loqosocp'           % loqo SOCP matlab interface
	%        [soln,lambda]=loqosocp(C,H,c,A,b,[],[],[],0,2);
otherwise
	error('programming error in loqo part of minimize');
end;
