 %MSSNR Maximum shortening signal-to-noise ratio TEQ design.
% [W, D, Dv] = MSSNR(H, Nb, Nw, Dmin, Dmax) returns the optimal
% time domain equalizer, and delay. Optimal in the sense of 
% maximizing the shortening signal to noise ratio. Dv is a vector
% containing the remaining tail power for delay values between
% Dmin and Dmax.
%
% H is the channel impulse response. Nb is the target length
% of the shortened impulse response. Nw is the number of taps
% in the TEQ. Dmin and Dmax define the search interval for the 
% optimal delay.
%
% The algorithm is from:
% P. J. W. Melsa, R. C. Younce, and C. E. Rohrs, "Impulse Response
% Shortening for Discrete Multitone Transceivers", IEEE Trans. on
% Comm., vol. 44, pp. 1662-1672, Dec. 1996.

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

function [wopt,dopt,delayVec] = mssnr(h,Nb,Nw,Dmin,Dmax,bf)

% open a figure for progress bar
if bf == 1
   [figHndl statusHndl] = setprogbar('Calculating MSSNR TEQ ...');     
end
% initialize variables
h = h(:);
lambdaopt = 0;
delayVec = ones(1,Dmax);
% channel convolution matrix
H = convmtx(h,Nw);

for delay = Dmin:Dmax % for each delay to be searched
   
  % update progress bar
  if bf == 1
     updateprogbar(statusHndl,delay-Dmin+1,Dmax-Dmin);
  end
  % Hwin: inside the window
  Hwin = H(delay+1:delay+Nb,:);
  % Hwall: outside the window
  Hwall = [H(1:delay,:); H(delay+Nb+1:size(H,1),:)];
  % energy of Hwall
  A = transpose(Hwall)*Hwall;
  % energy of Hwin
  B = transpose(Hwin)*Hwin;
  % Cholesky decomposition
  [sqrtA] = chol(A);
  % composite matrix
  C = inv(sqrtA.') * B * inv(sqrtA);
  [lambda q] = maxeig(C);
  w = inv(sqrtA) * q;
  %end
  
  % save the energy of hwall for the current delay
  delayVec(delay) = lambda;

  if lambda > lambdaopt % if energy is smaller than previous ones
     % save the TEQ, delay and energy
     wopt = w;
     dopt = delay;
     lambdaopt = lambda;
  end
end

% close progress bar
if bf == 1
   close(figHndl);
end

