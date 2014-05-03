function crsrmake(ax,name,dir,posit,ltype)
%CRSRMAKE Create axes crsr.
%       H=CRSRMAKE(AXES,'NAME','DIRECTION',POSITION,'LINETYPE')
%       creates a cursor on the axes pointed to by the handle
%       axes. If not handle is provided, the current axes is
%       used. 'NAME' is a unique identifier for the cursor and
%       is used to reference the cursor during subsequent cursor
%       operations. 'direction' can be either 'horizontal' or
%       'vertical'. POSITION is a scalar number of where the
%       cursor is to be located (x-axis location for 'vertical'
%       cursors, y-axis location for 'horizontal' cursors).
%       'LINETYPE' is any valid MATLAB linetype. An error occurs
%       if a cursor is created beyond the limits of the axes.
%
%       See also CRSRMOVE, CRSRDEL, CRSRON, CRSROFF

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% get current axis data
x = get(ax,'XLim');
y = get(ax,'YLim');

% draw the crsr
if strcmp(dir,'vertical'),

    % check the location
    if posit < x(1) | posit > x(2),
        error('crsrmake: Cursor location out of axes range...');
    end;

    % actually draw the damn thing
    axes(ax);
    line('Erasemode','xor','LineStyle',ltype,...
        'Xdata',[posit posit],'Ydata',y,...
        'Visible','on','Userdata',name);

elseif strcmp(dir,'horizontal'),

    % check the location
    if posit < y(1) | posit > y(2),
        error('crsrmake: Cursor location out of axes range...');
    end;

    % actually draw the damn thing
    axes(ax);
    line('Erasemode','xor','LineStyle',ltype,...
        'Xdata',x,'Ydata',[posit posit],...
        'Visible','on','Userdata',name);

else
    error('crsrmake: Invalid cursor direction...');
end;


