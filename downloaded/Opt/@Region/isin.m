function [result, I] = isin(reg, points)
% REGION/ISIN  determine if points are in a region
% [result] = isin(reg, points)
%
% For a list of points, returns the points which 
% are in reg.
% 
% [result, I] = inin(reg, points) also returns an
% index vector I, such that result = points(I,:)

global OPT_DATA;

type = OPT_DATA.regions(reg.ind).type;
param = OPT_DATA.regions(reg.ind).param;

if param.dim ~= size(points, 2)
  error('dimension mismatch');
end

if any(~isreal(points))
  error('points must be real');
end

if strcmp(type, 'composite')
  op1 = OPT_DATA.regions(reg.ind).op1;
  op2 = OPT_DATA.regions(reg.ind).op2;
  oper = OPT_DATA.regions(reg.ind).oper;
  comp = OPT_DATA.regions(reg.ind).complement;
end

if ~strcmp(type, 'composite') % do straight version of isin
  [result,I] = feval([type 'Isin'], reg, points);
  return;
else % for composite, do recursive call on children
  [res1,I1] = isin(Region(op1),points);
  [res2,I2] = isin(Region(op2),points);
  result = feval([oper 'Isin'], res1, res2); 
  % evaluate operation's effect
  I = feval([oper 'Isin'], I1, I2); 
  % get matching indices as well
end
