
% TEQDEMOV3 Demonstrates channel equalizer design functions
% in the DMTTEQ Toolbox.
%
% To start the demo type "teqdemov3".
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
% Programmers: Dr. Guner Arslan, Mr. Ming Ding, Dr. Biao Lu,
% Dr. Milos Milosevic, and Mr. Zukang Shen
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% They are also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function  teqdemov3(action);

if nargin < 1,
   action='init';
end;

if strcmp(action,'init'),
h0 = figure('Position',[232 255 575 423], ...
   'ToolBar','none',...
   'name','DMTTEQ ToolBox 3.1',...
   'NumberTitle','off',...
   'Menubar','figure');

figureColor = get(h0, 'Color');    

%Welcome textbox
h1 = uicontrol('Units','normalized', ...
   'Style', 'text', ...
   'HorizontalAlignment','center', ...
   'Units','normalized', ...
   'BackgroundColor', [1 1 1], ...
   'Min', 0, ...
   'Max', 2, ...
   'Value', [], ...
   'Enable', 'inactive', ...
   'Position',[0.05 0.76 0.36 0.17], ...
   'Callback', '', ...
   'String', {'Thank you for using version 3.1'...
              'of the Discrete Multitone Modulation'...
              'Equalizer Design Toolbox by UT Austin.'...
              'Please choose one of the following'...
              'equalizer structures to design:'});

%Design Demo with the Single-path Structure
SPHdl = uicontrol( ...
    'Units','normalized',...
   'Style', 'pushbutton', ...
   'Position', [0.05 0.65 0.36 0.06], ...
   'String', 'Single-Path TEQ', ...
   'Callback', 'teqdemo'); 

%Design Demo with the Dual-path Structure
DPHdl = uicontrol( ...
    'Units','normalized',...
   'Style', 'pushbutton', ...
   'Position', [0.05 0.57 0.36 0.06], ...
   'String', 'Dual-Path TEQ', ...
   'Callback', 'dualteq'); 

%Design Demo with the Per Tone Structure
PETHdl = uicontrol( ...
    'Units','normalized',...
   'Style', 'pushbutton', ...
   'Position', [0.05 0.49 0.36 0.06], ...
   'String', 'Per Tone', ...
   'Callback', 'pertone'); 

PETHdl = uicontrol( ...
    'Units','normalized',...
   'Style', 'pushbutton', ...
   'Position', [0.05 0.41 0.36 0.06], ...
   'String', 'TEQ Filter Bank', ...
   'Callback', 'tfb'); 

%Display the ESPL Logo
ax2=axes( 'Position', [0.05 0.13 0.36 0.25],'visible', 'off');
LogoHdl=imread('ESPLogo','gif');
imshow(LogoHdl);

% create a listbox for displaying the 'about' information
aboutListPos=[0.45,0.25,0.5,0.69];
aboutinfo = {...
'This Matlab toolbox implements design algorithms'
'for the four multicarrier equalizer structures'
'on the left.  Default parameters correspond to'
'downstream transmission in the G.DMT ADSL standard.'
'The Information button for each equalizer structure'
'demonstration lists references for each design'
'algorithm.  Equalizer designs can be saved.'
'                                           '
'This toolbox was developed by Prof. Brian L. Evans'''
'research group at The University of Texas at Austin.'
'Source of information on ADSL, including papers,'
'theses and presentations by his group, are available at'
' '
'http://www.ece.utexas.edu/~bevans/projects/adsl'
' '
'The initial design algorithms for conventional ADSL'
'equalizers, i.e. based on a single-path time domain'
'equalizer (TEQ), were by Prof. John M. Cioffi''s group'
'at Stanford University.  Per tone equalizer structure'
'was proposed by Prof. Marc Moonen''s group at the'
'Catholic University in Leuven, Belgium.  The dual-path'
'TEQ and TEQ filter bank structure were proposed by'
'Prof. Brian L. Evans'' group at UT Austin.'
' '
'TEQDEMOV3 Demonstrates channel equalizer design functions'
'in the Discrete Multitone (Multicarrier) Equalizer Design Toolbox.'
' '
'Copyright (c) 1999-2002 The University of Texas'
'All Rights Reserved.'
' '  
'This program is free software; you can redistribute it and/or modify'
'it under the terms of the GNU General Public License as published by'
'the Free Software Foundation; either version 2 of the License, or'
'(at your option) any later version.'
' '  
'This program is distributed in the hope that it will be useful,'
'but WITHOUT ANY WARRANTY; without even the implied warranty of'
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the'
'GNU General Public License for more details.'
' '  
' Director:    Prof. Brian L. Evans'
' Programmers: Dr. Guner Arslan, Mr. Ming Ding, Dr. Biao Lu, Dr. Milos Milosevic, and Mr. Zukang Shen'
' Version:     3.1 (May 8, 2003)'
' '
' The authors are with the Department of Electrical and Computer'
' Engineering, The University of Texas at Austin, Austin, TX.'};

aboutListH = uicontrol( ...
   'Style', 'list', ...
   'HorizontalAlignment','left', ...
   'Units','normalized', ...
   'BackgroundColor', figureColor, ...
   'Min', 0, ...
   'Max', 2, ...
   'Value', [], ...
   'Enable', 'inactive', ...
   'Position', aboutListPos, ...
   'Callback', '', ...
   'String', aboutinfo, ...
   'Tag', 'AboutListbox');

   % help button
   labelStr='Info';
   callbackStr='teqdemov3(''info'')';
   helpHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[0.45 0.13 0.22 0.07], ...
      'String',labelStr, ...
      'Callback',callbackStr);
  
  %close button
  backH = uicontrol( ...
   'Style', 'pushbutton', ...
   'Units', 'normalized', ...
   'Position', [0.73 0.13 0.22 0.07], ...
   'String', 'Close', ...
   'Tag', 'return', ...
   'Callback', 'close(gcbf)'); 

elseif strcmp(action,'info'),
   ttlStr = get(gcf,'name');
   myFig = gcf;
   
   topic1 =  ['DMT channel equalizer design demo'];
   helptop1 = [...
     'This demo lets you design channel equalizers for DMT systems and      '
     'analyze its performance.                                              '
     '                                                                      '
     'Usage: choose the different receiver structure to begin the design.   '
     '                                                                      '
     'The following receiver structure are supported:                       '
	 '  Signal path TEQ,                                                    '		  
	 '  Dual path TEQ,                                                      ' 
     '  Per Tone Equalizer bank,                                            '
     '  TEQ filter bank.                                                    '
     ];
   
   
   str =  { topic1 helptop1};
   
   helpwin(str,'Topic 1','Discrete Multitone (Multicarrier) Equalizer Design Toolbox');                   
   return  

end;


