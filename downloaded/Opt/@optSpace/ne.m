function r = ne(a, b)
% OPTSPACE/NE  Not equal.

if isa(a, 'optSpace') & isa(b, 'optSpace')
  r = (a.poolnum ~= b.poolnum);
  return;
elseif isa(b, 'optSpace')
  % if only b is an optSpace, switch the order and call again
  r = ne(b, a);
  return;
end

if ~isa(b, 'double')
  error('in a~=b, b must be a double or an optSpace.')
end

if prod(size(b)) ~= 1
  error('b must be a scalar.')
end

r = (a.poolnum ~= b);
