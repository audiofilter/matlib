% PROGTEST Test file for programmer toolbox.

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% Open a figure
figure(1);
clf;
clear functions

% local variables
colspace = .1/3;
frame = colspace/4;
wide = .2;
col1 = .05;
col2 = col1+wide+colspace;
col3 = col2+wide+colspace;
col4 = col3+wide+colspace;

hite = .05;
row1 = .025;
row2 = row1+hite;
row3 = row2+hite;
row4 = row3+hite;
row5 = row4+hite;
row6 = row5+hite;
row7 = row6+hite;
row8 = row7+hite;
row9 = row8+hite;
row10 = row9+hite;
row11 = row10+hite;
row12 = row11+hite;

% ------------------------------------------------------------------
% Draw text objects in row1
% Text object can be found with String or String & Userdata
% or String & Value.  Userdata must be a string, value must
% be a scalar number.
uicontrol(...
    'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row1 wide hite],...
    'String','Text 1'...
    );
uicontrol(...
    'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row1 wide hite],...
    'String','Text 2','Userdata','dennis','Value',2 ...
    );
uicontrol(...
    'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row1 wide hite],...
    'String','Text 3','Value',3 ...
    );
uicontrol(...
    'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row1 wide hite],...
    'String','Text 4','Userdata','george'...
    );

echo on
pause % press key to test the Text uicontrols

% turn Text 1 red - check finduitx(figure,'string')
set(finduitx(1,'Text 1'),'ForeGroundColor','red');

% turn Text 2 green - check finduitx(figure,'string')
set(finduitx(1,'Text 2'),'ForeGroundColor','green');

% turn Text 3 blue - check finduitx(figure,'string',value)
set(finduitx(1,'Text 3',3),'ForeGroundColor','blue');

% turn Text4 magenta - check finduitx(figure,'string','userdata')
set(finduitx(1,'Text 4','george'),'ForeGroundColor','magenta');

pause % press key to continue the Text uicontrols test

% turn Text 1 green - check finduitx('string')
set(finduitx(1,'Text 1'),'ForeGroundColor','green');

% turn Text 2 blue - check finduitx('string')
set(finduitx(1,'Text 2'),'ForeGroundColor','blue');

% turn Text 3 magenta - check finduitx('string',value)
set(finduitx(1,'Text 3',3),'ForeGroundColor','magenta');

% turn Text4 red - check finduitx('string','userdata')
set(finduitx(1,'Text 4','george'),'ForeGroundColor','red');

pause % Text complete
echo off
% ------------------------------------------------------------------
% Draw pushbutton objects in row2
% Pushbutton can be found by String or String & Userdata
% or String & Value.  Userdata must be a string, value must be
% a scalar number.
uicontrol(...
    'Style','pushbutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row2 wide hite],...
    'String','Push 1'...
    );
uicontrol(...
    'Style','pushbutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row2 wide hite],...
    'String','Push 2','Userdata','dennis','Value',2 ...
    );
uicontrol(...
    'Style','pushbutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row2 wide hite],...
    'String','Push 3','Userdata',3 ...
    );
uicontrol(...
    'Style','pushbutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row2 wide hite],...
    'String','Push 4','Userdata','george'...
    );

echo on
pause % press key to test the Pushbutton uicontrols

% turn Push 1 off - check findpush(figure,'string')
set(findpush(1,'Push 1'),'Visible','off');

% turn Push 2 off - check findpush(figure,'string')
set(findpush(1,'Push 2'),'Visible','off');

% turn Push 3 off - check findpush(figure,'string',value)
set(findpush(1,'Push 3',3),'Visible','off');

% turn Push4 off - check findpush(figure,'string','userdata')
set(findpush(1,'Push 4','george'),'Visible','off');

pause % press key to continue the Pushbutton uicontrols test

% turn Push 1 on - check findpush('string')
set(findpush(1,'Push 1'),'Visible','on');

% turn Push 2 on - check findpush('string')
set(findpush(1,'Push 2'),'Visible','on');

% turn Push 3 on - check findpush('string',value)
set(findpush(1,'Push 3',3),'Visible','on');

% turn Push4 on - check findpush('string','userdata')
set(findpush(1,'Push 4','george'),'Visible','on');

