function zoomtool(ga)
% ZOOMTOOL Axes zoom/measurement tool.
%       ZOOMTOOL(H) activates the ZOOMTOOL on the axes
%       specified by the handle H.
%
%       ZOOMTOOL activates the ZOOMTOOL on the current axes.
%
%       Once activated, ZOOMTOOL redraws the axis with two
%       vertical/horizontal cursors and several controls.
%
%       The cursor push button controls (one set for each cursor)
%       allow movement of the vertical cursor along the hori-
%       zontal axis. The horizontal cursor is automatically
%       adjusted to the magnitude of the corresponding sample
%       at the vertical cursor location. The push button
%       controls are:
%
%           "<" and ">" move the vertical cursor to the next
%               left or right sample.
%
%           "<<" and ">>" move the vertical cursor to the next
%               left or right peak.
%
%       A peak is defined a the next maxima or minima in the
%       curve formed by the vector values.
%
%       In addition to cursor manipulation with push buttons,
%       the cursors can also be manipulated with the mouse. A
%       single click on a curve will move the nearest cursor
%       (horizontal distance) to that point. The mouse button
%       can also be held down and the nearest cursor "dragged"
%       to the desired location.
%
%       The zoom push button controls (one set for the X-axis,
%       Y-axis, and both X- and Y-axis) are:
%
%           "> <" zooms in on the X-axis between the cursors.
%               Zooms to maximize the view of the Y-axis.
%
%           "< >" zooms out to the previous zoom limits.
%
%           "[ ]" zooms out to the full axis limits.
%
%       The X-Axis readouts are edit boxes. Using these edit
%       boxes, a desired location for the vertical cursors can
%       be entered. After pressing return, the cursor will be
%       moved to the new location. The "Delta X" readout is
%       also an edit box. It can be used to enter an offset
%       from cursor 1 to place cursor 2. Entering a location
%       such that a cursor would be located beyond the limits
%       of the axes will move the cursor to the axes limit.
%
%       The toggle push button ("T") toggles the attachment of
%       the cursor to next curve when an axes contains more than
%       one curve. Toggling to a specific curve can be accom-
%       plished with the mouse by simply selecting the desire
%       line.
%
%       If the handle, h, is omitted, the current axis is used.
%
%       Quitting ZOOMTOOL with the quit push button ("Q") leaves
%       the axes in the last zoomed state, removing the button
%       bars and readouts. after which the user can print or
%       otherwise treat the axes as any other axes.
%
%       Note: Only one ZOOMTOOL can be active in a single
%       figure window at a time. Multiple ZOOMTOOLs can be active
%       as long as they are attached to axes in different figure
%       windows. While active, ZOOMTOOL will cover the X-axis
%       label and may also cover the axes title.
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

% find parent window
gf = get(ga,'Parent');

% check to see if already running in same figure window
if findpush(gf,'<<') & findline(ga,1001),
    error('zoomtool: Only one zoomtool allowed in a single figure...');
end;

% crudely test to see if axes is 3d, is so, abort
if ~isempty(get(ga,'ZTickLabels')),
    error('zoomtool: Use not available with 3D plots...');
end;

% get first line in axes and use it's xdata
h = get(ga,'Children');
for i = 1:length(h),
    if strcmp(get(h(i),'type'),'line'),
        x = get(h(i),'XData');
        y = get(h(i),'YData');
        set(h(i),'UserData','zoomed');

        % setup for mouse movement or release
        set(h(1),'ButtonDownFcn','zoomdown');
        set(gf,'WindowButtonMotionFcn','');
        set(gf,'WindowButtonUpFcn','');
        break;
    end;
end;

% get handles to all lines currently in axes (used later here
%   and later)
[lcnt,lhand] = cntlines(ga);

% abort if axes is empty
if lcnt == 0,
    error('zoomtool: No lines in axes...');
end;

% set all lines to toggle if selected
for j = 1:lcnt,
    set(lhand(j),'ButtonDownFcn','zoomtggl(get(gcf,''CurrentAxes''));');
end;

