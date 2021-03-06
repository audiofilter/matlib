function [nD1,dD1,n,a,e,fp] = dfdd5(speck,ninc,filtype)

% dfdd5.m  DFD Design alternative D5
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
%% dfdnell.m, dfdhp.m, dfdsimsp.m

if filtype == 'l'
 speck(3) = dfda2k(5*log10(1+speck(3)^2));
 speck(4) = dfda2k(5*log10(1+speck(4)^2));
 Fp = speck(1);
 Fs = speck(2);
 Kp = speck(3);
 Ks = speck(4);
 n = dfdnminq(Fp, Fs, Kp, Ks);
 n  = n + ninc;
 [a,fn] = dfdxminq(n, Fp, Fs, Kp, Ks);
 if a > 10000
   [a,fn] = dfdxmq2(n, Fp, Fs, Kp, Ks);
 end
 e  = 1/sqrt(dfdl(n,a));
 fp = atan(tan(pi*Fp)/fn)/pi;
 [nD5,dD5] = dfdhp(n,a,e,fp);
 nD1 = conv(nD5,nD5);
 dD1 = conv(dD5,dD5);
end

if filtype == 'h'
 speck(3) = dfda2k(5*log10(1+speck(3)^2));
 speck(4) = dfda2k(5*log10(1+speck(4)^2));
 Fp = 0.5 - speck(2);
 Fs = 0.5 - speck(1);
 Kp = speck(3);
 Ks = speck(4);
 n = dfdnminq(Fp, Fs, Kp, Ks);
 n  = n + ninc;
 [a,fn] = dfdxminq(n, Fp, Fs, Kp, Ks);
 if a > 10000
   [a,fn] = dfdxmq2(n, Fp, Fs, Kp, Ks);
 end
 e  = 1/sqrt(dfdl(n,a));
 fp = atan(tan(pi*Fp)/fn)/pi;
 [nD1,dD1] = dfdhp(n,a,e,fp);
 ndHd = max(size(dD1))-1:-1:0;
 ndHm = (-ones(size(dD1))).^ndHd;
 dD5 = dD1 .* ndHm;
 nD5 = nD1 .* ndHm;
 nD1 = conv(nD5,nD5);
 dD1 = conv(dD5,dD5);
end

if filtype == 'b'
 speck = dfdsimsp(speck);
 speck(5) = dfda2k(5*log10(1+speck(5)^2));
 speck(6) = dfda2k(5*log10(1+speck(6)^2));
 speck(7) = dfda2k(5*log10(1+speck(7)^2));
 Fs1 = speck(1);
 Fp1 = speck(2);
 Fp2 = speck(3);
 Fs2 = speck(4);
 Ks1 = speck(5);
 Kpb = speck(6);
 Ks2 = speck(7);
 Fp = Fs1;
 Fs = atan(tan(pi*Fs1) * (tan(pi*Fs2)-tan(pi*Fs1)) / ...
                        (tan(pi*Fp2)-tan(pi*Fp1)) )/pi;
 Kp = Kpb;
 Ks = max([Ks1 Ks2]);
 n = dfdnminq(Fp, Fs, Kp, Ks);
 n  = n + ninc;
 [a,fn] = dfdxminq(n, Fp, Fs, Kp, Ks);
 if a > 10000
   [a,fn] = dfdxmq2(n, Fp, Fs, Kp, Ks);
 end
 e  = 1/sqrt(dfdl(n,a));
 fp = atan(tan(pi*Fp)/fn)/pi;
 k = tan(pi*Fp)* cot(pi*(Fp2-Fp1));
 g = (k-1)/(k+1);
 b = - 2*k*cos(pi*(Fp2+Fp1)) /((1+k)*cos(pi*(Fp2-Fp1)));
 [nD5,dD5] = dfdhb(n,a,e,fp,k,g,b);
 nD1 = conv(nD5,nD5);
 dD1 = conv(dD5,dD5);
end

if filtype == 'r'
 speck = dfdsimsp(speck);
 speck(5) = dfda2k(5*log10(1+speck(5)^2));
 speck(6) = dfda2k(5*log10(1+speck(6)^2));
 speck(7) = dfda2k(5*log10(1+speck(7)^2));
 Fp1 = speck(1);
 Fs1 = speck(2);
 Fs2 = speck(3);
 Fp2 = speck(4);
 Kp1 = speck(5);
 Ksr = speck(6);
 Kp2 = speck(7);
 Fp = Fp1;
 Fs = atan(tan(pi*Fp1) * (tan(pi*Fp2)-tan(pi*Fp1)) / ...
                        (tan(pi*Fs2)-tan(pi*Fs1)) )/pi;
 Kp = min([Kp1 Kp2]);
 Ks = Ksr;
 n = dfdnminq(Fp, Fs, Kp, Ks);
 n  = n + ninc;
 [a,fn] = dfdxminq(n, Fp, Fs, Kp, Ks);
 if a > 10000
   [a,fn] = dfdxmq2(n, Fp, Fs, Kp, Ks);
 end
 e  = 1/sqrt(dfdl(n,a));
 fp = atan(tan(pi*Fp)/fn)/pi;
 k = tan(pi*Fp)* tan(pi*(Fp2-Fp1));
 g = (1-k)/(k+1);
 b = - 2* cos(pi*(Fp2+Fp1)) /((1+k)*cos(pi*(Fp2-Fp1)));
 [nD5,dD5] = dfdhr(n,a,e,fp,k,g,b);
 nD1 = conv(nD5,nD5);
 dD1 = conv(dD5,dD5);
end