pause % Pushbutton complete
echo off
% ------------------------------------------------------------------
% Draw checkbox objects in row3
% Checkboxes can be found by String or String & Userdata.
% Userdata can be string or scalar number.
uicontrol(...
    'Style','checkbox','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row3 wide hite],...
    'String','Check 1','Userdata',1 ...
    );
uicontrol(...
    'Style','checkbox','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row3 wide hite],...
    'String','Check 2','Userdata','dennis'...
    );
uicontrol(...
    'Style','checkbox','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row3 wide hite],...
    'String','Check 3','Userdata',3 ...
    );
uicontrol(...
    'Style','checkbox','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row3 wide hite],...
    'String','Check 4','Userdata','george'...
    );

echo on
pause % press key to test the Checkbox uicontrols

% turn Check 1 off - check findchkb(figure,'string')
set(findchkb(1,'Check 1'),'Value',1);

% turn Check 2 off - check findchkb(figure,'string')
set(findchkb(1,'Check 2'),'Value',1);

% turn Check 3 off - check findchkb(figure,'string',userdata)
set(findchkb(1,'Check 3',3),'Value',1);

% turn Check4 off - check findchkb(figure,'string','userdata')
set(findchkb(1,'Check 4','george'),'Value',1);

pause % press key to continue the Checkbox uicontrols test

% turn Check 1 on - check findchkb('string')
set(findchkb(1,'Check 1'),'Value',0);

% turn Check 2 on - check findchkb('string')
set(findchkb(1,'Check 2'),'Value',0);

% turn Check 3 on - check findchkb('string',userdata)
set(findchkb(1,'Check 3',3),'Value',0);

% turn Check4 on - check findchkb('string','userdata')
set(findchkb(1,'Check 4','george'),'Value',0);

pause % Checkbox complete
echo off
% ------------------------------------------------------------------
% Draw edit objects in row4
% Editboxes can be found by Userdata or Value
% Userdata must be a string, Value must be a scalar number.
uicontrol(...
    'Style','edit','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row4 wide hite],...
    'String','Edit 1','Value',1 ...
    );
uicontrol(...
    'Style','edit','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row4 wide hite],...
    'String','Edit 2','Userdata','dennis'...
    );
uicontrol(...
    'Style','edit','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row4 wide hite],...
    'String','Edit 3','Value',3 ...
    );
uicontrol(...
    'Style','edit','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row4 wide hite],...
    'String','Edit 4','Userdata','george'...
    );

echo on
pause % press key to test the Editbox uicontrols

% turn Edit 1 red - check findedit(figure,value)
set(findedit(1,1),'ForeGroundColor','red');

% turn Edit 2 green - check findedit(figure,'userdata')
set(findedit(1,'dennis'),'ForeGroundColor','green');

% turn Edit 3 blue - check findedit(figure,value,value)
set(findedit(1,3),'ForeGroundColor','blue');

% turn Edit4 magenta - check findedit(figure,value,'userdata')
set(findedit(1,'george'),'ForeGroundColor','magenta');

pause % press key to continue the Edit uicontrols test

% turn Edit 1 green - check findedit(value)
set(findedit(1,1),'ForeGroundColor','green');

% turn Edit 2 blue - check findedit(value)
set(findedit(1,'dennis'),'ForeGroundColor','blue');

% turn Edit 3 magenta - check findedit(value,value)
set(findedit(1,3),'ForeGroundColor','magenta');

% turn Edit4 red - check findedit(value,'userdata')
set(findedit(1,'george'),'ForeGroundColor','red');

pause % Edit complete
echo off
% ------------------------------------------------------------------
% Draw popupmenu objects in row5
% Popupmenus can be found by Userdata
% Userdata can be a string or a scalar number.
uicontrol(...
    'Style','popupmenu','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row5 wide hite],...
    'String','Pop 1|Pop 2|Pop 3|Pop 4','Value',1, ...
    'Userdata',1 ...
    );
uicontrol(...
    'Style','popupmenu','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row5 wide hite],...
    'String','Pop 1|Pop 2|Pop 3|Pop 4','Value',2, ...
    'Userdata','dennis'...
    );
uicontrol(...
    'Style','popupmenu','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row5 wide hite],...
    'String','Pop 1|Pop 2|Pop 3|Pop 4','Value',3, ...
    'Userdata',3 ...
    );
