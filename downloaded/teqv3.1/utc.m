%UTC Minimum mean-squared error time domain equalizer design
%    using the unit-tap constraint.
% [B, W, D, MSE, I, Dv] = UTC(X, Y, N, Nb, Nw, Dmin, Dmax)
% returns the optimal target impulse response B, the time domain 
% equalizer W, the delay D, and the unit tap index I. Optimal is
% in the sense of minimum mean-squared error under the constraint
% of a unit-tap. MSE is the resulting mean-squared error and Dv
% is a vector containing the mean-squared error for delay values
% between Dmin and Dmax.
% 
% X is the transmitted data vector. Y is the received data vector
% (without channel noise). N is the channel noise vector. Nb is the 
% number of taps in the target impulse response and Nw the number of 
% taps in the time domain equalizer. Dmin and Dmax define the search 
% interval for the optimal delay.
% 
% See also UEC, CORRELATIONS
%
% The algorithm is from:
% N. Al-Dhahir and J. M. Cioffi, "Efficiently Computed Reduced-Parameter 
% Input-Aided MMSE Equalizers for ML Detection: A Unified Approach", 
% IEEE Trans. on Info. Theory, vol. 42, pp. 903-915, May 1996.

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
% Version:        @(#)utc.m	1.7	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [b, w, d, MSE,iopt,Dv] = utc(x,y,Nb,Nw,Dmin,Dmax,bf)

% open a figure for progress bar
if bf == 1
   [figHndl statusHndl] = setprogbar('Estimating MMSE-UTC TEQ ...');     
end

% initialize variables
Dv = ones(1,Dmax);
VAL = 0;
MSE = inf;

% calculate the input-output auto and cross correlations
[Rxx,Ryy,rxy,L] = correlations(x,y,Dmax,Nb,Nw);

for delay = Dmin:Dmax; % for each delay to be searched
   
  % update progress bar
  if bf == 1
     updateprogbar(statusHndl,delay-Dmin+1,Dmax-Dmin);
  end
  % calculate the correct part of the cross correlation
  Rxy = toeplitz(rxy(L+(0:Nb-1)+delay+1),rxy(L-(0:Nw-1)+delay+1));
  % calculate the MSE matrix and inverse it
  Rd = Rxx - Rxy*inv(Ryy)*Rxy';
  invRd = inv(Rd');
  % find the maximum diagonal entry and the corresponding index
  [junk i] = max(diag(invRd));
  % define a unit vector with 1 in the ith entry
  ei = zeros(Nb,1); 
  ei(i) = 1;
  % calculate the target impulse response
  bb = invRd*ei/invRd(i,i);
  % calculate the resulting MSE
  mse = 1./invRd(i,i);
  % save the MSE for this delay
  Dv(delay) = mse;
  
  if (mse<MSE)&(mse>=0) % if current MSE is lower than previous ones
	% save the current target, MSE, index, delay, and cross-correlation 
	b = bb;
	MSE = mse;
	iopt = i;
	d = delay;
	Rxyopt = Rxy;
  end
end

% use the optimum target impulse response to find the optimum TEQ
w = inv(Ryy)*Rxyopt'*b;
if bf == 1
   close(figHndl);
end
