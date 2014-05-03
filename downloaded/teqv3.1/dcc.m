% DCC TEQ design by cancelling the tail of known channel impulse response
% function ...
% [wopt,dopt, deldcvec] = ...
% dcc(respr,NCyclicPrefix,M, delay1, delay2)
% returns the time-domain equalizer, delay and a vector containing the 
% SSNR
% 
%Parameters in this function
% Inputs: 
% respr: a column-vector channel impulse response   
% NCyclicPrefix: the cyclic prefix
% M: the number of taps in TEQ
% delay1: the initial search point
% delay2: the final search point
% Outputs: 
% wopt: the coefficients of TEQ
% dopt: the optimal delay
% deldcvec: a vector to save the shortening-signal-to-noise ratio
%
% The algorithm is from:
% Robert Sedgewick, "Algorithms". It divide the TEQ into two-tap TEQs
% and design each two-tap TEQ by a greedy approach. 

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
% Version:        %W%   %G%
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

function ...
[wopt,dopt, deldcvec] = ...
 dcc(respr,NCyclicPrefix,M, delay1, delay2,bf)
% open a figure for progress bar
if bf == 1
   [figHndl statusHndl] = setprogbar('Calculating DCC TEQ ...');     
end

max_ssnren = realmin;
h = respr(:)';   % h is converted to a row vector

for Delta = delay1:delay2
  % update progress bar
  if bf ==1
     updateprogbar(statusHndl,Delta-delay1+1,delay2-delay1);
  end
  
   ImpBuild = h; 
	EqBuild = [1];
	
   for j = 1:(M-1)
      
         hk = [ImpBuild(1:Delta), ImpBuild(Delta+NCyclicPrefix+2:length(h))];
         hk_1 = [0, ImpBuild(1:Delta-1), ...
                  ImpBuild(Delta+NCyclicPrefix+1:length(h)-1)];
         SecondTap = - sum(hk.*hk_1)/sum(hk_1.^2);
         %SecondTap = -sum_1/sum_2
        ImpBuild = conv(ImpBuild,[1 SecondTap]);
        EqBuild = conv(EqBuild,[1 SecondTap]);

     end;  % end of for j = 1:(M-1)

    w = EqBuild;
    [ssnrEn, tailEn, sir] = ...
      remainenergy(Delta,h',w,NCyclicPrefix);
    deldcvec(Delta) = ssnrEn;
   if ssnrEn > max_ssnren
      max_ssnren = ssnrEn;
      dopt = Delta;
      wopt = w';
   end;

end;

% close progress bar
if bf == 1
   close(figHndl);
end