uicontrol(...
    'Style','popupmenu','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row5 wide hite],...
    'String','Pop 1|Pop 2|Pop 3|Pop 4','Value',4, ...
    'Userdata','george'...
    );

echo on
pause % press key to test the Popupmenu uicontrols

% turn menuitems around - check findpopu(figure,userdata)
set(findpopu(1,1),'Value',4);

% turn menuitems around - check findpopu(figure,'userdata')
set(findpopu(1,'dennis'),'Value',3);

% turn menuitems around - check findpopu(figure,userdata)
set(findpopu(1,3),'Value',2);

% turn menuitems around - check findpopu(figure,'userdata')
set(findpopu(1,'george'),'Value',1);

pause % press key to continue the popupmenu uicontrols test

% turn menuitems around - check findpopu(userdata)
set(findpopu(1,1),'Value',2);

% turn menuitems around - check findpopu('userdata')
set(findpopu(1,'dennis'),'Value',1);

% turn menuitems around  - check findpopu(userdata)
set(findpopu(1,3),'Value',4);

% turn menuitems around - check findpopu('userdata')
set(findpopu(1,'george'),'Value',3);

pause % Popupmenu complete
echo off
% ------------------------------------------------------------------
% Draw radiobutton objects in row6
% Radiobuttons can be found by String or String & Userdata.
% Userdata can be string or scalar number.
uicontrol(...
    'Style','radiobutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row6 wide hite],...
    'String','Radio 1','Userdata',1 ...
    );
uicontrol(...
    'Style','radiobutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row6 wide hite],...
    'String','Radio 2','Userdata','dennis'...
    );
uicontrol(...
    'Style','radiobutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row6 wide hite],...
    'String','Radio 3','Userdata',3 ...
    );
uicontrol(...
    'Style','radiobutton','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row6 wide hite],...
    'String','Radio 4','Userdata','george'...
    );

echo on
pause % press key to test the Checkbox uicontrols

% turn Radio 1 off - check findrdio(figure,'string')
set(findrdio(1,'Radio 1'),'Value',1);

% turn Radio 2 off - check findrdio(figure,'string')
set(findrdio(1,'Radio 2'),'Value',1);

% turn Radio 3 off - check findrdio(figure,'string',userdata)
set(findrdio(1,'Radio 3',3),'Value',1);

% turn Radio4 off - check findrdio(figure,'string','userdata')
set(findrdio(1,'Radio 4','george'),'Value',1);

pause % press key to continue the Radiobutton uicontrols test

% turn Radio 1 on - check findrdio('string')
set(findrdio(1,'Radio 1'),'Value',0);

% turn Radio 2 on - check findrdio('string')
set(findrdio(1,'Radio 2'),'Value',0);

% turn Radio 3 on - check findrdio('string',userdata)
set(findrdio(1,'Radio 3',3),'Value',0);

% turn Radio4 on - check findrdio('string','userdata')
set(findrdio(1,'Radio 4','george'),'Value',0);

pause % Radiobutton complete
echo off
% ------------------------------------------------------------------
% Draw Slider objects in row7
% Sliders can be found by String or String & Userdata.
% Userdata can be string or scalar number.
uicontrol(...
    'Style','Slider','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row7 wide hite],...
    'String','Slide 1','Userdata',1 ...
    );
uicontrol(...
    'Style','Slider','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row7 wide hite],...
    'String','Slide 2','Userdata','dennis'...
    );
uicontrol(...
    'Style','Slider','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row7 wide hite],...
    'String','Slide 3','Userdata',3 ...
    );
uicontrol(...
    'Style','Slider','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row7 wide hite],...
    'String','Slide 4','Userdata','george'...
    );

echo on
pause % press key to test the Checkbox uicontrols

% turn Slide 1 off - check findslid(figure,'string')
set(findslid(1,'Slide 1'),'Value',1);

% turn Slide 2 off - check findslid(figure,'string')
set(findslid(1,'Slide 2'),'Value',1);

% turn Slide 3 off - check findslid(figure,'string',userdata)
set(findslid(1,'Slide 3',3),'Value',1);

% turn Slide4 off - check findslid(figure,'string','userdata')
set(findslid(1,'Slide 4','george'),'Value',1);

pause % press key to continue the Slider uicontrols test

