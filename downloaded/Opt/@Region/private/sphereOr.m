function [rreg] = sphereOr(reg, offset)
% REGION/PRIVATE/SPHEREOR   sphere shift

global OPT_DATA;

regdata = OPT_DATA.regions(reg.ind);

regdata.param.center = regdata.param.center + offset;

rreg = Region(regdata.type, regdata.param, regdata.op1, regdata.op2, ...
	      regdata.oper);

