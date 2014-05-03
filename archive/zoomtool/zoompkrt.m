function zoompkrt(ga,cursor)
% ZOOMPKRT Used by ZOOMTOOL to move cursors one extrema to the
%           right after a ">>" push button event.
%       ZOOMPKRT(H,CURSOR) where H is the axis ZOOMTOOL is
%       active in and CURSOR is the cursor number (1 or 2).
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% find parent window
gf = get(ga,'Parent');

% get some data about the current axes state
xfactor = get(get(ga,'xlabel'),'UserData');
xxlim = get(ga,'Xlim');
xmin = min(get(findline(ga,'zoomed'),'XData'));
xlim = (xxlim - xmin) / xfactor + 1;

% get current cursor locations
if cursor == 1
    t = crsrloc(ga,1001);
else,
    t = crsrloc(ga,2001);
end;

% check to see if move will go past axis limits
if t >= xxlim(2)-100*eps,
    return;
end;

% index to right of current
k = (t - xmin) / xfactor + 2;

% new vertical cursor position
y = get(findline(ga,'zoomed'),'YData');
if k == 1,
    k = xlim(2);
else,
    while (sign(y(k)-y(k+1)) ~= sign(y(k)-y(k-1)))
        k = k+1;
        if k >= xlim(2)-1, k = xlim(2); break; end;
    end;
end;

% new vertical cursor position
cv = (k-1) * xfactor + xmin;

% new horizontal cursor positon
ch = y(((cv - xmin) / xfactor) + 1);

% move cursor to mouse click location
h = get(ga,'UserData');     % handles to readouts
if cursor == 1,
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


