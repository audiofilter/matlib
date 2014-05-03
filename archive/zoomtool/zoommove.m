function zoommove
% ZOOMMOVE Used by ZOOMTOOL to move nearest cursor to mouse
%           pointer on a WindowButtonMove event after ZOOMDOWN.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = gcf; ga = gca;

% global which live while mouse button down
global zoom_hy zoom_y zoom_cursor zoom_xfactor zoom_xxlim zoom_xmin

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, t = zoom_xxlim(1); end;
if t >= zoom_xxlim(2)-100*eps, t = zoom_xxlim(2); end;

% current index
k = round((t - zoom_xmin) / zoom_xfactor) + 1;

% current point locations
cv = (k-1) * zoom_xfactor + zoom_xmin;
ch = zoom_y(k);

% move cursor to mouse click location
if zoom_cursor == 1,
    crsrmove(ga,1001,cv);
    crsrmove(ga,1002,ch);
else
    crsrmove(ga,2001,cv);
    crsrmove(ga,2002,ch);
end;


