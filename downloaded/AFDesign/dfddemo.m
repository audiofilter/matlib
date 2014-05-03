% dfddemo.m  DFD demo specification and design D1 (script)
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
%% dfda2k.m

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
zoomfmax = 0.5;
zoomn = 100;

delete(gca);
if moreaxis
 delete(gca);
end
axis off;

text(0,0.9, 'DEMO (built-in) attenuation limits specification')
text(0,0.8, ['Fpass = ', num2str(speca(1))]);
text(0,0.7, ['Fstop = ', num2str(speca(2))]);
text(0,0.6, ['Apass = ', num2str(speca(3)), ' dB']);
text(0,0.5, ['Astop = ', num2str(speca(4)), ' dB']);
text(0,0.4, 'Fpass = passband edge frequency');
text(0,0.3, 'Fstop = stopband edge frequency')
text(0,0.2, 'Apass = maximum passband attenuation in dB')
text(0,0.1, 'Astop = minimum stopband attenuation in dB')
text(0,0, [num2str(nmin), ' <= n <= ', num2str(nmax), ...
                          '  is range of filter order'])
b16n = uicontrol('Style', 'text' ...
     , 'String', ['n=',num2str(nmin+ninc)] ...
     , 'Units', 'normalized', 'BackgroundColor',[0.9 0.9 0.9] ...
     , 'Position', [0.0 0.95 0.05 0.04]);

if fig2
set(eb8,'String',num2str(ninc));
set(et9,'String',[num2str(nincmin),'<=ninc<=',num2str(nincmax)]);
end
