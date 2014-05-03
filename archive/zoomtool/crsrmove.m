function [h] = crsrmove(ax,name,pos)
%CRSRMOVE Move axes cursor.
%       H=CRSRMOVE(AXES,'NAME',POSITION) moves the named cursor
%       to a new location. It does not change the visibility of
%       the cursor. If the axes handle is not provided, the
%       current axis is used.
%
%       See also CRSRCR, CRSRDEL, CRSRON, CRSROFF

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% get handle to cursor
h = findline(ax,name);

% get current axis data
x = get(ax,'XLim');
y = get(ax,'YLim');

% get current cursor location
xx = get(h,'XData');
yy = get(h,'YData');

% move the cursor
if xx(1) == xx(2),          % vertical cursor

    % actually move the damn thing
    set(h,'XData',[pos pos]);

elseif yy(1) == yy(2),      % horizontal cursor

    % actually move the damn thing
    set(h,'YData',[pos pos]);

else
    error('cursormv: Invalid cursor found...');
end;


