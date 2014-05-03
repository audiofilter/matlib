function zoomxout(ga)
% ZOOMXOUT Used by ZOOMTOOL to zoom the x axis out.
%       ZOOMXOUT(H) where H is the axis ZOOMTOOL is active in.
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

% get zoomxout stack
h = get(ga,'UserData');
zout = h(2);			% ZxO
stack = get(zout,'UserData');

% check for empty stack
if isempty(stack), return; end;

% pop last from stack
[m,n] = size(stack);
v1 = stack(m,1);
v2 = stack(m,2);
stack = stack(1:m-1,:);
set(zout,'UserData',stack);

% set new x limits
set(ga,'XLim',[v1 v2]);

% adjust horizontal cursor lengths
set(findline(ga,1002),'XData',[v1 v2]);
set(findline(ga,2002),'XData',[v1 v2]);

