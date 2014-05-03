function zoomxin(ga)
% ZOOMXIN Used by ZOOMTOOL to zoom the x axis in.
%       ZOOMXIN(H) where H is the axis ZOOMTOOL is active in.
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

% get vertical cursor positions
v1 = crsrloc(ga,1001);
v2 = crsrloc(ga,2001);

% check for same location
if abs(v1 - v2) < 100*eps,
    disp('zoomxin: Error (Cursors located at same point)');
    return;
end;

% check for order
if v1 > v2, t = v1; v1 = v2; v2 = t; end;

% get old x limits
xlim = get(ga,'XLim');

% store old on zoomxout stack
h = get(ga,'UserData');
zout = h(2);				% ZxO
stack = get(zout,'UserData');
stack = [stack ; xlim];
set(zout,'UserData',stack);

% set new x limits
set(ga,'XLim',[v1 v2]);

% adjust horizontal cursor lengths
set(findline(ga,1002),'XData',[v1 v2]);
set(findline(ga,2002),'XData',[v1 v2]);

