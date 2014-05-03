function zoomclr(ga)
% ZOOMCLR Used by ZOOMTOOL to remove itself from the axes.
%       ZOOMCLR(H) where H is the axis ZOOMTOOL is active in.
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

gf = gcf;

% get handles stored in Axis 'UserData'
h = get(ga,'UserData');

% Clean up objects with handles stored in 'Userdata' property
%   of the axis object
for i = 1:length(h),
    delete(h(i));
end;

% Clean up cursor controls (there are two of each)
for i = 1:2,
    delete(findpush(gf,'<'));
    delete(findpush(gf,'>'));
    delete(findpush(gf,'<<'));
    delete(findpush(gf,'>>'));
end;

% Clean off cursors
delete(findline(ga,1001));
delete(findline(ga,1002));
delete(findline(ga,2001));
delete(findline(ga,2002));

% clean off readout labels
delete(finduitx(gf,'X - - -'));
delete(finduitx(gf,'Y - - -'));
delete(finduitx(gf,'Delta X'));
delete(finduitx(gf,'Delta Y'));
delete(finduitx(gf,'X -.-.'));
delete(finduitx(gf,'Y -.-.'));

% Clean off the rest of the labels
delete(finduitx(gf,'Cursor 1 - -'));
delete(finduitx(gf,'Cursor 2 -.'));
delete(finduitx(gf,'X'));
delete(finduitx(gf,'Y'));
delete(finduitx(gf,'XY'));

% adjust size of axis back to original
old = get(ga,'Units');
set(ga,'Units','normal');
pos = get(ga,'Position');
pos(2) = pos(2) - 0.04;
pos(3) = pos(3) + 0.065;
pos(4) = pos(4) + 2*0.04;
set(ga,'Position',pos);
set(ga,'Units',old);

% allow axes to be replaced with new plot command
set(gf,'NextPlot','replace');

