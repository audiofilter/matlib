% Sym_MSSNR Maximum shortening signal-to-noise ratio TEQ design.
% [W, D, Dv] = SYM_MSSNR(H, Nb, Nw, Dmin, Dmax) is based on MSSNR.
% SYM_MSSNR arbitrary set the TEQ coefs to be symmetric. It reurns 
% the TEQ coefs in W, optimal delay in D and Dv is a vector
% containing the remaining tail power for delay values between
% Dmin and Dmax.
%
% H is the channel impulse response. Nb is the target length
% of the shortened impulse response. Nw is the number of taps
% in the TEQ. Dmin and Dmax define the search interval for the 
% optimal delay.
%
% The algorithm is from:
% R. K. Martin, C. R. Johnson, Jr, M. Ding, and B. L. Evans,
% "Exploiting Symmetry in Channel Shortening Equalizers",
% Proc. IEEE Int. Conf. on Acoustics, Speech, and Signal Proc.,
% April 6-10, 2003, Hong Kong, China.
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
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Guner Arslan is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [wopt,dopt,delayVec] = sym_mssnr(h,Nb,Nw,Dmin,Dmax,bf)

% open a figure for progress bar
if bf == 1
   [figHndl statusHndl] = setprogbar('Calculating SYM_MSSNR TEQ ...');     
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
  %[sqrtA] = chol(A);
  % composite matrix
  %C = inv(sqrtA.') * B * inv(sqrtA);
  %[lambda q] = maxeig(C);
  %w = inv(sqrtA) * q;
  %end
  
 if rem(Nw,2)==0
  A11 = A(1:Nw/2, 1:Nw/2);
  A12 = A(1:Nw/2, Nw/2+1:Nw);
  A21 = A(Nw/2+1:Nw, 1:Nw/2);
  A22 = A(Nw/2+1:Nw, Nw/2+1:Nw);
  
  B11 = B(1:Nw/2, 1:Nw/2);
  B12 = B(1:Nw/2, Nw/2+1:Nw);
  B21 = B(Nw/2+1:Nw, 1:Nw/2);
  B22 = B(Nw/2+1:Nw, Nw/2+1:Nw);
  
  J = fliplr(eye(size(A11)));
  
  AS = A11 +A12*J+ J'*A21+ J'*A22*J;
  BS = B11 +B12*J+ J'*B21+ J'*B22*J;
  
  [sqrtAS] = chol(AS);
  % composite matrix
  CS = inv(sqrtAS.') * BS * inv(sqrtAS);
  [lambdas qs] = maxeig(CS);
  vs = inv(sqrtAS) * qs;
  
  ws = [vs; J*vs];
  
else
  A11 = A(1:(Nw-1)/2, 1:(Nw-1)/2);
  A12 = A(1:(Nw-1)/2, (Nw+1)/2);
  A13 = A(1:(Nw-1)/2, (Nw+3)/2:Nw);
  A21 = A((Nw+1)/2, 1:(Nw-1)/2);
  A22 = A((Nw+1)/2, (Nw+1)/2);
  A23 = A((Nw+1)/2, (Nw+3)/2:Nw);
  A31 = A((Nw+3)/2:Nw, 1:(Nw-1)/2);
  A32 = A((Nw+3)/2:Nw, (Nw+1)/2);
  A33 = A((Nw+3)/2:Nw, (Nw+3)/2:Nw);
  
  B11 = B(1:(Nw-1)/2, 1:(Nw-1)/2);
  B12 = B(1:(Nw-1)/2, (Nw+1)/2);
  B13 = B(1:(Nw-1)/2, (Nw+3)/2:Nw);
  B21 = B((Nw+1)/2, 1:(Nw-1)/2);
  B22 = B((Nw+1)/2, (Nw+1)/2);
  B23 = B((Nw+1)/2, (Nw+3)/2:Nw);
  B31 = B((Nw+3)/2:Nw, 1:(Nw-1)/2);
  B32 = B((Nw+3)/2:Nw, (Nw+1)/2);
  B33 = B((Nw+3)/2:Nw, (Nw+3)/2:Nw);
  
  J = fliplr(eye(size(A11)));
  
  AS = [[A11+A13*J+J'*A31+J'*A33*J A12+J*A32];
        [A21+A23*J A22]];
    
  BS = [[B11+B13*J+J'*B31+J'*B33*J B12+J*B32];
        [B21+B23*J B22]];
    
  [sqrtAS] = chol(AS);
  % composite matrix
  CS = inv(sqrtAS.') * BS * inv(sqrtAS);
  [lambdas qs] = maxeig(CS);
  vs = inv(sqrtAS) * qs;
  
  ws = [vs; J*(vs(1:(Nw-1)/2))];
end
  
  % save the energy of hwall for the current delay
  delayVec(delay) = lambdas;

  if lambdas > lambdaopt % if energy is smaller than previous ones
     % save the TEQ, delay and energy
     wopt = ws;
     dopt = delay;
     lambdaopt = lambdas;
  end
end



% close progress bar
if bf == 1
   close(figHndl);
end

