%MINISI_DUAL minimum-ISI TEQ design for a dual-path TEQ structure.
% [W, D, Dv] = MINISI(Sx, Sn, Sh, H, N, Nb, Nw, Dmin, Dmax, M)
% returns the time domain equalizer in W and the delay in D.
% Dv is a vector containing the remaining ISI power for delay
% values between Dmin and Dmax.
%
% Sx is the input data frequency spectrum. Sn is the channel
% noise frequency spectrum. Sh is the magnitude square of the
% channel frequency response. H is the channel impulse response.
% N is the FFT size in the discrete multitone modulation. Nb is
% target window size (target length of the equalized channel).
% Nw is the number of taps in the time domain equalizer. Dmin
% and Dmax define the search interval for the optimal delay. M 
% is a string defining what method to be used for the generalized
% eigenvalue decomposition. Choices are:
%
%    'AUTOMATIC'  automatic selection of best method
%    'GENEIGEND'  direct generalized eigenvalue decomposition 
%    'CHOLESKYD'  Cholesky decomposition based method
%    'MINEIGEND'  convert to normal minimum eigenvalue decomposition
%    'MAXEIGEND'  convert to normal maximum eigenvalue decomposition
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
% Version:        @(#)minisi_dual.m	1.8	09/25/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [wopt,dopt,delayVec] = minisi_dual(Sx,Sn,Sh,h,N,Nb,Nw,Dmin,Dmax,used,bf)

% open a figure for progress bar

   [figHndl statusHndl] = setprogbar('Calculating Min-ISI TEQ ...');     


% initialize variables
lambdaopt = 0;
XXi = inf;
delayVec = ones(1,Dmax);


% NN is the number of used subchannels
NN = length(used);
% channel convolution matrix

H = convmtx(h(:),Nw); 	

H = H(1:N,:); 

% weighted function is the SNR
%SSx = Sx(used).*Sh(used)./Sn(used);
SSx = Sx(used)./Sn(used);
SSSx = zeros(size(Sx));

%SSSx(used)  = SSx; %Is it correct? Ding Ming masked on 07/16/2001
SSSx(used) = SSx;
%SSSx(used) = 1; % don't use any weighting here.


[n k] = meshgrid(0:N-1,0:N-1);
QQ = exp(-j*2*pi.*k.*n./N);

B = zeros(N,N);
    for i=1:N/2
        B=B+(QQ(i,:).')*SSSx(i)*QQ(i,:);
    end


for delay = Dmin:Dmax  % for each delay to be searched
    
    updateprogbar(statusHndl,delay-Dmin+1,Dmax-Dmin);
    
    % window function placed at delay+1
    g = zeros(N,1);
    g(delay+1:delay+Nb) = ones(Nb,1);
    % diagonal ISI window matrix
    D = diag(1-g);
    % ISI matrix
    XX = H.'*D.'*B*D*H;% + eye(Nw);
    %XX = H.'*D.'*D*H;%no weighting is used
    % diagonal signal window matrix
    G = diag(g);
    % constraint matrix
    YY = H.'*G.'*G*H;
    % Cholesky decomposition of constraint matrix
    %[sqrtY p]= chol(Y);
    % minimum generalized eigenvalue/eigenvector

    if bf == 0
        [lambda w] = mineig(XX,YY);  
    elseif bf ==1
        [sqrtX] = chol(XX);
        % composite matrix
        C = inv(sqrtX.') * YY * inv(sqrtX);
        [lambda q] = maxeig(C);
        w = inv(sqrtX) * q;
    elseif bf ==2
            [sqrtY] = chol(YY);
            C = inv(sqrtY) * XX * inv(sqrtY.');
            [lambda q] = mineig(C);
            w = inv(sqrtY.') * q;
        elseif bf ==3
            [lambda w] = maxeig(inv(XX)*YY);
        elseif bf == 4
            [lambda q] = mineig(XX*inv(YY));
            w = inv(YY) * q;
        else bf == 5
            [lambda q] = maxeig(YY*inv(XX));
            w = inv(XX) * q;
     end
    
    % save this eigenvalue in the delay vector
    delayVec(delay) = lambda;
    xx(delay) =   obje(w,h,delay,Nb,N,Sx(used),Sn(used),6,4.2,2.208e6,used);
    
    %if  lambda > lambdaopt % if current eigenvalue is smaller than previous ones
    if xx(delay) < XXi
    % save the current TEQ, delay, and eigenvalue
        wopt = w;
        dopt = delay;
        lambdaopt = lambda;
        XXi = xx(delay);
    end
end

% close progress bar

   close(figHndl);

