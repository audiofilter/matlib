% teqfb TEQ Filter Bank Design Method
% [rmax,optiamlD,teqfbcoef]=teqfb(channel, inputSignal, AWGNnoise, NEXTnoise, D, gamma, N, Nw, Nb)
% returns the max bit rate in rmax, the optimal delay in optimalD, the optimal TEQ filter bank
% coefficients in teqfbcoef (one row in teqfbcoef represents one TEQ for a certain subcarrier).
%
% channel is the channel impulse response. totalinputSignalpower is total 
% transmitter signal without noise. totalAWGNpower is the total AWGN noise
% power. NEXTsigma is the averaged NEXT correlation matrix. 
% Dmin is the minimum delay. Dmax is the maximum delay. gamma is the SNR gap. N is 
% the FFT size. Nw is the TEQ length. Nb is the SIR length. 
%
% The algorithm is from:
% M. Milosevic, L.F.C. Pessoa, B. L. Evans, and R. Baldick, "Optimal Time 
% Domain Equalization Design for Maximizing Data Rate of Discrete Multi_tone
% Systems", IEEE Trans. on Signal Proc., accepted for publication.
%
% M. Milosevic, L. F. C. Pessoa, B. L. Evans, and R. Baldick,
% "DMT Bit Rate Maximization With Optimal Time Domain Equalizer
% Filter Bank Architecture", Proc. IEEE Asilomar Conf. on Signals,
% Systems, and Computers, Nov. 3-6, 2002, vol. 1, pp. 377-382,
% Pacific Grove, CA, USA, invited paper.
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
% Programmers:	Zukang Shen
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [maxr,maxsubsnr,optimalD,teqfbcoef,maxfeqcoef,totalRateVector]=teqfb(channel, inputSignal, AWGNnoise, NEXTnoise, Dmin, Dmax, gamma, N, Nw, Nb, delaySearch)
totalinputSignalpower=cov(inputSignal);
totalAWGNpower=cov(AWGNnoise);
NEXTsigma=nextsigma(NEXTnoise,N,Nw);


%consider subcarriers from 7 to N/2
[figHndl statusHndl] = setprogbar('Calculating TEQ filter bank ...'); 

if delaySearch==1
%since thorough search for optimal delay is very time consuming, here we use new optimal delay got from findchanneldelay
optimalD=findchanneldelay(channel, Nb);
for D=optimalD
    rmax=0;
    teqfbcoeftmp=[];
    for k=7:N/2 
        updateprogbar(statusHndl,k,N/2);
        [A,B]=teqfb_ab(channel, totalinputSignalpower, totalAWGNpower, NEXTsigma, D, gamma, N, Nw, Nb, k);
        %find the largest generalized eigen value of (real(A),real(B))
        [V,DD]=eig(real(A),real(B));
        [maxEigValue,maxEigValueindex]=max(abs(diag(DD)));
        teqfbcoeftmp=[teqfbcoeftmp;V(:,maxEigValueindex).'];
        feqtemp=fft(channel,N).*fft(V(:,maxEigValueindex),N);
        feqcoef(k)=1/feqtemp(k);
        r(k)=log2(maxEigValue);
        subsnr(k)=maxEigValue-1;
    end
       totalRateVector=sum(r);
       rmax=sum(r);
       maxr=r;
       optimalD=D;
       maxsubsnr=subsnr;
       teqfbcoef=teqfbcoeftmp;
       maxfeqcoef=feqcoef;
    
end
close(figHndl);
end

if delaySearch==0
    rmax=0;
    teqfbcoeftmp=[];
    for D=Dmin:Dmax
    D
    for k=7:N/2 
        k
        updateprogbar(statusHndl,N/2*(D-Dmin)+k,N/2*(Dmax-Dmin+1));
        [A,B]=teqfb_ab(channel, totalinputSignalpower, totalAWGNpower, NEXTsigma, D, gamma, N, Nw, Nb, k);
        %find the largest generalized eigen value of (real(A),real(B))
        [V,DD]=eig(real(A),real(B));
        [maxEigValue,maxEigValueindex]=max(abs(diag(DD)));
        teqfbcoeftmp=[teqfbcoeftmp;V(:,maxEigValueindex).'];
        feqtemp=fft(channel,N).*fft(V(:,maxEigValueindex),N);
        feqcoef(k)=1/feqtemp(k);
        r(k)=log2(maxEigValue);
        subsnr(k)=maxEigValue-1;
    end
    totalRateVector(D-Dmin+1)=sum(r);
    if (sum(r)>rmax)
       rmax=sum(r)
       maxr=r;
       optimalD=D;
       maxsubsnr=subsnr;
       teqfbcoef=teqfbcoeftmp;
       maxfeqcoef=feqcoef;
    end
end
close(figHndl);
end
    