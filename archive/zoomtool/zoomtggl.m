function zoomtggl(ga);
% ZOOMTGGL Used by ZOOMTOOL to move toggle attachment of
%           cursors to line objects.
%       ZOOMTGGLT(H) where H is the axis ZOOMTOOL is active in.
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

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% get handles to all the lines
h = get(findpush(gf,'T'),'UserData');

% get present line
hcur = findline(ga,'zoomed');

% find it's index
i = find(h == hcur);

% increase it's index
i = i + 1;

% wrap if necessary
if i > length(h),
    i = 1;
end;

% re-identify the lines
set(hcur,'UserData',[]);
set(h(i),'UserData','zoomed');

% setup for mouse movement or release
set(hcur,'ButtonDownFcn','zoomtggl(get(gcf,''CurrentAxes''));');
set(h(i),'ButtonDownFcn','zoomdown');

% set horizontal factor
x = get(h(i),'XData');
y = get(h(i),'YData');
xmin = min(x);
xmax = max(x);
xlen = length(x);
xfactor = (xmax - xmin) / (xlen - 1);
set(get(ga,'xlabel'),'UserData',xfactor);

% set axes on line points
p = get(ga,'xlim');
v1 = p(1);
v2 = p(2);

% calculate current indices
k1 = round((v1 - xmin) / xfactor) + 1;
k2 = round((v2 - xmin) / xfactor) + 1;

% current point locations
c1v = (k1-1) * xfactor + xmin;
c2v = (k2-1) * xfactor + xmin;

% reset xlimits
set(ga,'xlim',[c1v c2v]);

% update cursor positons

% check to see if click is now past axis new axis limits
%   adjust if it is
if t <= c1v+100*eps, t = c1v; end;
if t >= c2v-100*eps, t = c2v; end;

% get vertical cursor positions
v1 = crsrloc(ga,1001);
v2 = crsrloc(ga,2001);

% go ahead and move closest cursor to mouse click
if abs(t - v1) < abs(t - v2)
    v1 = t;
else
    v2 = t;
end;

% calculate current indices
k1 = round((v1 - xmin) / xfactor) + 1;
k2 = round((v2 - xmin) / xfactor) + 1;

% current point locations
c1v = (k1-1) * xfactor + xmin;
c1h = y(k1);
c2v = (k2-1) * xfactor + xmin;
c2h = y(k2);

% handles to readouts
h = get(ga,'UserData');

crsrmove(ga,1001,c1v);
crsrmove(ga,1002,c1h);
crsrmove(ga,2001,c2v);
crsrmove(ga,2002,c2h);
set(h(9),'String',num2str(c1v));
set(h(10),'String',num2str(c1h));
set(h(11),'String',num2str(abs(c2v-c1v)));
set(h(12),'String',num2str(abs(c2h-c1h)));
set(h(13),'String',num2str(c2v));
set(h(14),'String',num2str(c2h));


