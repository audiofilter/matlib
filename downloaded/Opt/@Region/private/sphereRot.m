function [rreg] = sphereRot(reg, ang, dims)
% REGION/PRIVATE/SPHEREROT  rotate sphere

global OPT_DATA;

regdata = OPT_DATA.regions(reg.ind);

Q = [cos(ang) -sin(ang); sin(ang) cos(ang)];

regdata.param.center(dims) = regdata.param.center(dims) * Q';
% postmultiply since center is a row vector

rreg = Region(regdata.type, regdata.param, regdata.op1, regdata.op2, ...
	      regdata.oper);

