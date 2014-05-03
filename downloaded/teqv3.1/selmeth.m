%SELMETH selects and runs the desired TEQ design method.
% [B, W, D, MSE, Dv, I, T] = 
%           SELMETH(M,X,Y,N,C,Nb,Nw,Dmin,Dmax,Bf,Nl,NN,Ni,Sx,Sn,H,Ui,G))
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
% Programmers:	Guner Arslan
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.


function [B, W, D, MSE, Dv, I,title_str] = selmeth(method,inputSignal,...
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
      [B, W, D, MSE, Dv] = uec(inputSignal, receivedSignal+noise,...
			       Nb, Nw, Dmin, Dmax,barflag);
      title_str = sprintf('MMSE-UEC');
   elseif method==2,
      [B, W, D, MSE, I, Dv] = utc(inputSignal, receivedSignal+noise,...
				  Nb, Nw, Dmin, Dmax,barflag);
      title_str = sprintf('MMSE-UTC');
   elseif method==3,
      [W, D, Dv] = mssnr(channel, Nb, Nw, Dmin, Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('MSSNR');
   elseif method==4,
      if exist('constr') ~= 0
         [Binit, W, D, MSEmin, Dv] = uec(inputSignal, receivedSignal+noise...
					 , Nb, Nw, Dmin, Dmax,barflag);
         MSEmax = (10^0.2)*MSEmin;
         Dmin = D;
         Dmax = D;
         [B, W, D, MSE] = geo(inputSignal, receivedSignal+noise,...
	 Nb, Nw, N, Dmin, Dmax,MSEmax,Binit,barflag,usedSubs);

         title_str = sprintf('GEO');
      else
		error('Optimization Toolbox 1.5 is required to run this method !')
		set(gcf,'Pointer','arrow');
		return;
	  end
   elseif method == 5,
      [W,D,Dv] = minisi(inputSpec,noiseSpec,channelGain,...
		  channel,N,Nb,Nw,Dmin,Dmax,usedSubs,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('Min-ISI');
   elseif method == 6,
      %initial point for optimization
      [Wsub,D,Dv] = minisi(inputSpec,noiseSpec,channelGain,...
         channel,N,Nb,Nw,Dmin,Dmax,usedSubs,barflag);
      Dmin = D;
      Dmax = D;
      %Wsub = rand(Nw,1)/sqrt(Nw+1);
      [W,D,Dv]=mbr(inputSpec,noiseSpec,usedSubs,channel,N,Nb,Nw,...
         Dmin,Dmax,Wsub,gamma,numIter,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('MBR');
   elseif method == 7,
      [W, D, Dv] = dcc(channel,Nb,Nw,Dmin,Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('DCC');
   elseif method == 8,
      [W, D, Dv] = dcm(channel,Nb,Nw,Dmin,Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('DCM');
   elseif method == 9,
      [zopt, W, D, Dv] = mpteq(channel, Nb, Nw, Dmin, Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('MP');
   elseif method == 10,
      [zopt, W, D, Dv] = mmpteq(receivedSignal+noise, channel,...
		  Nb, Nw, Dmin, Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('MMP');
	elseif method == 11,
	  [B, W, D, MSE, Dv] = eigapp(inputSignal, receivedSignal+noise,...
				      Nb, Nw, Dmin, Dmax, barflag);
	  title_str = sprintf('Eig-App');
    elseif method == 12, %added by ming 09/18/01
	  [B, W] = armateq(inputSignal, receivedSignal+noise,...
				      Nb, Nw,barflag);
	  title_str = sprintf('ARMA');
    elseif method == 13,
      [W, D, Dv] = sym_mssnr(channel, Nb, Nw, Dmin, Dmax,barflag);
      B = eps*ones(Nb,1); %doesn't return a B so make one up
      title_str = sprintf('Sym-MSSNR');
	end
       
