% afdzoomd.m  AFD Zoom attenuation
%   
%          Advanced Analog Filter Design - AFDesign
%   
%   Authors: Dejan V. Tosic, Miroslav D. Lutovac, 1999/02/21
%   tosic@galeb.etf.bg.ac.yu   http://www.rcub.bg.ac.yu/~tosicde/
%   lutovac@iritel.bg.ac.yu    http://galeb.etf.bg.ac.yu/~lutovac/
%   Copyright (c) 1999-2000 by Tosic & Lutovac
%   $Revision: 1.21 $  $Date: 2000/10/03 13:45$
%   
%   References:
%   Miroslav D. Lutovac, Dejan V. Tosic, Brian L. Evans
%        Filter Design for Signal Processing
%           Using MATLAB and Mathematica
%        Prentice Hall - ISBN 0-201-36130-2 
%         http://www.prenhall.com/lutovac
%
                         
% This file is part of AFDesign toolbox for MATLAB.
% Refer to the file LICENSE.TXT for full details.
%                        
% AFDesign version 2.1, Copyright (c) 1999-2000 D. Tosic and M. Lutovac
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

if fig3 & find(get(0,'Children')==fig3)
 figure(fig3)
else
 fig3 = figure;
 set(fig3, 'Name', 'Zoom Attenuation Characteristic' ...
         , 'NumberTitle', 'off', 'Position', initsize ...
         , 'Color',[0.35 0.45 0.35])
end

zoomfmin = 0;
if filnumb==1 | filnumb==2
 zoomfmax = 2*speca(2);
elseif filnumb==3 | filnumb==4
 zoomfmax = 2*speca(4);
else
 error(['AFD ERROR: Unsupported filter type ', num2str(filnumb)]);
end

afdzoomp(numD,denD,zoomfmin,zoomfmax,zoomn,nD);

%-----------------------------------------------------------------%

zbb0close = uicontrol('String', 'close', 'Units', 'normalized' ...
     , 'Position', [0.93 0.9 0.07 0.05] ...
     , 'CallBack', ' ');

zbb1grid = uicontrol('String', 'grid', 'Units', 'normalized' ...
     , 'Position', [0.93 0.84 0.07 0.05] ...
     , 'CallBack', ' ');

zbb2log = uicontrol('String', 'log', 'Units', 'normalized' ...
     , 'Position', [0.93 0.78 0.07 0.05] ...
     , 'CallBack', ' ');

zbb3lin = uicontrol('String', 'lin', 'Units', 'normalized' ...
     , 'Position', [0.93 0.72 0.07 0.05] ...
     , 'CallBack', ' ');

zbb3zoom = uicontrol('String', 'zoom', 'Units', 'normalized' ...
     , 'Position', [0.93 0.66 0.07 0.05] ...
     , 'CallBack', ' ');

%-----------------------------------------------------------------%

zt1fmin = uicontrol('Style', 'text' ...
     , 'Units',    'normalized', 'BackgroundColor',[0.8 0.8 0.8] ...
     , 'Position', [0 0 0.08 0.04] ...
     , 'String',   'fmin');

zb1fmin = uicontrol('Style', 'edit' ...
     , 'String', num2str(zoomfmin) ...
     , 'Units',    'normalized', 'BackgroundColor',[1 1 1] ...
     , 'Position', [0.09 0 0.10 0.04] ...
     , 'CallBack', ' ');

zt2fmax = uicontrol('Style', 'text' ...
     , 'Units',    'normalized', 'BackgroundColor',[0.8 0.8 0.8] ...
     , 'Position', [0.21 0 0.08 0.04] ...
     , 'String',   'fmax');

zb2fmax = uicontrol('Style', 'edit' ...
     , 'String', num2str(zoomfmax) ...
     , 'Units',    'normalized', 'BackgroundColor',[1 1 1] ...
     , 'Position', [0.30 0 0.12 0.04] ...
     , 'CallBack', ' ');

zt3n = uicontrol('Style', 'text' ...
     , 'Units',    'normalized', 'BackgroundColor',[0.8 0.8 0.8] ...
     , 'Position', [0.93 0.05 0.07 0.04] ...
     , 'String',   'points');

zb3n = uicontrol('Style', 'edit' ...
     , 'String', num2str(zoomn) ...
     , 'Units',    'normalized', 'BackgroundColor',[1 1 1] ...
     , 'Position', [0.93 0 0.07 0.04] ...
     , 'CallBack', ' ');
