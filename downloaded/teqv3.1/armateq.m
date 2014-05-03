% ARMA pole-cancelling TEQ design.
% [bopt, wopt] = armateq(x, y, Nb, Nw, bf) returns the time domain 
% equalizer.
%
% x is the channel input data. Nb is the target length
% of the shortened impulse response, also the number of zeros
% of the identified ARMA model for the channel. Nw is the number of taps
% in the TEQ, also the number of poles of the identified ARMA model for the
% channel plus 1.
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
% Programmers:	Ming Ding
% Version:        %W% %G%
% 
% The authors are with the Department of Electrical and Computer
% Engineering, The University of Texas at Austin, Austin, TX.
% They can be reached at arslan@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function [bopt, wopt] = armateq(x, y, Nb, Nw, bf)

% open a figure for progress bar
if bf ==1
   [figHndl statusHndl] = setprogbar('Calculating ARMA TEQ ...');     
end

% initialize
b = zeros(Nb, 1);
a = zeros(Nw, 1);

% max delay
L = max([Nb Nw]) ;

%only 5000 samples are used here.
x=x(513:5512);
y=y(513:5512);

% data length
N = length(x);


   % form the data matrix
   D = zeros(N - L + 1, Nw + Nb - 1);
   for n = L:N,
      D(n - L + 1, :) = [x(n:-1:(n - Nb +  1)), -y((n - 1):-1:(n - Nw +1))];
   end
   
   y = y.';
   
   % channel estimate
   h = zeros(Nw + Nb  - 1, 1);
   h = pinv(D)*y(L:N);
   
   % separate out MA and AR components
   b = h(1:Nb);
   a = [1; h((Nb + 1):(Nw + Nb - 1))];
   
   bopt = b;
   wopt = a;
  
% close progress bar
if bf ==1
   close(figHndl);
end
