% PTE_LS Least-Squares Per Tone Equalizer Design.
%
% [FEQM, D] = pte_ls(X, y, h, L, N, bf)
%
% FEQM: equalizer settings ((N x L ); 
% D: delay
% py: Processed received signal
% pX: referenced Frequence domain input signal
%
% X: Training sequence (N X T) in Frequency domain; 
% y: equalizer input ((N + K - 1) x T); s(2 - K), ..., s(2*N)
% h: channel
% L: number of taps
% N: FFT size
% bf: bar flag

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
% Version:        %W% %G% pte_ls.m 1.0 01/15/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

   function [maxSubSNR, Ps, Pn, FEQM, D, py, pX, rateVector] = pte_ls(X, y, h, L, N, bf, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain)

% open a figure for progress bar
   [figHndl statusHndl] = setprogbar('Calculating LS Per Tone ...');     
   
   if delaySearch==1
   %CP length
   P = 32;
   %P = 0;  %try training signal without cp.
   
   channel_delay = findchanneldelay(h, P+1);
   D = channel_delay;
   
   % Frame alignment
   y = y(channel_delay+1:length(y));

   % update frame count
   T = floor(length(y)/(N+P));
   
   % S/P
   y = reshape(y(1:(N+P)*T), N + P, T);
 
   % get rid of bad blocks
   X = X(:, 2:(T - 1));
   pX = X;
   y = y(:, 2:(T - 1));
   py = y;
   T = T - 2;

   FEQM=zeros(L,N/2);
   SDFT=zeros(N,L,T);
  
   for j=1:T
      updateprogbar(statusHndl,j,T);
      SDFT(:,:,j)=SlidingDFT(y(:,j),N,L);
   end
   
   for i=1:N/2
   temp=conj(reshape(SDFT(i,:,:),L,T))';
   FEQM(:,i)=pinv(temp)*X(i,:).';    
   end
   
   Xhat = pertoneeq(FEQM.',py);

   [maxSubSNR, Ps, Pn] = snr_pte(pX, Xhat, usedSubs);
   
   bmap(usedSubs) = ba_cal(maxSubSNR(usedSubs), 9.8, margin, codingGain, 0, 100, 0);
   rtmp=sum(bmap);
   rateVector=rtmp;
   % close progress bar
   close(figHndl);
end

if delaySearch==0
      %CP length
   P = 32;
   %P = 0;  %try training signal without cp.
   rmax=0;
   for channel_delay=Dmin:Dmax
   
   ytmp=y;
   
   % Frame alignment
   ytmp = ytmp(channel_delay+1:length(ytmp));

   % update frame count
   T = floor(length(ytmp)/(N+P));
   
   % S/P
   ytmp = reshape(ytmp(1:(N+P)*T), N + P, T);
 
   % get rid of bad blocks
   Xtmp = X(:, 2:(T - 1));
   pXtmp = Xtmp;
   ytmp = ytmp(:, 2:(T - 1));
   pytmp = ytmp;
   T = T - 2;

   FEQM=zeros(L,N/2);
   SDFT=zeros(N,L,T);
  
   for j=1:T
      updateprogbar(statusHndl,(channel_delay-Dmin)*T+j,T*(Dmax-Dmin+1));
      SDFT(:,:,j)=SlidingDFT(ytmp(:,j),N,L);
      j
   end
   
   for i=1:N/2
   temp=conj(reshape(SDFT(i,:,:),L,T))';
   FEQMtmp(:,i)=pinv(temp)*Xtmp(i,:).';    
   end
   
   Xhattmp = pertoneeq(FEQMtmp.',pytmp);

   [subSNRtmp, Pstmp, Pntmp] = snr_pte(pXtmp, Xhattmp, usedSubs);
   
   bmap(usedSubs) = ba_cal(subSNRtmp(usedSubs), 9.8, margin, codingGain, 0, 100, 0);
   rtmp=sum(bmap);
   rateVector(channel_delay-Dmin+1)=rtmp;
   if rtmp>rmax
      rmax=rtmp;
      maxSubSNR=subSNRtmp;
      Ps=Pstmp;
      Pn=Pntmp;
      FEQM=FEQMtmp;
      D=channel_delay;
      py=pytmp;
      pX=pXtmp;
   end
   
end
   % close progress bar
   close(figHndl);
   
end

