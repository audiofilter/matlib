% SNR_PTE computes the subband SNR for Per Tone equalizers
% [snr, Px, Pv] = snr_pte(X, Xhat , usedSubs) returns the
% subchannel SNR in SNR, signal power in Px, and noise power
% in Pv.

% X is the transmitted signal. Xhat is the estimation of transmitted
% signal. usedSubs is the used subchannels.

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
% Programmers:	Ming Ding
% Version:        @(#)snr_pte.m	1.0	01/15/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [snr, Px, Pv] = snr_pte(X, Xhat , usedSubs)

% block and data sizes
[N T] = size(X);

% initialize SNR
snr  = zeros(N, 1);

% SNR Calculation

% initialize signal and noise estimates
Px   = zeros(N, 1);
V    = zeros(N, T);
Pv   = zeros(N, 1);

% signal power
Px(usedSubs) = mean(abs(X(usedSubs, :)).^2, 2);

% noise power
V(usedSubs, :) = X(usedSubs, :) - Xhat(usedSubs, :);
Pv(usedSubs) = mean(abs(V(usedSubs, :)).^2, 2);

% subchannel SNR
snr(usedSubs) = Px(usedSubs)./Pv(usedSubs);

