function zoomyful(ga)
% ZOOMYFUL Used by ZOOMTOOL to zoom the y axis to full limits.
%       ZOOMYFUL(H) where H is the axis ZOOMTOOL is active in.
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

% get zoomyful limits
h = get(ga,'UserData');
zout = h(6);				% ZxF
stack = get(zout,'UserData');

% check for empty stack
if isempty(stack), return; end;

% store in place of zoomxout stack
set(h(5),'UserData',stack);		% ZxO

% call zoomxout
zoomyout(ga);

