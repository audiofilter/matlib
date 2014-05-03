%MBR_DUAL Maximum bit rate TEQ design for dual-path structure.
% [W, D, Dv] = OPT(Sx, Sn, H, N, Nb, Nw, Dmin, Dmax, Wo, G, I) returns  
% the optimal time domain equalizer W, and delay D. Optimal is in the 
% sense of maximum channel capacity. Dv is a vector containing the
% objective value for delays between Dmin and Dmax. I is a scalar
% which is multiplied with Nw to determine the number of iteration to 
% be run for the optimization.
%
% Sx is the transmitted signal power spectrum. Sn is the channel noise
% power spectrum. H is the channel impulse response. N is the FFT size
% in the discrete multitone modulation. Nb is the target length of the
% equalized channel. Nw is the number of taps in the time domain 
% equalizer. Dmin and Dmax define the interval over which the delay is
% being searched. Wo is the initial starting point for the optimization.
% G is the SNR gap (not in dB). I is the number of iteration to be
% used in the optimization procedure.
%
% The algorithm is from:
% G. Arslan, B. L. Evans, and S. Kiaei, "Equalization for 
% Discrete Multitone Transceivers to Maximize Channel Capacity", 
% IEEE Trans. on Signal Proc., submitted.

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

function [wopt,dopt,Dv]=mbr_dual(Sx,Sn,used,h,N,Nb,Nw,Dmin,Dmax,wsub,gamma,iter,bf)

% open a figure for progress bar

   [figHndl statusHndl] = setprogbar('Calculating MBR TEQ ...');     



% initialize variables
bdmtopt = 0;
RES = inf;
opt = foptions; 
opt(14) = Nw*iter*2; 
opt(2) = 1e-20;
opt(3) = 1e-20;
opt(7) =  1;
Dv = ones(1,Dmax);
dopt = Dmin;
wopt = wsub;
Dv = 1;
% number of used subchannels
NN = length(used);
% channel convolution matrix
H = convmtx(h(:),Nw); 
% first N rows are used
H = H(1:N,:);     
% generate a DFT matrix
[n k] = meshgrid(0:N-1,0:N-1);
QQ = exp(-j*2*pi.*k.*n./N);
% select the rows corresponding to used subchannels
Q = QQ(used,:);

for delay = Dmin:Dmax % for each delay to be searched
  % update progress bar
 updateprogbar(statusHndl,delay-Dmin+1,Dmax-Dmin);
 
  % window function placed at delay+1
  g = zeros(N,1);
  g(delay+1:delay+Nb) = ones(Nb,1); 
  % diagonal signal window matrix
  G = diag(g);
  % diagonal ISI window matrix
  D =  diag(1-g);
  
  for i = 1:NN; % for each used subchannel
	% part of the signal matrix
	XX = Q(i,:)*G*H;
	% part of the ISI matrix
	YY = Q(i,:)*D*H;
	% signal matrix for subchannel i
	A(:,:,i) = (XX'*XX)*Sx(i);
	% distortion matrix for subchannel i
	B(:,:,i) = (YY'*YY*Sx(i) + Q(i,1:Nw)'*Q(i,1:Nw)*Sn(i));
%pause  
end
%RES = obj(wsub,NN,A,B,gamma);
 RES = obje(wsub,h,delay,Nb,N,Sx(used),Sn(used),6,4.2,2.208e6,used);


  % turn off annoying warnings during optimization 
  warning off; 
  % minimize the objective 
  %wo = fmins('obj',wsub,opt,[],NN,A,B,gamma); 
  wo = fmins('obje',wsub,opt,[],h,delay,Nb,N,Sx(used),Sn(used),6,4.2,2.208e6,used); 


  wo = wo/norm(wo);
  % turn warning back on
  warning on;
  % calculate the objective (-bdmt) for the obtained TEQ
  %res = obj(wo,NN,A,B,gamma);
  res = obje(wo,h,delay,Nb,N,Sx(used),Sn(used),6,4.2,2.208e6,used);

  % save the objective for the current delay
  Dv(1,delay) = res;

  if res < RES % if objective is smaller than previous ones
	% save the current TEQ, delay, and objective
	wopt = wo;
	dopt = delay;
   RES = res;
end
 end
%a = wopt;

 % close progress bar

    close(figHndl);

