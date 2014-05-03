function [numH,denH] = afdhp(n,a,e)

% afdhp.m  AFD normalized lowpass elliptic transfer function
%          Hcal(n,ksi,epsilon) numerator and denominator polynomials
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
%% afdxna.m, afdsnaei.m

X = afdxna(n,a);
nX = length(X);
for ind = 1:nX
 S(ind) = afdsnaei(n,a,e,ind);
end

g = 1;
numH = 1;
denH = 1;
if abs(n-2*fix(n/2)) == 0
  for i=1:n/2
    g = g * ( abs(S(i))^2 ) / ( a^2 / (X(i))^2);
    numH = conv(numH, [1   0           a^2/(X(i))^2]);
    denH = conv(denH, [1 -2*real(S(i)) abs(S(i))^2]);
  end
    g = g / sqrt(1+e^2);
else
  for i=1:(n-1)/2
    g = g * ( abs(S(i))^2 ) / ( a^2 / (X(i))^2);
    numH = conv(numH, [1   0           a^2/(X(i))^2]);
    denH = conv(denH, [1 -2*real(S(i)) abs(S(i))^2]);
  end
    g = - g * S((n+1)/2);
    denH = conv(denH, [1 -S((n+1)/2)]);
end
numH = g*numH;
