function dfdzoomp(num,den,f1,f2,n,order)

% dfdzoomp.m  AFD Zoom attenuation plot
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

if nargin < 3
 n = 100;
 f2 = 0.499;
 f1 = 0.001
elseif nargin < 4
 n = 100;
 f2 = 0.499;
elseif nargin < 5
 n = 100;
end

if n<2
 error('AFD ERROR: Number of plot points is less than 2 in DFDZOOMP.');
end
if f1 >= f2
 error('AFD ERROR: f1 >= f2 in DDFZOOMP');
end
if f2 > 0.5
 error('AFD ERROR: f2 > 0.5 in DDFZOOMP');
end

d = (f2-f1)/n;
f = f1:d:f2;
p = 2*pi*f;
H = freqz(num,den,p);
A0 = 1/10^40*ones(size(f));
A = -20*log10(abs(H)+A0);
plot(f,A)
xlabel('frequency');
ylabel('attenuation (dB)');
title(['Attenuation characteristic',' (order=',num2str(order),')']);
a = axis;
a(1) = f1;
a(2) = f2;
axis(a);

set(gca,'Color',[0.45 0.55 0.45])
