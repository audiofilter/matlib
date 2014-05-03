%CORRELATIONS Input/output auto/cross-correlation.
% [RXX, RYY, RXY, L] = CORRELATIONS(X,Y,Dmax,Nb,Nw) returns the 
% input autocorrelation matrix RXX, the output autocorrelation 
% matrix RYY, and the input-output cross-correlation vector RXY 
% of size 2L+1. L is calculated so that the cross-correlation 
% matrix of a delayed X and Y can be generated from RXY. The delay 
% of X has to be smaller than Dmax.
%
% X is the transmitted data vector. Y is the received data vector
% (including the channel noise). Dmax is the maximum allowed delay.
% Nb and Nw are the tap sizes of the target impulse response and
% the time domain equalizer, respectively.

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
% Version:        @(#)correlations.m	1.5   07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [Rxx,Ryy,rxy,L] = correlations(x,y,maxDelay,Nb,Nw)

% size of rxy should be big enough to generate cross
% correlation matrices for delays up to maxDelay
L = max([maxDelay+Nb Nw]);
% calculate the input autocorrelation vector of size Nb
rxx = xcorr(x,x,Nb,'unbiased');
% form a toeplitz matrix of size Nb x Nb
Rxx = toeplitz(rxx(Nb+1+(0:Nb-1)));
% calculate the output autocorrelation vector of size Nw
ryy = xcorr(y,y,Nw,'unbiased');
% form a toeplitz matrix of size Nw x Nw
Ryy = toeplitz(ryy(Nw+1+(0:Nw-1)));
% calculate the input-output cross-correlation of size L
rxy = xcorr(x,y,L,'unbiased');
% fix for the bug in Matlab 5.0
% it gives the cross correlation flipped
vers = version;
if str2num(vers(1)) >= 6  %the bug is fixed with version 6
    rxx = fliplr(rxx);
    rxy = fliplr(rxy);
    ryy = fliplr(ryy);
end

