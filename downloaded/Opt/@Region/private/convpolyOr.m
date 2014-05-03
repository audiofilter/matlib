function [rreg] = convpolyOr(reg, offset)
% REGION/PRIVATE/CONVPOLYOR  shift convpoly

global OPT_DATA;

param = OPT_DATA.regions(reg.ind).param;
if ~isfield(param, 'A')
  doConvpolyLegwork(reg.ind, param);
  % do preprocessing if first time called, then reload parameters
  param = OPT_DATA.regions(reg.ind).param;
end

regdata = OPT_DATA.regions(reg.ind);

param.b = param.b + dot(param.A, repmat(offset', 1, size(param.A,2)))';

% a hyperplane, represented by a'x = b, is characterized by its
% normal vector, a, and b, which is the distance the hyperplane
% sits from the origin along its normal vector. Shifting a
% hyperplane has the effect of sliding it along its normal
% vector. The distance slid is the projection of the offset vector
% along the normal direction, or (a . offset).
% Matlab allows a matrix dot product, which dots the matrices
% column by column; hence the transposes which need to be taken.
param.points = param.points + repmat(offset, size(param.points,1), 1);
% for the vertices, simply add the offset

rreg = Region(regdata.type, param, regdata.op1, regdata.op2, ...
	      regdata.oper);

