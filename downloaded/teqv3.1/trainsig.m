%TRAINSIG Modulates binary data with discrete multitone modulation.
% Y = TRAINSIG(X,L,N,F,P) returns a DMT training signal in Y. 
%
% X is length-N binary input sequence to be modulated where N is the FFT
% size in the DMT modulation. L*N is the length of Y. F is a flag if set 
% to 1 then Y is periodic with N. P defines the number of unused 
% subchannels near DC.

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
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

%generate L symbol training sequence from binary data x 
function [y, Fx] = trainsig(x,L,flag,P)
x = x(:).'; 
N = length(x);

if flag == 0
   x = x(1:N-1);
   x1 = kron(ones(1,L),x);
   x15 = [x1 x1(1:L)];
   x2 = reshape(x15,2,L*N/2);
else 
   x1 = reshape(x,2,N/2);
   x2 = kron(ones(1,L),x1);
end

x3 = -2*(x2 - 0.5);
x4 = x3(1,:)+j*x3(2,:);
x5 = reshape(x4,N/2,L).';
x5(:,1:P) = zeros(L,P);
x6 = [zeros(L,1) x5(:,2:N/2) zeros(L,1) fliplr(conj(x5(:,2:N/2))) ].';
x7 = real(1/sqrt(N)*ifft(x6));  %%why 1/sqrt(N) not sqrt(N)
x8 = reshape(x7,1,N*L);
y = x8;
Fx = x6;


