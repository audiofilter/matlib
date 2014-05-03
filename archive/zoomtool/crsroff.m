function [h] = crsroff(fig,name)
%CRSROFF Turn axes crsr off.
%       H=CRSROFF(AXES,'NAME') turns the named cursor visibility
%       off.
%
%       See also CRSRMAKE, CRSRDEL, CRSRMOV, CRSRON

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% get handle to cursor
h = findline(ax,name);
set(h,'Visible','off');

