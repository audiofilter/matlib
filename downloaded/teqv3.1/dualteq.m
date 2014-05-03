% dualteq Demonstrates dual-path time domain equalizers design functions
% in the DMTTEQ Toolbox.
%
% To start the demo type "dualteq".
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

function  dualteq(action);

if nargin < 1,
   action='init';
end;

if strcmp(action,'init'),
   %close all;
   shh = get(0,'showHiddenHandles');
   set(0,'showHiddenHandles','on')
   figNumber=figure( ...
      'Name','Dual-path TEQ Design Demo', ...
      'ToolBar','figure',...
      'handlevisibility','callback',...
      'IntegerHandle','off',...
      'NumberTitle','off',...
      'Position',[232 255 575 423]);
   
   set(gcf,'Pointer','watch');
   
   % figure parameters
   labelColor=[0.8 0.8 0.8];
   yInitPos=0.90;
   menutop=0.95;
   btnTop = 0.6;
   top=0.75;
   left=0.685;
   btnWid=0.290;
   btnHt=0.055;
   textHeight = 0.05;
   textWidth = 0.06;
   spacing=0.005;
   resWidth = 0.55;
   resHeight = 0.12;
   grpleft = 0.09;
   grpbuttom = 0.3;
   
   % graph axis setup
   axesposition = [grpleft grpbuttom+0.05 0.55 0.6];
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
   resyPos = yPos+tabHeight+border+0.1;
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
      'String','Rate1', ...
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
      'String','Rate2', ...
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
      'String','RateDual', ...
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
      'String','SSNR1', ...
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
      'String','SSNR2', ...
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
   labelStr='Minimum Intersymbol Interference|Maximum Bit Rate'; 
   callbackStr='dualteq(''changemethod'');';
   methodHndl=uicontrol( ...
      'Style','popupmenu', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Interruptible','on', ...
      'Callback',callbackStr);
   
   % Nb label
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
      'String','SIR length (Nb)', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Nb
   textPos = [labelLeft+labelWidth-.015 labelBottom textWidth+.025 textHeight];
   callbackStr = 'dualteq(''setNb'')';
   str = sprintf('32');
   mat = [32];
   NbHndl = uicontrol( ...
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
   callbackStr = 'dualteq(''setNw'')';
   str = sprintf('5');        
   mat = [5];
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
   callbackStr = 'dualteq(''setN'')';
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
   callbackStr = 'dualteq(''setCG'')';
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
   callbackStr = 'dualteq(''setMargin'')';
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
   callbackStr = 'dualteq(''setDmin'')';
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
   callbackStr = 'dualteq(''setDmax'')';
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
   callbackStr = 'dualteq(''setPwr'')';
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
   callbackStr = 'dualteq(''setAWGN'')';
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
   callbackStr = 'dualteq(''setCSA'')';
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
   
   
   % graphic selection menu
   labelStr=['SNR & Matched Filter Bound|Shortened channel|TEQ impulse response|'...
         'TEQ frequency response|Original & shortened channel'...
         '|Noise Power Spectrum|Delay Plot|Equalized channel freq resp|SNR & Matched Filter Bound 2'];
   callbackStr='dualteq(''plotGraph'');';
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
   callbackStr='dualteq(''design'')';
   closeHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom+2*(btnHt+spacing) btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
  
   % save teq button
   labelStr='Save Equalizer';
   callbackStr='dualteq(''savedualteq'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom+btnHt+spacing btnWid/2 btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
    % save all button
   labelStr='Save Parameters';
   callbackStr='dualteq(''saveall'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left+btnWid/2 frmBottom+btnHt+spacing btnWid/2 btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
  
   % help button
   labelStr='Information';
   callbackStr='dualteq(''info'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left frmBottom btnWid btnHt], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   

      % Umin label
   yPos=frmBottom-frmBorder+0.06;
   labelPos = [grpleft yPos labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Umin', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Umin
   yPos=frmBottom-frmBorder+0.06;
   textPos = [grpleft+labelWidth-.02  yPos textWidth textHeight];
   callbackStr = 'dualteq(''setUmin'')';
   str = sprintf('39');
   mat = [39];
   UminHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % Umax label
   yPos=frmBottom-frmBorder+0.06;
   labelPos = [grpleft+labelWidth+.1  yPos labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Umax', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Umax
   yPos=frmBottom-frmBorder+0.06;
   textPos = [grpleft+labelWidth+0.05+labelWidth  yPos textWidth textHeight];
   callbackStr = 'dualteq(''setUmax'')';
   str = sprintf('250');
   mat = [250];
   UmaxHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
      % Cmin label
   yPos=frmBottom-frmBorder;
   labelPos = [grpleft yPos labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Cmin', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Cmin
   textPos = [grpleft+labelWidth-.02  yPos textWidth textHeight];
   callbackStr = 'dualteq(''setCmin'')';
   str = sprintf('39');
   mat = [39];
   CminHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);
   
   % Cmax label
   yPos=frmBottom-frmBorder;
   labelPos = [grpleft+labelWidth+.1  yPos labelWidth textHeight];
   h = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'Horiz','left', ...
      'String','Cmax', ...
      'Interruptible','off', ...
      'BackgroundColor',[0.5 0.5 0.5], ...
      'ForegroundColor','white');
   
   % set Cmax
   yPos=frmBottom-frmBorder;
   textPos = [grpleft+labelWidth+0.05+labelWidth  yPos textWidth textHeight];
   callbackStr = 'dualteq(''setCmax'')';
   str = sprintf('59');
   mat = [59];
   CmaxHndl = uicontrol( ...
      'Style','edit', ...
      'Units','normalized', ...
      'Position',textPos, ...
      'Max',1, ... 
      'Horiz','right', ...
      'Background','white', ...
      'Foreground','black', ...
      'String',str,'Userdata',mat, ...
      'callback',callbackStr);

   
   % put all handles in userdata of the parent object
   fhndlList=[freqzHnd NbHndl NwHndl NHndl CGHndl MarginHndl ...
         DminHndl DmaxHndl PwrHndl AWGNHndl CSAHndl viewHndl ...
      helpHndl closeHndl methodHndl h11 h21 h31 h41 h51 h61 UminHndl ...
       UmaxHndl CminHndl CmaxHndl];
   set(figNumber, ...
      'Visible','on', ...
      'UserData',fhndlList);
   
   drawnow
   axes(freqzHnd)
   set(freqzHnd,'Userdata',[])
   dualteq('design')
   set(gcf,'Pointer','arrow','handlevisibility','callback');
   set(0,'showHiddenHandles',shh)
   return
   
   
   % change method 
elseif strcmp(action,'changemethod'),
   v = get(gco,'value');  
   % 1=min-ISI,2=MBR
   set(gco,'userdata',v);
   return
   
   % set Nb
elseif strcmp(action,'setNb'),
   hndlList=get(gcf,'Userdata');
   nw = get(hndlList(3),'userdata');
   meth = get(hndlList(15),'value');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow Nb<1 or if MSSNR is chosen Nb<=Nw
   if vv < 1 | (vv <= nw & meth == 3), 
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv));
   return
   
   % set Nw
