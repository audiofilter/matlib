% afddemo.m  AFD demo specification and design D1 (script)
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

%% calls:
%% afda2k.m

% demo init spec
speca = [3000 3225 0.2 40];
filnumb = 1;
filtype = 'l';

speck = speca;
speck(3:4) = afda2k(speca(3:4));

% demo design D1 parameters
desnumb = 1;
destype = 'D1';

nD = 8.0000000000000000e+000;
aD = 1.0750000000000000e+000;
eD = 2.1709110541636540e-001;
fpD= 3.0000000000000000e+003;

numD = [2.6295534298184940e-037, 0.0000000000000000e+000, ...
        1.6645621891963680e-027, 0.0000000000000000e+000, ...
        2.2655508867109020e-018, 0.0000000000000000e+000, ...
        1.1193712576867830e-009, 0.0000000000000000e+000, ...
        1.8554842946007200e-001];
denD = [6.2746718091214740e-035, 1.6905678026768590e-030, ...
        7.8004444384509330e-026, 1.4895419716948210e-021, ...
        3.2284901038606240e-017, 4.1800996648557700e-013, ...
        4.9705515033058140e-009, 3.6487254752300700e-005, ...
        1.8987040759519150e-001];
nmin = 8;
nmax = 16;

nincmin = 0;
nincmax = 8;
ninc = 0;

zoomfmin = 0;
zoomfmax = 2*speca(2);
zoomn = 100;

delete(gca);
if moreaxis
 delete(gca);
end
axis off;

text(0,0.9, 'DEMO (built-in) attenuation limits specification')
text(0,0.8, ['Fpass = ', num2str(speca(1)), ' Hz']);
text(0,0.7, ['Fstop = ', num2str(speca(2)), ' Hz']);
text(0,0.6, ['Apass = ', num2str(speca(3)), ' dB']);
text(0,0.5, ['Astop = ', num2str(speca(4)), ' dB']);
text(0,0.4, 'Fpass = passband edge frequency in Hz');
text(0,0.3, 'Fstop = stopband edge frequency in Hz')
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
