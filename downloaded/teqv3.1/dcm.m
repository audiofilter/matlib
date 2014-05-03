% DCM TEQ design by minimizing 1/SSNR
% function ...
% [wopt,dopt, deldcvec] = ...
% dcm(respr,NCyclicPrefix,M, delay1, delay2)
% returns the time-domain equalizer, delay and a vector containing the 
% SSNR
% 
%Parameters in this function
% Inputs: 
% h; channel impulse response
% Nb: the target length of the shortened impulse response
% Nw: the number of taps in TEQ
% minDelay: initial search point
% maxDelay: end search point
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
%Version:        @(#)dcteqminimization.m	1.1	05/11/00
%
%The authors are with the Department of Electrical and Computer
%Engineering, The University of Texas at Austin, Austin, TX.
%They can be reached at blu@ece.utexas.edu.
%Biao Lu is also with the Embedded Signal Processing
%Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The "Divide & Conquer" algorithm is from the following book
% Robert Sedgewick, "Algorithms". It divide the TEQ into two-tap TEQs
% and design each two-tap TEQ by a greedy approach. This
% "DC-TEQ-cancellation" is used to cancel the samples of channel impulse
% response. 
%%%%Parameters in this function
%%% Inputs: 
%%% h: a column vector of original channel impulse response
%%% Nb: cyclic prefix
%%% Nw: the number of tap in TEQ
%%% minDelay: the inital search point
%%% maxDelay: the final search point
%%% Outputs: 
%%% bopt: the optimal shortened impulse response which is not required
%%% wopt: the coefficients of TEQ
%%% dopt: the optimal delay
%%% MSEdcmin: the mean squared error
%%% deldcvec: a vector to save the shortening-signal-to-noise ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ...
[wopt,dopt, deldcvec]= dcm(h,Nb,Nw,minDelay,maxDelay,bf)

% open a figure for progress bar
if bf == 1
   [figHndl statusHndl] = setprogbar('Calculating DCM TEQ ...');     
end

	 h = h(:);
     max_ssnren = realmin;

for delay = minDelay:maxDelay
 % update progress bar
 if bf ==1
    updateprogbar(statusHndl,delay-minDelay+1,maxDelay-minDelay);
 end
 
	ImBuild = h;
    EqBuild = [1];
   for j = 1: Nw-1
      % Calculate the convolution matrix
	    H = convmtx(ImBuild,2);
    	Hwin = H(delay+1:delay+Nb+1,:);
 	    Hwall = [H(1:delay,:); H(delay+Nb+2:size(H,1),:)];
      % calculate the matrices A and B
	    A = transpose(Hwall)*Hwall;
        B = transpose(Hwin)*Hwin;
		a1 = A(1,1);
	 a2 = A(1,2);
	 a3 = A(2,2);
	 b1 = B(1,1);
	 b2 = B(1,2);
	 b3 = B(2,2);
     rootscoeff = [a3*b2-a2*b3, a3*b1-a1*b3, a2*b1-a1*b2];

     b =  a3*b1-a1*b3;
     a = a3*b2-a2*b3;

     c = a2*b1-a1*b2;
     gvector(1) = (-b+sqrt(b*b-4*a*c))/(2*a);
     gvector(2) = (-b-sqrt(b*b-4*a*c))/(2*a);

     testg1 = [1, gvector(1)];
     [ssnrEn, tailEn1, sir] = ...
      remainenergy(delay,ImBuild,testg1,Nb+1);
     testg2 = [1, gvector(2)];
     [ssnrEn, tailEn2, sir] = ...
      remainenergy(delay,ImBuild,testg2,Nb+1);
     if tailEn1 < tailEn2
	    ImBuild = conv(ImBuild,testg1);
        EqBuild = conv(EqBuild, testg1);
     else
	    ImBuild = conv(ImBuild,testg2);
        EqBuild = conv(EqBuild, testg2);
     end; %end of if tailEn1 < tailEn2         
   end; % end of for j = 1: Nw-1

   w = EqBuild;
    [ssnrEn, tailEn, sir] = remainenergy(delay,h,w,Nb+1);
    deldcvec(delay) = ssnrEn;
   if ssnrEn  > max_ssnren
      max_ssnren = ssnrEn;
      dopt = delay;
      wopt = w';
   end;
%pause
end;

% close progress bar
if bf ==1
   close(figHndl);
end


