% afdesign.m    Advanced Digital and Analog Filter Design
%               AFDesign (main script)
%           
%   Authors: Dejan V. Tosic, Miroslav D. Lutovac, 1999/02/21
%   tosic@galeb.etf.bg.ac.yu   http://www.rcub.bg.ac.yu/~tosicde/
%   lutovac@iritel.bg.ac.yu    http://galeb.etf.bg.ac.yu/~lutovac/
%   Copyright (c) 1999-2000 by Tosic & Lutovac
%   $Revision: 1.21 $  $Date: 2000/10/03 13:45$
%       
%   References:
%   [1] Miroslav D. Lutovac, Dejan V. Tosic, Brian L. Evans
%       Filter Design for Signal Processing
%        Using MATLAB and Mathematica
%       Prentice Hall - ISBN 0-201-36130-2 
%        http://www.prenhall.com/lutovac
%       
                         
% This file is part of AFDesign toolbox for MATLAB.
% Refer to the file LICENSE.TXT for full details.
%                        
% AFDesign version 2.1, Copyright (C) 1999-2000 D. Tosic and M. Lutovac
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; see LICENSE.TXT for details.
%                       
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%                       
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc.,  59 Temple Place,  Suite 330,  Boston,
% MA  02111-1307  USA,  http://www.fsf.org/

clear all; close all

% ============  Default directory  ========================|
%                                                          |
NEWpathname = lower('c:\afd\AFDesign'); % Default directory|
%                                                          |
% =========================================================|

NEWpathnames = ['''' NEWpathname ''''];
cdNEWpathname = ['cd ' NEWpathname];

pathnamea = lower(pwd);
lpathnamea = length(pathnamea);

if lpathnamea > 7
  epathnamea = sum(abs(pathnamea(lpathnamea-7:lpathnamea)-lower('AFDesign')));
else
  epathnamea = 1;
end

fig1 = figure; axis off;
xx=get(fig1,'Position')-[100 50 -160 -100];

set(fig1, 'Name', 'Advanced Filter Design v2.1'...
       , 'Position', [50 20 650 500] ...
       , 'NumberTitle', 'off' ...
       , 'NextPlot', 'replace' )
whitebg(fig1,[1 1 0.9]);


text(0,1.05,'Advanced Filter Design'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 16)

text(0,0.99,'AFDesign version 2.1, Copyright (c) 1999-2000  D.Tosic and M.Lutovac'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 10)

text(0,0.94,'This is free software; see LICENSE.TXT for details'...
, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'FontSize', 9)

if epathnamea == 0

%aadesign;

set(gcf,'DefaultTextColor','b')

text(0.0,0.80,'CLICK a button to choose'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12)

text(0.0,0.75,'Digital or Analog Filter Design'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12)

uiclose = uicontrol('String', 'close', 'Units', 'normalized' ...
     , 'Position', [0.92 0.01 0.07 0.05] ...
     , 'CallBack', 'close all');

uiDAD = uicontrol('String', 'DIGITAL design' ...
     , 'Units', 'normalized' ...
     , 'Position', [0.1 0.5 0.3 0.1] ...
     , 'CallBack', 'dadesign');

uiAAD = uicontrol('String', 'ANALOG design' ...
     , 'Units', 'normalized' ...
     , 'Position', [0.6 0.5 0.3 0.1] ...
     , 'CallBack', 'aadesign');

text(0,0.35,'See advanced filter design details in the book'...
, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'FontSize', 10)

text(0,0.29,'Miroslav D. Lutovac, Dejan V. Tosic, Brian L. Evans'...
, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'FontSize', 12)

text(0,0.2,'Filter Design for Signal Processing'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12)

text(0,0.14,'Using MATLAB and Mathematica'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12)

text(0,0.05,'Prentice Hall - ISBN 0-201-36130-2'...
, 'FontName', 'Helvetica', 'FontWeight', 'normal', 'FontSize', 10)

text(0,0,'http://www.prenhall.com/lutovac'...
, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12)

set(gcf,'DefaultTextColor','k')

else
  set(gcf,'DefaultTextColor','m')
  text(0.0,0.85,'Your current working directory is')
  text(0.0,0.77,pathnamea)
  set(gcf,'DefaultTextColor','r')
  text(0.0,0.66,'Change your working directory', 'FontWeight', 'bold')
  text(0.0,0.56,'to the directory where AFDesign has been installed.')
  set(gcf,'DefaultTextColor','b')
  text(0.0,0.44,'For example, switch to the command window', 'FontWeight', 'bold')
  text(0.0,0.36,'and issue a command like this cd c:\afd\AFDesign')
  text(0.0,0.28,'or CLICK a button to change or')
  text(0.0,0.20,'browse to find directory AFDesign')
  set(gcf,'DefaultTextColor','k')

  uiCLOSE = uicontrol('String', 'CLOSE', 'Units', 'normalized' ...
     , 'Position', [0.88 0.7 0.1 0.1] ...
     , 'CallBack', 'close(gcf)');

 uitextCD = uicontrol('Style', 'text', 'Units', 'normalized' ...
    , 'HorizontalAlignment', 'center', 'BackgroundColor',[0.5 0.99 0.99] ...
    , 'Position', [0.59 0.005 0.41 0.22] ...
    , 'String',   'Change working directory to');

  % Change directory to AFDesign and select the file afdesign.m
  uiBROWSE = uicontrol('String', 'Browse to find directory AFDesign', 'Units', 'normalized' ...
     , 'Position', [0.6 0.025 0.39 0.07] ...
     , 'CallBack', ...
   ['[browsefile,browsepath] = uigetfile(''afdesign.m'',' ...
   ' ''Change directory to AFDesign and select the file afdesign.m'');' ...
   'if browsepath>0;browsepath1=browsepath(1:length(browsepath)-1);' ...
   'eval([''cd '',browsepath1]);afdesign;end']);

  testNEWpathname = [NEWpathname '\afdesign.m'];
  % test the existence of the NEWpathname and the file afdesign.m
  if exist(testNEWpathname) == 2
    % create the button if the file and directory exist
    uiCDNEW = uicontrol('String', NEWpathname, 'Units', 'normalized' ...
     , 'Position', [0.6 0.1 0.39 0.07] ...
     , 'CallBack', 'eval([cdNEWpathname ''; afdesign''])');
  end

end

%afdesign
