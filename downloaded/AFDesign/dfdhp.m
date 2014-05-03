function [numH,denH] = dfdhp(n,a,e,fp)

% dfdhp.m  AFD normalized transfer function
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
%% dfdxna.m, dfdsnaei.m, dfdzbl.m

X = dfdxna(n,a);
nX = length(X);
for ind = 1:nX
 S(ind) = dfdsnaei(n,a,e,ind);
end

if abs(n-2*fix(n/2)) ~= 0
 X((n+1)/2) = 1/10^6;
end

zz = dfdzbl(j*a*ones(size(X))./X,fp);
zp = dfdzbl(S,fp);

if abs(n-2*fix(n/2)) ~= 0
 zz((n+1)/2) = -1;
end

g = 1;
numH = 1;
denH = 1;
if abs(n-2*fix(n/2)) == 0
  for i=1:n/2
    g = g * (2 -2*real(zz(i))) / (1 -2*real(zp(i)) + abs(zp(i))^2);
    numH = conv(numH, [1   -2*real(zz(i))               1]);
    denH = conv(denH, [1   -2*real(zp(i))    abs(zp(i))^2]);
  end
    g = g * sqrt(1+e^2);
else
  for i=1:(n-1)/2
    g = g * (2 -2*real(zz(i))) / (1 -2*real(zp(i)) + abs(zp(i))^2);
    numH = conv(numH, [1   -2*real(zz(i))               1]);
    denH = conv(denH, [1   -2*real(zp(i))    abs(zp(i))^2]);
  end
    g = 2*g/(1 -zp((n+1)/2));
    numH = conv(numH, [1 1]);
    denH = conv(denH, [1 -zp((n+1)/2)]);
end
numH = numH/g;

