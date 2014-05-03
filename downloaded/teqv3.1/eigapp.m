%EIGAPP Eigen approach time domain equalizer design 
% [B, W, D, MSE, Dv] = EIGAPP(X, Y, N, Nb, Nw, Dmin, Dmax) returns
% the target impulse response B, the time domain equalizer
% W, and the delay D. MSE is the resulting mean-squared error and 
% Dv is a vector containing the mean-squared error for delay values 
% between Dmin and Dmax.
%
% X is the transmitted data vector. Y is the received data vector
% (without channel noise). N is the channel noise vector. Nb is the 
% number of taps in the target impulse response and Nw the number of 
% taps in the time domain equalizer. Dmin and Dmax define the search 
% interval for the optimal delay.
% 
% The algorithm is from:
% B. Farhang-Boroujeny and Ming Ding, "An Eigen-Approach to the
% Design of Near-Optimum Time Domain Equalizer for DMT Transceivers", 
% IEEE Int. Conf. on Comm (ICC'99), vol. 2, pp. 937-941, 1999.

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
% Version:        @(#)eigapp.m	1.2  11/25/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.


function [bopt, wopt, dopt, MSE, delayVec]=...
	eigapp(x,y,Nb,Nw,minDelay,maxDelay,bf)

% calculate the input-output auto and cross correlations
[Rxx,Ryy,rxy,L] = correlations(x,y,maxDelay,Nb,Nw);

% initialize variables
delayVec = ones(1,maxDelay);
VAL = 0;
MSE = inf;
m = 1;

% open a figure for progress bar
if bf ==1
   [figHndl statusHndl] = setprogbar('Calculating Eig-App TEQ ...');     
end

for delay = minDelay:maxDelay; % for each delay to be searched
  % update progress bar
  if bf ==1
     updateprogbar(statusHndl,delay-minDelay+1,maxDelay-minDelay);
  end
  % calculate the input-output cross-correlation matrix
  Rxy = toeplitz(rxy(L+(0:Nb-1)+delay+1),rxy(L-(0:Nw-1)+delay+1));
  % calculate the MSE matrix
  Rd = Rxx - Rxy*inv(Ryy)*Rxy';
  % find the eigenvectors and eigenvalues
  [V D] = eig(Rd);
  % extract the eigenvalues into a vector
  values = abs(real(diag(D)));
  % calculate the weighting for each eigenvector
  alpha = values.^(-m);
  % target impulse response is the weighted sum of eigenvectors
  bb = (alpha'*V')';
  % normalize the target impulse response to unit norm
  bb = bb./norm(bb);
  % calculate the MSE for this target impulse response
  mse = abs(bb'*Rd*bb);
  
  % save the MSE for this delay
  delayVec(delay) = mse;
  
  if mse < MSE % if the current MSE is lower then previous ones
	% save the current target, delay, MSE, and crosscorrelation matrix
	bopt = bb;
	dopt = delay;
	MSE  = mse;
	Rxyopt = Rxy;
end

end

% use the optimum target impulse response to find the optimum TEQ
wopt = inv(Ryy)*Rxyopt'*bopt;

% close progress bar
if bf ==1
   close(figHndl);
end