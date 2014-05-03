function bit = probett(reg, prims, row)
% REGION/PROBETT evaluate Boolean function
%
% BIT = PROBETT(REG, PRIMS, ROW) evaluates the Boolean function over
% primitive regions specified by the region REG and evaluated on the
% primitive variables given by PRIMS. ROW is an integer which
% specifies the binary value for each of the primitive values. The
% variables are assumed to be ordered from least significant to most
% significant.
%
% Example: PROBETT(15, [1 2 3], 0) evaluates 
% f15(P1 = 0, P2 = 0, P3 = 0)
% PROBETT(15, [1 2 3], 6) evaluates
% f15(P1 = 1, P2 = 1, P3 = 0)

global OPT_DATA;

if row > 2^length(prims)-1
  error('row exceeds size of truth table');
end

if ~strcmp(OPT_DATA.regions(reg.ind).type, 'composite')
  % if reg is a primitive type region, the task is easy
  compl = OPT_DATA.regions(reg.ind).complement;
  bitcol = find(prims == reg.ind);
  % determine primitive's column in the function
  if isempty(bitcol)
    % if we are given no relevant variables
    error ('don''t care.');
  else
    bit = any(bitand(2^(bitcol-1), row));
    %bit = xor(bit, compl);
  end
else
  % if reg is a composite region; reg is a boolean function
  op1 = OPT_DATA.regions(reg.ind).op1;
  op2 = OPT_DATA.regions(reg.ind).op2;
  oper = OPT_DATA.regions(reg.ind).oper;
  bit1 = probett(Region(op1), prims, row);
  bit2 = probett(Region(op2), prims, row);
  switch oper
   case 'union'
    bit = or(bit1, bit2);
   case 'intersect'
    bit = and(bit1, bit2);
  end
end

