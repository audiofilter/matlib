function [nD5,dD5,numH,denH,n,a,e,fp] = afd2d5(speck,ninc,filtype)

% afd2d5.m  AFD Design alternative 2D5
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

%% calls: 
%% afda2k.m, afdnminq.m, afdxminq.m, afdl.m, afdhp.m, afdsimsp.m

if filtype == 'l'
 Fp = speck(1);
 Fs = speck(2);
 speck(3) = afda2k(5*log10(1+speck(3)^2));
 speck(4) = afda2k(5*log10(1+speck(4)^2));
 Kpp= speck(3);
 Ks = speck(4);
 Kp = 1/Ks;
 n = afdnminq(Fp, Fs, Kpp, Ks);
 n  = n + ninc;
 [a,fn] = afdxminq(n, Fp, Fs, Kpp, Ks);
 Ks2 = Ks+1;
 while a > 100
   [a,fn] = afdxminq(n, Fp, Fs, Kpp, Ks2);
   Ks2 = Ks2+1;
 end
 e  = 1/sqrt(afdl(n,a));
 fp = Fp/fn;
 [numH,denH] = afdhp(n,a,e);
 nn = length(numH)-1:-1:0;
 nD5 = (ones(size(nn))/(2*pi*fp)).^nn .*numH;
 nd = length(denH)-1:-1:0;
 dD5 = (ones(size(nd))/(2*pi*fp)).^nd .*denH;
 nD5 = conv(nD5,nD5);
 dD5 = conv(dD5,dD5);
end

if filtype == 'h'
 Fp = speck(1);
 Fs = speck(2);
 speck(3) = afda2k(5*log10(1+speck(3)^2));
 speck(4) = afda2k(5*log10(1+speck(4)^2));
 Kpp = speck(3);
 Ks = speck(4);
 Kp = 1/Ks;
 n = afdnminq(Fp, Fs, Kpp, Ks);
 n  = n + ninc;
 [a,fn] = afdxminq(n, Fp, Fs, Kpp, Ks);
 Ks2 = Ks+1;
 while a > 100
   [a,fn] = afdxminq(n, Fp, Fs, Kpp, Ks2);
   Ks2 = Ks2+1;
 end
 e  = 1/sqrt(afdl(n,a));
 fp = Fs*fn;
 [numH,denH] = afdhp(n,a,e);
 if max(size(numH)) < max(size(denH))
   numH = [0 numH];
 end
 nD1h = fliplr(numH);
 dD1h = fliplr(denH);
 nn  = length(nD1h)-1:-1:0;
 nD5 = (ones(size(nn))/(2*pi*fp)).^nn .*nD1h;
 nd  = length(dD1h)-1:-1:0;
 dD5 = (ones(size(nd))/(2*pi*fp)).^nd .*dD1h;
 nD5 = conv(nD5,nD5);
 dD5 = conv(dD5,dD5);
end

