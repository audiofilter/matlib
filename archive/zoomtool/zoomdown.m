function zoomdown
% ZOOMDOWN Used by ZOOMTOOL to move nearest cursor to mouse
%           pointer on a ButtonDown event associated with a
%           line object.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% current values
ga = gca; gf = gcf;

% global which live while mouse button down
global zoom_hy zoom_y zoom_cursor zoom_xfactor zoom_xxlim zoom_xmin

% get some data about the current axes state
zoom_xfactor = get(get(ga,'xlabel'),'UserData');
zoom_xxlim = get(ga,'Xlim');
zoom_xmin = min(get(findline(ga,'zoomed'),'XData'));

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, return; end;
if t >= zoom_xxlim(2)-100*eps, return; end;

% current index
k = round((t - zoom_xmin) / zoom_xfactor) + 1;

% get line data
zoom_hy = findline(ga,'zoomed');
zoom_y = get(zoom_hy,'YData');

% setup for mouse movement or release
set(zoom_hy,'ButtonDownFcn','');
set(gf,'WindowButtonMotionFcn', 'zoommove;');
set(gf,'WindowButtonUpFcn', 'zoomup;');

% current point locations
cv = (k-1) * zoom_xfactor + zoom_xmin;
ch = zoom_y(k);

% find closest vertical cursor to mouse click location
if abs(cv - crsrloc(ga,1001)) < abs(cv - crsrloc(ga,2001))
    zoom_cursor = 1;
    crsrmove(ga,1001,cv);
    crsrmove(ga,1002,ch);
else
    zoom_cursor = 2;
    crsrmove(ga,2001,cv);
    crsrmove(ga,2002,ch);
end;


