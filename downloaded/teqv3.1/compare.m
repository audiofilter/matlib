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
% They can be reached at ming@ece.utexas.edu.
% Ming Ding is also with the Embedded Signal Processing
% Laboratory in the Dept. of ECE, http://signal.ece.utexas.edu.

clear all
close all
clc

%filename = ['nw17finalsims'];
%filename = ['tmp'];
filename = ['nb32_1'];
%eval(str1(run,:));
channels = 4;
%methods = 4;
methods = [ 1 3 4 5 6  ]; 
%1:UEC,2:UTC,3:MSSNR,4:GEO,5:minISI,6:MBR
nb = 32;
nw = [2:32];
repeats = 1;

% init variables
N = 512;
codingGain = 4.2;
margin = 6;
Dmin = 1;
Dmax = 50;
totalInputPower = 23;
AWGNpower = -140;
barflag = 0;
chflag=0;
%number of iteration per TEQ tap
numIter = 400;

maxiter = length(channels)*length(methods)*length(nw)*length(nb)*repeats;
iter = 0;
totaltime = 0;

for rep = 1:repeats
   for loopNum = channels
      %generate signal,noise, and channel data
      [recNoisySig,receivedSignal,noise,channel,inputSignal,gamma,fs] = ...
         siggen(N,AWGNpower,loopNum,totalInputPower,codingGain,margin,barflag,chflag);
      
      %estimate the power spectrums
      [inputSpecAll, noiseSpecAll, channelGainAll]=...
         specestim(inputSignal,noise,channel,N,barflag);
      
      %calculate SNRs and usable channels
      [subMFBall,subMFB,usedSubs,noiseSpec,channelGain,inputSpec] = ...
         calcSNRs(inputSpecAll,channelGainAll,noiseSpecAll,gamma);
      
      for Nw = nw
         for Nb = nb
            t0 = clock;
            for method = methods
               %updateprogbar(statusHndl,iter,maxiter);
               iter= iter+1;
               
               % chose method and design TEQ
               [B, W, D, MSE, Dv, I,title_str] = selmeth(method,inputSignal,...
                  receivedSignal,noise,channel(1:N),...
                  Nb,Nw,Dmin,Dmax,barflag,N,numIter,inputSpec,noiseSpec,channelGain,...
                  usedSubs,gamma);
               
               % get performance results
               [SSNR, SNR, subSNR,geoSNRfinal,geoSNRmfb,bDMTfinal,bDMTmfb,...
                     RDMTfinal,RDMTmfb,hw,Fh,Fw,colorNoiseaft,Fhw] = ...
                  perform(W,B,channel,D,Nb,N,inputSignal,noise,...
                  channelGainAll,inputSpecAll,noiseSpecAll,margin,codingGain,fs,subMFBall,usedSubs);
               fprintf('\n %i %i %i->%2.2f% ',Nw,Nb,method,100*RDMTfinal/RDMTmfb);
               
               %save results in arrays
               SSNRresults(Nw,Nb,loopNum,method,rep) = SSNR;
               SNRresults(Nw,Nb,loopNum,method,rep) = SNR;
               geoSNRfinalresults(Nw,Nb,loopNum,method,rep) = geoSNRfinal;
               geoSNRmfbresults(Nw,Nb,loopNum,method,rep) = geoSNRmfb;
               bDMTfinalresults(Nw,Nb,loopNum,method,rep) = bDMTfinal;
               bDMTmfbresults(Nw,Nb,loopNum,method,rep) = bDMTmfb;
               RDMTfinalresults(Nw,Nb,loopNum,method,rep) = RDMTfinal;
               RDMTmfbresults(Nw,Nb,loopNum,method,rep) = RDMTmfb;
               
            end
            
            fprintf('\n');
            t1 = clock;
            timeforiter = etime(t1,t0);
            totaltime = totaltime + timeforiter;
            timeleft = totaltime/iter*(maxiter-iter);
            days = floor(timeleft/(60*60*24));
            timedays = timeleft-days*60*60*24;
            hours = floor( timedays / (60*60) );
            timehours = timedays - hours*60*60;
            minutes = floor(timehours / 60);
            timeminutes = timehours - minutes*60;
            seconds = timeminutes;
            fprintf('Time remaining: %2.0f day(s) %2.0f hour(s) %2.0f minute(s) %2.0f second(s)\n',...
               days,hours,minutes,seconds);
         end
      end
   end
   
str2 = ['save ',filename,' SSNRresults SNRresults geoSNRfinalresults '...
      'geoSNRmfbresults bDMTfinalresults bDMTmfbresults ' ...
      'RDMTfinalresults RDMTmfbresults nb nw channels methods'];
eval(str2);
   
end
   