if filtype == 'b'
 speck = afdsimsp(speck);
 Fs1 = speck(1);
 Fp1 = speck(2);
 Fp2 = speck(3);
 Fs2 = speck(4);
 speck(5) = afda2k(5*log10(1+speck(5)^2));
 speck(6) = afda2k(5*log10(1+speck(6)^2));
 speck(7) = afda2k(5*log10(1+speck(7)^2));
 Ks1 = speck(5);
 Kpb = speck(6);
 Ks2 = speck(7);
 B = Fp2 - Fp1;
 Fr = sqrt(Fp1*Fp2);
 Fp = Fs1;
 Fs = Fp*(Fs2-Fs1)/B;
 Ks = max([Ks1 Ks2]);
 n = afdnminq(Fp, Fs, Kpb, Ks);
 n  = n + ninc;
 [a,fn] = afdxminq(n, Fp, Fs, Kpb, Ks);
 Ks2 = Ks+1;
 while a > 100
   [a,fn] = afdxminq(n, Fp, Fs, Kpb, Ks2);
   Ks2 = Ks2+1;
 end
 e  = 1/sqrt(afdl(n,a));
 fp = Fp/fn;
 Kp = 1/Ks;
 fp = (Fp2-Fp1);
 [nD1l,dD1l] = afdhp(n,a,e);
 nn = length(nD1l)-1:-1:0;

 nD1 = (ones(size(nn))/(2*pi*fp)).^nn .*nD1l;
 nd = length(dD1l)-1:-1:0;
 dD1 = (ones(size(nd))/(2*pi*fp)).^nd .*dD1l;

 if max(size(nD1l)) < max(size(dD1l))
   nD1l = [0 nD1l];
 end
 nn = max(size(nD1l));
 lb = zeros(nn,2*nn-1);
 w2 = 4*pi^2*Fp1*Fp2;
 fp = (Fp2-Fp1)/fn;
 w1 = 2*pi*fp;
 ns = 0:length(nD1);

 byquad = 1;
 for ind = 1:nn
   lb(ind,nn-ind+1:nn-ind+max(size(byquad))) = byquad;
   byquad = conv(byquad,[1 0 w2]);
 end
 W1 = (ones(size(ns))*w1).^ns;
 W1 = fliplr(W1);
 nBP = 0;
 dBP = 0;
 for ind=1:nn
  lb0(ind,:) =  lb(ind,:) * W1(ind);
  nBP = nBP + lb0(ind,:) * nD1l(nn-ind+1);
  dBP = dBP + lb0(ind,:) * dD1l(nn-ind+1);
 end
 numH = dD1l;
 denH = dD1l;
 nD5 = nBP;
 dD5 = dBP;
 nD5 = conv(nD5,nD5);
 dD5 = conv(dD5,dD5);
end

if filtype == 'r'
 speck = afdsimsp(speck);
 Fp1 = speck(1);
 Fs1 = speck(2);
 Fs2 = speck(3);
 Fp2 = speck(4);
 speck(5) = afda2k(5*log10(1+speck(5)^2));
 speck(6) = afda2k(5*log10(1+speck(6)^2));
 speck(7) = afda2k(5*log10(1+speck(7)^2));
 Kp1 = speck(5);
 Ksr = speck(6);
 Kp2 = speck(7);
 B = Fs2 - Fs1;
 Fr = sqrt(Fs1*Fs2);
 Fp = Fp1;
 Fs = Fp1*(Fp2-Fp1)/B;
 Kp = min([Kp1 Kp2]);
 n = afdnminq(Fp, Fs, Kp, Ksr);
 n  = n + ninc;
 [a,fn] = afdxminq(n, Fp, Fs, Kp, Ksr);
 Ks2 = Ksr+1;
 while a > 100
   [a,fn] = afdxminq(n, Fp, Fs, Kp, Ks2);
   Ks2 = Ks2+1;
 end
 e  = 1/sqrt(afdl(n,a));
 fp = Fp;
  Kp = 1/Ksr;
 [nD1l,dD1l] = afdhp(n,a,e);
 nn = length(nD1l)-1:-1:0;

 nD1 = (ones(size(nn))/(2*pi*fp)).^nn .*nD1l;
 nd = length(dD1l)-1:-1:0;
 dD1 = (ones(size(nd))/(2*pi*fp)).^nd .*dD1l;

 if max(size(nD1l)) < max(size(dD1l))
   nD1l = [0 nD1l];
 end
 nn = max(size(nD1l));
 lb = zeros(nn,2*nn-1);
 w2 = 4*pi^2*Fs1*Fs2;
 fp = (Fp2-Fp1)*fn;
 w1 = 2*pi*fp;
 ns = 0:length(nD1);

 byquad = 1;
 for ind = 1:nn
   lb(ind,nn-ind+1:nn-ind+max(size(byquad))) = byquad;
   byquad = conv(byquad,[1 0 w2]);
 end
 W1 = (ones(size(ns))*w1).^ns;
 W1 = fliplr(W1);
 for ind=1:nn
  lb0(ind,:) =  lb(ind,:) * W1(ind);
 end
 nD1l = fliplr(nD1l);
 dD1l = fliplr(dD1l);
 nBP = 0;
 dBP = 0;
 for ind=1:nn
  nBP = nBP + lb0(ind,:) * nD1l(nn-ind+1);
  dBP = dBP + lb0(ind,:) * dD1l(nn-ind+1);
 end
 numH = dD1l;
 denH = dD1l;
 nD5 = nBP;
 dD5 = dBP;
 nD5 = conv(nD5,nD5);
 dD5 = conv(dD5,dD5);
end
