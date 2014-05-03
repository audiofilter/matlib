function twoaxis=dfdplot(num,den,speca,filnumb,moreaxis,Dtype)

% dfdplot.m  AFD Plot attenuation
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

twoaxis = 0;
initaxis = [0.13 0.11 0.775 0.815];
if moreaxis ~= 0
 delete(gca);
 set(gca, 'Position', initaxis);
end

if filnumb == 1

f1 = 0; f2 = 0.5;
f = f1:(f2-f1)/100:f2;
p = 2*pi*f;
A0 = 1/10^40*ones(size(p));
A = -20*log10(abs(freqz(num,den,p))+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(3) speca(3) 2*speca(4)],'r:', ...
 [speca(2) speca(2) 0.5],[0 speca(4) speca(4)],'r:');
xlabel('frequency');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = -0.1*speca(4);
a(4) = 1.5*speca(4);
axis(a);

elseif filnumb == 2

f1 = 0; f2 = 0.5;
f = f1:(f2-f1)/100:f2;
p = 2*pi*f;
A0 = 1/10^40*ones(size(p));
A = -20*log10(abs(freqz(num,den,p))+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(4) speca(4) 0],'r:', ...
 [speca(2) speca(2) 0.5],[2*speca(4) speca(3) speca(3)],'r:');
xlabel('frequency');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = -0.1*speca(4);
a(4) = 1.5*speca(4);
axis(a);

elseif filnumb == 3

f1 = 0; f2 = 0.5;
f = f1:(f2-f1)/100:f2;
p = 2*pi*f;
A0 = 1/10^40*ones(size(p));
A = -20*log10(abs(freqz(num,den,p))+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(5) speca(5) 0],'r:', ...
 [speca(2) speca(2) speca(3) speca(3)],[speca(5) speca(6) speca(6) speca(7)],'r:', ...
 [speca(4) speca(4) 0.5],[0 speca(7) speca(7)],'r:');
xlabel('frequency');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = -0.1*speca(5);
a(4) = 1.5*max([speca(5) speca(7)]);
axis(a);

elseif filnumb == 4

f1 = 0; f2 = 0.5;
f = f1:(f2-f1)/100:f2;
p = 2*pi*f;
A0 = 1/10^40*ones(size(p));
A = -20*log10(abs(freqz(num,den,p))+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(5) speca(5) 2*speca(6)],'r:', ...
 [speca(2) speca(2) speca(3) speca(3)],[0 speca(6) speca(6) 0],'r:', ...
 [speca(4) speca(4) 0.5],[2*speca(6) speca(7) speca(7)],'r:');
xlabel('frequency');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = -0.1*speca(6);
a(4) = 1.5*speca(6);
axis(a);

end
sizespeca = length(speca);
if filnumb == 1
  title([sprintf('%s : Sa= %9.6f %9.6f %9.5f dB %9.3f dB',Dtype, speca)],'FontSize',9);
elseif filnumb == 2
  title([sprintf('%s : Sa= %9.6f %9.6f %9.5f dB %9.3f dB',Dtype, speca)],'FontSize',9);
elseif filnumb == 3
  title([sprintf('%s : Sa= %9.6f %9.6f %9.6f %9.6f %6.2d dB %9.5f dB %6.2d dB',Dtype,speca)],'FontSize',7);
elseif filnumb == 4
  title([sprintf('%s : Sa= %9.6f %9.6f %9.6f %9.6f %9.5f dB %6.2d dB %9.5f dB',Dtype,speca)],'FontSize',7);
else
  title([sprintf('%s : Sa= %11.1d %11.1d %9.1d dB %9.1d dB',Dtype, speca)],'FontSize',9);
end
