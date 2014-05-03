function Rx = afdrx(c)

% afdrx.m  AFD auxiliary function Rx(c)
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

%  calls:
%% afdxna.m

% n = 8;
% x = 3.225/3;
% Ks = 99.99499987499376;
% Kp = 0.21709110541637;
global AFD_n_x_Ks_Kp;
nxkskp = AFD_n_x_Ks_Kp;
n  = nxkskp(1);
x  = nxkskp(2);
Ks = nxkskp(3);
Kp = nxkskp(4);

a=1+c^2;

X = zeros(1,n);
for i =1:n
  X(i) = ellipj( ((2*i-1)/n + 1)*ellipke(1/a^2), 1/a^2);
end

X = afdxna(n,a);

r = 1; R = ones(size(x));
if abs(n-2*fix(n/2)) == 0
  for i=1:n/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R .* ((x.^2 - X(i)^2))./((x.^2 - a^2/X(i)^2));
  end
else
  for i=1:(n-1)/2
    r = r * ((1 - X(i)^2))/((1 - a^2/X(i)^2));
    R = R .* ((x.^2 - X(i)^2))./((x.^2 - a^2/X(i)^2));
  end
    R = x .* R;
end
Rx = (R/r - Ks/Kp)^2;
