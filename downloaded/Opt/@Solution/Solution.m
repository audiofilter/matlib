function [soln] = Solution(x, y, pool)
% SOLUTION  class of solution to SOCP
%
% SOLUTION members:
%      x: vector of primal variables
%      y: vector of dual variables
%   pool: optSpace object specifying pool of optimization variables
%
% SOLUTION methods:
% constructor:
%   [soln] = Solution(x, y, pool)
%      creates a Solution object with primal solution 'x', dual
%      solution 'y', using pool of optimization variables 'pool'.

if ~isa(pool, 'optSpace')
  error('third argument must be of class optSpace')
end

soln.x = x;
soln.y = y;
soln.pool = pool;

soln = class(soln, 'Solution');
