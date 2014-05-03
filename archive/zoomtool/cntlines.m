function [y,h] = cntlines(ax)
%CNTLINES Count line axes objects.
%       [Y] = CNTLINES(AX) counts the number of line objects
%       in the axes specified with the handle H.
%
%       [Y] = CNTLINES counts the number of line objects
%       in the current axes.
%
%       [Y,H] = CNTLINES(AX) and [Y,H] = CNTLINES return a
%       vector containing the LINE handles in h.
%
%       See also FIGURE, AXES

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% default
if nargin == 0, ax = gca; end;

gf = get(ax,'Parent');

% check validity of handle given
if isempty(find(get(gf,'Children') == ax)),
    error('cntlines: Invalid axes handle...');
end

% output variables
y = 0;
h = [];

% find line objects
c = get(ax,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'line'), y = y + 1; end;
    if nargout == 2, h = [h ; c(i)]; end;
end;

