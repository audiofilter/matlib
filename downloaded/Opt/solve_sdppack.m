function [soln,dual]=solve_sdppack(obj,constr,ov,method,hookfn)

disp('setting up sdppack data structures');
% first do objective
if isa(obj,'optVector')
	b=-full(get_h(obj,'linear'));
else
	error('illegal objective type')
end;
% now do constraints
A.s=[];A.q=[];A.l=[];
C.s=[];C.q=[];C.l=[];
blk.s=[];blk.q=[];blk.l=[];
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'
		A.l=[A.l, get_A(constr{k}).'];
		C.l=[C.l; full(get_b(constr{k}))];
		blk.l=size(A.l,2);
	case 'socconstr'
		Mrank=get_Mrank(constr{k});
		tmpA=get_A(constr{k}); tmpb=get_b(constr{k});
		tmpc=get_c(constr{k}); tmpd=get_d(constr{k});
		for m=1:length(Mrank)
			A.q=[A.q,-tmpc{m},-tmpA{m}];
			C.q=[C.q;full(tmpd(m));full(tmpb{m}.')];
		end;
		%A.q=[A.q,-get_c(constr{k},'matrix').',-get_A(constr{k},'matrix').'];
		%C.q=[C.q;full(get_d(constr{k}));full(get_b(constr{k},'matrix'))];
		blk.q=[blk.q, get_Mrank(constr{k})+1];
	otherwise
		error('illegal constraint type');
	end;
end;
disp('calling sdppack');
setopt;
init;
[X,y,Z,iter,compval,feasval,objval,termflag]=fsql(A,b,C,blk,X,y,Z,opt);
termflag
soln=y;
dual=X;
