function [rreg] = halfspaceRot(reg, ang, dims)
% REGION/PRIVATE/HALFSPACEROT  rotate halfspace

global OPT_DATA;

regdata = OPT_DATA.regions(reg.ind);

Q = [cos(ang) -sin(ang); sin(ang) cos(ang)];

regdata.param.a(dims) = Q* regdata.param.a(dims);

rreg = Region(regdata.type, regdata.param, regdata.op1, regdata.op2, ...
	      regdata.oper);

