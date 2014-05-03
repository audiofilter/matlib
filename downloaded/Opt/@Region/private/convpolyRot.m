function [rreg] = convpolyRot(reg, ang, dims)
% REGION/PRIVATE/CONVPOLYROT  rotate convpoly

global OPT_DATA;

Q = [cos(ang) -sin(ang); sin(ang) cos(ang)];

param = OPT_DATA.regions(reg.ind).param;
if ~isfield(param, 'A')
  doConvpolyLegwork(reg.ind, param);
  % do preprocessing if first time called, then reload parameters
  param = OPT_DATA.regions(reg.ind).param;
end

regdata = OPT_DATA.regions(reg.ind);

param.A(dims,:) = Q * param.A(dims,:);
param.points(:, dims) = param.points(:,dims) * Q';

rreg = Region(regdata.type, param, regdata.op1, regdata.op2, ...
	      regdata.oper);

