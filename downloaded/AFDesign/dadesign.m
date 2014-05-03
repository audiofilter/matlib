% dadesign.m  Digital Advanced Filter Design (main script)
%   
%          Advanced Digital Filter Design - AFDesign
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

%  calls:
%% dfda2k.m, dfdesbut.m

% spec format (spec is attenuation-limits spec)
% 4-number spec defaults to lowpass digital
% spec is a set of positive numbers, the first number is filter type specifier
%  1 -- lowpass 'l'
%  2 -- highpass 'h'
%  3 -- bandpass 'b'
%  4 -- band reject 'r'
% lowpass spec:  1, Fpass, Fstop, Apass, Astop
% highpass spec: 2, Fstop, Fpass, Apass, Astop
% bandpass spec: 3, Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2
% bandstop spec: 4, Fpass1, Fstop1, Fstop2, Fpass2, Apass1, Astop, Apass2
% (band reject)

clear all; close all; clc; disp('Advanced Digital Filter Design');
clf
Nydx = 1;
matlabversion = version;
screensizedraw = get(0,'ScreenSize');
pdraw = get(gca,'Position');
if matlabversion(1)-'4' ==0 
  if screensizedraw(3) == 800
    FontInfo = 10;
  else
    FontInfo = 8;
  end
else
  FontInfo = 8;
end

% mainfig, editfig, zoomfig
fig1 = 0;
fig2 = 0;
fig3 = 0;

% demo init spec
speca = [0.2 0.212 0.2 40];
filnumb = 1;
filtype = 'l';

speck = speca;
speck(3:4) = dfda2k(speca(3:4));

% demo design D1 parameters
desnumb = 1;
destype = 'D1';

nD = 8;
aD = 1.08155069576185;
eD =  0.217091;
fpD= 0.2;

numD = [0.02486430630874 0.02187331664743 0.07633088394268 ...
        0.06729427078353 0.10381314278932 0.06729427078353 ...
        0.07633088394268 0.02187331664743 0.02486430630874];

denD = [1 -2.98219203035993 6.06974818317651 ...
       -7.95485544794521  7.83507110290910 -5.53041664554408 ...
        2.83474731743684 -0.94319508831423 0.16691765211468];
nmin = 8;
nmax = 16;

nincmin = 0;
nincmax = 8;
ninc = 0;

zoomfmin = 0;
zoomfmax = 2*speca(2);
zoomn = 100;

filname = ['lowpass   '; 'highpass  '; 'bandpass  '; 'bandreject'];

eseconds = 2;
dfddinfo

%-----------------------------------------------------------------%
fig1 = 1;
initaxis = get(gca,'Position');
moreaxis = 0;
axis off;
initsize = [20 120 680 520];
set(fig1, 'Name', 'Advanced Digital Filter Design' ...
        , 'NumberTitle', 'off' ...
        , 'Position', initsize);
whitebg(fig1,[1 1 1]);

svgasize = [0 0 800 562];

clf
bdfdinfo;
dfdesbut;
