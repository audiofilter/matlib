function [rreg] = halfspaceOr(reg, offset)
% REGION/PRIVATE/HALFSPACEOR  halfspace shift

global OPT_DATA;

regdata = OPT_DATA.regions(reg.ind);

regdata.param.b = regdata.param.b + dot(offset, regdata.param.a);
% see explanation in convpolyOr.m

rreg = Region(regdata.type, regdata.param, regdata.op1, regdata.op2, ...
	      regdata.oper);

