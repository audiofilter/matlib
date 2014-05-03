function [nD1,dD1,n,a,e,fp] = dfdd3a(speck,ninc,filtype)

% dfdd3a.m  DFD Design alternative D3a
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
 Fp = speck(1);
 Fs = speck(2);
 Kp = speck(3);
 Ks = speck(4);
 n  = dfdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = dfdxmin(n, Kp, Ks);
 e  = Kp;
 fp = Fp;
 [nD1,dD1] = dfdhp(n,a,e,fp);
end

if filtype == 'h'
 Fp = 0.5 - speck(2);
 Fs = 0.5 - speck(1);
 Kp = speck(3);
 Ks = speck(4);
 n  = dfdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = dfdxmin(n, Kp, Ks);
 e  = Kp;
 fp = Fp;
 [nD1,dD1] = dfdhp(n,a,e,fp);
 ndHd = max(size(dD1))-1:-1:0;
 ndHm = (-ones(size(dD1))).^ndHd;
 dD1 = dD1 .* ndHm;
 nD1 = nD1 .* ndHm;
end

if filtype == 'b'
 speck = dfdsimsp(speck);
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
 n  = dfdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = dfdxmin(n, Kp, Ks);
 e  = Kp;
 fp = Fp;
 k = tan(pi*Fp)* cot(pi*(Fp2-Fp1));
 g = (k-1)/(k+1);
 b = - 2*k*cos(pi*(Fp2+Fp1)) /((1+k)*cos(pi*(Fp2-Fp1)));
 [nD1,dD1] = dfdhb(n,a,e,fp,k,g,b);
end

if filtype == 'r'
 speck = dfdsimsp(speck);
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
 n  = dfdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = dfdxmin(n, Kp, Ks);
 e  = Kp;
 fp = Fp;
 k = tan(pi*Fp)* tan(pi*(Fp2-Fp1));
 g = (1-k)/(k+1);
 b = - 2* cos(pi*(Fp2+Fp1)) /((1+k)*cos(pi*(Fp2-Fp1)));
 [nD1,dD1] = dfdhr(n,a,e,fp,k,g,b);
end