elseif strcmp(action,'setNw'),
   hndlList=get(gcf,'Userdata');
   nb = get(hndlList(2),'userdata');
   meth = get(hndlList(15),'value');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % do not allow Nw<1 or if MSSNR is chosen Nw>=Nb
   if vv <= 1 | (vv >= nb & meth == 3),
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
   
      % set Umin   
elseif strcmp(action,'setUmin'),
   hndlList=get(gcf,'Userdata');
   Umax = get(hndlList(23),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmin cannot be smaller than 1 and larger than Dmax
   if vv<1 | vv > Umax, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set Umax   
elseif strcmp(action,'setUmax'),
   hndlList=get(gcf,'Userdata');
   Umin = get(hndlList(22),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmax cannot be smaller than 1 and Dmin
   if vv < 1 | vv < Umin, 
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set Cmin   
   elseif strcmp(action,'setCmin'),
   hndlList=get(gcf,'Userdata');
   Cmax = get(hndlList(25),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmin cannot be smaller than 1 and larger than Dmax
   if vv<1 | vv > Cmax, 
      vv = v; 
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return
   
   % set Cmax   
   elseif strcmp(action,'setCmax'),
   hndlList=get(gcf,'Userdata');
   Cmin = get(hndlList(24),'Userdata');
   v = get(gco,'Userdata');
   s = get(gco,'String');
   vv = eval(s,num2str(v(1)));
   % Dmax cannot be smaller than 1 and Dmin
   if vv < 1 | vv < Cmin, 
      vv = v;
   end
   set(gco,'Userdata',vv,'String',num2str(vv))
   return

   % design TEQ   
   elseif strcmp(action,'design'),
   set(gcf,'Pointer','watch');
   % get handles
   axHndl=gca;
   fhndlList=get(gcf,'Userdata');
   freqzHndl = fhndlList(1);
   NbHndl = fhndlList(2);
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
   UminHndl = fhndlList(22);
   UmaxHndl = fhndlList(23);
   CminHndl = fhndlList(24);
   CmaxHndl = fhndlList(25);
   
   colors = get(gca,'colororder'); 
  
   % init variables
   Nb = get(NbHndl,'userdata');
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
   UsedMin=get(UminHndl,'userdata');
   UsedMax=get(UmaxHndl,'userdata');
   CdualMin=get(CminHndl,'userdata');
   CdualMax=get(CmaxHndl,'userdata');
   barflag = 0;
   chflag = 0;
   %number of iteration per TEQ tap
   numIter = 1000;

   
   %generate signal,noise, and channel data
   [recNoisySig,receivedSignal,noise,channel,inputSignal,gamma,fs] = ...
      siggen(N,AWGNpower,loopNum,totalInputPower,codingGain,margin,barflag,chflag);
  
  %save tmp1.mat inputSignal, receivedSignal, noise;

   %estimate the power spectrums
   [inputSpecAll, noiseSpecAll, channelGainAll]=...
      specestim(inputSignal,noise,channel,N,barflag);
   
   %first pass for whole bandwidth teq design
   usedSubs = [UsedMin:UsedMax]';
   selectSubs = usedSubs;
   
   %calculate SNRs and usable channels
   [subMFBall,subMFB,noiseSpec,channelGain,inputSpec] = ...
   calcsnrs_dual(inputSpecAll,channelGainAll,noiseSpecAll,gamma,usedSubs);

   % chose method and design TEQ
   [B, W, D, MSE, Dv, I,title_str] = selmeth_dual(method,inputSignal,...
      receivedSignal,noise,channel(1:N),...
   Nb,Nw,Dmin,Dmax,barflag,N,numIter,inputSpec,noiseSpec,channelGain,...
   selectSubs,gamma);

   % get performance results
   [SSNR, SNR, subSNR,geoSNRfinal,geoSNRmfb,bDMTfinal,bDMTmfb,...
         RDMTfinal,RDMTmfb,hw,Fh,Fw,colorNoiseaft,Fhw] = ...
      perform(W,B,channel,D,Nb,N,inputSignal,noise,...
      channelGainAll,inputSpecAll,noiseSpecAll,margin,codingGain,fs,subMFBall,usedSubs);
   
  % save results to disk in order to use it in other functions 
   save path1tmpresults title_str N hw B D Nb W Nw subSNR subMFB channel Fh ...
	   noiseSpec colorNoiseaft Dv Dmin Dmax Fhw Fw usedSubs ... 
       inputSignal receivedSignal noise;
   
   %Second pass for sub-bandwidth teq design
   selectSubs = [CdualMin:CdualMax]';
   
   % chose method and design the second TEQ
   [B2, W2, D2, MSE2, Dv2, I2,title_str2] = selmeth_dual(method,inputSignal,...
      receivedSignal,noise,channel(1:N),...
   Nb,Nw,Dmin,Dmax,barflag,N,numIter,inputSpec,noiseSpec,channelGain,...
   selectSubs,gamma);

   % get performance results
   [SSNR2, SNR2, subSNR2,geoSNRfinal2,geoSNRmfb2,bDMTfinal2,bDMTmfb2,...
         RDMTfinal2,RDMTmfb2,hw2,Fh2,Fw2,colorNoiseaft2,Fhw2] = ...
      perform(W2,B2,channel,D2,Nb,N,inputSignal,noise,...
      channelGainAll,inputSpecAll,noiseSpecAll,margin,codingGain,fs,subMFBall,usedSubs);
  
    save path2tmpresults B2 W2 D2 MSE2 Dv2 I2 title_str2 SSNR2 SNR2 ...
    subSNR2 geoSNRfinal2 geoSNRmfb2 bDMTfinal2 bDMTmfb2 ...
    RDMTfinal2 RDMTmfb2 hw2 Fh2 Fw2 colorNoiseaft2 Fhw2;
    
   %get Dual-path TEQ design
   dualSNR=subSNR; 
   for i=1:length(subSNR)
       if subSNR(i)<subSNR2(i)
           dualSNR(i)=subSNR2(i);
       end
   end
   
   [geoSNRdual bDMTdual RDMTdual] = geosnr(dualSNR(usedSubs),margin,codingGain,N,Nb,fs);
   
     % put results into table
   str = sprintf('%1.3fe6',RDMTfinal/1e6);
   set(methRateHndl,'string',str);
   str = sprintf('%1.3fe6',RDMTfinal2/1e6);
   set(methSNRHndl,'string',str);
   str = sprintf('%1.3fe6',RDMTdual/1e6);
   set(methSSNRHndl,'string',str);
   str = sprintf('%3.1f',SSNR);
   set(methDelayHndl,'string',str);
   str = sprintf('%3.1f',SSNR2);
   set(methMSEHndl,'string',str);
   str = sprintf('%1.3fe6',RDMTmfb/1e6);
   set(methMaxHndl,'string',str);
   
   TEQequalizerTaps = W;
   TEQequalizerTaps2 = W2;
   TEQtargetImpulseResp = B;
   TEQoptimalDelay = D;
   TEQoptimalDelay2 =D2;
   TEQoriginalChannel = channel;
   TEQequalizedChannel = hw;
   TEQmatchedFilterBoundPerChannel = subMFB;
   TEQSNRperChannel = subSNR;
   TEQoriginalChannelFreqResp = Fh;
   TEQequalizerFreqResp = Fw;
   TEQequalizedChannelFreqResp = Fhw;
   TEQequalizedChannelFreqResp2 = Fhw2;
   TEQchanNoisePowSpecAfterEqual = colorNoiseaft;
   TEQchanNoisePowSpecBeforeEqual = noiseSpec;
   TEQperformanceVersusDelay = Dv;
   TEQDmin = Dmin;
   TEQDmax = Dmax;
   TEQNb = Nb;
   TEQNw = Nw;
   TEQN = N;
   TEQCodingGain=codingGain;
   TEQMargin=margin;
   TEQInputPower=totalInputPower;
   TEQAWGNPower=AWGNpower;
   TEQLoopnum=loopNum;
   TEQCdualMin=CdualMin;
   TEQCdualMax=CdualMax;
   TEQUsedMin=UsedMin;
   TEQUsedMax=UsedMax;
   
   save dualteqresults TEQequalizerTaps TEQequalizerTaps2 TEQtargetImpulseResp  ...
	   TEQoptimalDelay TEQoptimalDelay2 TEQoriginalChannel TEQequalizedChannel ...
	   TEQmatchedFilterBoundPerChannel TEQSNRperChannel ...
	   TEQoriginalChannelFreqResp TEQequalizerFreqResp TEQequalizedChannelFreqResp2 ...
	   TEQequalizedChannelFreqResp TEQchanNoisePowSpecAfterEqual...
	   TEQchanNoisePowSpecBeforeEqual TEQDmin TEQDmax TEQNb TEQNw TEQN TEQCodingGain ...
       TEQMargin TEQInputPower TEQAWGNPower TEQLoopnum TEQCdualMin TEQCdualMax TEQUsedMin ...
       TEQUsedMax;
	   
   % plot result
   dualteq('plotGraph');
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
   load path1tmpresults;
   load path2tmpresults;
   freqAxis = 1:N/2+1;
   
   % plot chosen graph
   if graphNum == 1
      legend off
      plot(freqAxis(usedSubs),10*log10(subSNR(usedSubs)+eps))
      hold on;
      plot(freqAxis(usedSubs),10*log10(subSNR2(usedSubs)+eps),'g')
      plot(freqAxis(usedSubs),10*log10(subMFB(usedSubs)+eps),'r')
      hold off
      grid on
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency')
      ylabel('magnitude (dB)')
      title([title_str,' achieved and upper-bound SNR'])
      legend('SNR1','SNR2','MFB',0);
      
   elseif graphNum == 2      
 	  legend off
      hw100 = hw(1:100)/norm(hw);
      axhndlList = get(freqzHndl,'UserData');
      hndl = plot(hw100); 
      set(gcf,'handlevisibility','callback')
      grid on
      xlabel('tap number')
      ylabel('amplitude')
      title([title_str,' SIR'])
      legend('SIR');          

  
   elseif graphNum == 3
      legend off
      hndl = stem(W); 
      if Nw > 3
         hold on;
         plot(W,':');
         hold off
      end
      axis([0 Nw+1 1.1*min(W)*(min(W)<=0) 1.1*max(W)*(max(W)>0)])
      xlabel('tap number')
      ylabel('amplitude')
      title([title_str,' TEQ impulse response'])
      
   elseif graphNum == 4
      legend off
      plot(freqAxis(usedSubs),20*log10(abs(Fw(usedSubs))+eps));
      grid on
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency bin number')
      ylabel('magnitude (dB)')
      title([title_str,' TEQ frequency response'])
      
   elseif graphNum == 5
      legend off
      maxAmp = max(abs(hw));
      plot(channel(1:500)/max(abs(channel))*maxAmp);
      hold on
      plot(hw(1:500),'r');
      hold off
      grid on	
      xlabel('discrete time (n)')
      ylabel('amplitude')
      title([title_str,' Original & Shortened Channel'])
      legend('original','shortened',0);         
      
   elseif graphNum == 6
      legend off
      plot(freqAxis(usedSubs),20*log10(noiseSpec(usedSubs)+eps),'r')
      hold on
      plot(freqAxis(usedSubs),20*log10(colorNoiseaft(usedSubs)+eps))
      hold off
      grid on	
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency')
      ylabel('magnitude (dB)')
      title([title_str,' Noise Power Spectrum'])
      legend('before TEQ','after TEQ',0);         
      
   elseif graphNum == 7
      legend off
      plot(Dmin:Dmax,10*log10(real(Dv(Dmin:Dmax))+eps))
      grid on	
      ylabel('objective function (e.g. MSE for MMSE method)')
      xlabel('delay')
      title([title_str,' Cost vs delay plot'])
      
   elseif graphNum == 8
      legend off
      plot(freqAxis(usedSubs),10*log10(abs(Fhw(usedSubs)).^2+eps));
      grid on
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      ylabel('magnitude (dB)')
      xlabel('frequency')
      title([title_str,' Equalized Channel Frequency Response'])
 
  elseif graphNum == 9
      legend off
      plot(freqAxis(usedSubs),10*log10(subSNR2(usedSubs)+eps))
      hold on;
      plot(freqAxis(usedSubs),10*log10(subMFB(usedSubs)+eps),'r')
      hold off
      grid on
      axisSet = axis;
      axisSet(1) = min(freqAxis(usedSubs))-2;
      axisSet(2) = max(freqAxis(usedSubs))+2;
      axis(axisSet);
      xlabel('frequency')
      ylabel('magnitude (dB)')
      title([title_str,' achieved and upper-bound SNR for second TEQ'])
      legend('SNR','MFB',0);
  end
  
   set(gcf,'Pointer','arrow');
   return
   
   % save teq and feq
    elseif strcmp (action ,'savedualteq')
       
    [filename,path]=uiputfile('*');
    if filename==0
        return;    
    end
    
    load dualteqresults;
    output=fopen([path,filename],'w');
    fprintf(output,'%s','path 1: optimal delay =');
    fprintf(output,' %d ;\n',TEQoptimalDelay);
    fprintf(output,'\n');
    fprintf(output,'%s\n','path 1: teq=[');
    for i=1:length(TEQequalizerTaps)
        fprintf(output,'%f \n',TEQequalizerTaps(i));
    end
    fprintf(output,'%s\n','];');
    fprintf(output,'\n');
    fprintf(output,'%s\n','path 1: feq=[');
    for i=1:length(TEQequalizedChannelFreqResp)
        fprintf(output,'%f \n',1/TEQequalizedChannelFreqResp(i));
    end
    fprintf(output,'%s\n','];');
    
    fprintf(output,'%s','path 2: optimal delay =');
    fprintf(output,' %d ;\n',TEQoptimalDelay);
    fprintf(output,'\n');
    fprintf(output,'%s\n','path 2: teq=[');
    for i=1:length(TEQequalizerTaps)
        fprintf(output,'%f \n',TEQequalizerTaps(i));
    end
    fprintf(output,'%s\n','];');
    fprintf(output,'\n');
    fprintf(output,'%s\n','path 2: feq=[');
    for i=1:length(TEQequalizedChannelFreqResp)
        fprintf(output,'%f \n',1/TEQequalizedChannelFreqResp2(i));
    end
    fprintf(output,'%s\n','];');
    
    fclose(output);    
    
    %save all parameters
    elseif strcmp(action,'saveall')
    [filename,path]=uiputfile('*');
    if filename==0;
        return;
    end
    
    load dualteqresults;
    output=fopen([path,filename],'w');
    fprintf(output,'all the parameters are also saved into %s.mat\n',filename);
    fprintf(output,'%s','SIR length =');
    fprintf(output,' %d\n',TEQNb);
    fprintf(output,'%s','TEQ length =');
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
    fprintf(output,'%s','Umin =');
    fprintf(output,' %d;\n',TEQUsedMin);
    fprintf(output,'%s','Umax =');
    fprintf(output,' %d;\n',TEQUsedMax);
    fprintf(output,'%s','Cmin =');
    fprintf(output,' %d;\n',TEQCdualMin);
    fprintf(output,'%s','Dmax =');
    fprintf(output,' %d;\n',TEQCdualMax);
    fclose(output);
    str=sprintf(['save ', filename,' TEQNb TEQNw TEQN TEQCodingGain TEQMargin TEQDmin',...
            ' TEQDmax TEQInputPower TEQAWGNPower TEQLoopnum;']);
    eval(str);
    
   % get help
   elseif strcmp(action,'info'),
   ttlStr = get(gcf,'name');
   myFig = gcf;
   
   topic1 =  ['Dual-path TEQ design demo'];
   helptop1 = [...
     'This demonstration enables the design of a dual-path discrete         ' 
     'multitone equalizer.  The upper path consists of a time domain        '
     'equalizer (TEQ) and an FFT.  The lower path consists of a separate    '
     'TEQ and FFT.  The two paths feed into a path selector that selects    '
     'either the upper or lower path for each subchannel.  The path         '
     'selector output is fed into a frequency domain equalizer (FEQ).       '
     'The basic idea is to design the two TEQs to perform well over         '
     'different groups of subchannels.  It allows reuse of conventional     '
     '(single path) equalizer designs.  The dual-path TEQ structure is      '
     'explained in more detail in the following paper:                      '
     '                                                                      '
     'M. Ding, A. J. Redfern, and B. L. Evans, "A Dual-path TEQ Structure   '
     'For DMT-ADSL Systems", Proc. IEEE Int. Conf. on Acoustics, Speech, and'
     ' Signal Proc., May 13-17, 2002, vol. III, pp. 2573-2576, Orlando, FL. '
     '                                                                      '
     'Usage: Set parameters to desired values and hit the Calculate button. '
     '                                                                      '
     'The following design methods are supported:                           '
     '  Minimum intersymbol interference method,                            '
     '      G. Arslan, B. L. Evans, and S. Kiaei, "Equalization for         '
     '      Discrete Multitone Transceivers to Maximize Channel Capacity",  '
     '      IEEE Trans. on Signal Proc., submitted.                         '
     '  Maximum channel capacity method,                                    '
     '      G. Arslan, B. L. Evans, and S. Kiaei, "Equalization for         '
     '      Discrete Multitone Transceivers to Maximize Channel Capacity",  '
     '      IEEE Trans. on Signal Proc., submitted.                         '
     ];
   
   topic2 =  ['Design and Simulation Parameters'];
   helptop2 = [...
	 'On the top of the control window on the right is a pulldown menu      '
     'from which a design method can be chosen.                             '
	 'Below this pulldown menu are the following editable text windows      '
     'which are used to set the desired parameters,                         '
     '  Shortened impulse response (SIR) length. This is the desired length '
     '   of the channel after equalization. For example, it should be set   '
     '   to 33 (one plus the cyclic prefix length) for the ADSL standard.   '
     '  Time domain equalizer (TEQ) length. Defines the number of taps of   ' 
	 '   the TEQ.                                                           '
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
     '   on. Currently 8 standard CSA loops are supported.                  '
     '                                                                      '
     '  On the bottom of the control window on the left there are other     '
     '  editable text windows which can be used to set the desired          '
     '  parameters:                                                         '
     '  Umin and Umax: Sets the used subcarriers for the first TEQ with the '
     '                 index started from Umin to Umax.                     '
     '  Cmin and Cmax: Sets the selected subcarriers for the second TEQ with'
     '                 index started from Cmin to Cmax.                     '];
   
     topic3 =  ['Graphics'];
   helptop3 = [...
	 'Below the editable text windows is another pull-down menu which       '
     'is used to select the desired graph to be displayed.                  '
     'The following graphics can be selected:                               '
     '  SNR and MFB. The SNR for first and second TEQ and matched filter    '
     '   bound to the SNR is displayed as a function of frequency           '
     '   (subchannels).                                                     '
     '  Noise Power Spectrum. Shows the power spectrum of the noise which   '
     '   consists of NEXT noise plus AWGN.                                  '
     '  The rest plots display the result from the first TEQ.               '
     '  Target and shortened channel. Displays the shortened channel impulse'	 
	 '   response and the target channel impulse response for the MMSE and  ' 
	 '   geometric SNR methods. For all other methods the location of the   ' 
     '   target window is displayed instead of a target impulse response.   '
     '  TEQ impulse response. Shows the impulse response of the TEQ.        '
     '  TEQ frequency response. Shows the TEQ in frequency domain.          '
     '  Original and shortened channel. Displays the channel impulse        '
     '   responsebefore and after equalization.                             '
     '  Delay Plot. Displays the performance measure of the method with     '
     '   respect to the delay.                                              '
     '  Equalized channel freq resp. Displays the frequency response of the '
     '   channel after equalization.                                        '];
 
   topic4 =  ['Performance Measures'];
   helptop4 = [...
'The two remaining buttons in the control frame are                    '
'   Info. Displays this help.                                          '
'   Calculate. Starts the calculation and performance evaluation of the'
'    TEQ.                                                              '
'The following performance measures are calculated and listed in the   '
'table:                                                                '
'   Rate1. Gives the achievable bit rate with the given channel and the' 
'          first TEQ settings.                                         '
'   Rate2. Gives the achievable bit rate with the given channel and the' 
'          second TEQ settings.                                        '
'   Ratedual. Gives the achievable bit rate with the given channel and ' 
'          the dual-path TEQ settings.                                 '
'   SSNR1. Shows the shortening SNR in dB for the first TEQ. This is   '
'   defined as the ratio of the energy of the shortened channel impulse'
'   response in the target window the the energy outside the target    '
'   window.                                                            '
'   SSNR2. Shows the shortening SNR in dB for the second TEQ.          '
'   Max Rate. Shows the absolute maximum achievable bit rate given the '
'    channel and equalizer settings. It is basically the capacity      '
'   calculated from the MFB.                                           '];
		 
   str =  { topic1 helptop1; topic2 helptop2; topic3 helptop3; topic4 helptop4 };
   
   helpwin(str,'Topic 1','Dual-path TEQ design demo')                   
   return  
   
else
   disp(sprintf( 'Internal ERROR: ''%s'' not recognized',action))
end    






 
