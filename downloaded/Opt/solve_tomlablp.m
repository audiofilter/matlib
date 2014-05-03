function [soln,dual]=solve_tomlablp(obj,constr,ov,method,hookfn)

% potential solvers: lp-minos, minos, sqopt, snopt, lpopt
if strcmp(hookfn,' ')
	hookfn='lpopt';
end;
	
% first do objective
if isa(obj,'optVector')
	c=full(get_h(obj,'linear'));
else
	error('illegal objective type')
end;
% now do constraints
N=length(c);
x_L=repmat(-inf,N,1); x_U=repmat(inf,N,1);
A=[]; b_L=[]; b_U=[];
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'
		Kk=length(constr{k});
		A=[A; get_A(constr{k})];
		switch get_rel(constr{k})
		case '<'
			b_U=[b_U; full(get_b(constr{k}))];
			b_L=[b_L; repmat(-inf,Kk,1)];
		case '=='
			b_U=[b_U; full(get_b(constr{k}))];
			b_L=[b_L; full(get_b(constr{k}))];
		otherwise
			error('illegal linear constraint');
		end;
	otherwise
		error('illegal constraint type');
	end;
end;
Prob=lpAssign(c,A,b_L,b_U,x_L,x_U);
Prob.PriLevOpt=2;
%save Prob.mat Prob;
%Result=lpSolve(Prob);    % slow, crashes when A sparse, don't use
%Result=qpSolve(Prob);    % slow
Result=tomRun(hookfn,Prob,[],2);
soln=Result.x_k;
dual=Result.v_k;
