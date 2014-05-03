function [rreg]=or(reg, offset)
% REGION/OR  overloaded | operater, used as linear shift
% [rreg] = or(reg, offset)
%
% REG | OFFSET shifts the Region by the offset vector OFFSET

global OPT_DATA;

if ~isa(reg,'Region')
  error('in a|b, a must be a Region and b must be an offset vector');
end

if min(size(offset)) ~= 1
  error('offset must be a vector.')
end

if length(offset) ~= get_dim(reg)
  error('offset of wrong dimension.')
end
offset = offset(:)'; % ensure row vector

if any(~isreal(offset))
  error('offset must be real.')
end

regdata = OPT_DATA.regions(reg.ind);

if strcmp(regdata.type, 'composite')
  % for composite, shift every Region in the tree
  switch regdata.oper
   case 'union'
    rreg = union( or(Region(regdata.op1), offset), ...
		 or(Region(regdata.op2), offset) );
   case 'intersect'
    rreg = intersect( or(Region(regdata.op1), offset), ...
		     or(Region(regdata.op2), offset) );
  end
else
  % execute offset for specific primitive type (private fcn)
  rreg = feval([OPT_DATA.regions(reg.ind).type 'Or'], reg, offset);
end
