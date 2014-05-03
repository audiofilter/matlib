function [soln,dual]=solve_mosek1(obj,constr,ov,method,hookfn)

switch(method)
case {'mosek', 'mosek1'}
	%mskinit(0,'mosek.lic',0);
	disp('setting up data structures');
	switch lower(class(obj))
	case 'optquad'
		[prob.qosubi,prob.qosubj,prob.qoval] = find(2*tril(get_kernel(obj,'purequad')));
		prob.c=full(get_kernel(obj,'linear'));
	case 'optvector'
		prob.c=full(get_h(obj,'linear'));
	otherwise
		error('unknown objective type');
	end;
	% now do constraints
	prob.qcsubk=[]; prob.qcsubi=[]; prob.qcsubj=[]; prob.qcval=[];
	prob.a=[]; prob.blc=[]; prob.buc=[]; prob.blx=[]; prob.bux=[];
	kk=1;
	for k=1:length(constr)
		switch lower(class(constr{k}))
		case 'linconstr'
			Kk=length(constr{k});
			prob.a=[prob.a; get_A(constr{k})];
			switch get_rel(constr{k})
			case '<'
				prob.blc=[prob.blc; repmat(-inf,Kk,1)];
				prob.buc=[prob.buc; get_b(constr{k})];
			case '=='
				prob.blc=[prob.blc; get_b(constr{k})];
				prob.buc=[prob.buc; get_b(constr{k})];
			otherwise
				error('illegal linear constraint');
			end;
			kk=kk+Kk;
		case 'socconstr'
			Mrank=get_Mrank(constr{k});
			Kk=length(Mrank);
			tmpA=get_A(constr{k}); tmpb=get_b(constr{k});
			tmpc=get_c(constr{k}); tmpd=get_d(constr{k});
			for m=1:Kk
				% quadratic kernel
				Qm=tmpA{m}*tmpA{m}.'-tmpc{m}*tmpc{m}.';
				[qksubi,qksubj,qkval] = find(2*tril(Qm)); 
				prob.qcsubi=[prob.qcsubi; qksubi];
				prob.qcsubj=[prob.qcsubj; qksubj];
				prob.qcval=[prob.qcval; qkval];
				prob.qcsubk=[prob.qcsubk;repmat(kk,length(qkval),1)];
				% linear
				am=2*(tmpb{m}*tmpA{m}.'-tmpd(m)*tmpc{m}.');
				prob.a=[prob.a; am];
				% constant
				um=tmpd(m)*tmpd(m)-tmpb{m}*tmpb{m}.';
				prob.buc=[prob.buc;um];
				kk=kk+1;
			end;
			prob.blc=[prob.blc; repmat(-inf,Kk,1)];
		otherwise
			error('unknown constraint type');
		end;
	end;
	if isempty(prob.a)
		prob.a=sparse(0,length(prob.c));
	end;
	disp('calling mosek');
	[rcode,res]=mosekopt('minimize',prob);
	soln=res.sol.xx;
	dual=res.sol.suc;
	
case 'mosek1dual'
	%mskinit(0,'mosek.lic',0);
	disp('setting up data structures');
	switch lower(class(obj))
	case 'optvector'
		prob.blc=-full(get_h(obj,'linear'));
		prob.buc=prob.blc;
	otherwise
		error('unknown objective type');
	end;
	N=length(prob.blc);  % # of dual variables/primal linear constraints
	M=0;                 % # of SOC constraints so far
	% now do constraints
	prob.qcsubk=[]; prob.qcsubi=[]; prob.qcsubj=[]; prob.qcval=[];
	prob.c=[]; prob.a=[]; prob.blx=[]; prob.bux=[];
	kk=1;
	for k=1:length(constr)
		switch lower(class(constr{k}))
		case 'linconstr'
			Kk=length(constr{k});
			prob.a=[prob.a, get_A(constr{k}).'];
			switch get_rel(constr{k})
			case '<'
				prob.c=[prob.c; get_b(constr{k})];
				prob.blx=[prob.blx;      zeros(Kk,1)];
				prob.bux=[prob.bux; repmat(inf,Kk,1)];
				%	    case '=='
				%	      prob.blc=[prob.blc; get_b(constr{k})];
				%	      prob.buc=[prob.buc; get_b(constr{k})];
			otherwise
				error('illegal linear constraint');
			end;
			kk=kk+Kk;
		case 'socconstr'
			Mrank=get_Mrank(constr{k});
			K=length(Mrank);
			tmpA=get_A(constr{k}); tmpb=get_b(constr{k});
			tmpc=get_c(constr{k}); tmpd=get_d(constr{k});
			for m=1:K
				Kk=Mrank(m)+1;
				M=M+1;
				% constant part
				prob.c=[prob.c;tmpd(m);tmpb{m}.'];
				% linear part
				prob.a=[prob.a, -tmpc{m}, -tmpA{m}];
				prob.blx=[prob.blx; 0; repmat(-inf,Kk-1,1)];
				prob.bux=[prob.bux; repmat(inf,Kk,1)];
				% second-order cone
				prob.qcsubi=[prob.qcsubi; (kk:kk+Kk-1).'];
				prob.qcsubj=[prob.qcsubj; (kk:kk+Kk-1).']; % this is redundant
				prob.qcsubk=[prob.qcsubk; repmat(N+M,Kk,1)];
				prob.qcval =[prob.qcval; -1; ones(Kk-1,1)];
				kk=kk+Kk;
			end;
		otherwise
			error('unknown constraint type');
		end;
	end;
	% finish of matrix formatting
	if(M>0)
		prob.a(N+M,1)=0;
		prob.blc=[prob.blc; repmat(-inf,M,1)];
		prob.buc=[prob.buc; zeros(M,1)];
	end;
	disp('calling mosek');
	sc = mskgetsc; param=[];
	param.MSK_IPAR_OPTIMIZER=sc.MSK_OPTIMIZER_CONE;
	[rcode,res]=mosekopt('minimize',prob,param);
	soln=res.sol.y(1:N);
	dual=res.sol.xx;    
	