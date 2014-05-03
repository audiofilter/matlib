%SELMETH_DUAL selects and runs the desired TEQ design method for a Dual
% path TEQ structure.
% [B, W, D, MSE, Dv, I, T] = 
%           SELMETH_DUAL(M,X,Y,N,C,Nb,Nw,Dmin,Dmax,Bf,Nl,NN,Ni,Sx,Sn,H,Ui,G))
% returns the target impulse response in B (if the method does not use
% a TIR than B is a zero vector, W is the TEQ, D the optimal delay, MSE
% the mean squared error, Dv is a vector of the performance measure of
% the method called vs delay, I is used only with unit tap constrained
% MMSE method where I is the index of the constrained tap and T is a 
% string with the name of the called method in it. 
%
% M is a integer defining which method to be used, X is the transmitted 
% signal, Y is the received signal, N is the received noise, C is the 
% channel impulse response, Nb is the cyclic prefix size, Nw the number
% of taps in the TEQ, Dmin and Dmax define the interval over which the 
% optimal delay is searched, Bf is a flag if set to one enables the 
% progress bar during calculations, NN is the FFT size in the DMT modulation
% Ni is the number of iteration used in the optimization methods, Sx and
% Sn are the input signal and noise power spectrums, H the channel gain
% squared, Ui a vector of ones and zeros defining the used channels with
% ones, and G is the SNR gap in dB.

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


function [B, W, D, MSE, Dv, I,title_str] = selmeth_dual(method,inputSignal,...
   receivedSignal,noise,channel,...
   Nb,Nw,Dmin,Dmax,barflag,N,numIter,inputSpec,noiseSpec,channelGain,...
   usedSubs,gamma)
B = 0;
W = 0;
D = 0;
Dv = 0;
title_str = '';
I = 0;
MSE = 0;


if method==1,
        [W,D,Dv] = minisi_dual(inputSpec,noiseSpec,channelGain,...
		  channel,N,Nb,Nw,Dmin,Dmax,usedSubs,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('Min-ISI');
   elseif method == 2,
      %initial point for optimization
      [Wsub,D,Dv] = minisi_dual(inputSpec,noiseSpec,channelGain,...
         channel,N,Nb,Nw,Dmin,Dmax,usedSubs,barflag);
      Dmin = D;
      Dmax = D;
      %Wsub = rand(Nw,1)/sqrt(Nw+1);
      [W,D,Dv]=mbr_dual(inputSpec,noiseSpec,usedSubs,channel,N,Nb,Nw,...
         Dmin,Dmax,Wsub,gamma,numIter,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('MBR');
   end
       
