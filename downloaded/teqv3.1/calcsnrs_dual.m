%CALCSNRS_DUAL calculates the signal to noise ratio in each subchannel 
%for dual-path receiver structure.
% [initSNRi,MFBi,noiseSpec,channelGain,inputSpec] = ...
%   calcsnrs_dual(initInputSpec,initChannelGain,initNoiseSpec,gamma,usedChannels)
% returns the SNRs in initSNRi and the  matched filter bound in the used subchannels 
% in MFBi. The used channels are returned in Ui, the used noise spectrum in noiseSpec, the
% used channel gains in ChannelGain and the used input spectrum in inputSpec.
% 
%The used channel are those which can support at least 2 bits with the given SNR gap in G,
% which is manually selected by system operator.
%initInputSpec is the raw input power spectrum, initChannelGain the channel gain squared, 
%initNoiseSpec is the channel noise power spectrum and gamma the snr gap in dB.

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
% Programmers:	Guner Arslan and Ming Ding 
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [initSNRi,MFBi,noiseSpec,channelGain,inputSpec] = ...
   calcsnrs_dual(initInputSpec,initChannelGain,initNoiseSpec,gamma,usedChannels)

N = (length(initInputSpec)-1)*2;
%calculate SNRi for Sx = 1;
initSNRi = initInputSpec.*initChannelGain./initNoiseSpec; 
%Eliminate useless channels, first assume all usable channels
%SNR required to carry 2 bits with given gap
SNR2bits = gamma*(2^2-1);
%Do not use subchannels which cannot carry 2 bits
%usedChannels = initSNRi >= SNR2bits;
%Do not use DC and Nyquist subchannels
if sum(usedChannels) == 0
    warning('Not enough transmit power to transmit any bits through the channel');
    warning('RESULTS ARE NOT VALID');
    usedChannels(1) = 1;
end

   noiseSpec = zeros(size(initNoiseSpec));
   inputSpec = noiseSpec;
   channelGain = noiseSpec;
   
   noiseSpec(usedChannels) = initNoiseSpec(usedChannels);
   channelGain(usedChannels) = initChannelGain(usedChannels);
   
   %input power equally distributed over the entire channel
   inputSpec(usedChannels) = initInputSpec(usedChannels);
%noise and channel gain in used channels 
%noiseSpec = initNoiseSpec(usedChannels);
%channelGain = initChannelGain(usedChannels);
%inputSpec = initInputSpec(usedChannels);
%matched filter bound if available power would be distributed 
%over the entire bandwidth
MFBi = inputSpec.*channelGain./(noiseSpec+eps);
%MFBiall = initInputSpec.*initChannelGain./initNoiseSpec;

