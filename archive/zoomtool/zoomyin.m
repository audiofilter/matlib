function zoomyin(ga)
% ZOOMYIN  Used by ZOOMTOOL to zoom the y axis in.
%       ZOOMYIN(H) where H is the axis ZOOMTOOL is active in.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


if nargin ~= 1,
    ga = gca;
end;
gf = get(gca,'Parent');

% get some data about the current axes state
xfactor = get(get(ga,'xlabel'),'UserData');
xxlim = get(ga,'Xlim');
xmin = min(get(findline(ga,'zoomed'),'XData'));
xlim = (xxlim - xmin) / xfactor + 1;

% get old y limits
ylim = get(ga,'YLim');

% store old on zoomxout stack
h = get(ga,'UserData');
zout = h(5);				% ZyO
stack = get(zout,'UserData');
stack = [stack ; ylim];
set(zout,'UserData',stack);

% set new y limits
y = get(findline(ga,'zoomed'),'YData');
ymin = min(y(xlim(1):xlim(2)));
ymax = max(y(xlim(1):xlim(2)));
ylim = [ymin ymax];
delta = (ymax - ymin) * 0.05;
ylim(1) = ymin - delta;
ylim(2) = ymax + delta;
set(ga,'YLim',ylim);

% adjust vertical cursor lengths
set(findline(ga,1001),'YData',ylim);
set(findline(ga,2001),'YData',ylim);

