function Rx = dfdqx(c)

% dfdqx.m  AFD qx(c)
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
%% dfdxna.m, dfdl.m

global DFD_n_x_Ks_Kp;
nxkskp = DFD_n_x_Ks_Kp;
n  = nxkskp(1);
xs = nxkskp(2);
Ks = nxkskp(3);
Kp = nxkskp(4);

a=xs+c(1)^2;
y=1+c(2)^2;

X = zeros(1,n);
for i =1:n
  X(i) = ellipj( ((2*i-1)/n + 1)*ellipke(1/a^2), 1/a^2);
end

X = dfdxna(n,a);
L = dfdl(n,a);
e = 1/sqrt(L);

x = y;
r = 1; R = 1;
if abs(n-2*fix(n/2)) == 0
  for i=1:n/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R * ((x^2 - X(i)^2))/((x^2 - a^2/X(i)^2));
  end
else
  for i=1:(n-1)/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R * ((x^2 - X(i)^2))/((x^2 - a^2/X(i)^2));
  end
    R = x*R;
end
R1 = R/r;

x = y*xs;
r = 1; R = 1;
if abs(n-2*fix(n/2)) == 0
  for i=1:n/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R * ((x^2 - X(i)^2))/((x^2 - a^2/X(i)^2));
  end
else
  for i=1:(n-1)/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R * ((x^2 - X(i)^2))/((x^2 - a^2/X(i)^2));
  end
    R = x * R;
end
R2 = R/r;

Rx = (e*R1/Kp - 1)^2 + (e*R2/Ks - 1)^2;
