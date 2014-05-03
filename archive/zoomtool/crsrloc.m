function [y] = crsrloc(ax,name)
%CRSRLOC Return axes cursor position.
%       y=crsrloc(axes,'name') returns the x- or y-axes cursor
%       location dependent upon if the cursor is a vertical or
%       horizontal cursor.
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

    y = get(h,'XData');
    y = y(1);

elseif yy(1) == yy(2),      % horizontal cursor

    y = get(h,'YData');
    y = y(1);

else
    error('cursormv: Invalid cursor found...');
end;


