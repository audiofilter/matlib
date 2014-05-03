function zoomup
% ZOOMUP Used by ZOOMTOOL to move nearest cursor to mouse
%           pointer on a WindowButtonUp event after ZOOMDOWN.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% can do this since user has to click on line to activate
gf = gcf;
ga = gca;

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

% setup for mouse movement or release
set(zoom_hy,'ButtonDownFcn','zoomdown');
set(gf,'WindowButtonMotionFcn','');
set(gf,'WindowButtonUpFcn','');

% current point locations
cv = (k-1) * zoom_xfactor + zoom_xmin;
ch = zoom_y(k);
h = get(ga,'UserData');     % handles to readouts

% move cursor to mouse click location
if zoom_cursor == 1,
    crsrmove(ga,1001,cv);
    crsrmove(ga,1002,ch);
    set(h(9),'String',num2str(cv));
    set(h(10),'String',num2str(ch));
    cvb = crsrloc(ga,2001);
    chb = crsrloc(ga,2002);
else
    crsrmove(ga,2001,cv);
    crsrmove(ga,2002,ch);
    set(h(13),'String',num2str(cv));
    set(h(14),'String',num2str(ch));
    cvb = crsrloc(ga,1001);
    chb = crsrloc(ga,1002);
end;
set(h(11),'String',num2str(abs(cvb-cv)));
set(h(12),'String',num2str(abs(chb-ch)));

% global which live while mouse button down
clear global zoom_hy zoom_y zoom_cursor zoom_xfactor zoom_xxlim zoom_xmin



