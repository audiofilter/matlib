function [nmin,nmax,nincmin,nincmax] = dfdorder(speck,filnumb)

% dfdorder.m  AFD order range (nmin,nmax)
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

if filnumb==1 | filnumb==2

 Fp = speck(1);
 Fs = speck(2);
 Kp = speck(3);
 Ks = speck(4);

elseif filnumb==3
 Fs1 = speck(1);
 Fp1 = speck(2);
 Fp2 = speck(3);
 Fs2 = speck(4);
 Ks1 = speck(5);
 Kpb = speck(6);
 Ks2 = speck(7);
 B = Fp2 - Fp1;
 Fr = sqrt(Fp1*Fp2);

 Fp = Fs1;
 Fs = Fp*(Fs2-Fs1)/B;
 Kp = Kpb;
 Ks = max([Ks1 Ks2]);

elseif filnumb==4
 Fp1 = speck(1);
 Fs1 = speck(2);
 Fs2 = speck(3);
 Fp2 = speck(4);
 Kp1 = speck(5);
 Ksr = speck(6);
 Kp2 = speck(7);

errorFrequency = tan(pi*Fp1) * tan(pi*Fp2)- tan(pi*Fs1) * tan(pi*Fs2);
 Fp1p = atan(tan(pi*Fs1) * tan(pi*Fs2) / tan(pi*Fp2) )/pi;
 Fp2p = atan(tan(pi*Fs1) * tan(pi*Fs2) / tan(pi*Fp1) )/pi;
 if abs(errorFrequency) > 1/10^9
  if Fp1p > Fp1
   Fp1 = Fp1p;
  else
   Fp2 = Fp2p;
  end
 end

% B = Fs2 - Fs1;
% Fr = sqrt(Fs1*Fs2);
 Fp = Fp1;
 Fs = atan(tan(pi*Fp1) * (tan(pi*Fp2)-tan(pi*Fp1)) / ...
                        (tan(pi*Fs2)-tan(pi*Fs1)) )/pi;
 Kp = min([Kp1 Kp2]);
 Ks = Ksr;

else
 error('DFD ERROR: Unsupported filter type.');

end

k      = tan(pi*Fp)/tan(pi*Fs);
L      = Ks/Kp;
num    = ellipke(1-1/L^2)/ellipke(1/L^2);
den    = ellipke(1 - k^2)/ellipke(k^2);
nellip = ceil(num/den);


ncheb = ceil(acosh(L)/acosh(1/k));

nmin = nellip;
nmax = min([2*nmin,ncheb-1]);

if nmax < nmin
 nmax = nmin;
end

nincmin = 0;
nincmax = nmax - nmin;

