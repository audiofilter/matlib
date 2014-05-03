% pertone Demonstrates Per Tone equalizers design functions
% in the DMTTEQ Toolbox.
%
% To start the demo type "pertone".
%
% For more information use the "info" button after starting
% the demo.

% Copyright (c) 1999-2003 The University of Texas
% All Rights Reserved.
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% The GNU Public License is available in the file LICENSE, or you
% can write to the Free Software Foundation, Inc., 59 Temple Place -
% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
% World Wide Web at http://www.fsf.org.
%  
% Programmers:	Ming Ding, Guner Arslan and Zukang Shen
% Version:      @(#)dualteq.m	1.0 01/14/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function  pertone(action);

if nargin < 1,
   action='init';
end;

if strcmp(action,'init'),
   %close all;
   shh = get(0,'showHiddenHandles');
   set(0,'showHiddenHandles','on')
   figNumber=figure( ...
      'Name','Per Tone Equalizers Design Demo', ...
      'ToolBar','figure',...
      'handlevisibility','callback',...
      'IntegerHandle','off',...
      'NumberTitle','off',...
      'Position',[232 255 575 423]);
   
   set(gcf,'Pointer','watch');
   
   % figure parameters
   labelColor=[0.8 0.8 0.8];
   yInitPos=0.90;
   menutop=0.97;
   btnTop = 0.6;
   top=0.75;
   left=0.685;
   btnWid=0.290;
   btnHt=0.055;
   textHeight = 0.04;
   textWidth = 0.06;
   spacing=0.005;
   resWidth = 0.55;
   resHeight = 0.12;
   grpleft = 0.09;
   grpbuttom = 0.3;
   
   % graph axis setup
   axesposition = [grpleft grpbuttom 0.55 0.63];
   axes( ...
      'Units','normalized', ...
      'Position',axesposition, ...
      'XTick',[],'YTick',[], ...
      'Box','on');
   set(figNumber,'defaultaxesposition',axesposition)
   freqzHnd = subplot(1,1,1);
   set(gca, ...
      'Units','normalized', ...
      'Position',axesposition, ...
      'XTick',[],'YTick',[], ...
      'Box','on');
   
   
   % console frame setup
   frmBorder=0.019; frmBottom=0.04; 
   frmHeight = 0.92; frmWidth = btnWid;
   yPos=frmBottom-frmBorder;
   frmPos=[left-frmBorder yPos frmWidth+2*frmBorder frmHeight+2*frmBorder];
   h=uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',frmPos, ...
      'BackgroundColor',[0.5 0.5 0.5]);
   
   % result frame setup
   numColumn = 6;
   numRow = 2;
   border = 0.002;
   tabWidth = (resWidth - (numColumn + 1) * border) / numColumn;
   tabHeight = (resHeight - (numRow + 1) * border) / numRow;
   resyPos = yPos+tabHeight+border;
   resfrmPos=[grpleft resyPos resWidth resHeight+border];
   
   h=uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',resfrmPos, ...
      'BackgroundColor',[0.5 0.5 0.5]);
   
   % result table entries
   gridNum = [1 1];
   tabBottom = resyPos + border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h11 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String',' ', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [1 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h12 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','Rate', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [2 1];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h21 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [2 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h22 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','SNR', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [3 1];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h31 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [3 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h32 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','SSNR', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [4 1];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h41 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [4 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h42 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','MSE', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [5 1];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h51 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [5 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h52 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','Delay', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [6 1];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h61 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   gridNum = [6 2];
   tabBottom = resyPos+border + (border+tabHeight)*(gridNum(2)-1);
   tabLeft = grpleft+ border + (border+tabWidth)*(gridNum(1)-1);
   tabPos = [tabLeft tabBottom tabWidth tabHeight];
   h62 = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',tabPos, ...
      'Horiz','center', ...
      'String','MaxRate 1-FIR', ...
      'Interruptible','off', ...
      'BackgroundColor','white', ...
      'ForegroundColor','black');
   
   % TEQ Design Routine Selection Menu
   btnNumber=1;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   btnPos=[left yPos-btnHt btnWid btnHt];
   labelStr='Least Squares PTE|MMSE PTE'; 
   callbackStr='pertone(''changemethod'');';
   methodHndl=uicontrol( ...
      'Style','popupmenu', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Interruptible','on', ...
      'Callback',callbackStr);
   
   % Tone Grouping label
   btnNumber=1;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Tones per group', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set TG
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setTG'')';
   str = sprintf('1');
   mat = [1];
   TGHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % Nw label
   btnNumber=2;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','TEQ length (Nw)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Nw
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setNw'')';
   str = sprintf('32');        %default setting changed from 16 to 3 09/18/01 by ming
   mat = [32];
   NwHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % FFT Size label
   btnNumber=3;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','FFT Size (N)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set FFT size
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setN'')';
   str = sprintf('512');
   mat = [512];
   NHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % coding gain label
   btnNumber=4;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Coding gain (dB)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set coding gain 
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setCG'')';
   str = sprintf('4.2');
   mat = [4.2];
   CGHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % Margin label
   btnNumber=5;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Margin (dB)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set margin
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setMargin'')';
   str = sprintf('6');
   mat = [6];
   MarginHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   
   % Dmin label
   btnNumber=6;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Dmin', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Dmin
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setDmin'')';
   str = sprintf('15');
   mat = [15];
   DminHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % Dmax label
   btnNumber=7;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Dmax', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Dmax
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setDmax'')';
   str = sprintf('35');
   mat = [35];
   DmaxHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % input power label
   btnNumber=8;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Input power (dBm)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set input power
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setPwr'')';
   str = sprintf('23');
   mat = [23];
   PwrHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % AWGN power label
   btnNumber=9;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','AWGN pow (dBm/Hz)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set AWGN power
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setAWGN'')';
   str = sprintf('-140');
   mat = [-140];
   AWGNHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % channel number label
   btnNumber=10;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','CSA loop # (1-8)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set channel number
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'pertone(''setCSA'')';
   str = sprintf('1');
   mat = [1];
   CSAHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % heuristic delay search
   btnNumber=11;
   yPos=menutop-(btnNumber-1)*(btnHt+spacing);
   top = yPos - btnHt - spacing;
   labelWidth = frmWidth-textWidth-.01;
   labelBottom=top-textHeight;
   labelLeft = left;
   labelPos = [labelLeft labelBottom+0.01 labelWidth textHeight];
   mat=[1];
   callbackStr='tfb(''setHDelaySearch'');';
   hd = uicontrol( ...
      'Style','radio', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','heuristic delay', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white',...
      'Userdata',mat,...
      'Value',1,...
      'callback',callbackStr);
  

   
   % optimal delay search
   textPos = [labelLeft+labelWidth-.07 labelBottom+0.01 textWidth+.08 textHeight];
   callbackStr='tfb(''setODelaySearch'');';
   od = uicontrol( ...
      'Style','radio', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Horiz','left', ...
      'String','optimal delay', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white',...
      'Userdata',mat,...
      'value',0,...
      'callback',callbackStr);
  
   % graphic selection menu
   labelStr=['SNR & MFB'...
         '|Noise Power Spectrum|delay plot'];
   callbackStr='pertone(''plotGraph'');';
   mat = 1;
   viewHndl=uicontrol( ...
      'Style','popupmenu', ...
      'Units','normalized', ...
      'Position',[left frmBottom+3*(btnHt+spacing) btnWid btnHt], ...
      'String',labelStr,'Userdata',mat, ...
      'Interruptible','on', ...
      'Callback',callbackStr);
   
   % run button
   labelStr='Calculate';
   callbackStr='pertone(''design'')';
   closeHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom+2*(btnHt+spacing) btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
  
   % save pertone button
   labelStr='Save Equalizer';
   callbackStr='pertone(''savepertone'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom+btnHt+spacing btnWid/2 btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
    % save all button
   labelStr='Save Parameters';
   callbackStr='pertone(''saveall'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left+btnWid/2 frmBottom+btnHt+spacing btnWid/2 btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
  % help button
   labelStr='Information';
   callbackStr='pertone(''info'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);

  
   % put all handles in userdata of the parent object
   fhndlList=[freqzHnd TGHndl NwHndl NHndl CGHndl MarginHndl ...
         DminHndl DmaxHndl PwrHndl AWGNHndl CSAHndl viewHndl ...
     helpHndl closeHndl methodHndl h11 h21 h31 h41 h51 h61 hd od];
   set(figNumber, ...
      'Visible','on', ...
      'UserData',fhndlList);
   
   drawnow
   axes(freqzHnd)
   set(freqzHnd,'Userdata',[])
   pertone('design')
   set(gcf,'Pointer','arrow','handlevisibility','callback');
   set(0,'showHiddenHandles',shh)
   return
   
   
   % change method 
