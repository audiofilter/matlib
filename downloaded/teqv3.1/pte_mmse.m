%MING DING 10/7/02
%MMSE PER TONE DESIGN METHOD

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
% Version:        %W% %G% pte_mmse.m 1.0 01/15/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

%system specifications
%N = 64;
%Nw = 2;
%nu = 2;

%load ../teqv3/channels/csaloop1.time
%channel = csaloop1(:,2)/2208000;

%Debug
%channel = channel(1:64);

function [maxSubSNR, Ps, Pn, FEQM, D, py, pX, rateVector] = pte_mmse(channel, N, Nw, noise, AWGN, inputSignal, ...
    receivedSignal, delaySearch, usedSubs, Dmin, Dmax, margin, codingGain)

[figHndl statusHndl] = setprogbar('Calculating MMSE Per Tone ...');     

if delaySearch==1
   y=receivedSignal+noise;
   nu = 32;
   
   
   channel_delay = findchanneldelay(channel, nu+1);
   D = channel_delay;
   
   % Frame alignment
   y = y(channel_delay+1:length(y));

   % update frame count
   T = floor(length(y)/(N+nu));
   
   % S/P
   y = reshape(y(1:(N+nu)*T), N + nu, T);
 
   % get rid of bad blocks
   X = inputSignal(:, 2:(T - 1));
   pX = X;
   y = y(:, 2:(T - 1));
   py = y*N;
   
   Sx = mean(abs((inputSignal(1:N,:)).^2),2);
   Rx = diag([Sx; Sx; Sx]);

   Rn = mean(abs(noise.^2))*eye(N+Nw-1);
   
   updateprogbar(statusHndl,1,4);
%find the tail and head of the channel
[h, L, K] = findHeadTail(channel,nu+1);
h = h.';

%Create H matrix
Delta = 0;

O1 = zeros(N+Nw-1, N+nu-Nw+1-L+nu+Delta);
O2 = zeros(N+Nw-1, N+nu-K-Delta);
O3 = zeros(nu, N-nu);

P = [O3, eye(nu);eye(N)];
PP = zeros(3*(N+nu), 3*N);
PP(1:N+nu, 1:N) = P;
PP(N+nu+1:2*(N+nu), N+1:2*N) = P;
PP(2*(N+nu)+1:3*(N+nu), 2*N+1:3*N) = P;

FN = dftmatrix(N)./sqrt(N);
IFN = conj(FN);
II = zeros(N*3,N*3);
II(1:N, 1:N) = IFN;
II(N+1:2*N, N+1:2*N) = IFN;
II(2*N+1:3*N, 2*N+1:3*N) = IFN;

ColN= 3*(N+nu)-(N+nu-Nw+1-L+nu+Delta)-(N+nu-K-Delta);
H2 = zeros(N+Nw-1, ColN);

updateprogbar(statusHndl,2,4);
for i = 1:N+Nw-1
    H2(i, i:i+length(h)-1) = h;
end

HH = [O1 H2 O2]*PP*II;

%Sx = 0.1*ones(N,1);
%Rx = zeros(3*N,3*N);
%Rx = diag([Sx; Sx; Sx]);
%Rn = diag(ones(N+Nw-1,1));

Ry = real(HH*Rx*HH'+Rn);


FEQM=zeros(Nw,N/2);
temp = zeros(Nw,1);
updateprogbar(statusHndl,3,4);
for i = 1:N/2
F = zeros(Nw, N+Nw-1);
for j = 1:Nw
    F(j, j:j+N-1) = FN(i,:);
end
RI = inv(F*Ry*F')*F;
temp = RI*HH(:,i+N)*Sx(i);
temp = conj(temp);
FEQM(:,i) = flipud(temp);
end

Xhat = pertoneeq(FEQM.',py);

   [maxSubSNR, Ps, Pn] = snr_pte(pX, Xhat, usedSubs);
   
   bmap(usedSubs) = ba_cal(maxSubSNR(usedSubs), 9.8, margin, codingGain, 0, 100, 0);
   rtmp=sum(bmap);
   rateVector=rtmp;

   
updateprogbar(statusHndl,4,4);
   % close progress bar
   close(figHndl);

end

if delaySearch==0
    y=receivedSignal+noise;
   nu = 32;
   rmax=0;
   
   for channel_delay = Dmin:Dmax
   updateprogbar(statusHndl,channel_delay-Dmin+1,Dmax-Dmin+1);
   ytmp=y;
   
   % Frame alignment
   ytmp = ytmp(channel_delay+1:length(ytmp));

   % update frame count
   T = floor(length(ytmp)/(N+nu));
   
   % S/P
   ytmp = reshape(ytmp(1:(N+nu)*T), N + nu, T);
 
   % get rid of bad blocks
   Xtmp = inputSignal(:, 2:(T - 1));
   pXtmp = Xtmp;
   ytmp = ytmp(:, 2:(T - 1));
   pytmp = ytmp*N;
   
   Sx = mean(abs((inputSignal(1:N,:)).^2),2);
   Rx = diag([Sx; Sx; Sx]);

   Rn = mean(abs(noise.^2))*eye(N+Nw-1);
   
   
%find the tail and head of the channel
[h, L, K] = findHeadTail(channel,nu+1);
h = h.';

%Create H matrix
Delta = channel_delay - K;

O1 = zeros(N+Nw-1, N+nu-Nw+1-L+nu+Delta);
O2 = zeros(N+Nw-1, N+nu-K-Delta);
O3 = zeros(nu, N-nu);

P = [O3, eye(nu);eye(N)];
PP = zeros(3*(N+nu), 3*N);
PP(1:N+nu, 1:N) = P;
PP(N+nu+1:2*(N+nu), N+1:2*N) = P;
PP(2*(N+nu)+1:3*(N+nu), 2*N+1:3*N) = P;

FN = dftmatrix(N)./sqrt(N);
IFN = conj(FN);
II = zeros(N*3,N*3);
II(1:N, 1:N) = IFN;
II(N+1:2*N, N+1:2*N) = IFN;
II(2*N+1:3*N, 2*N+1:3*N) = IFN;

ColN= 3*(N+nu)-(N+nu-Nw+1-L+nu+Delta)-(N+nu-K-Delta);
H2 = zeros(N+Nw-1, ColN);


for i = 1:N+Nw-1
    H2(i, i:i+length(h)-1) = h;
end

HH = [O1 H2 O2]*PP*II;

%Sx = 0.1*ones(N,1);
%Rx = zeros(3*N,3*N);
%Rx = diag([Sx; Sx; Sx]);
%Rn = diag(ones(N+Nw-1,1));

Ry = real(HH*Rx*HH'+Rn);


FEQMtmp=zeros(Nw,N/2);
temp = zeros(Nw,1);

for i = 1:N/2
F = zeros(Nw, N+Nw-1);
for j = 1:Nw
    F(j, j:j+N-1) = FN(i,:);
end
RI = inv(F*Ry*F')*F;
temp = RI*HH(:,i+N)*Sx(i);
temp = conj(temp);
FEQMtmp(:,i) = flipud(temp);
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
