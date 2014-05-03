function [h] = crsron(ax,name)
%CRSRON Turn axes cursor on.
%       H=CRSRON(AXES,'NAME') turns the named cursor visibility
%       on.
%
%       See also CRSRMAKE, CRSRDEL, CRSRMOVE, CRSROFF

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% get handle to cursor
h = findline(ax,name);
set(h,'Visible','on');

