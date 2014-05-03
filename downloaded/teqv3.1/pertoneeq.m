% pertoneeq implements Per Tone equalizers in a simulated DMT-ADSL system.
%
% z = pertoneeq(P, s)
%
% z: equalizer output ((N x 1) x T ); z(0), ..., z(N - 1)
% P: equalizer coefficients (N x K)
% s: equalizer input ((2*N + K - 1) x T); s(2 - K), ..., s(2*N)
% T: number of Frames
%
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
% Version:      @(#)pertoneeq.m	1.0 01/14/02
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function z = pertoneeq(P, s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% pertoneeq.m
%
% Per tone equalization.
%
% 04/13/2001 Arthur Redfern created
% 06/25/2001 Ming Ding revised
%
% z = pertoneeq(P, s)
%
% z: equalizer output ((N x 1) x T ); z(0), ..., z(N - 1)
% P: equalizer coefficients (N x K)
% s: equalizer input ((2*N + K - 1) x T); s(2 - K), ..., s(2*N)
%
% T: number of Frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of subchannels and equalizer length
[N L] = size(P);
[N2, T]=size(s);

% initialize variables
z = zeros(N, T);

%FFT size is double the number of FEQs
N = 2*N;
scale=sqrt(N);
M = zeros(N, L);


for i=1:T
% received signal filtering matrix
s1 = L+1;
s2 = N + L ;
temp=s(:,i);
for k = 1:L,
    temp2 = fft(temp(s1:s2))/scale;
  
    M(:, k) = temp2;
    
    s1 = s1 - 1;
    s2 = s2 - 1;
end

% equalizer output
for n = 1:N/2,
    z(n,i) = (M(n, :)*P(n, :).').';
end

clear temp

end