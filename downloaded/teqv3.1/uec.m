%UEC Minimum mean-squared error time domain equalizer design 
%    using the unit-energy constraint.
% [B, W, D, MSE, Dv] = UEC(X, Y, N, Nb, Nw, Dmin, Dmax) returns
% the optimal target impulse response B, the time domain equalizer
% W, and the delay D. Optimal is in the sense of minimum mean-squared
% error under the unit-energy constraint. MSE is the resulting 
% mean-squared error and Dv is a vector containing the mean-squared 
% error for delay values between Dmin and Dmax.
%
% X is the transmitted data vector. Y is the received data vector
% (without channel noise). N is the channel noise vector. Nb is the 
% number of taps in the target impulse response and Nw the number of 
% taps in the time domain equalizer. Dmin and Dmax define the search 
% interval for the optimal delay.
% 
% See also UTC, EIGEN, CORRELATIONS
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
% Version:        @(#)uec.m	1.5	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.


function [bopt, wopt, dopt, MSE, delayVec]=uec(x,y,Nb,Nw,minDelay,maxDelay,bf)

% calculate the input-output auto and cross correlations
[Rxx,Ryy,rxy,L] = correlations(x,y,maxDelay,Nb,Nw);

% solve the eigenvalue problem
[bopt, wopt, dopt, MSE, Rxyopt, delayVec] = ...
	eigen(Rxx,Ryy,rxy,minDelay,maxDelay,Nb,Nw,L,0,bf); 





