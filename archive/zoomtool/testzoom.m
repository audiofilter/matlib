function TESTZOOM
%TESTZOOM Test zoom controls.
%       TESTZOOM clears the present figure and creates a sample
%       plot used to test zoomtool controls.
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

clf
if findmenu(gcf,'Zoom'),
	delete(findmenu(gcf,'Zoom'))
end;

% local variables
column_width = .2;    b_width = .175;    b_hite = .05;
columns = (0:4) * column_width;
rows = (0:4) * b_hite + .025;
axis_left = .15;     axis_bottom = rows(4) + .2;
axis_width = .75;   axis_hite = .9 - axis_bottom;

set(gcf,'units','normal');

% create axes for time domain and frequency domain plot
h=axes; %('Position',[axis_left axis_bottom axis_width axis_hite]);

% create test curve
x2 = -4:20;
y2 = x2 .^3 - 24 * x2 .^2 + 128 * x2;

% new x scale
x2 = (11:35)/3;

% Create test plot
plot(x2,y2,'r');
title('Test Data')
xlabel('X-Axis');
ylabel('Y-Axis');

% set it up
zoomtool(gca);

plot(x2,[y2' (y2+ones(1,length(y2))*500)']);
title('Multiline Test Data')
xlabel('X-Axis');
ylabel('Y-Axis');

zoomtool

