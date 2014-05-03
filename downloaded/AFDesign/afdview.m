% afdview.m  AFD view specification (script)
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

delete(gca);
if moreaxis
 delete(gca);
end
axis off;

if     filnumb==1
 text(0,1.0, 'Current attenuation limits LOWPASS specification');
 text(0,0.8, ['Fpass = ', num2str(speca(1)), ' Hz']);
 text(0,0.7, ['Fstop = ', num2str(speca(2)), ' Hz']);
 text(0,0.6, ['Apass = ', num2str(speca(3)), ' dB']);
 text(0,0.5, ['Astop = ', num2str(speca(4)), ' dB']);
 text(0,0.4, 'Fpass = passband edge frequency in Hz');
 text(0,0.3, 'Fstop = stopband edge frequency in Hz')
 text(0,0.2, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
elseif filnumb==2
 text(0,1.0, 'Current attenuation limits HIGHPASS specification');
 text(0,0.8, ['Fstop = ', num2str(speca(1)), ' Hz']);
 text(0,0.7, ['Fpass = ', num2str(speca(2)), ' Hz']);
 text(0,0.6, ['Apass = ', num2str(speca(3)), ' dB']);
 text(0,0.5, ['Astop = ', num2str(speca(4)), ' dB']);
 text(0,0.4, 'Fpass = passband edge frequency in Hz');
 text(0,0.3, 'Fstop = stopband edge frequency in Hz')
 text(0,0.2, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
elseif filnumb==3
 text(0,1.0, 'Current attenuation limits BANDPASS specification');
 text(0,0.8,  ['Fstop1 = ', num2str(speca(1)), ' Hz']);
 text(0,0.74, ['Fpass1 = ', num2str(speca(2)), ' Hz']);
 text(0,0.68, ['Fpass2 = ', num2str(speca(3)), ' Hz']);
 text(0,0.62, ['Fstop2 = ', num2str(speca(4)), ' Hz']);
 text(0,0.56, ['Astop1 = ', num2str(speca(5)), ' dB']);
 text(0,0.50, ['Apass = ',  num2str(speca(6)), ' dB']);
 text(0,0.44, ['Astop2 = ', num2str(speca(7)), ' dB']);
 text(0,0.28, 'Fpass = passband edge frequency in Hz');
 text(0,0.22, 'Fstop = stopband edge frequency in Hz')
 text(0,0.16, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
elseif filnumb==4
 text(0,1.0, 'Current attenuation limits BANDREJECT specification');
 text(0,0.8,  ['Fpass1 = ', num2str(speca(1)), ' Hz']);
 text(0,0.74, ['Fstop1 = ', num2str(speca(2)), ' Hz']);
 text(0,0.68, ['Fstop2 = ', num2str(speca(3)), ' Hz']);
 text(0,0.62, ['Fpass2 = ', num2str(speca(4)), ' Hz']);
 text(0,0.56, ['Apass1 = ', num2str(speca(5)), ' dB']);
 text(0,0.50, ['Astop = ',  num2str(speca(6)), ' dB']);
 text(0,0.44, ['Apass2 = ', num2str(speca(7)), ' dB']);
 text(0,0.28, 'Fpass = passband edge frequency in Hz');
 text(0,0.22, 'Fstop = stopband edge frequency in Hz')
 text(0,0.16, 'Apass = maximum passband attenuation in dB')
 text(0,0.1, 'Astop = minimum stopband attenuation in dB')
end

 text(0,0, [num2str(nmin), ' <= n <= ', num2str(nmax), ...
               '  is range of filter order'])
