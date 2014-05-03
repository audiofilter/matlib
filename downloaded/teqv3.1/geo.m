%GEO Geometric TEQ design.(x,y,n,Nb,Nw,N,minDelay,maxDelay,MSEmax,Buec)
% [B, W, D, MSE, Dv] = GEO(X, Y, N, Nb, Nw, NN, Dmin, Dmax, MSEmax, Buec)
% returns the optimal target impulse response B, time domain 
% equalizer W, and delay D. Optimal is in the sense of maximizing
% the approximate geometric SNR. MSE is the resulting mean-squared 
% error. Dv is a vector containing the mean-squared error for delay
% values between Dmin and Dmax.
%
% X is the transmitted data vector. Y is the received data vector
% (without channel noise). N is the channel noise vector. Nb is the 
% number of taps in the target impulse response and Nw the number of 
% taps in the time domain equalizer. NN is the FFT size in the discrete
% multitone modulation. Dmin and Dmax define the search interval for 
% the optimal delay. MSEmax the upperbound on the mean-squared error. 
% Buec is the starting point for the nonlinear constraint optimization
% required to find the optimal TEQ.
%
% NOTE: The Mathworks Optimization Toolbox is required to run this
% function. The 'constr' is used from the Optimization toolbox.
% Optimization Toolbox Version 1.5.1 has been used in this function
%
% The design method is from:
% N. Al-Dhahir and J. M. Cioffi, "Optimum finite-length equalization
% for multicarrier transceivers", IEEE Trans. on Comm., vol 44. 
% pp. 56-63, Jan. 1996.

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
% Version:        @(#)geo.m	1.5	11/25/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [b,w,d,mmse,delayVec]=geo(x,y,Nb,Nw,N,minDelay,maxDelay,MSEmax,Buec,bf,used)

% initialize variables
MMSE = inf;
VAL = inf;
opt = foptions;
opt(14) = 200*Nb;
%opt(2) = 1e-4;
%opt(3) = 1e-4;
binit = Buec;
delayVec = ones(1,maxDelay); 
used = [0 ones(1,N/2-1) 0] == 1;

% calculate the input-output auto and cross correlations
[Rxx,Ryy,rxy,L] = correlations(x,y,maxDelay,Nb,Nw);

% open a figure for progress bar
if bf == 1
[figHndl statusHndl] = setprogbar('Calculating Geometric TEQ ...');     
end


for delay = minDelay:maxDelay % for each delay to be searched
  % update progress bar
  if bf == 1
     updateprogbar(statusHndl,delay-minDelay+1,maxDelay-minDelay);
  end
  % solve the eigenvalue problem (note eigen running just for one delay
  [bopt, wopt, dopt, MSE, Rxy] = eigen(Rxx,Ryy,rxy,delay,delay,Nb,Nw,L);
  % calculate the MSE matrix
  Rd = Rxx - Rxy*inv(Ryy)*Rxy';
  VAL = objective(binit,minDelay,N,Rd,MSE,MSEmax,used);
  % solve the constraint optimization problem with the toolbox
  bo = constr('objective',binit,opt,[],[],[],delay,N,Rd,MSE,MSEmax,used);
  % calculate the mean-squared error
  mmse = bo'*Rd*bo;
  % get the value of the objective function for the current TIR
  val = objective(bo,delay,N,Rd,MSE,MSEmax,used);
  % save the MSE for this delay
  delayVec(delay) = val;
 
  if (VAL > val) % if the current objective is lower then previous ones
	% save the current target, delay, objective, MSE, and 
	% cross-correlation matrix
	b = bo;
	d = delay;
	VAL = val;
	MMSE = mmse;
	Rxyopt = Rxy;
  end
end

% use the optimum target impulse response to find the optimum TEQ
w = inv(Ryy)*Rxyopt'*b;
 
% close progress bar
if bf == 1
   close(figHndl);
end

