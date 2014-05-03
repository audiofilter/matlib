function [soln,dual]=solve_boydsocp(obj,constr,ov,method,hookfn)

% first do objective
if isa(obj,'optVector')
	f=full(get_h(obj,'linear'));
else
	error('illegal objective type')
end;
% now do constraints
A=[];b=[];C=[];d=[];N=[];
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'
		C=[C;get_A(constr{k}).'];
		d=[d;get_b(constr{k}).'];
		N=[N zeros(1,length(constr{k}))];
	case 'socconstr'
		A=[A;get_A(constr{k},'matrix').'];
		b=[b;get_b(constr{k},'matrix').'];
		C=[C;get_c(constr{k},'matrix').'];
		d=[d;get_d(constr{k}).'];
		N=[N get_Mrank(constr{k})];
	otherwise
		error('illegal constraint type');
	end;
end;
%save boyd.mat A b C d N;
[soln,info,z,w]=socp(f,full(A),full(b),full(C),full(d),N);
dual.z=z; dual.w=w;
info
