function [h] = findtext(ax,string,value)
%FINDTEXT Find axes text object.
%       [H]=FINDTEXT(AXES,'TEXT') finds the text object
%       with 'TEXT' in the axes specified with the
%       handle AXES.
%
%       The above uses the String property.  Both 'TEXT' and
%       the String property must be exact matches.
%
%       [H]=FINDTEXT(AXES,'TEXT',IDENTIFIER) find the text 
%       object with 'TEXT' and the Userdata property equal to 
%       IDENTIFIER.  This use is convenient when an axes contains
%       two or more text objects with the same text.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPOPU,
%           FINDPUSH, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% output variables
h = [];

% defaults
if nargin ~= 3,
    value = [];
end;

% find axes objects
c = get(ax,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'text'),
            if ~isempty(string),
                if strcmp(get(c(i),'String'),string),
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
            else
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

