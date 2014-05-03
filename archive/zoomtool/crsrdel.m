function [h] = crsrdel(ax,name)
%CRSRDEL Delete axes cursor.
%       H=CRSRDEL(AXES,'NAME') deletes the named cursor.
%
%       See also CRSRMAKE, CRSRMOVE, CRSRON, CRSROFF

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% get handle to cursor
h = findline(ax,name);
delete(h);
