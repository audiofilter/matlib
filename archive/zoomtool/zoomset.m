function zoomset(ga,arg2)
% ZOOMSET Used by ZOOMTOOL to move position cursors according to
%           their associated edit boxes.
%       ZOOMSET(H,CURSOR) where H is the axis ZOOMTOOL is
%       active in and CURSOR is the cursor number (1 or 2) or
%       the Delta X edit box (3).
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = get(ga,'Parent');

% get some data about the current axes state
zoom_xfactor = get(get(ga,'xlabel'),'UserData');
zoom_xxlim = get(ga,'Xlim');
zoom_xmin = min(get(findline(ga,'zoomed'),'XData'));


if arg2 == 1

    t = eval(get(findedit(gf,3001),'String'));
    zoom_cursor = 1;

elseif arg2 == 2,

    t = eval(get(findedit(gf,3002),'String'));
    zoom_cursor = 2;

elseif arg2 == 3,

    t = eval(get(findedit(gf,3001),'String')) + ...
            eval(get(findedit(gf,3003),'String'));
    zoom_cursor = 2;

end;

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, t = zoom_xxlim(1); end;
if t >= zoom_xxlim(2)-100*eps, t = zoom_xxlim(2); end;

% calculate current index
k = round((t - zoom_xmin) / zoom_xfactor) + 1;

% get line data
zoom_hy = findline(ga,'zoomed');
zoom_y = get(zoom_hy,'YData');

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


