function [y] = getpopst(fig,value)
%GETPOPST Return current string label on popup menus.
%	    [H]=GETPOPST(FIGURE,'IDENTIFIER') finds the popup menu
%       uicontrol with the Userdata property equal to
%       'IDENTIFIER'. Both 'IDENTIFIER' and the Userdata property
%       must be strings. It then parses out and returns the
%       string currently shown on the popup menu.
%
%       (ex: uicontrol('Style','pop',...
%           'String','Hamming|Hanning|Bartlett|Triangular',...);
%
%       [H]=GETPOPST(FIGURE,IDENTIFIER) finds the popup menu
%       uicontrol with the UserData property equal to identifier.
%       Both IDENTIFIER and the UserData property must be scalar
%       numbers.
%
%	See also IDAXES, FINDAXES, FINDCHKB, FINDEDIT, FINDFRAM,
%	    FINDMENU, FINDPUSH, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% output variables
h = [];

% find figure objects
h = findpopu(fig,value);

% error check
if isempty(h); y = []; return; end;

% get popup menu labels
values = get(h,'String');

% get index to current label
i = get(h,'Value');

% parse out current label
[m,n] = size(values(i,:));

% trim off nulls
for k = n:-1:1,
    if values(i,k) ~= 0,
        break;
    end;
end;

% return string
y = values(i,1:k);

