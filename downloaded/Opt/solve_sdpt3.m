function [soln,dual]=solve_sdpt3(obj,constr,ov,method,hookfn)

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
lincount = 0; socq = 0;
Alin = []; clin = []; Asoc = []; csoc = [];
for k=1:length(constr)
	switch lower(class(constr{k}))
	case 'linconstr'  % these need to be first, so prepend
		if strcmp(get_rel(constr{k}),'<') % eqreduce handles == for now
			lincount = lincount + size(get_A(constr{k}),1);
			Alin=[H*get_A(constr{k}).', Alin];
			clin=[get_b(constr{k})-get_A(constr{k})*x0; clin];
		end;
	case 'socconstr'  % for now these are last, so append
		Asoc=[Asoc, -H*get_cA(constr{k})];
		csoc=[csoc; get_db(constr{k}).' + get_cA(constr{k}).'*x0];
		socq=[socq, get_Mrank(constr{k})+1];
	otherwise
		error('illegal constraint type');
	end;
end;
if ~isempty(Alin)
	A{1,1} = Alin;   C{1,1} = clin;
	blk{1,1} = 'l';  blk{1,2} = lincount; 
	if ~isempty(Asoc)
		A{2,1} = Asoc;   C{2,1} = csoc;
		blk{2,1} = 'q';  blk{2,2} = socq;
	end
else
	% better have SOC
	A{1,1} = Asoc;   C{1,1} = csoc;
	blk{1,1} = 'q';  blk{1,2} = socq;
end
disp('calling SDPT3');
sqlparameters;
%OPTIONS.rmdepconstr = 1; % VERY slow
[obj,X,y,Z] = sqlp(blk, A, C, b, [], [], [], OPTIONS);
soln = H.'*y+x0;
dual = vertcat(X{:});
