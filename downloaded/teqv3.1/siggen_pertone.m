%SIGGEN_pertone Generate DMT modulated signal at channel input and output.
%for pertone equalizer design.
%
%[Xn,Y,N,H,X,G,F] = SIGGEN_PERTONE(NN,A,C,P,Cg,M,Nn,B) returns the noisy signal 
%at the channel output in Xn, the channel output without noise in Y, the 
%channel noise in N, the channel impulse response in H, the transmit signal
%in X, the SNR gap in G, and the sampling frequency in F.
%
%NN is the FFT size in the DMT modulation, A is white noise power in dBm/Hz,
%C is the CSA loop number, P is the input power in dBm, Cg is the coding gain 
%in dB, M is the margin in dB, and Bf is a flag if set to one enables the progress
%bar during calculations.

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

function [recNoisySig,receivedSignal,noise,channel,inputSignal,gamma,fs,NEXTnoise, AWGN, trainSignalFX] = ...
   siggen_pertone(N,AWGNpower,channels,totalInputPower,codingGain,margin,bf,chbf)

   fs = 2.208e6;         % sampling frequency
   M = 511;              % number of DMT block to be transmitted 
                         
   L = M*(N);			       % sequence length
   P = 6;
   inputImpedance = 100; % Ohm
   noisePower = inputImpedance*0.001*fs/2*10^(AWGNpower/10); % V^2
   channelName = ['csaloop',num2str(channels)];
   power = inputImpedance*0.001*10^(totalInputPower/10);   % V^2
   %requires SNR gap gamma
   gamma = 10^((9.8 - codingGain + margin)/10); 
      %generate pseudo-random downstream sequence
   %trainingPower = inputImpedance*fs/2*0.001*10^(-40/10);   % V^2
   trainingPower = power;
  
   [trainingSignal, trainSignalFX] = trainsig(prd(N),M,1,P);
   trainSignalFX = trainSignalFX*sqrt( trainingPower/cov(trainingSignal) );
   inputSignal_mid = trainingSignal*sqrt( trainingPower/cov(trainingSignal) );
   %add cyclic prefix here
   inputSignal=zeros(1,length(M*(N+32)));
   for i=1:M
       inputSignal(((i-1)*(N+32)+33):i*(N+32))=inputSignal_mid(((i-1)*N+1):i*N);
       inputSignal(((i-1)*(N+32)+1):((i-1)*(N+32)+32))=inputSignal_mid(((i-1)*N+N-32+1):i*N);
   end
   
   %pass it through the channel
   [receivedSignal,channel,noise,NEXTnoise, AWGN]=dsl(N,inputSignal,channelName,noisePower,bf,chbf);
   %add the noise 
   recNoisySig = receivedSignal + noise;

  