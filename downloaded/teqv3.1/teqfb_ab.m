% teqfb_ab TEQ filter bank metrix Ak,Bk calculation
% [Ak,Bk]=teqfb_ab(channel, totalinputSignalpower, totalAWGNpower, NEXTsigma, D, gamma, N, Nw, Nb, k)
% returns metrix Ak and Bk for the kth subcarriers.
%
% channel is the channel impulse response. totalinputSignalpower is total 
% transmitter signal without noise. totalAWGNpower is the total AWGN noise
% power. NEXTsigma is the averaged NEXT correlation matrix. 
% D is the system energy delay. gamma is the SNR gap. N is the FFT size.
% Nw is the TEQ length. Nb is the SIR length. k is the kth subcarrier
% under consideration.
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

function [Ak, Bk]=teqfb_ab(channel, totalinputSignalpower, totalAWGNpower, NEXTsigma, D, gamma, N, Nw, Nb, k)

%define H, N+Nw-1 by Nw
H=reshape([repmat([channel;zeros(1,Nw)'],Nw-1,1);channel],N+Nw-1,Nw);

%define Hu, D by Nw
Hu=H(1:D,1:Nw);

%define Hc, Nb by Nw
%Originally, Hc should be v by Nw
%v is the CP length
v=Nb;
Hc=H(D+1:D+v,1:Nw);

%define Hb, N+Nw-1-D-v by Nw;
Hb=H(D+v+1:N+Nw-1,1:Nw);

Qk=exp(-sqrt(-1)*2*pi*k*[0:N-1]/N).';
%define Qkcirc, N+Nw-1 by N
ND=N-D;
N1=N-1;
Qkcircindexup=fliplr(gallery('circul',[ND-1:-1:0,N1:-1:ND]));
Qkcircindex=[Qkcircindexup;Qkcircindexup(1:Nw-1,:)]+1;
Qkcirc=Qk(Qkcircindex);
%calculate Akbar
Akbar=totalinputSignalpower/250*H.'*Qkcirc*Qkcirc'*H;

%define Vk, D by D
Vk=rot90(triu(toeplitz(Qk(N:-1:N-D+1).')));
    
%define Wk, N-v-D+Nw-1 by N-v-D+Nw-1
Wk=fliplr(flipud(rot90(triu(toeplitz(Qk(1:N-v-D+Nw-1).')))));


%define Qknoise, Nw by Nw+N-1
Qknoise=reshape([zeros(1,Nw-1),repmat([Qk(1:N).',zeros(1,Nw-2)],1,Nw),0],Nw+N-1,Nw).';

%calculate Bkbar
Bkbar=2*totalinputSignalpower/250*(Hu.'*Vk*Vk'*Hu+Hb.'*Wk*Wk'*Hb)+totalAWGNpower/250*Qknoise*Qknoise';
%    +Qknoise*NEXTsigma*Qknoise';

%Bkbar=2*totalinputSignalpower/250*(Hu.'*Vk*Vk'*Hu+Hb.'*Wk*Wk'*Hb);
%calculate Ak,Bk
Ak=gamma*Bkbar+Akbar;
Bk=gamma*Bkbar;