% get the extremes of all lines, this is necessary to set the 
%   y limits if the zoomtool is ran against an axis that has 
%   already been zoomed and to show all the y data if the first 
%   line object in the stack does not contain the largest y 
%   values of all line objects (believe me, it's all true).
extremes = zeros(lcnt,4);
for i = 1:lcnt,
    yt = get(lhand(i),'YData');
    xt = get(lhand(i),'XData');
    extremes(i,1) = min(xt);
    extremes(i,2) = max(xt);
    extremes(i,3) = min(yt);
    extremes(i,4) = max(yt);
end;
clear yt xt

% all lines must have same X-axis extremes, can have different
%   number of points in between
if all(extremes(:,1) ~= extremes(1,1)) | all(extremes(:,2) ~= extremes(1,2))
    error('zoomtool: Lines must have same X-axis endpoint values...');
end;

% get horizontal scale
xlen = length(x);
xmin = x(1);
xmax = x(xlen);

% set horizontal factor
xfactor = (xmax - xmin) / (xlen - 1);
set(get(ga,'xlabel'),'UserData',xfactor);

% insure zoom is full
set(ga,'XLim',[xmin xmax]);

% set new y limits, ensure data not coincident to border
ylim = [min(extremes(:,3)) max(extremes(:,4))];
delta = (ylim(2) - ylim(1)) * 0.05;
ylim(1) = ylim(1) - delta;
ylim(2) = ylim(2) + delta;
set(ga,'YLim',ylim);

% Y zoom is much simpler

% add cursors to axis
v1 = floor(xlen/4);
v2 = floor(xlen*3/4);
h1 = y(v1);
h2 = y(v2);
crsrmake(ga,1001,'vertical',(v1-1) * xfactor + xmin,'--');
crsrmake(ga,1002,'horizontal',h1,'--');
crsrmake(ga,2001,'vertical',(v2-1) * xfactor + xmin,'-.');
crsrmake(ga,2002,'horizontal',h2,'-.');

% reset right border to make room for buttons
olda = get(ga,'units');
set(ga,'Units','normal');
b_hite = 0.04;
pos = get(ga,'Position');
pos(2) = pos(2) + b_hite;
pos(3) = pos(3) - 0.065;
pos(4) = pos(4) - 2*b_hite;
set(ga,'Position',pos);
set(ga,'Units',olda);

% add cursor control buttons along top
% store axis number in 'Value' property to use in callback
rvbase = pos(1);
lvbase = rvbase + pos(3);
hbase = pos(2) + pos(4);
b_width = b_hite;
uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[rvbase hbase b_width b_hite],...
    'String','<','UserData',gca,...
    'Callback','zoomleft(get(get(gcf,''CurrentObject''),''UserData''),1);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[rvbase+b_width hbase b_width b_hite],...
    'String','>','UserData',gca,...
    'Callback','zoomrght(get(get(gcf,''CurrentObject''),''UserData''),1);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[rvbase+2*b_width hbase b_width b_hite],...
    'String','<<','UserData',gca,...
    'Callback','zoompklf(get(get(gcf,''CurrentObject''),''UserData''),1);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[rvbase+3*b_width hbase b_width b_hite],...
    'String','>>','UserData',gca,...
    'Callback','zoompkrt(get(get(gcf,''CurrentObject''),''UserData''),1);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase-4*b_width hbase b_width b_hite],...
    'String','<','UserData',gca,...
    'Callback','zoomleft(get(get(gcf,''CurrentObject''),''UserData''),2);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase-3*b_width hbase b_width b_hite],...
    'String','>','UserData',gca,...
    'Callback','zoomrght(get(get(gcf,''CurrentObject''),''UserData''),2);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase-2*b_width hbase b_width b_hite],...
    'String','<<','UserData',gca,...
    'Callback','zoompklf(get(get(gcf,''CurrentObject''),''UserData''),2);');

uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase-b_width hbase b_width b_hite],...
    'String','>>','UserData',gca,...
    'Callback','zoompkrt(get(get(gcf,''CurrentObject''),''UserData''),2);');

uicontrol('Style','text','Units','normal','ForeGroundColor','white',...
    'Position',[rvbase hbase+b_hite 4*b_width b_hite],...
    'String','Cursor 1 - -');

uicontrol('Style','text','Units','normal','ForeGroundColor','white',...
    'Position',[lvbase-4*b_width hbase+b_hite 4*b_width b_hite],...
    'String','Cursor 2 -.');

handles = zeros(17,1);

% zoom x icons

% vertical button bar
uicontrol('Style','Text','Units','normal','ForeGroundColor','white',...
    'Position',[lvbase hbase-1*b_hite 1.5*b_width b_hite],...
    'String','X');

handles(1) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-2*b_hite 1.5*b_width b_hite],...
    'String','> <','UserData',[],...
    'Callback','zoomxin(get(gcf,''CurrentAxes''));');

handles(2) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-3*b_hite 1.5*b_width b_hite],...
    'String','< >','UserData',[],...
    'Callback','zoomxout(get(gcf,''CurrentAxes''));');

handles(3) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-4*b_hite 1.5*b_width b_hite],...
    'String','[ ]','UserData',[],...
    'Callback','zoomxful(get(gcf,''CurrentAxes''));');

% zoom y icons

uicontrol('Style','Text','Units','normal','ForeGroundColor','white',...
    'Position',[lvbase hbase-6*b_hite 1.5*b_width b_hite],...
    'String','Y');

handles(4) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-7*b_hite 1.5*b_width b_hite],...
    'String','> <','UserData',[],...
    'Callback','zoomyin(get(gcf,''CurrentAxes''));');

