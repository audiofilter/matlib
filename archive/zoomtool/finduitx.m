function [h] = finduitx(fig,text,value)
%FINDUITX Find text uicontrol.
%       [H]=FINDUITX(FIGURE,'TEXT') finds the text uicontrol
%       with 'TEXT' in the figure window specified with the
%       handle FIGURE.
%
%       The above uses the String property of the uicontrol.
%       Both 'text' and the String property must be exact matches.
%
%       [H]=FINDUITX(FIGURE,'TEXT','IDENTIFIER') 
%       finds the text uicontrol with the label 'TEXT' and with
%       the Userdata property equal to 'IDENTIFIER'.  Both
%       'IDENTIFIER' and the Userdata property must be strings.
%       This use is convenient when a figure window contains two
%       or more text uicontrols with the same labels.
%
%       [H]=FINDUITX(FIGURE,'TEXT',IDENTIFIER) and find the text
%       uicontrol with the label 'TEXT' and with the Value pro-
%       perty equal to IDENTIFIER.  Both IDENTIFIER and the Value
%       property must be numbers.  This use is convenient when a
%       figure window contains two or more text controls with the
%       same labels and the Userdata property is used for variable
%       storage.
%
%       [H] = FINDUITX(FIGURE,'','IDENTIFIER') and
%       [H] = FINDUITX(FIGURE,'',IDENTIFIER) find the text 
%       uicontrol and with the Userdata property equal to 
%       'IDENTIFIER' or Value property is equal to IDENTIFIER.  
%       This use is convenient when the text uicontrol's face 
%       value changes such as when it is used as a digital 
%       readout or a similar function.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPOPU,
%           FINDPUSH, FINDRDIO, FINDSLID

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
        if strcmp(get(c(i),'Style'),'text'),
            if ~isempty(text),
                if strcmp(get(c(i),'String'),text),
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
                            if get(c(i),'Value') == value,
                                h = c(i);
                                return;
                            end;
                        end;
                    end;
                end;
            else
                if isstr(value),
                    if strcmp(get(c(i),'Userdata'),value),
                        h = c(i);
                        return;
                    end;
                else,
                    if get(c(i),'Value') == value,
                        h = c(i);
                        return;
                    end;
                end;
            end;
        end;
    end;
end;

