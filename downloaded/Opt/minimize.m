function [soln,dual]=minimize(obj,constr,ov,method,hookfn)
% minimize4 function - interface to optimization engines
% [soln]=minimize4(obj,constr,ov,method)
% method = {'eig','geneig','loqo','loqosocp','loqosoclp','boydsocp','sdppack','sedumi'}
global OPT_DATA;

if nargin<4
  method='sedumi';
end;
if nargin<5
  hookfn=' ';
end;

switch lower(method)
case {'eig','geneig'}            % ordinary and generalized eigenfilter methods
	[soln,dual]=solve_eig(obj,constr,ov,method,hookfn);  
case {'loqo','loqoqp'}           % loqo QP matlab interface
	[soln,dual]=solve_loqoqp(obj,constr,ov,method,hookfn);
case {'loqosoclp','loqosoclog','loqosocp'} % matlab interface for SOCP/LP using LOQO
	[soln,dual]=solve_loqosocp(obj,constr,ov,method,hookfn);  
case 'boydsocp'           % boyd SOCP matlab interface
	[soln,dual]=solve_boydsocp(obj,constr,ov,method,hookfn);  
case 'sdppack'            % sdppack SDP/SOCP/LP routine
	[soln,dual]=solve_sdppack(obj,constr,ov,method,hookfn);
case {'sedumi','sedumi_dump','sedumi_dump_nosolve'}  % sedumi SDP/SOCP/LP routine
	[soln,dual]=solve_sedumi(obj,constr,ov,method,hookfn); 
case {'sdpt3'}
	[soln,dual]=solve_sdpt3(obj,constr,ov,method,hookfn);
case {'mosek1','mosek1dual'}
	[soln,dual]=solve_mosek1(obj,constr,ov,method,hookfn);
case {'mosek2dual'} % new mosek v2 interface - dual problem
	[soln,dual]=solve_mosek2(obj,constr,ov,method,hookfn);
case {'mosek','mosekdual','mosek3dual'} % mosek v3 interface - dual problem
	[soln,dual]=solve_mosek3(obj,constr,ov,method,hookfn);
case 'tomlablp'           % tomlab LP interface
	[soln,dual]=solve_tomlablp(obj,constr,ov,method,hookfn);
otherwise
	error('unknown opt. method');
end;

if (nargout == 1) | (nargout == 0)
  % if only one left hand argument, return solution as Solution object
  soln = Solution(soln, dual, ov);
end
