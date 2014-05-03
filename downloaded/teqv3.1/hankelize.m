%HANKELIZE low-rank Hankel approximation
% out = hankelize(Input, M, converge) returns the matrix with Hankel 
% structure and approximately low rank. 
%
% Input is the input matrix. M is the number of dominant eigenvalues.
% converge is the stopping criterion to terminate the iteration of 
% low-rank Hankel approximation.
%
% This algorithm is from:
% Y. Li and K. J. R. Liu and J. Razavilar, "A Parameter Estimation
% Scheme for Damped Sinusoidal Signals Based on Low-Rank {H}ankel
% Approximation" , IEEE Transaction on Signal Processing, vol. 45,
% No. 2, pp. 481-486, Feb. 1997.

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
% Version:      @(#)hankelize.m	1.3 10/12/00
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function out = hankelize(Input, M, converge)
	H = Input;

for iter1 = 1:15
% Form the optimum rank M matrix approximation to H
	[U,S,V] = svd(H);
	s_value = diag(S);
	size_s = max(size(s_value));
   [sort_s, s_index] = sort(s_value);
   H_bar = 0 + sqrt(-1)*0;
   for i = 0:M-1
		u = U(:, s_index(size_s - i));
		v = V(:, s_index(size_s - i));
		H_bar = H_bar + s_value(s_index(size_s - i)).*u*v';
	end;		
% H_bar is not in the form of Hankel, then re-form a Hankel matrix H_hat
	[row_H, col_H] = size(H_bar);

if row_H < col_H	
	% Calculate the first column
	for row_in = 1:row_H
		H_hat_c(row_in) = 0;
		for m = row_in:-1:1
	           H_hat_c(row_in) = H_hat_c(row_in)+H_bar(m, row_in+1-m);
		end;
		H_hat_c(row_in) = H_hat_c(row_in)/row_in;
	end;
	% Calculate the last row

	for col_in = 1:col_H
		H_hat_r(col_in) = 0;
		total = row_H + col_in;
		m = row_H;
		count = 0;
		while m >= 1
			for j = col_in:col_H	
			if m+j == total
				count = count + 1;
			  	H_hat_r(col_in) = H_hat_r(col_in)+H_bar(m,j);
			end; %endif
			end; %endfor
			m = m-1;
		end; % endwhile
		H_hat_r(col_in) = H_hat_r(col_in)/count;
	end;
else
	% Calculate the last row
	for col_in = 1:col_H
		total = col_in + row_H;
		H_hat_r(col_in) = 0;
				
		for m = row_H:-1:(total - col_H)
		   H_hat_r(col_in) = H_hat_r(col_in) + H_bar(m, total - m);
		end;
		H_hat_r(col_in) =H_hat_r(col_in)/(row_H+col_H+1-total);
	end;

	% Calculate the first column  
	for row_in = 1:row_H
		H_hat_c(row_in) = 0;
		total = 1 + row_in;
		m = 1;
		count = 0;
		while m <= col_H
			if total - m >= 1
			count = count + 1;
			H_hat_c(row_in) = H_hat_c(row_in)+H_bar(total-m, m);
			end; %endif
			m = m+1;
		end; % endwhile
		H_hat_c(row_in) = H_hat_c(row_in)/count;
	end;
end; % endif

	% Form the new Hankel matrix
	H_hat = hankel(H_hat_c, H_hat_r);


% Calculate the Frobenius norm between H_hat and H_bar
	f_norm = sqrt(sum(sum(abs(H_hat - H_bar))));
	if f_norm < converge
		break;
	end;
	H = H_hat;
end;
 
	out = H_hat;
