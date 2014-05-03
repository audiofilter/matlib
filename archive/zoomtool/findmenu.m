function [h] = findmenu(fig,menu,submenu1,submenu2)
%FINDMENU Find uimenu uicontrol.
%       [H]=FINDMENU(FIGURE,'MENU','SUBMENU','SUBMENU') find
%       the uimenu with the Label property chain equal to the
%       chained combination of 'MENU' and up to two 'SUBMENU'.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDPOPU, FINDPUSH,
%           FINDRDIO, FINDSLID, FINDUITX, IDAXES

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% check arg count
if nargin == 2,
    submenu1 = [];
    submenu2 = [];
elseif nargin == 3,
    submenu2 = [];
end;

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uimenu'),
        if strcmp(get(c(i),'Label'),menu),
            if ~isempty(submenu1),
                d = get(c(i),'Children');
                for j = 1:length(d),
                    if strcmp(get(d(j),'Label'),submenu1),
                        if ~isempty(submenu2),
                            e = get(d(j),'Children');
                            for k = 1:length(e),
                                if strcmp(get(e(k),'Label'),submenu2),
                                    h = e(k);
                                    return;
                                end;
                            end;
                        else,
                            h = d(j);
                            return;
                        end;
                    end;
                end;
            else,
                h = c(i);
                return;
            end;
        end;
    end;
end;

