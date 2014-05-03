function [h] = findslid(fig,arg2,value)
%FINDSLID Find radiobutton uicontrol.
%       [Y] = FINDSLID(FIGURE,'STRING') finds the radiobutton
%       uicontrol with the label 'STRING' in the figure window
%       specified with the handle FIGURE.
%
%       Uses the 'String' property of the UICONTROL.  'STRING'
%       and 'String' property must be exact matches.
%
%       [Y] = FINDSLID(FIGURE,'STRING',IDENTIFIER) and find the
%       radiobutton uicontrol with the label 'STRING' and with
%       the Userdata property equal to IDENTIFIER.  IDENTIFIER
%       and the Userdata property can be either strings or a
%       scalar number.  This usage is convenient when a figure
%       window contains two or more pushbuttons uicontrols with
%       the same labels.
%
%       See also FINDAXES, FINDEDIT, FINDMENU, FINDPOPU, FINDPUSH,
%           FINDSLID, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin == 2,
    value = [];
end;

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        if strcmp(get(c(i),'Style'),'slider'),
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
                        if get(c(i),'Userdata') == value,
                            h = c(i);
                            return;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

