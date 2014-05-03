%GEOSNR Geometric SNR, bit per symbol, and bit rate.
% [G, B, R] = GEOSNR(SNR, M, C, N, Nb, Fs) returns the geometric
% SNR in G (dB), bit per symbol in B, and bit rate in R.
%
% SNR is a vector containing the SNRs in each used subchannel.
% M is the system margin in dB. C is the coding gain of any code
% applied in dB. N is the FFT size in the discrete multitone 
% modulation. Nb is the cyclic prefix length. Fs is the sampling
% frequency.

% Copyright (c) 1999-2003 The University of Texas
% All Rights Reserved.
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% The GNU Public License is available in the file LICENSE, or you
% can write to the Free Software Foundation, Inc., 59 Temple Place -
% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
% World Wide Web at http://www.fsf.org.
%  
% Programmers:	Guner Arslan
% Version:        @(#)geosnr.m	1.3	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [SNRgeo, bDMT, RDMT] = geosnr(SNRi,margin,codingGain,N,Nb,fs)

% calculate gamma
gam = 10^((9.8 + margin - codingGain)/10);
% number of channels used
NN = length(SNRi);
% geometric SNR
SNRgeo  = 10*log10( gam*(prod( (1+(SNRi/gam)).^(1/NN))-1) );
% bits/symbol
bDMT = (NN*log(  (1+((10^(SNRgeo/10))/gam)) )  /log(2));

%bDMT = sum(log(1+SNRi/gam)/log(2));
% bits/second
RDMT = sum(log(SNRi/gam+1)./log(2))*fs/(N+Nb);
%RDMT = fs./(N+Nb)*(log(SNRgeo/gam+1)./log(2))*NN
%RDMT = bDMT/(N+Nb)*fs

