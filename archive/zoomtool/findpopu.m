function [h] = findpopu(fig,value)
%FINDPOPU Find popupmenu uicontrol.
%	    [H]=FINDPOPU(FIGURE,'IDENTIFIER') find the popup menu
%       uicontrol with the Userdata property equal to
%       'IDENTIFIER'. Both 'IDENTIFIER' and the Userdata property
%       must be strings.
%
%       [H]=FINDPOPU(FIGURE,IDENTIFIER) find the popup menu
%       uicontrol with the UserData property equal to identifier.
%       Both IDENTIFIER and the UserData property must be scalar
%       numbers.
%
%	    See also IDAXES, FINDAXES, FINDCHKB, FINDEDIT, FINDFRAM,
%           FINDMENU, FINDPUSH, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        if strcmp(get(c(i),'Style'),'popupmenu'),
            if isstr(value),
                if strcmp(get(c(i),'Userdata'),value),
                    h = c(i);
                    return;
                end;
            else,
                if get(c(i),'Userdata') == value,
                    h = c(i);
                    return;
                end;
            end;
        end;
    end;
end;

