% MMPTEQ TEQ design with modified matrix pencil method by estimating 
% the poles of an IIR channel
% function [zopt, wopt,dopt, delmmp] = ...
%   mmpteq(received, channel, NCyclicPrefix, Nw, delay1, delay2)
% returns the poles, TEQ coefficients, delay, and the vector containing
% the SSNR
%
%Parameters in this function
% Inputs: 
% received: received signal
% channel: a column vector of original channel impulse response
% NCyclicPrefix: cyclic prefix
% Nw: the number of tap in TEQ
% delay1: the inital search point
% delay2: the final search point
% Outputs:
% zopt: the locations of poles 
% bopt: the optimal shortened impulse response which is not required
% wopt: the coefficients of TEQ
% dopt: the optimal delay
% delmp: a vector to save the shortening-signal-to-noise ratio
%
% The algorithm is from:
% Y. Hua and T. K. Sarkar, "Matrix Pencil Method for Estimating
% Parameters of Exponentially Damped/Undamped Sinusoids in Noise",
% IEEE Trans. Acoust. Speech Signal Processing, vol. 38, No. 5,
% pp. 814-824, May 1990
% and 
% B. Lu, D. Wei, B. L. Evans, and A. C. Bovik, ``Improved Matrix 
% Pencil Methods'', Proc. IEEE Asilomar Conf. on Signals, Systems, 
% and Computers, Nov. 1-4, 1998, Pacific Grove, CA, vol. 2, pp. 1433-1437.

%Copyright (c) 1999-2003 The University of Texas
%All Rights Reserved.
% 
%This program is free software; you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation; either version 2 of the License, or
%(at your option) any later version.
% 
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
% 
%The GNU Public License is available in the file LICENSE, or you
%can write to the Free Software Foundation, Inc., 59 Temple Place -
%Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
%World Wide Web at http://www.fsf.org.
% 
%Programmers:	Biao Lu 
% Version:       @(#)mmpteq.m	1.4 10/12/00
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [zopt, wopt,dopt, delmmp] = ...
   mmpteq(received, channel, NCyclicPrefix, Nw, delay1, delay2,bf)

% open a figure for progress bar
if bf ==1
   [figHndl statusHndl] = setprogbar('Calculating MMP TEQ ...');     
end
% Set up the parameters
% Pencil parameters
L = NCyclicPrefix + 1;
N = ceil(3*L/2);
if N < 25
   N = 25;
end;

respr = received';
M = Nw - 1;
h = channel';
maxssnrdB = realmin;
for delta = delay1:delay2
   % update progress bar
   if bf ==1
      updateprogbar(statusHndl,delta-delay1+1,delay2-delay1);
   end
   
   noise_y = respr(delta+1:delta+N);
   % Form the Hankel matrix for the original matrix
   % For the whole matrix 
   % Form the first column
   %H_c = conj(noise_y(1:N-L));
   H_c = noise_y(1:N-L);
   % For the last row
   %H_r = conj(noise_y(N-L: N));
   H_r = noise_y(N-L: N);
   H = hankel(H_c, H_r);
   
   % call the function: hankelize
   H_hankel = hankelize(H, M, 1e-6);
   
   % Partition the Hankelized matrix
   Y1 = H_hankel(:, 1:L);
   Y0 = H_hankel(:, 2:L+1);
   
   % Find the zt: the M eigenvalues of pinv(Y0)*Y1
   % Find the singular values of Y0
   [Uy0, Sy0, Vy0] = svd(Y0);
   value_sy0 = diag(Sy0);
   
   % Form the Y0_plus
   Y0_plus = 0;
   % Form the Y1_back_truncate
   if 0
      size_s = max(size(value_sy0));
      [sort_s, s_index] = sort(value_sy0);
      
      for i = 1:M
         tmp = sort_s(s_index(i));
         location = find(value_sy0 == tmp);
         u = Uy0(:, location);
         v = Vy0(:, location);
         Y0_plus = Y0_plus + 1/value_sy0(location).*v*u';
      end;
   else
      for i = 1:M
         Y0_plus1 = 1/value_sy0(i)* Vy0(:,i)*Uy0(:,i)';
         Y0_plus = Y0_plus + Y0_plus1;
      end;
      
   end;
   % Do the SVD truncation of Y1
   % Find the singular values of Y1
   [Uy1, Sy1, Vy1] = svd(Y1);
   value_sy1 = diag(Sy1);
   
   % Form the Y1_truncate
   
   Y1_truncate = 0;
   if 0
      
      size_s = max(size(value_sy1));
      [sort_s, s_index] = sort(value_sy1);
      
      for i = 1:M
         tmp = sort_s(s_index(i));
         location = find(value_sy1 == tmp);
         
         u = Uy1(:, location);
         v = Vy1(:, location);
         Y1_truncate = Y1_truncate + value_sy1(location).*u*v';
      end;
   else
      
      for i = 1:M
         Y1_truncate1 = value_sy1(i).*Uy1(:,i)*Vy1(:,i)';
         Y1_truncate =Y1_truncate + Y1_truncate1;
         
      end;
      
   end;
   % Find the zt
   z = eig(Y1_truncate*Y0_plus);
   sort_z = sort(z);
   flip_sort_z = flipud(sort_z);
   tmp = flip_sort_z(1:M);
   
   if abs(tmp(1)) > 1
      tmp(1) = 1/tmp(1);
   end;
   
   teqtmp = [1, -abs(tmp(1))];
   
   for i = 2:M
      if mod(i, 2) ~= 0
         if abs(tmp(i)) > 1
            tmp(i) = 1/tmp(i);
         end;
         
         teqtmp = conv(teqtmp, [1, -abs(tmp(i))]);
      else
         if abs(tmp(i)) > 1
            tmp(i) = 1/tmp(i);
         end;
         
         teqtmp = conv(teqtmp, [1, abs(tmp(i))]);
      end;
   end;
   
   [ssnrEn_mp, tailEn_mp, sirmp] = remainenergy(delta,channel,teqtmp,NCyclicPrefix);
   delmmp(delta) = ssnrEn_mp;
   if ssnrEn_mp > maxssnrdB
      maxssnrdB = ssnrEn_mp;
      dopt = delta;
      wopt = teqtmp';
      zopt = roots(teqtmp);
   end;
end;

% close progress bar
if bf ==1
   close(figHndl);
end

