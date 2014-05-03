function [h] = findpush(fig,arg2,value)
%FINDPUSH Find pushbutton uicontrol.
%       [H]=FINDPUSH(FIGURE,'LABEL') finds the push button
%       uicontrol with 'LABEL' text in the figure window
%       specified with the handle FIGURE.
%
%       The term 'LABEL' refers to the text displayed on the
%       push button as defined by the String property of the
%       uicontrol. Both 'LABEL' and the String property must
%       be exact matches.
%
%       [H]=FINDPUSH(FIGURE,'LABEL',IDENTIFIER) find the push
%       button uicontrol with 'LABEL' text and with the Userdata
%       property equal to IDENTIFIER.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPOPU,
%           FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 3,
    value = [];
end;

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        if strcmp(get(c(i),'Style'),'pushbutton'),
            if strcmp(get(c(i),'String'),arg2),
                if isempty(value),
                    h = c(i);
                    return;
                else,
                    if isstr(value),
                        if strcmp(get(c(i),'Userdata'),value),
                            h = c(i);
                            return;
                        end;
                    else,
                        if get(c(i),'UserData') == value,
                            h = c(i);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