% turn Slide 1 on - check findslid('string')
set(findslid(1,'Slide 1'),'Value',0);

% turn Slide 2 on - check findslid('string')
set(findslid(1,'Slide 2'),'Value',0);

% turn Slide 3 on - check findslid('string',userdata)
set(findslid(1,'Slide 3',3),'Value',0);

% turn Slide4 on - check findslid('string','userdata')
set(findslid(1,'Slide 4','george'),'Value',0);

pause % Slider complete
echo off
% ------------------------------------------------------------------
% Draw frame objects in row8
% Frames can be found by Userdata
% Userdata can be a string or a scalar number.
uicontrol(...
    'Style','frame','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col1 row8 wide hite],...
    'String','','Value',1, ...
    'Userdata',1 ...
    );
uicontrol(...
    'Style','frame','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col2 row8 wide hite],...
    'String','','Value',2, ...
    'Userdata','dennis'...
    );
uicontrol(...
    'Style','frame','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col3 row8 wide hite],...
    'String','','Value',3, ...
    'Userdata',3 ...
    );
uicontrol(...
    'Style','frame','Units','normal','Horiz','center',...
    'Foreground','black','Position',[col4 row8 wide hite],...
    'String','','Value',4, ...
    'Userdata','george'...
    );

echo on
pause % press key to test the Popupmenu uicontrols

% turn frames off - check findfram(figure,userdata)
set(findfram(1,1),'Visible','off');

% turn frames off - check findfram(figure,'userdata')
set(findfram(1,'dennis'),'Visible','off');

% turn frames off - check findfram(figure,userdata)
set(findfram(1,3),'Visible','off');

% turn frames off - check findfram(figure,'userdata')
set(findfram(1,'george'),'Visible','off');

pause % press key to continue the frame uicontrols test

% turn frames on - check findfram(userdata)
set(findfram(1,1),'Visible','on');

% turn frames on - check findfram('userdata')
set(findfram(1,'dennis'),'Visible','on');

% turn frames on  - check findfram(userdata)
set(findfram(1,3),'Visible','on');

% turn frames on - check findfram('userdata')
set(findfram(1,'george'),'Visible','on');

pause % Popupmenu complete

% make some axis
axes('position',[col1 row11 wide 4*hite]);
idaxes(1);
title('Axis 1');
axes('position',[col2 row11 wide 4*hite]);
idaxes('dennis');
title('Axis 2');
axes('position',[col3 row11 wide 4*hite]);
idaxes(3);
title('Axis 3');
axes('position',[col4 row11 wide 4*hite]);
idaxes('george');
title('Axis 4');

echo on
pause % press key to test axes

% turn Axes 1 green - check findaxes(value)
set(findaxes(1,1),'Color','green');

% turn Axes 2 blue - check findaxes(value)
set(findaxes(1,'dennis'),'Color','blue');

% turn Axes 3 magenta - check findaxes(value,value)
set(findaxes(1,3),'Color','magenta');

% turn Axes4 red - check findaxes(value,'userdata')
set(findaxes(1,'george'),'Color','red');

pause % Axes complete
echo off
% ------------------------------------------------------------------
% Draw menus.
% uimenus can be accessed with Labels
f = uimenu('Label','Workspace');
uimenu(f,'Label','New Figure');
f2 = uimenu(f,'Label','Save');
uimenu(f2,'Label','As');
uimenu(f2,'Label','Was');
uimenu(f,'Label','Exit');

echo on
pause % press key to test uimenus

% Menu should be
%    Workspace
%      New Figure
%      Save
%        As
%        Was
%      Exit

pause % press key after checking menu

set(findmenu(1,'Workspace'),'Label','Dennis');
set(findmenu(1,'Dennis','Exit'),'Label','Leave');
set(findmenu(1,'Dennis','Save','Was'),'Label','Were');

% Menu should be
%    Dennis
%      New Figure
%      Save
%        As
%        Were
%      Leave

pause % press key after checking menu

set(findmenu(1,'Dennis'),'Label','Workspace');
set(findmenu(1,'Workspace','Leave'),'Label','Exit');
set(findmenu(1,'Workspace','Save','Were'),'Label','Was');

% Menu should be
%    Dennis
%      New Figure
%      Save
%        As
%        Were
%      Leave

pause % press key after checking menu


