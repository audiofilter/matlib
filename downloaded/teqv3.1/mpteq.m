% MPTEQ TEQ design with matrix pencil method by estimating the poles
% of an IIR channel
% function [zopt, wopt,dopt, delmmp] = ...
%   mpteq(channel, NCyclicPrefix, Nw, delay1, delay2)
% returns the poles, TEQ coefficients, delay, and the vector containing
% the SSNR
%
%Parameters in this function
% Inputs: 
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
% Version:       @(#)mpteq.m	1.3 10/12/00
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [zopt, wopt,dopt, delmp] = ...
         mpteq(channel,NCyclicPrefix, Nw,delay1,delay2,bf)

% open a figure for progress bar
if bf ==1
   [figHndl statusHndl] = setprogbar('Calculating MP TEQ ...');     
end

% Set up the parameters
% Pencil parameters
L = NCyclicPrefix + 1;
N = ceil(3*L/2);
if N < 25
   N = 25;
end;

respr = channel';
M = Nw - 1;

maxssnrdB = realmin;

for delta = delay1:delay2
  % update progress bar
  if bf == 1
     updateprogbar(statusHndl,delta-delay1+1,delay2-delay1);
  end
  
   noise_y = respr(delta+1:delta+N);

% They are Hankel

	% For the whole matrix
	% Form the first column
   %H_c = conj(noise_y(1:N-L));
   H_c = noise_y(1:N-L);

	% For the last row
	%H_r = conj(noise_y(N-L: N));
   H_r = noise_y(N-L: N);
   H = hankel(H_c, H_r);

	% Partition the whole matrix to get the matrix pencils
	Y1 = H(:, 1:L);
	Y0 = H(:, 2:L+1);

% Find the zt: the M eigenvalues of pinv(Y0)*Y1
	% Find the singular values of Y0
	[Uy0, Sy0, Vy0] = svd(Y0);
	value_sy0 = diag(Sy0);

% Form the Y0_plus
	Y0_plus = 0;
	for i = 1:M
		Y0_plus1 = 1/value_sy0(i)* Vy0(:,i)*Uy0(:,i)';
		Y0_plus = Y0_plus + Y0_plus1;
	end;

% Do the SVD truncation of Y1
	% Find the singular values of Y1
	[Uy1, Sy1, Vy1] = svd(Y1);
	value_sy1 = diag(Sy1);

% Form the Y1_truncate
	Y1_truncate = 0;
	for i = 1:M
      Y1_truncate1 = value_sy1(i).*Uy1(:, i)*Vy1(:,i)';
		Y1_truncate =Y1_truncate + Y1_truncate1;
	end;

   % Find the zt
   B = Y1_truncate*Y0_plus;
	z = eig(Y1_truncate*Y0_plus);
	sort_z = sort(z);
	flip_sort_z = flipud(sort_z);
	tmp = flip_sort_z(1:M);
	imag_tmp = find(imag(tmp) ~= 0);
	leng_tmp = length(imag_tmp);
if ~isempty(imag_tmp)
  	teqtmp1 = poly([tmp(imag_tmp(1)),-1/tmp(imag_tmp(1))]);
	less1_tmp = real(dht(teqtmp1));
	teqtmp1 = poly(roots(less1_tmp));

	for k = 1:floor((leng_tmp -1)/2)
   	teqtmp2 = poly([tmp(imag_tmp(2*k+1)), -1/tmp(imag_tmp(2*k+2))]);
   	less1_tmp = real(dht(teqtmp2));
   	teqtmp2 = poly(roots(less1_tmp));
   	teqtmp1 = conv(teqtmp1, teqtmp2);
	end;
else
   teqtmp1 = [1];
  
end;

real_tmp = find(imag(tmp) == 0);
if ~isempty(real_tmp)
	lengreal = length(real_tmp);
	teqtmp3 = [1, -abs(tmp(real_tmp(1)))];
	less1real_tmp = real(dht(teqtmp3));
   teqtmp3 = poly(roots(less1real_tmp));
   
	for i = 2:lengreal
   	if mod(i, 2) ~= 0
      	teqtmp3 = conv(teqtmp3, [1, -abs(tmp(real_tmp(i)))]);
   	else
      	teqtmp3 = conv(teqtmp3, [1, abs(tmp(real_tmp(i)))]);
   	end;
   end;
   teqtmp = conv(teqtmp1, teqtmp3);
else 
   teqtmp = teqtmp1;
end;

[ssnrEn_mp, tailEn_mp, sirmp] = ...
   remainenergy(delta, respr',teqtmp,NCyclicPrefix+1);
  delmp(delta) = ssnrEn_mp;
   if ssnrEn_mp > maxssnrdB
      maxssnrdB = ssnrEn_mp;
	  dopt = delta;
      wopt = teqtmp';
      zopt = roots(teqtmp);
   end;
end;

% close progress bar
if bf == 1
   close(figHndl);
end
