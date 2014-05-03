% SLIDINGDFT computes the sliding FFT coefficients.
%
% SDFT=SlidingDFT(Y,N,L)
% 
% Y:input in column vector
% N:FFT length
% L:Sliding window length

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
% Programmers:	Ming Ding
% Version:        @(#)SlidingDFT.m	1.0	01/15/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function SDFT=SlidingDFT(Y,N,L)
%Y=randn(544,1);
%N=512;
%L=32;
%CP=32;

CP=length(Y)-N;
alpha=exp(-sqrt(-1)*2*pi/N);
phase=alpha.^([0:N-1]');

DFTM=dftmatrix(N);

%scale constant
scale=sqrt(N);

SDFT=zeros(N,L);
SDFT(:,1)=DFTM*Y(CP+1:N+CP);
%SDFT(:,1)=SDFT(:,1)/scale;
OneV=ones(N,1);

for i=2:L
    offset=Y(CP-i+2)-Y(N+CP-i+2);
    SDFT(:,i)=SDFT(:,i-1).*phase+OneV*offset;
    %SDFT is based on the previous one
end
SDFT=SDFT/scale;
