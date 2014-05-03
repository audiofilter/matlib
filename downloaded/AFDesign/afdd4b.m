function [nD4b,dD4b,numH,denH,n,a,e,fp] = afdd4b(speck,ninc,filtype)

% afdd4b.m  Design alternative D4b
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
%% afdnell.m, afdxmax.m, afdl.m, afdhp.m, afdsimsp.m

if filtype == 'l'
 Fp = speck(1);
 Fs = speck(2);
 Kp = speck(3);
 Ks = speck(4);
 n  = afdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = afdxmax(n,Fp,Fs,Kp,Ks);
 e  = Ks/afdl(n,a);
 fp = Fs/a;
 [numH,denH] = afdhp(n,a,e);
 nn = length(numH)-1:-1:0;
 nD4b = (ones(size(nn))/(2*pi*fp)).^nn .*numH;
 nd = length(denH)-1:-1:0;
 dD4b = (ones(size(nd))/(2*pi*fp)).^nd .*denH;
end

if filtype == 'h'
 Fp = speck(1);
 Fs = speck(2);
 Kp = speck(3);
 Ks = speck(4);
 n  = afdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = afdxmax(n,Fp,Fs,Kp,Ks);
 e  = Ks/afdl(n,a);
 fp = Fp*a;
 [numH,denH] = afdhp(n,a,e);
 if max(size(numH)) < max(size(denH))
   numH = [0 numH];
 end
 nD1h = fliplr(numH);
 dD1h = fliplr(denH);
 nn = length(nD1h)-1:-1:0;
 nD4b = (ones(size(nn))/(2*pi*fp)).^nn .*nD1h;
 nd = length(dD1h)-1:-1:0;
 dD4b = (ones(size(nd))/(2*pi*fp)).^nd .*dD1h;
end

if filtype == 'b'
 speck = afdsimsp(speck);
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
 Ks = max([Ks1 Ks2]);
 Kp = Kpb;
 n = afdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = afdxmax(n,Fp,Fs,Kp,Ks);
 e  = Ks/afdl(n,a);
 fp = Fs/a;
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
 fp = (Fs/Fp)*(Fp2-Fp1)/a;
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
 nD4b = nBP;
 dD4b = dBP;
end

if filtype == 'r'
 speck = afdsimsp(speck);
 Fp1 = speck(1);
 Fs1 = speck(2);
 Fs2 = speck(3);
 Fp2 = speck(4);
 Kp1 = speck(5);
 Ksr = speck(6);
 Kp2 = speck(7);
 B = Fs2 - Fs1;
 Fr = sqrt(Fs1*Fs2);
 Fp = Fp1;
 Fs = Fp1*(Fp2-Fp1)/B;
 Kp = min([Kp1 Kp2]);
 Ks = Ksr;
 n = afdnell(Fp,Fs,Kp,Ks);
 n  = n + ninc;
 a  = afdxmax(n,Fp,Fs,Kp,Ks);
 e  = Ks/afdl(n,a);
 fp = Fp;
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
 fp = (Fp/Fs)*(Fp2-Fp1)*a;
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
 nD4b = nBP;
 dD4b = dBP;
end
