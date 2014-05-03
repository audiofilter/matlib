%OBJECTIVE Objective function to maximize approximate geometric 
%          signal-to-noise ratio.
% [F, G] = OBJECTIVE(B, D, N, Rd, MSE, MSEmax, U) returns the
% negative of the approximate geometric SNR in F. G returns a 
% negative number when the constraints are satisfied, non-negative 
% otherwise. 
%
% B is the target impulse response. D is the delay. N is the FFT 
% size of the discrete multitone modulation. Rd is the MSE matrix.
% MSEmax the upperbound on the mean-squared error. U is a binary
% vector of size N/2+1 with 1s for used subchannels and 0s for
% unused ones.
%
% The objective function is used to design a geometric TEQ
% proposed in:
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
% Version:        @(#)objective.m	1.4	07/26/00
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [f, g] = objective(b,d,N,Rd,MSE,MSEmax,used)
%used = ones(length(used),1) == 1;
% N-point fft of the target impulse response delayed by d samples
Bu = sqrt(N)*fft([zeros(d,1) ;b],N); 
% remove the conjugate part
Bu = Bu(1:N/2+1); 
% select out the used channels
B = Bu(used).'; 
%B = Bu;
% magnitude square
C = abs(B).^2;						
% convert 0 magnitudes to 1s so that they vanish with the log
C(C==0) = 1;
% log(|B_i|^2)
D = log(C);
% sum of log of magnitude squares of the target impulse response
% normalized by the number of subchannel used -> L(b)
f = -sum(D)/sum(used);						
% MSE constraint and unit energy constraint
g = [ 
  b'*Rd*b - MSEmax;				    % MSE < MSEmax constrain
  b'*b - 1.0001;				    % ||b||=1
  -b'*b + 0.9999 ];				    
