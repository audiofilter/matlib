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
% Programmers:	Biao Lu
% Version:        @(#)remainenergy.m	1.2	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at blu@ece.utexas.edu.
% Biao Lu is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parameters in this function
%%% Inputs:
%%% Delta: the delay
%%% h: original channel impulse response
%%% teqcoeff: the coefficients of a TEQ
%%% cp: the cyclic prefix
%%% Outputs:
%%% ssnrindb: the shortening-signal-to-noise ratio in dB
%%% tailEnindB: tail energy in dB
%%% hconvteq: the effective channel impulse response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ssnrindb, tailEnindB, hconvteq]=remainenergy(Delta, h, teqcoeff, cp)

% This function is used to calculate the energy of the tail
% Input parameters:
% Delta: the system delay
% h: the channel impulse response
% cp: cyclic prefix
% teqcoeff: the coefficients of the TEQ
%hconvteq = conv(h./norm(h), teqcoeff./norm(teqcoeff));
%plot(h)
%teqcoeff
%cp
%Delta
%pause
h = h./norm(h);
hconvteq = conv(h, teqcoeff);
scaler = norm(hconvteq).^2;

	% norm(teqcoeff)
%pause
   remain = [hconvteq(1:Delta); hconvteq(Delta+cp+1:length(hconvteq))];
   nusamples = hconvteq(Delta+1:Delta+cp);

   tailEnindB = 10*log10(sum(remain.^2)/scaler);
scaler = norm(nusamples).^2;
ssnrindb = 10*log10(sum(nusamples.^2)/sum(remain.^2));
channelimpulse = h./norm(h);
originaltail = [channelimpulse(1:Delta);...
			   channelimpulse(Delta+cp+1:length(channelimpulse))];
origintailindB = 10*log10(sum(originaltail.^2));

   

