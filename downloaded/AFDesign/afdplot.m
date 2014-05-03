function twoaxis=afdplot(num,den,speca,filnumb,moreaxis,Dtype)

% afdplot.m  AFD Plot attenuation
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

twoaxis = 0;
initaxis = [0.13 0.11 0.775 0.815];
if moreaxis ~= 0
 delete(gca);
 set(gca, 'Position', initaxis);
end

if filnumb == 1

f1 = 0; f2 = 5*speca(2);
f = f1:(f2-f1)/100:f2;
s = j*2*pi*f;
H = polyval(num,s)./polyval(den,s);
A0 = 1/10^40*ones(size(f));
A = -20*log10(abs(H)+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(3) speca(3) 2*speca(4)],'r:', ...
 [speca(2) speca(2) 5*speca(2)],[0 speca(4) speca(4)],'r:');
xlabel('frequency (Hz)');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = 0;
a(4) = 1.5*speca(4);
axis(a);

elseif filnumb == 2

f1 = 0; f2 = 5*speca(2);
f = f1:(f2-f1)/100:f2;
s = j*2*pi*f;
H = polyval(num,s)./polyval(den,s);
A0 = 1/10^40*ones(size(f));
A = -20*log10(abs(H)+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(4) speca(4) 0],'r:', ...
 [speca(2) speca(2) 5*speca(2)],[2*speca(4) speca(3) speca(3)],'r:');
xlabel('frequency (Hz)');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = 0;
a(4) = 1.5*speca(4);
axis(a);

elseif filnumb == 3

f1 = 0; f2 = 5*speca(4);
f = f1:(f2-f1)/100:f2;
s = j*2*pi*f;
H = polyval(num,s)./polyval(den,s);
A0 = 1/10^40*ones(size(f));
A = -20*log10(abs(H)+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(5) speca(5) 0],'r:', ...
 [speca(2) speca(2) speca(3) speca(3)],[speca(5) speca(6) speca(6) speca(7)],'r:', ...
 [speca(4) speca(4) 5*speca(4)],[0 speca(7) speca(7)],'r:');
xlabel('frequency (Hz)');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = 0;
a(4) = 1.5*max(speca(5),speca(7));
axis(a);

elseif filnumb == 4

f1 = 0; f2 = 5*speca(4);
f = f1:(f2-f1)/100:f2;
s = j*2*pi*f;
H = polyval(num,s)./polyval(den,s);
A0 = 1/10^40*ones(size(f));
A = -20*log10(abs(H)+A0);
plot(f,A,'b', ...
 [0 speca(1) speca(1)],[speca(5) speca(5) 2*speca(6)],'r:', ...
 [speca(2) speca(2) speca(3) speca(3)],[0 speca(6) speca(6) 0],'r:', ...
 [speca(4) speca(4) 5*speca(4)],[2*speca(6) speca(7) speca(7)],'r:');
xlabel('frequency (Hz)');
ylabel('attenuation (dB)');
a = axis;
a(1) = f1;
a(2) = f2;
a(3) = 0;
a(4) = 1.5*speca(6);
axis(a);

end
sizespeca = length(speca);
if sizespeca==4
  title([sprintf('%s : Sa= %11.1d Hz %11.1d Hz %9.5f dB %9.1d dB',Dtype, speca)],'FontSize',9);
elseif sizespeca==7
  if speca(6)<3
    title([sprintf('%s : Sa= %11.1d Hz %11.1d Hz %11.1d Hz %11.1d Hz %5.1d dB %9.5f dB %5.1d dB',Dtype,speca)],'FontSize',7);
  elseif (speca(5)+speca(5))<6
    title([sprintf('%s : Sa= %11.1d Hz %11.1d Hz %11.1d Hz %11.1d Hz %9.5f dB %9.1d dB %9.5f dB',Dtype,speca)],'FontSize',7);
  else
    title([sprintf('%s : Sa= %11.1d Hz %11.1d Hz %11.1d Hz %11.1d Hz %9.1d dB %9.1d dB %9.1d dB',Dtype,speca)],'FontSize',7);
  end
else
  title([sprintf('%s : Sa= %11.1d Hz %11.1d Hz %9.1d dB %9.1d dB',Dtype, speca)],'FontSize',9);
end
