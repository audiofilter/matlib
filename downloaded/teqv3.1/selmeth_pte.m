%SELMETH_PTE selects and runs the desired TEQ design method
% for Per Tone Equalizer Design.
% [WM, D, title_str, py, pX] = 
%           SELMETH_PTE(method,inputSignal,receivedSignal,noise,channel,
%  Nw, N , barflag))
% returns the per tone equalizer banks in WM. D the optimal delay, MSE
% the mean squared error, Title_str is a string with the name of the called 
% method in it. py, pX are matrices of processed input and output data 
%
% method is a integer defining which method to be used, inputSignal is the 
% transmitted signal, receivedSignal is the received signal, noise is the 
% received noise, channel is the channel impulse response, Nw the number
% of taps in the TEQ, Barflag is a flag if set to one enables the 
% progress bar during calculations, N is the FFT size in the DMT modulation

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
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.


function [maxSubSNR, Ps, Pn, WM, D, title_str, py, pX, rateVector] = selmeth_pte(method,inputSignal,...
   receivedSignal,noise,channel,...
   Nw, N , barflag, AWGN, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain)

WM = 0;
D = 0;
title_str = '';

if method==1,
      [maxSubSNR, Ps, Pn, WM, D, py, pX, rateVector] = pte_ls(inputSignal, receivedSignal+noise,...
			       channel, Nw, N, barflag, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain);
      title_str = sprintf('Least Squares pertone');
  elseif method ==2,
      [maxSubSNR, Ps, Pn, WM, D, py, pX, rateVector]= pte_mmse(channel, N, Nw, noise, AWGN, ...
          inputSignal, receivedSignal, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain);
      title_str = sprintf('MMSE pertone');
end
       
