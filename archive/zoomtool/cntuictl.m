function [n,y] = cntuictl(fig,style)
%CNTUICTL Count figure uicontrols objects.
%       [N] = CNTUICTL(H,'OBJECT') counts the number of
%       UICONTROLs of 'STYLE' in the figure window specified
%       with the handle H.  Valid values for 'STYLE' are
%       the same as those for the Style property of UICONTROLs.
%       Partial values for 'STYLE' are recognized (i.e. 'pop'
%       for 'popupmenu').  Current valid styles are:
%
%               pushbutton | radiobutton | checkbox | slider |
%               edit | popupmenu | text | frame
%
%       [N] = CNTUICTL('STYLE') counts the number of UICONTROLs
%       of 'STYLE' in the current figure window.
%
%       [N] = CNTUICTL(H) counts the total number of UICONTROLS
%       in the figure window specified with the handle H.
%
%       [N,Y] = CNTUICTL(H,'STYLE'), [N,Y] = CNTUICTL('STYLE')
%       and [Y,Y] = CNTUICTL return a vector containing the
%       handles to the counted objects in Y.

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% default
if nargin == 0,
    fig = gcf;
    style = [];
elseif nargin == 1,
    if isstr(fig),
        style = fig;
        fig = gcf;
    else,
        style = [];
    end;
elseif nargin == 3,
    if ~isstr(style),
        error('cntuictl: Style must be specified as a string...');
    end;
elseif nargin > 3,
    error('cntuictl: Invalid number of input arguments...');
end;

% check validity of handle given
if isempty(find(get(0,'Children') == fig)),
    error('cntuictl: Invalid figure window handle...');
end

% output variables
n = 0;
y = [];

% valid style arguments
valid = str2mat('pushbutton','radiobutton','checkbox',...
                'slider','edit','popupmenu','text','frame');

% find the uicontrols
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        y = [y ; c(i)];
    end;
end;

if isempty(style),
    n = length(y);
else
    m = size(valid);
    ok = 0;
    s = length(style);
    for i = 1:m,
        if strcmp(style,valid(i,1:s)),
            ok = 1;
            break;
        end;
    end;
    if ok == 0,
        error('cntuictl: Invalid style specified...');
    end;
    for i = 1:length(y),
        str = get(y(i),'Style');
        if strcmp(str(1:s),style),
            yy = [yy ; (i)];
        end;
    end;
    y = yy;
    n = length(y);
end;

