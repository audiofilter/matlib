function [soln,dual]=solve_sedumi(obj,constr,ov,method,hookfn)

disp('setting up data structures');
% first take care of equality constraints
[H,x0]=eqreduce(constr,ov);
% do objective
if isa(obj,'optVector')
	b=-H*full(get_h(obj,'linear'));
else
	error('illegal objective type')
end;
% now do constraints
A=[]; c=[];
K.l=0; K.q=[]; K.r=[]; K.s=[];
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'  % these need to be first, so prepend
		if strcmp(get_rel(constr{k}),'<') % eqreduce handles == for now
			A=[H*get_A(constr{k}).', A];
			c=[get_b(constr{k})-get_A(constr{k})*x0; c];
			K.l=K.l+size(get_A(constr{k}),1);
		end;
	case 'socconstr'  % for now these are last, so append
		A=[A, -H*get_cA(constr{k})];
		c=[c; get_db(constr{k}).' + get_cA(constr{k}).'*x0];
		K.q=[K.q, get_Mrank(constr{k})+1];
        if(K.q(end)==2)   % sedumi can't handle rank-1 cones
            A(1,end+1)=0; % so, add a column of zeros
            c(end+1)=0;
            K.q(end)=3;
        end;
	otherwise
		error('illegal constraint type');
	end;
end;
if strcmp(lower(method),'sedumi_dump') | strcmp(lower(method),'sedumi_dump_nosolve')
	if nargin<5
		save sedumi.mat A b c K;
	else
		save([hookfn,'.mat'],'A','b','c','K');
	end;
end;
if ~strcmp(lower(method),'sedumi_dump_nosolve')
	disp('calling sedumi');
	%toc
	[x,y,INFO]=sedumi(A,b,c,K);	 
	%[x,y,INFO]=sedumi(sparse(A),b,c,K);	 
	%pars.alg=1;         % 1 is default for 1.04, 2 for 1.05
	%pars.stepdif=0;     % 0 is default for 1.04, 1 for 1.05
	%pars.cg.maxiter=0; % v. 1.05 only
	%pars.cg.refine=0; % v. 1.05 only
	%[x,y,INFO]=sedumi(sparse(A),b,c,K,pars);
	%[x,y,INFO]=sedumi(A,b,c,K,pars);
	soln=H.'*y+x0;
	dual=x;
else
	soln=[];
	dual=[];
end;
