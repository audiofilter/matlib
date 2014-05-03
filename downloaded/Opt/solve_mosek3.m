function [soln,dual]=solve_mosek3(obj,constr,ov,method,hookfn)

disp('setting up data structures');
switch lower(class(obj))
case 'optvector'
	prob.blc=-full(get_h(obj,'linear'));
	prob.buc=prob.blc; % dual objective becomes primal constraint value
otherwise
	error('unknown objective type');
end;
N=length(prob.blc);  % # of dual variables/primal linear constraints
% now do constraints
prob.cones={};
prob.c=[]; prob.a=[]; prob.blx=[]; prob.bux=[];
kk=1;
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'
		Kk=length(constr{k});
		prob.a=[prob.a, sparse(get_A(constr{k})).']; % add to primal linear constr.
		switch get_rel(constr{k})
		case '<'
			prob.c=[prob.c; get_b(constr{k})]; % primal obj = dual constraint
			prob.blx=[prob.blx;      zeros(Kk,1)]; % standard form:
			prob.bux=[prob.bux; repmat(inf,Kk,1)]; %  nonnegative primal vars
			%case '=='
			%  prob.blc=[prob.blc; get_b(constr{k})];
			%  prob.buc=[prob.buc; get_b(constr{k})];
		otherwise
			error('illegal linear constraint');
		end;
		kk=kk+Kk;
	case 'socconstr'
	    % constant part
	    prob.c=[prob.c; get_db(constr{k}).']; % primal obj = dual constraint
	    % linear part
	    prob.a=[prob.a, -sparse(get_cA(constr{k}))]; % add to primal lin. constr.
	    Mrank=get_Mrank(constr{k});
	    K=length(Mrank);
	    for m=1:K  % loop over individual cones
	        Kk=Mrank(m)+1;
	        prob.blx=[prob.blx; 0; repmat(-inf,Kk-1,1)]; % dual SOCs become
	        prob.bux=[prob.bux; repmat(inf,Kk,1)];       %  primal vars
	        % second-order cone - new, simpler interface
	        prob.cones{end+1}.type='MSK_CT_QUAD';
	        prob.cones{end}.sub=kk:kk+Kk-1;
	        kk=kk+Kk;
	    end;
	otherwise
	    error('unknown constraint type');
	end;
end;
disp('calling mosek');
param=[];
param.MSK_IPAR_NUM_PROCESSORS=1;
[rcode,res]=mosekopt('minimize',prob,param);
soln=res.sol.itr.y(1:N); % mosek's primal is our dual
dual=res.sol.itr.xx;    
