function idaxes(arg1,arg2)
%IDAXES Assign identifier to axes.
%       IDAXES('string') or IDAXES(handle,'string') assigns the
%       identifying string to the Userdata property of the current
%       axes or that identified by handle.
%
%       IDAXES(value) or IDAXES(handle,value) assigns the
%       identifying value to the Userdata property of the current
%       axes or that identified by handle.
%
%       If no axis or figure are present, both are created.
%
%       The Userdata property of the axis title is used to store
%       the identifier.
%
%       See also FINDAXES

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% check
if nargin < 1 | nargin > 2,
    error('idaxes: Invalid number of input arguments...');
end;

if nargin == 1,
    h = gca;
    id = arg1;
elseif nargin == 2,
    h = arg1;
    id = arg2;
end;

% set the id
set(get(h,'title'),'Userdata',id);

