function [soln,dual]=solve_eig(obj,constr,ov,method,hookfn)

switch(lower(method))
case 'eig'            % ordinary eigenfilter method
	%  if ~ispure(obj)
	%    error('objective must be pure quadratic for eigenfilter methods');
	%  end;
	Q=get_kernel(obj,'purequad');
	%    [v,d]=eigs(Q,1,'SM');
	[V,D]=eig(full(Q));
	[dmin,imin]=min(abs(diag(D)));
	v=V(:,imin);
	soln=v;
	
case 'geneig'         % generalized eigenfilter
	A=get_kernel(obj,'purequad');
	d=get_d(constr{1});     % get the constant on the right of the ==
	%k=get_obj2(constr{1});
	S=get_A(constr{1});     % get the kernel factor
	B=S{1}'*S{1}/d;         % recreate and scale the kernel
	%den=get_obj1(constr{1})/k;
	%B=get_kernel(den,'purequad');
	%    [v,d]=eigsnew(A,B/k,1,'SM');
	[V,D]=eig(full(A),full(B));
	[dmin,imin]=min(abs(diag(D)));
	v=V(:,imin);
	soln=v/sqrt(v'*B*v);    % scale the opt variables
	%soln=v/sqrt(optimal(den,v));
end;
dual=[];	
