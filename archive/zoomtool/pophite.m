function pophite(h)
%POPHITE Adjust height of popup menu for MS-Windows.
%       POPHITE(H) adjust the heighth of the popup menu pointed
%       to by the uicontrol handle H so that all popup menu
%       items are visible without a scroll bar when the popup
%       menu is opened under MS-Windows.

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% only run under windows
if ~strcmp(computer,'PCWIN'); return; end;

% save old units
old = get(h,'units');

% change to pixels
set(h,'units','pixels');

% get current position in pixels
pp = get(h,'Position');

% change hieght to fit
pp(4) = get(h,'Max') * 22 + 2;

% set new hieght
set(h,'Position',floor(pp));

% restore original units
set(h,'Units',old);