handles(5) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-8*b_hite 1.5*b_width b_hite],...
    'String','< >','UserData',[],...
    'Callback','zoomyout(get(gcf,''CurrentAxes''));');

handles(6) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-9*b_hite 1.5*b_width b_hite],...
    'String','[ ]','UserData',[],...
    'Callback','zoomyful(get(gcf,''CurrentAxes''));');

% zoom xy icons

uicontrol('Style','Text','Units','normal','ForeGroundColor','white',...
    'Position',[lvbase hbase-11*b_hite 1.5*b_width b_hite],...
    'String','XY');

handles(7) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-12*b_hite 1.5*b_width b_hite],...
    'String','> <','UserData',[],...
    'Callback',...
    'zoomxin(get(gcf,''CurrentAxes''));zoomyin(get(gcf,''CurrentAxes''));');

handles(17) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-13*b_hite 1.5*b_width b_hite],...
    'String','< >','UserData',[],...
    'Callback',...
    'zoomyout(get(gcf,''CurrentAxes''));zoomxout(get(gcf,''CurrentAxes''));');

handles(8) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-14*b_hite 1.5*b_width b_hite],...
    'String','[ ]','UserData',[],...
    'Callback',...
    'zoomxful(get(gcf,''CurrentAxes''));zoomyful(get(gcf,''CurrentAxes''));');

% toggle icon

handles(16) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase-16*b_hite 1.5*b_width b_hite],...
    'String','T','UserData',lhand,...
    'Callback',...
    'zoomtggl(get(gcf,''CurrentAxes''));');

% turn off toggle button if not needed
if lcnt == 1,
    set(handles(16),'Visible','off');
end;

% set zoom full limits
set(handles(3),'UserData',[xmin xmax]);

% get horizontal scale
ylim = get(ga,'YLim');

% set zoom full limits
set(handles(6),'UserData',ylim);

hbase = pos(2) - 2*b_hite;          % edit/text uicontrols readouts
tbase = pos(2) - 3*b_hite;          % text uicontrol labels

% set up Clr button before changin b_width variable
handles(15) = uicontrol('Style','Pushbutton','Units','normal',...
    'Position',[lvbase hbase 1.5*b_width b_hite],...
    'String','Q','UserData',[],...
    'Callback',...
    'zoomclr(get(gcf,''CurrentAxes''));');

b_width = (lvbase - rvbase) / 6;
v1 = crsrloc(ga,1001);
v2 = crsrloc(ga,2001);
h1 = crsrloc(ga,1002);
h2 = crsrloc(ga,2002);

handles(9) = uicontrol('Style','edit','Units','normal',...
    'Position',[rvbase+0*b_width hbase b_width*.9 b_hite],...
    'String',num2str(v1),'UserData',gca,'Value',3001,...
    'BackGroundColor','magenta','ForeGroundColor','white',...
    'Callback','zoomset(get(get(gcf,''CurrentObject''),''UserData''),1);');

uicontrol('Style','text','Units','normal','ForeGroundColor','white',...
    'Position',[rvbase+0*b_width tbase b_width*.9 b_hite],...
    'String','X - - -');

handles(10) = uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+1*b_width hbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String',num2str(h2),'UserData',gca);

uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+1*b_width tbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String','Y - - -');

handles(11) = uicontrol('Style','edit','Units','normal',...
    'Position',[rvbase+2*b_width hbase b_width*.9 b_hite],...
    'String',num2str(abs(v2-v1)),'UserData',gca,'Value',3003,...
    'BackGroundColor','magenta','ForeGroundColor','white',...
    'Callback','zoomset(get(get(gcf,''CurrentObject''),''UserData''),3);');

uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+2*b_width tbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String','Delta X');

handles(12) = uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+3*b_width hbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String',num2str(abs(h2-h1)),'UserData',gca);

uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+3*b_width tbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String','Delta Y');

handles(13) = uicontrol('Style','edit','Units','normal',...
    'Position',[rvbase+4*b_width hbase b_width*.9 b_hite],...
    'String',num2str(v2),'UserData',gca,'Value',3002,...
    'BackGroundColor','magenta','ForeGroundColor','white',...
    'Callback','zoomset(get(get(gcf,''CurrentObject''),''UserData''),2);');

uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+4*b_width tbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String','X -.-.');

handles(14) = uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+5*b_width hbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String',num2str(h2),'UserData',gca);

uicontrol('Style','text','Units','normal',...
    'Position',[rvbase+5*b_width tbase b_width*.9 b_hite],...
    'ForeGroundColor','white','String','Y -.-.');

set(gf,'CurrentAxes',ga);

set(ga,'UserData',handles);

% don't allow another plot to be added without first closing
% the zoomtool.
set(gf,'NextPlot','New');

