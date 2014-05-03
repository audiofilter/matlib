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
% Programmers:	Ming Ding, Guner Arslan and Zukang Shen
% Version:      %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [bitrate,subsnr]=perform_tfb(recNoisySig,FX,delay,teqfbcoef,feq,channel,N);
%perform_tfb calculates the bit rate and subcarrier SNR

%recNoisySig is the received noisy signal
%FX is the ideal frequency domain signal
%delay is the system delay
%teqfbcoef contains all the filter coefficients
%feq contains all the 1-tap FEQ coefficients.
[figHndl statusHndl] = setprogbar('Calculating Subcarrier SNR...'); 

for k=7:7
    updateprogbar(statusHndl,k,250);
    signalAfterChannel=filter(teqfbcoef(k-6,:),1,recNoisySig);
    %CP length
    p=32;
    k
    blockNum=length(recNoisySig)/(N+p)-2;
    for j=1:blockNum
        currentBlock=signalAfterChannel(j*(N+p)+delay:j*(N+p)+delay+N);
        tempresult=fft(currentBlock,N);
        currentSignalAfterFEQ(j)=tempresult(k)/feq(k)
         
        currentNoise(j)=currentSignalAfterFEQ(j)-FX(k,j+1);
    end
     
    subPower= mean(abs(currentSignalAfterFEQ).^2, 2);
    
    subNoise= mean(abs(currentNoise).^2, 2);
    subsnr(k)=subPower/subNoise
    bitrate(k)=log2(1+subsnr(k));
end
close(figHndl);

