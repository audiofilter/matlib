function chhoices(name,header,labels,callbacks)
%CHOICES Create a list of choices with uicontrols and callbacks.
%	CHOICES('NAME',HEADER,BUTTONLABELS,CALLBACKS) creates
%	a window with registered name NAME.  The window contains
%	the string HEADER and buttons labeled with BUTTONLABELS.
%	These buttons register callback strings from CALLBACKS.
%	An additional button, labeled 'Close', is added to each
%	choicelist.
%
%	CHOICES is useful for constructing demo menus.
%	Use CHOICES in conjunction with CHOICEX, as in
%	this example.
%	    header = 'Easy Example';
%	    labels = str2mat('Choice 1','Choice 2','Choice 3');
%	    callbacks = str2mat('image(magic(1))','image(magic(2))', ...
%	        'image(magic(3))');
%	    choices('EXAMPLE', header, labels, callbacks);
%

%	Loren Shure, 8-14-92.
%	Copyright (c) 1984-92 by The MathWorks, Inc.
%
%	Modified by M.Zeytinoglu 08.16.1993
%

%       This function does not work under Octave

if ~isstr(name) | ~isstr(header) | ~isstr(labels) | ~isstr(callbacks)
	error('Requires string arguments.');
end
if nargin < 4
	error('Not enough input arguments.')
end
global CHOICELIST
global CHOICEHANDLES
name = deblank(name);
if isempty(name)
	error('Requires non-blank string argument.')
end
% ensure list doesn't go into figure 1
figs = sort(get(0,'Children'));
if isempty(figs)
	figs = figure;
end
if figs(1) ~= 1
	figs = [figure; figs];
end
cf = gcf;
matchn = 0;
for i = 1:size(CHOICELIST,1)
	if strcmp(name,deblank(CHOICELIST(i,:)))
	    matchn = i;
	    break;
	end
end
if ~matchn
	CHOICEHANDLES = [CHOICEHANDLES; 0];
	if isempty(CHOICELIST)
	    CHOICELIST = name;
	else
	    CHOICELIST = str2mat(CHOICELIST, name);
	end
	matchn = size(CHOICEHANDLES,1);
else
	matchh = 0;
	for i = 1:size(figs,1)
	    if figs(i) == CHOICEHANDLES(matchn)
	        matchh = i;
	        break;
	    end
	end
	if matchh
	    figure(CHOICEHANDLES(matchn));
	    return
	end
end
xedge = 30;
ybord = 30;
width = 30;
yedge = 35;
c = computer;
if c(1:2) == 'PC'
   hh = text(.1,.1,'Aq');yedge = get(hh,'extent');delete(hh)
   yedge = 1.6*yedge(4);
end
avwidth = 7; % actually 6.8886 +/- 0.4887
height = 30;
imax = 1;
maxlen = size(labels,2);
twidth = 1.2*maxlen*avwidth;
% now figure out total dimensions needed so things can get placed in pixels
mwwidth = twidth + width + 2*xedge;
mwheight = (size(labels,1)+2)*yedge;
ss = get(0,'ScreenSize');
swidth = ss(3); sheight = ss(4);
left = 20;
bottom = sheight-mwheight-ybord;
rect = [left bottom mwwidth mwheight];
CHOICEHANDLES(matchn) = figure('Position',rect,'number','off', ...
    'name','','resize','off','colormap',[],'NextPlot','new');
fg = CHOICEHANDLES(matchn);
fgs = CHOICEHANDLES(CHOICEHANDLES ~= fg);
set(fgs,'visible','on')
set(gca,'Position',[0 0 1 1]); axis off;
% Place header
hh=uicontrol(fg,'style','text','units','normal',...
          'position',[.05,.91,.9,.11 ],'string',header,...
          'Horizontal','center');
set(hh,'backg',get(gcf,'color'),'foreg',[1 1 1]-get(gcf,'color'))
% set up pre-amble so figure 1 is available for rendering in
sb = ['figure(1);set(',int2str(fg),',''visible'',''on'');'];
se = [';global CHOICEHANDLES,set(CHOICEHANDLES(length(CHOICEHANDLES)),''visible'',''on'')'];
for ii=size(labels,1):-1:1
	i = size(labels,1) + 2 - ii;
	h1 = uicontrol(fg,'position',[xedge  (i-.5)*yedge width+twidth height]);
	set(h1,'callback',[sb callbacks(ii,:) se])
	set(h1,'string',['  ',labels(ii,:)]);
% left justify string inside button
	set(h1,'HorizontalAlignment','left');
end
% Create Close button
h1 = uicontrol(fg,'position',[xedge .5*yedge width+twidth height]);
set(h1,'string','  Close');
set(h1,'callback',['choicex(''',name,''')']);
set(h1,'HorizontalAlignment','left');
figure(cf)
