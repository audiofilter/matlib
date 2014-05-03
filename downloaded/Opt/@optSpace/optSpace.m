function [ov] = optSpace(arg1)
% OPTSPACE  class of optimization variable sets (optSpaces)
%
% OPTSPACE members:
%   spacename: name of optSpace. 
%     poolnum: index number of optSpace, used to refer to the
%              global table OPT_DATA in which the size of (number
%              of variables in) the pool is stored.
%
% OPTSPACE methods:
% constructor:
%   allocates a new space (pool) of optimization variables, and
%   returns a pointer.
%   [ov] = optSpace(spacename)
%      allocates a new space and assigns it the name 'spacename'
%   [ov] = optSpace()
%      allocates a new space with no (blank) name assigned
% extraction methods:
%   ind = get_poolnum(pool), ind = double(pool)
%      retrieves index number of optSpace pool
% operators:
%   r = eq(pool1, pool2)
%      returns true if the pools are the same
%   r = ne(pool1, pool2)
%      returns true if the pools are not the same
% other methods:
%   subsindex(pool)
%      allows optSpace to be used as an index


global OPT_DATA;

if nargin == 1
  if ischar(arg1)
    p=length(OPT_DATA.pools)+1;
    OPT_DATA.pools(p)=0;
    OPT_DATA.poolnames{p} = arg1;
    os.spacename = arg1;
  elseif isnumeric(arg1) & (prod(size(arg1)) == 1)
    % pointer dereference
    if ~iswhole(arg1)
      error('optSpace index must be a whole number.');
    end
    if arg1 == 0
      % null optSpace (used for constant optVectors)
      os.spacename = 'NULL';
      p = 0;
    elseif (arg1 < 1) | (arg1 > length(OPT_DATA.pools))
      error('optSpace index out of range.');
    else
      os.spacename = OPT_DATA.poolnames{arg1};
      p = arg1;
    end
  else
    error('optSpace name must be a character string.');
  end
else
  p = length(OPT_DATA.pools) + 1;
  OPT_DATA.pools(p) = 0;
  OPT_DATA.poolnames{p} = '';
  os.spacename = '';
end

os.poolnum = p;
ov = class(os, 'optSpace');
