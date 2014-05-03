function [rc,newparam] = BoxCheck(param, sz);
% NDPROCESS/private/BOXCHECK
% param is parameter structure from constructor
%
% rc is return message.
% [] for valid parameters.
% also returns newparam, to allow for additional parameters.

rc = [];

if sz(1) ~= size(param,1)
  rc = [rc char(10) ['Must have same number of parameter entries as' ...
		     ' basis function instances']];
end

if sz(2) ~= size(param,2)
  rc = [rc char(10) ['A ' num2str(sz(2)) '-D ''Box'' requires ' ...
		     num2str(sz(2)) ' width parameters. ' ...
		     num2str(size(param,2)) ' are given.' ]];
end

newparam = param;

