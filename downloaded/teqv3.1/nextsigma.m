% nextsigma calculates the averaged NEXT correlation matrix
% [NEXTsigma]= nextsigma(NEXTnoise, N, Nw)
% returns metrix Ak and Bk for the kth subcarriers.

% NEXT noise is in the vector NEXTnoise. N is the FFT size. Nw is the TEQ length.

% NEXTsigma is the averaged NEXT correlation matrix.

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
% Programmers:	Zukang Shen
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [NEXTsigma]= nextsigma(NEXTnoise, N, Nw)

NEXTsigma=reshape(zeros(1,(N+Nw-1)^2),N+Nw-1,N+Nw-1);
for i=1:1%length(NEXTnoise)/N-1
    nexttmp=NEXTnoise(i*N-Nw+2:(i+1)*N).'*NEXTnoise(i*N-Nw+2:(i+1)*N);
    NEXTsigma=NEXTsigma+nexttmp;
end

%NEXTsigma=NEXTsigma/(length(NEXTnoise)/N-1);