elseif strcmp(action,'changemethod'),
   v = get(gco,'value');  
   % 1=MMSE-UEC,2=MMSE-UTC,3=MSSNR,4=GEO,5=min-ISI,6=MBR,7=DCC,8=DCM,9=MP,
   % 10=MMP, 11=Eig-App 12=ARMA
   set(gco,'userdata',v);
   return
   
   % set TG
elseif strcmp(action,'setTG'),
   hndlList=get(gcf,'Userdata');
   tg = get(hndlList(2),'userdata');
   meth = get(hndlList(15),'value');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow tg<1 or tg>256
   if vv < 1 | vv >256
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv));
   return
   
   % set Nw
elseif strcmp(action,'setNw'),
   hndlList=get(gcf,'Userdata');
   nw = get(hndlList(3),'userdata');
   meth = get(hndlList(15),'value');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow Nw<1 
   if vv <= 1 
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set coding gain   
elseif strcmp(action,'setCG'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow negative coding gain 
   if vv < 0, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set margin   
elseif strcmp(action,'setMargin'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow negative margin
   if vv < 0, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set input power   
elseif strcmp(action,'setPwr'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow negative input power
   if vv < 0, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set white noise power   
elseif strcmp(action,'setAWGN'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow negative noise power
   if vv > 0, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set channel number   
elseif strcmp(action,'setCSA'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % only have 8 CSA channel numbered 1-8
   if vv < 1 | vv > 8, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set Dmin   
elseif strcmp(action,'setDmin'),
   hndlList=get(gcf,'Userdata');
   Dmax = get(hndlList(8),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmin cannot be smaller than 1 and larger than Dmax
   if vv<1 | vv > Dmax, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set Dmax   
elseif strcmp(action,'setDmax'),
   hndlList=get(gcf,'Userdata');
   Dmin = get(hndlList(7),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmax cannot be smaller than 1 and Dmin
   if vv < 1 | vv < Dmin, 
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set N   
elseif strcmp(action,'setN'),
   hndlList=get(gcf,'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % N has to be a power of 2
   if (floor(log(vv)/log(2))-(log(vv)/log(2))) ~= 0
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
 elseif strcmp(action,'setHDelaySearch'),
   hndlList=get(gcf,'Userdata');
   hd=hndlList(22);
   od=hndlList(23);
  set(hd,'value',get(hd,'Max'));
  set(hd,'userdata','1');
  set(od,'value',get(od,'Min'));
  set(od,'userdata','0');
         
   return
   
 elseif strcmp(action,'setODelaySearch'),
   hndlList=get(gcf,'Userdata');
   hd=hndlList(22);
   od=hndlList(23);
  set(od,'value',get(od,'Max'));
  set(od,'userdata','1');
  set(hd,'value',get(hd,'Min'));
  set(hd,'userdata','0');
   return
   
   
   % design TEQ   
elseif strcmp(action,'design'),
   set(gcf,'Pointer','watch');
   % get handles
   axHndl=gca;
   fhndlList=get(gcf,'Userdata');
   freqzHndl = fhndlList(1);
   TGHndl = fhndlList(2);
   NwHndl = fhndlList(3);
   NHndl = fhndlList(4);
   CGHndl = fhndlList(5);
   MarginHndl = fhndlList(6);
   DminHndl = fhndlList(7);
   DmaxHndl = fhndlList(8);
   PwrHndl = fhndlList(9);
   AWGNHndl = fhndlList(10);
   CSAHndl = fhndlList(11);
   viewHndl = fhndlList(12);
   helpHndl = fhndlList(13);
   closeHndl = fhndlList(14);
   methodHndl = fhndlList(15);
   methRateHndl = fhndlList(16);
   methSNRHndl = fhndlList(17);
   methSSNRHndl = fhndlList(18);
   methMSEHndl = fhndlList(19);
   methDelayHndl = fhndlList(20);
   methMaxHndl = fhndlList(21);
   HDHndl=fhndlList(22);
   ODHndl=fhndlList(23);
   
   colors = get(gca,'colororder'); 
  
   % init variables
   TG = get(TGHndl,'userdata');
   Nw = get(NwHndl,'userdata');
   N = get(NHndl,'userdata');
   codingGain = get(CGHndl,'userdata');
   margin = get(MarginHndl,'userdata');
   Dmin = get(DminHndl,'userdata');
   Dmax = get(DmaxHndl,'userdata');
   totalInputPower = get(PwrHndl,'userdata');
   AWGNpower = get(AWGNHndl,'userdata');
   loopNum = get(CSAHndl,'userdata');
   method = get(methodHndl,'value');
   HD=get(HDHndl,'value');
   OD=get(ODHndl,'value');
   if (HD==1)&(OD==0)
       delaySearch=1; %delaySearch=1 => heuristic delay search
   elseif (HD==0)&(OD==1)
       delaySearch=0; %delaySearch=0 => optimal delay search
   else
       delaySearch=1;
   end
   barflag = 1;
   chflag=1;
   %number of iteration per TEQ tap
   numIter = 1000;

   
   %generate signal,noise, and channel data
   [recNoisySig,receivedSignal,noise,channel,inputSignal,gamma,fs,NEXTnoise, AWGN, FX] = ...
      siggen_pertone(N,AWGNpower,loopNum,totalInputPower,codingGain,margin,barflag,chflag);

  %save tmp1.mat inputSignal, receivedSignal, noise;

   %estimate the power spectrums
   [inputSpecAll, noiseSpecAll, channelGainAll]=...
      specestim(inputSignal,noise,channel,N,barflag);
%     figure
%     plot(inputSpecAll);
   %calculate SNRs and usable channels
   [subMFBall,subMFB,usedSubs,noiseSpec,channelGain,inputSpec] = ...
   calcsnrs(inputSpecAll,channelGainAll,noiseSpecAll,gamma);

   %chose method and design pertone
   [subSNR, Ps, Pn, WM, D, title_str, py, pX, rateVector] = selmeth_pte(method,FX,...
   receivedSignal,noise,channel, Nw, N, barflag, AWGN, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain);
   

%    Xhat = pertoneeq(WM.',py);
% 
%    [subSNR, Ps, Pn] = snr_pte(pX, Xhat, usedSubs);
   
   
   bmap(usedSubs) = ba_cal(subSNR(usedSubs), 9.8, margin, codingGain, 0, 100, 0);
   
   RDMTfinal = fs/(N+32)*sum(bmap);
   
   bmfb(usedSubs) = ba_cal(subMFBall(usedSubs), 9.8, margin, codingGain, 0, 100, 0);
   RDMTmfb = fs/(N+32)*sum(bmfb); %include the cp
   % get performance results
   %[SSNR, SNR, subSNR,geoSNRfinal,geoSNRmfb,bDMTfinal,bDMTmfb,...
    %     RDMTfinal,RDMTmfb,hw,Fh,Fw,colorNoiseaft,Fhw] = ...
     % perform(W,B,channel,D,Nb,N,inputSignal,noise,...
      %channelGainAll,inputSpecAll,noiseSpecAll,margin,codingGain,fs,subMFBall,usedSubs);
   
   % put results into table
   str = sprintf('%1.3fe6',RDMTfinal/1e6);
   set(methRateHndl,'string',str);
   str = '-';
   set(methSNRHndl,'string',str);
   str = '-';
   set(methSSNRHndl,'string',str);
   str = sprintf('%d',D);
   set(methDelayHndl,'string',str);
   str = '-';
   set(methMSEHndl,'string',str);
   str = sprintf('%1.3fe6',RDMTmfb/1e6);
   set(methMaxHndl,'string',str);
   
   
   % save results to disk in order to use it in other functions 
   save pertonetmpresults subMFBall subSNR N usedSubs title_str noiseSpec noiseSpecAll WM D py pX delaySearch rateVector Dmin Dmax fs;
   
   %TEQequalizerTaps = W;
   %TEQtargetImpulseResp = B;
   %TEQoptimalDelay = D;
   %TEQoriginalChannel = channel;
   %TEQequalizedChannel = hw;
   %TEQmatchedFilterBoundPerChannel = subMFB;
   %TEQSNRperChannel = subSNR;
   %TEQoriginalChannelFreqResp = Fh;
   %TEQequalizerFreqResp = Fw;
   %TEQequalizedChannelFreqResp = Fhw;
   %TEQchanNoisePowSpecAfterEqual = colorNoiseaft;
   %TEQchanNoisePowSpecBeforeEqual = noiseSpec;
    TEQDmin = Dmin;
    TEQDmax = Dmax;
    TEQTG = TG;
    TEQNw = Nw;
    TEQN = N;
    TEQPT = WM;
    TEQPTSubsnr = subSNR;
    TEQoriginalChannel = channel;
    TEQoptimalDelay = D;
    TEQCodingGain=codingGain;
    TEQMargin=margin;
    TEQInputPower=totalInputPower;
    TEQAWGNPower=AWGNpower;
    TEQLoopnum=loopNum;
   
    save pertoneresults TEQDmin TEQDmax TEQTG TEQNw TEQN TEQPT TEQPTSubsnr TEQoriginalChannel ...
    TEQoptimalDelay TEQCodingGain TEQMargin TEQInputPower TEQAWGNPower TEQLoopnum;

   %save teqresults TEQequalizerTaps TEQtargetImpulseResp  ...
	   %TEQoptimalDelay TEQoriginalChannel TEQequalizedChannel ...
	   %TEQmatchedFilterBoundPerChannel TEQSNRperChannel ...
	   %TEQoriginalChannelFreqResp TEQequalizerFreqResp ...
	   %TEQequalizedChannelFreqResp TEQchanNoisePowSpecAfterEqual...
	   %TEQchanNoisePowSpecBeforeEqual TEQDmin TEQDmax TEQNb TEQNw TEQN;
	   
   % plot result
   pertone('plotGraph');
   set(gcf,'Pointer','arrow');
   return
   
   % plot graph
elseif strcmp(action,'plotGraph'),
  legend off
  set(gcf,'Pointer','watch');
   % get handles
   fhndlList = get(gcf,'Userdata');
   viewHndl = fhndlList(12);
   freqzHndl = fhndlList(1);
   % set axis
   axHndl = gca;
   axes(freqzHndl);
   % which graph is going to be plotted
   graphNum = get(viewHndl,'value'); 
   %1= TIR/SIR, 2= TEQ impulse res., 3= TEQ freq. res., 4= SNR/MFB
   %5=original and short channel impulse res, 6 = noise power spec., 
   %7= delay plot, 8= equalized channel freq
   
   % load results for current TEQ
   load pertonetmpresults;
   freqAxis = 1:N/2+1;
   
   % plot chosen grap
   if graphNum == 1
      legend off
      plot(freqAxis(usedSubs),10*log10(subSNR(usedSubs)+eps))
      hold on;
      plot(freqAxis(usedSubs),10*log10(subMFBall(usedSubs)+eps),'r')
      hold off
      grid on
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency')
      ylabel('magnitude (dB)')
      title([title_str,' achieved and upper-bound SNR'])
      legend('SNR','MFB',0);
      
  elseif graphNum == 2
      legend off
      plot(freqAxis(usedSubs),20*log10(noiseSpecAll(usedSubs)+eps),'r')
      grid on	
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency')
      ylabel('magnitude (dB)')
      title([title_str,' Noise Power Spectrum'])
      legend('before TEQ','after TEQ',0);  
      
    elseif graphNum == 3 
      if delaySearch==0
        legend off
        plot([Dmin:Dmax],rateVector*fs/(N+32));
        xlabel('delay');
        ylabel('bit rate');
        title([title_str,' bit rate vs. delay']);
     else
        legend off
        plot([D],rateVector*fs/(N+32));
        xlabel('delay');
        ylabel('bit rate');
        title([title_str,' bit rate vs. delay']); 
      end
      grid on
  end
   
   set(gcf,'Pointer','arrow');
   return
   
     %save pertone to a file 
elseif strcmp(action,'savepertone');
   
    [filename,path]=uiputfile('*');
    if filename==0
        return;    
    end
    
    load pertoneresults;
    output=fopen([path,filename],'w');
    fprintf(output,'%s','optimal delay =');
    fprintf(output,' %d ;\n',TEQoptimalDelay);
    fprintf(output,'\n');
    [rowNum,colNum]=size(TEQPT);
    for j=1:colNum
        fprintf(output,'subcarrier %d FEQ =[\n',j);
        for i=1:rowNum
            fprintf(output,'%f \n',TEQPT(i,j));
        end
        fprintf(output,'%s\n','];');
        fprintf(output,'\n');
    end


    fclose(output);
    
    
   %save all parameters
elseif strcmp(action,'saveall')
    [filename,path]=uiputfile('*');
    if filename==0;
        return;
    end
    
    load pertoneresults;
    output=fopen([path,filename],'w');
    fprintf(output,'all the parameters are also saved into %s.mat\n',filename);
    fprintf(output,'%s','tone group =');
    fprintf(output,' %d\n',TEQTG);
    fprintf(output,'%s','FEQ length =');
    fprintf(output,' %d;\n',TEQNw);
    fprintf(output,'%s','FFT size =');
    fprintf(output,' %d;\n',TEQN);
    fprintf(output,'%s','coding gain =');
    fprintf(output,' %f;\n',TEQCodingGain);
    fprintf(output,'%s','margin =');
    fprintf(output,' %d;\n',TEQMargin);
    fprintf(output,'%s','Dmin =');
    fprintf(output,' %d;\n',TEQDmin);
    fprintf(output,'%s','Dmax =');
    fprintf(output,' %d;\n',TEQDmax);
    fprintf(output,'%s','input power =');
    fprintf(output,' %f (dBm);\n',TEQInputPower);
    fprintf(output,'%s','AWGN power =');
    fprintf(output,' %f (dBm/Hz);\n',TEQAWGNPower);
    fprintf(output,'%s','loop number =');
    fprintf(output,' %d;\n',TEQLoopnum);
    fclose(output);
    str=sprintf(['save ', filename,' TEQTG TEQNw TEQN TEQCodingGain TEQMargin TEQDmin',...
            ' TEQDmax TEQInputPower TEQAWGNPower TEQLoopnum;']);
    eval(str);
    
    
   % get help
elseif strcmp(action,'info'),
   ttlStr = get(gcf,'name');
   myFig = gcf;
   
   topic1 =  ['Per Tone design demo'];
   helptop1 = [...
     'The demonstration facilitates the design of a per tone equalizer      '
     'structure.  The per tone equalizer consists of a sliding FFT and      '
     'a linear combiner of each vector of sliding FFT values for each       '
     'subchannel (tone) with a vector of equalizer coefficients tuned       '
     'for that tone.  In essence, the time domain equalizer of Nw taps      '
     'in the conventional equalizer has been moved into the single-tap      '
     'frequency domain equalizer to form the Nw-tap linear combiner.  A     '
     'reduced complexity per tone equalizer structure exists which          '
     'replaces the sliding FFT with a single FFT and tapped delay line      '
     'of time domain difference terms.  For either structure, Nw N/2        '
     'complex coefficients need to be trained, where Nw is the equalizer    '
     'length (combiner taps per tone) and N/2 is the number of              '
     'subchannels (tones).  More information concerning the per tone        '
     'equalizer can be found in the following paper:                        '
     '                                                                      '
     'K. Van Acker, G. Leus, M. Moonen, O. van de Wiel, and T. Pollet,      '
     '"Per Tone Equalization for DMT-based systems", IEEE Trans. on         '
     'Communications, vol. 49, no. 1, pp. 109-119, Jan. 2001.               '
     '                                                                      '
     'Usage: Set parameters to desired values and hit the Calculate button. '
     '                                                                      '
     'The following design methods are supported:                           '
	 '  Least squares matching of frequency domain input-output.            '
     '  MMSE pertone method                                                 '
     '    G. Ysebaert, M. Moonen and T. Pollet, "Combined RLS-LMS           '
     '    initialization for per tone equalizers in DMT-receivers"          ' 
     '    Acoustics, Speech, and Signal Processing, 2002 IEEE International '
     '    Conference on , Volume: 3 , 2002                                  '
	 ];
   
   topic2 =  ['Design and Simulation Parameters'];
   helptop2 = [...
	 'On the top of he control window on the right is a pulldown menu       '
     'from which a design method can be chosen.                             '
	 'Below this pulldown menu are the following editable text windows      '
     'which are used to set the desired parameters,                         '
     '  Tones per group. Set the tones for each group.                      '
     '   Per tone equalizer length. Defines the number of taps of           ' 
	 '   the equalizer for each tone.                                       '
     '  Fast Fourier transform (FFT) size. Sets the FFT size used in DMT    '
     '   modulation. It is twice the number of subchannels.                 '
     '  Coding gain (dB). Defines a coding in dB used during capacity       '
     '   calculations.                                                      '
     '  Margin (dB). Sets the desired system margin in dB. This is also     '
     '   used in capacity calculations.                                     '
     '  Dmin and Dmax. The optimal delay is search in the interval between  '
     '   Dmin and Dmax.                                                     '
	 '  Input power (dBm). Defines the input signal power in dBm.           '
	 '  AWGN pow (dBm/Hz). Sets the amount of additive white Gaussian noise '
     '   in dBm/Hz. AWGN is added to the near-end crosstalk noise.          '
     '  CSA loop \# (1-8). Selects the desired channel to run the simulation'
     '   on. Currently 8 standard CSA loops are supported.                  '];
   
     topic3 =  ['Graphics'];
   helptop3 = [...
	 'Below the editable text windows is another pull-down menu which       '
     'is used to select the desired graph to be displayed.                  '
     'The following graphics can be selected:                               '
     '  SNR and MFB. The SNR and matched filter bound to the SNR is         '
     '   displayed as a function of frequency (subchannels).                '
     '  Noise Power Spectrum. Shows the power spectrum of the noise which   '
     '   consists of NEXT noise plus AWGN.                                  '
     ];
 
   topic4 =  ['Performance Measures'];
   helptop4 = [...
'The two remaining buttons in the control frame are                    '
'   Info. Displays this help.                                          '
'   Calculate. Starts the calculation and performance evaluation of the'
'    TEQ.                                                              '
'The following performance measures are calculated and listed in the   '
'table:                                                                '
'   Rate. Gives the achievable bit rate with the given channel and Per '
'    Tone Equalizers settings.                                         '
'   Max Rate. Shows the absolute maximum achievable bit rate given the '
'    channel and equalizer settings. It is basically the capacity      '
'   calculated from the MFB.                                           '];
		 
   str =  { topic1 helptop1; topic2 helptop2; topic3 helptop3; topic4 helptop4 };
   
   helpwin(str,'Topic 1','Per Tone design demo')                   
   return  
   
else
   disp(sprintf( 'Internal ERROR: ''%s'' not recognized',action))
end    






 
