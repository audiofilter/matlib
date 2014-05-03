%PERFORM Evaluate the performance of an TEQ in terms of
% SSNR, SNR, geometric SNR, and channel capacity.
% [SS, S, Si, Sg, Mg, Bf, Bm, Rf, Rm, Hw, Fh, Fw, Nc, Fhw] = 
% PERFORM(W,B,H,D,Nb,NN,X,N,Ph,Px,Pn,M,C,Fs,Mi) returns
% the shortening SNR in SS, the SNR at the output of the 
% equalizer in S, the SNR distribution over the subchannels
% in the vector Si. Sg is the real geometric SNR achieved
% with the TEQ and Mg is the geometric SNR that can be 
% achieved in the case of zero ISI (Mg is calculated using
% the MFB distribution while Sg is calculated with the SNR
% distribution.). Bf is the number of bits per symbol 
% achievable with the TEQ and Bm is the upperbound on
% bits per symbol. Rf is the channel capacity achieved with 
% the TEQ and Rm is the upperbound on the channel capacity.
% Hw is a vector containing the equalized channel impulse 
% response. Fh is a vector containing the frequency response 
% of the original channel and Fw is vector containing the 
% equalizer. Nc is a vector of the power spectrum of the 
% channel noise after equalization and Fhw is a vector 
% containing the frequency response of the equalized channel.
%
% W is TEQ impulse response. B is the target impulse response
% (for MMSE based techniques). H is the channel impulse
% response. D is the optimal delay with TEQ. Nb is the target
% window size. NN is the FFT size used in the DMT modulation.
% X is the transmitted signal. N the channel noise. Ph is the 
% magnitude square of the channel frequency response. 
% Px is the power spectrum of the transmitted signal. Pn is the 
% power spectrum of the channel noise. M is the desired system 
% margin in dB which is used for channel capacity calculations.
% C is the coding gain in dB assumed for channel capacity 
% calculations. Fs is the sampling frequency. Mi is the matched
% filter bound distribution over frequency.

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
% Version:      @(#)perform.m	1.3  09/25/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [SSNR, SNR, SNRi,geoSNRfinal,geoSNRmfb,bDMTfinal,bDMTmfb,...
          RDMTfinal,RDMTmfb,hw,Fh,Fw,colorNoiseaft,Shw] = ...
   perform(W,B,channel,D,Nb,N,inputSignal,noise,...
           channelGain,inputSpec,noiseSpec,margin,codingGain,fs,MFBi,used)
%W = W/norm(W);
% equalized channel 
hw = conv(W,channel);
%hw = hw(1:N);
%hw = conv(W,channel);
%hw = hw(1:N);
% target window
win = zeros(length(hw),1); 
win(D+1:D+Nb) = ones(1,Nb); 
% signal path impulse response
hwin = hw.*win;
hwin = hwin - mean(hwin);
% ISI path impulse response
hwout = hw.*(1-win);     
hwout = hwout - mean(hwout);
% energy of the ISI path 
normhwout = norm(hwout,2)^2;
% remaining energy is signal 
normhwin = norm(hwin,2)^2;   
% signal path energy to ISI energy gives the SSNR
SSNR = 10*log10(normhwin./normhwout); 
% received signal power after equalizer
fy = cov(filter(hw,1,inputSignal));  %FIXED: W->hw
% received noise power after equalizer
fn = cov(filter(W,1,noise));  
% SNR at the receiver at the output of the equalizer
SNR = 10*log10(fy./fn);   
% equivalent path frequency responses in the used subchannels
Fhwu = fft(hw,N)*sqrt(N); Fhw = Fhwu(1:N/2+1).'; %Fhw = Fhw(used);
Fhu = fft(channel,N)*sqrt(N); Fh = Fhu(1:N/2+1).'; %Fh = Fh(used);
% TIR frequency response
Fbu = fft([zeros(D,1); B],N)*sqrt(N); Fb = Fbu(1:N/2+1).'; %Fb = Fb(used);
% TEQ frequency response
Fwu = fft(W,N)*sqrt(N); Fw = Fwu(1:N/2+1).';  %Fw = Fw(used);
Fhwinu = fft(hwin,N)*sqrt(N); Fhwin = Fhwinu(1:N/2+1).'; %Fhwin = Fhwin(used);
Fhwoutu = fft(hwout,N)*sqrt(N); Fhwout = Fhwoutu(1:N/2+1).'; %Fhwout = Fhwout(used);
Shw = channelGain.*abs(Fw).^2;
%Fhwin = sqrt(Shw);

% noise power spectrum
colorNoiseaft = noiseSpec.*abs(Fw).^2;  
% ISI power spectrum
isiaft = inputSpec.*abs(Fhwout).^2;   
% signal power spectrum
signalaft = inputSpec.*abs(Fhwin).^2;    
% subband SNRs after equalization
SNRi = signalaft./( colorNoiseaft + isiaft ); 
%SNRi(MFBi<SNRi) = MFBi(MFBi<SNRi);
% calculate geometric SNRs, bit/symbols and bit/second with equalizer
[geoSNRfinal bDMTfinal RDMTfinal] = geosnr(SNRi(used),margin,codingGain,N,Nb,fs);
% calculate geometric SNRs, bit/symbols and bit/second for upper bound
[geoSNRmfb bDMTmfb RDMTmfb] = geosnr(MFBi(used),margin,codingGain,N,Nb,fs);

save perf
