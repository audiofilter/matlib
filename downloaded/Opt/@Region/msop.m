function [fcn, prims] = msop(reg)
% REGION/MSOP Minimal sum-of-products
%
% fcn = msop(reg) 

global OPT_DATA;

if ~strcmp(OPT_DATA.regions(reg.ind).type, 'composite')
  % if reg is a primitive region, return a simple 0,1 truth table.
  tt = logical([0;1]);
  fcn = {reg.ind};
  prims = reg.ind;
  return;
end

%prims1 = OPT_DATA.regions(reg.ind).param.primitiveChildren1;
%prims2 = OPT_DATA.regions(reg.ind).param.primitiveChildren2;
%[prims, I, J] = unique([prims1 prims2]);
prims = OPT_DATA.regions(reg.ind).param.primitiveChildren;
op1 = OPT_DATA.regions(reg.ind).op1;
op2 = OPT_DATA.regions(reg.ind).op2;
oper = OPT_DATA.regions(reg.ind).oper;

tt = logical(zeros(2^length(prims),1));
for qq = 0:2^length(prims)-1
  % note: consider placing probett() at the end of this file
  tt1 = probett(Region(op1),prims,qq);
  tt2 = probett(Region(op2),prims,qq);
  switch oper
   case 'union'
    tt(qq+1) = or(tt1, tt2);
   case 'intersect'
    tt(qq+1) = and(tt1, tt2);
  end
  % note subscript qq+1 for MATLAB array indexing
end

% Quine-McCluskey
fcn = qm(find(tt)-1, length(prims));
% qm returns a reduced function described by variable numbers which
% are numbered starting from 1. 
% While qm returns complemented variables as negative variable
% numbers, there is no danger of this occurring here, as the
% not(reg) operation actually creates a new region with the
% complement flag set.

% Now convert these variable numbers into Region indices.
prims = fliplr(prims); 
% flip the vector of primitives, since qm() assumes the given
% minterms are from a truth table with the LSB on the right; for
% example, with only minterm 1 present the function is:
% f(a, b, c, d) = a + b' + c' + d'
% since a is the LSV.
for qq=1:length(fcn)
  fcn{qq} = prims(fcn{qq});
end
