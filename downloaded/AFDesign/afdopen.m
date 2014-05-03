function [speck,speca,filnumb,filtype,nmin,nmax,nincmin,nincmax] = ...
         afdopen(moreaxis)

% afdopen.m  AFD open specification
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
%% afda2k.m, afdorder.m

[filename, pathname] = uigetfile('a*.dat', 'Open Specification File');
filespec = [pathname, filename];
if filename==0
 return
end
eval(['load ', filespec]);

dotposit = findstr(filename,'.');
eval(['speca =', filename(1:dotposit-1), ';']);
speclen = length(speca);

if speclen==4
 filnumb = 1;
elseif speclen>4
 filnumb = speca(1);
 speca = speca(2:speclen);
else
 error('AFD ERROR in filter specification: Insufficient data.')
end

if any(speca-abs(speca))
 error('AFD ERROR in filter specification: Negative data.')
end

speck = speca;

delete(gca);
if moreaxis
 delete(gca);
end
axis off;

if     filnumb==1
 filtype = 'l';
 set(gcf,'DefaultTextColor','r')
 text(0,0.94, 'CLICK a button D1, D2, D3a, D3b, D4a, D4b, D5, 2D5');
 set(gcf,'DefaultTextColor','b')
 text(0,0.84, 'Attenuation limits lowpass specification from');
 text(0,0.74, [lower(pathname),filename], 'FontWeight', 'bold');
 text(0,0.66, ['Fpass = ', num2str(speca(1)), ' Hz']);
 text(0,0.58, ['Fstop = ', num2str(speca(2)), ' Hz']);
 text(0,0.5, ['Apass = ', num2str(speca(3)), ' dB']);
 text(0,0.42, ['Astop = ', num2str(speca(4)), ' dB']);
 text(0,0.31, 'Fpass = passband edge frequency in Hz');
 text(0,0.24, 'Fstop = stopband edge frequency in Hz')
 text(0,0.17, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
 set(gcf,'DefaultTextColor','k')
 if speca(1)>=speca(2)
  error('AFD ERROR in lowpass spec: Fpass >= Fstop.')
 end
 if speca(3)>=speca(4)
  error('AFD ERROR in lowpass spec: Apass >= Astop.')
 end
 speck(3:4) = afda2k(speca(3:4));
 [nmin,nmax,nincmin,nincmax] = afdorder(speck,filnumb);

elseif filnumb==2
 filtype = 'h';
 set(gcf,'DefaultTextColor','r')
 text(0,0.94, 'CLICK a button D1, D2, D3a, D3b, D4a, D4b, D5 or 2D5');
 set(gcf,'DefaultTextColor','b')
 text(0,0.84, 'Attenuation limits highpass specification from');
 text(0,0.74, [lower(pathname),filename], 'FontWeight', 'bold');
 text(0,0.66, ['Fstop = ', num2str(speca(1)), ' Hz']);
 text(0,0.58, ['Fpass = ', num2str(speca(2)), ' Hz']);
 text(0,0.5, ['Apass = ', num2str(speca(3)), ' dB']);
 text(0,0.42, ['Astop = ', num2str(speca(4)), ' dB']);
 text(0,0.31, 'Fpass = passband edge frequency in Hz');
 text(0,0.24, 'Fstop = stopband edge frequency in Hz')
 text(0,0.17, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
 set(gcf,'DefaultTextColor','k')
 if speca(1)>=speca(2)
  error('AFD ERROR in highpass spec: Fstop >= Fpass.')
 end
 if speca(3)>=speca(4)
  error('AFD ERROR in highpass spec: Apass >= Astop.')
 end
 speck(3:4) = afda2k(speca(3:4));
 [nmin,nmax,nincmin,nincmax] = afdorder(speck,filnumb);

elseif filnumb==3
 filtype = 'b';
 set(gcf,'DefaultTextColor','r')
 text(0,0.94, 'CLICK a button D1, D2, D3a, D3b, D4a, D4b, D5 or 2D5');
 set(gcf,'DefaultTextColor','b')
 text(0,0.78, 'Attenuation limits bandpass specification from');
 text(0,0.7, [lower(pathname),filename], 'FontWeight', 'bold');
 text(0,0.6,  ['Fstop1 = ', num2str(speca(1)), ' Hz']);
 text(0,0.55, ['Fpass1 = ', num2str(speca(2)), ' Hz']);
 text(0,0.5, ['Fpass2 = ', num2str(speca(3)), ' Hz']);
 text(0,0.45, ['Fstop2 = ', num2str(speca(4)), ' Hz']);
 text(0,0.4, ['Astop1 = ', num2str(speca(5)), ' dB']);
 text(0,0.35, ['Apass = ',  num2str(speca(6)), ' dB']);
 text(0,0.3, ['Astop2 = ', num2str(speca(7)), ' dB']);
 text(0,0.2, 'Fpass = passband edge frequency in Hz');
 text(0,0.15, 'Fstop = stopband edge frequency in Hz')
 text(0,0.1, 'Apass = maximum passband attenuation in dB')
 text(0,0.05, 'Astop = minimum stopband attenuation in dB')
 set(gcf,'DefaultTextColor','k')
 if speca(1)>=speca(2)
  error('AFD ERROR in bandpass spec: Fstop1 >= Fpass1.')
 end
 if speca(2)>=speca(3)
  error('AFD ERROR in bandpass spec: Fpass1 >= Fpass2.')
 end
 if speca(3)>=speca(4)
  error('AFD ERROR in bandpass spec: Fpass2 >= Fstop2.')
 end
 if speca(6)>=speca(5)
  error('AFD ERROR in bandpass spec: Apass >= Astop1.')
 end
 if speca(6)>=speca(7)
  error('AFD ERROR in bandpass spec: Apass >= Astop2.')
 end
 speck(5:7) = afda2k(speca(5:7));
 [nmin,nmax,nincmin,nincmax] = afdorder(speck,filnumb);

elseif filnumb==4
 filtype = 'r';
 set(gcf,'DefaultTextColor','r')
 text(0,0.94, 'CLICK a button D1, D2, D3a, D3b, D4a, D4b, D5 or 2D5');
 set(gcf,'DefaultTextColor','b')
 text(0,0.78, 'Attenuation limits bandreject specification from');
 text(0,0.7, [lower(pathname),filename], 'FontWeight', 'bold');
 text(0,0.6,  ['Fpass1 = ', num2str(speca(1)), ' Hz']);
 text(0,0.55, ['Fstop1 = ', num2str(speca(2)), ' Hz']);
 text(0,0.5, ['Fstop2 = ', num2str(speca(3)), ' Hz']);
 text(0,0.45, ['Fpass2 = ', num2str(speca(4)), ' Hz']);
 text(0,0.4, ['Apass1 = ', num2str(speca(5)), ' dB']);
 text(0,0.35, ['Astop = ',  num2str(speca(6)), ' dB']);
 text(0,0.3, ['Apass2 = ', num2str(speca(7)), ' dB']);
 text(0,0.2, 'Fpass = passband edge frequency in Hz');
 text(0,0.15, 'Fstop = stopband edge frequency in Hz')
 text(0,0.1, 'Apass = maximum passband attenuation in dB')
 text(0,0.05, 'Astop = minimum stopband attenuation in dB')
 set(gcf,'DefaultTextColor','k')
 if speca(1)>=speca(2)
  error('AFD ERROR in bandreject spec: Fpass1 >= Fstop1.')
 end
 if speca(2)>=speca(3)
  error('AFD ERROR in bandreject spec: Fstop1 >= Fstop2.')
 end
 if speca(3)>=speca(4)
  error('AFD ERROR in bandreject spec: Fstop2 >= Fpass2.')
 end
 if speca(5)>=speca(6)
  error('AFD ERROR in bandreject spec: Apass1 >= Astop.')
 end
 if speca(7)>=speca(6)
  error('AFD ERROR in bandreject spec: Apass2 >= Astop.')
 end
 speck(5:7) = afda2k(speca(5:7));
 [nmin,nmax,nincmin,nincmax] = afdorder(speck,filnumb);

else
 error(['AFD ERROR: Unsupported filter type ', num2str(filnumb), '.'])

end
