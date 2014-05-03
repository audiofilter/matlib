% ba_cal.m bit allocation for the DMT-ADSL system
% bmap = ba_cal(snr, loss, margin, codinggain, minbits, maxbits, qflag) returns
% the bit allocation scheme based on current transmission environment.
%
% snr is the signal-to-noise ratio vector containing each subcarrier's SNR.
% snrgap is the constellation loss (SNR gap) in dB. margin is the system
% margin in dB. codinggain is the channel coding gain in dB. minbits and 
% maxbits denote the range of constellation size in bits. qflag is the
% flag control the quantization of integer constellation bits.
%
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
% Version:        @(#)ba_cal.m	1.0  01/15/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function bmap = ba_cal(snr, snrgap, margin, codinggain, minbits, maxbits, qflag)

% compute the capacity gap
gap = 10.^((snrgap + margin - codinggain)./10);

% initial bit map
bmap = zeros(length(snr), 1);

% calculates bits supported
bmap = log2(1 + snr./gap);

% for each frequency (subchannel)
for j = 1:length(snr),
   
   % limit the constellation size
   if (bmap(j) > maxbits)
      bmap(j) = maxbits; 
   elseif (bmap(j) < minbits) 
      bmap(j) = 0;
   else
      if qflag == 1,
         bmap(j) = floor(bmap(j));
      end
   end

end

