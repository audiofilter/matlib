function [rc,newparam] = CircleCheck(param, sz);
% NDPROCESS/private/CIRLCECHECK
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
if size(param,2) ~= 1
  rc = [rc char(10) ['Scalar radius parameter for each instance of' ...
		     ' ''Circle'' ']];
end
if any(~isreal(param)) | any(param<0)
  rc = [rc char(10) '''Circle'' radius must be positive, real'];
end

newparam = param;
