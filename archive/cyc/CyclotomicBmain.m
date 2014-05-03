%**************************************************************************
%  CYCLOTOMIC POLYNOMIAL (CP) PREFILTER WITH REMEZ EQUALIZER DESIGN PROGRAM
%
%   This program designs a hybrid cascade FIR/FIR linear phase filter.  
%   The first stage is a multiplierless FIR prefilter whose multiplierless
%   subsections are selected from a set of the first 104 cyclotomic polynomials.
%   In this program the second stage is designed using the Remez
%   exchange algorithm.  The resulting hybrid filter has reduced 
%   multiplicative and additive complexity when compared to conventional
%   implementations.  
%  
%                      Richard J. Hartnett 10/18/93 
%
    
%clear;
j=sqrt(-1);echo off;hold off;

%*********DATA FILE LOAD BLOCK*********************************************
%   USE THIS BLOCK ONLY IF YOU HAVE PREVIOUSLY SAVED THE FREQUENCY        * 
%   RESPONSES (Cfreq) AND ROOTS (CycloRoots) into data files called       *
%   Cfreq and CycloRoots.  After having calculated Cfreq and CycloRoots,  *
%   the save command may be used to create these data files.  We          *
%   recommend loading from external data files rather than calculating    *
%   roots and frequency responses each time to speed execution            *
%                                                                         *
%   If you run the code for the first time you will need to "uncomment"   * 
%   the portion of the code in the prefilter "growing" algorithm which    *
%   is the called the "root and frequency response calculation block"     *
%   ("prefilter growing algorithm" is CycgenB)  
%                                                                         *
%load Cfreq;         % stored frequency responses of the                  * 
                    % cyclotomic polynomials                              *
%load CycloRoots;    % stored roots of cyclotomic polynomials             *
%*********END OF DATA FILE LOAD BLOCK**************************************

%**********DATA ENTRY PORTION OF CODE **************************************

% THESE ARE YOUR FILTER CHOICES*********************************************
     LowPass=0;           %1 if lowpass, 0 if not
     BandPass=1;          %1 if bandpass, 0 if not
     MultiBand=0;         %1 if multiband, 0 if not (2 passbands only, please)
% END FILTER CHOICE SECTION*************************************************
ShouldWeight=0;          % 18 Nov 91 change... do you want the prefilter
                         % to have more costly errors near the transition band?
                         % (mainly for IIR equalizers)- put 1 if yes-
                         % Weighting is done in CycIncreaseB

PassRippleSpec=0.15;      % in dB, how much ripple will we allow in the passband
                          % of the prefilter-equalizer cascade

StopAttenSpec=60;         % in dB, what is the minimum stopband attenuation we
                          % want for the prefilter-equalizer cascade

AllowedPreLength=87;      %Maximum allowed prefilter impulse response length

AllowedEqLength=10;        %allowed equalizer impulse response length

AllowedPBAtten=8;         %how much deviation in dB will we allow for
                           %our prefilter in the passband?
                           %For lowpass and bandpass filters, we suggest
                           %6 to 8 dB is a reasonable number.  For
                           %multiband filters, this number needs to be
                           %increased, possibly as high as 15

ReqPreSBAtten=80;          %the stopband attenuation we want to achieve
                            %from our prefilter

TransBandIntrusion=0.1;   %allowed intrusion into transition band
                           %We suggest values in the range of 0.05-0.20
                           %We have obtained good results using the lower
                           %part of this range for narrow LPF's, in the middle
                           %for BPF's, and in the high end for
                           %multiband filters. 


PassStopWt=10^(0.9);          % Relative Stopband/Passband weighting used in
                                % the call to the remez exchange algorithm;
                                % A weight >1 weights stopband errors more than
                                % passband errors- It is this passband-stopband
                                % weighting, together with the length of 
                                % the equalizer, which are the "unknowns" in
                                % the design of a minimal length equalizer.
                                % PassStopWt=10^(1.25) for LPF example
                                % PassStopWt=10^(0.9) for BPF with 0.15 cf
                                % PassStopWt=10^(+1.5) for BPF with 0.20 cf
                                % PassStopWt=10^(+1.5) for Multiband example 
                                 


WtThreshold=10^(-4);            % Any weight below this is set to WtThreshold.
                                % In the Parks-McClellan algorithm, there is a
                                % division by the weighting function, and this 
                                % thresholding avoids numerical difficulties.
                                % For examples used in this paper, we have found
                                % that this value gives good results.

NumPts=1024;               %number of frequency domain points, and
Res=1/NumPts;              %the associated resolution for cyclotomic
                           %polynomial prefilter calculations

NumberOfSamples=NumPts; 

%
if LowPass==1,
  %0-Wp1-Ws1-0.5
   WpOne=0.15; %PASSband edge in terms of fractions of Fs
   WsOne=0.195;  %STOPband edge in terms of fractions of Fs
   WpOneIndex=round(WpOne*NumberOfSamples+0.49);
   WsOneIndex=round(WsOne*NumberOfSamples+0.49);
end; %(if LowPass) 

if BandPass==1,
     % 0-Ws1-Wp1-Wp2-Ws2-0.5

      WsOne=0.105;  %LOWER STOPband edge in terms of fractions of Fs
      WpOne=0.14;   %LOWER PASSband edge in terms of fractions of Fs
      WpTwo=0.16;   %UPPER PASSband edge in terms of fractions of Fs
      WsTwo=0.195;  %UPPER STOPband edge in terms of fractions of Fs

%     WsOne=0.168;    WsOneIndex=round(WsOne*NumberOfSamples+0.49);
%     WsTwo=0.232;    WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
%     WpOne=0.189;    WpOneIndex=round(WpOne*NumberOfSamples+0.49);
%     WpTwo=0.211;    WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);


      WsOneIndex=round(WsOne*NumberOfSamples+0.49);
      WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
      WpOneIndex=round(WpOne*NumberOfSamples+0.49);
      WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);
end; %(if BandPass)

if MultiBand==1,
     % 0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5      just 2 passbands for now
      WsOne=0.165;  %LOWER SB edge in terms of fractions of Fs, region 1 
      WpOne=0.200;   %LOWER PB edge in terms of fractions of Fs, region 1
      WpTwo=0.240;   %UPPER PB edge in terms of fractions of Fs, region 1
      WsTwo=0.275;  %UPPER SB edge in terms of fractions of Fs, region 1
      WsThree=0.33;      %LOWER SB edge in terms of fractions of Fs, region 2
      WpThree=0.36;      %LOWER PB edge in terms of fractions of Fs, region 2
      WpFour=0.39;       %UPPER PB edge in terms of fractions of Fs, region 2
      WsFour=0.42;       %UPPER SB edge in terms of fractions of Fs, region 2
      WsOneIndex=round(WsOne*NumberOfSamples+0.49);
      WpOneIndex=round(WpOne*NumberOfSamples+0.49);
      WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);
      WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
      WsThreeIndex=round(WsThree*NumberOfSamples+0.49);
      WpThreeIndex=round(WpThree*NumberOfSamples+0.49);
      WpFourIndex=min(round(WpFour*NumPts+0.49),NumPts/2+1);
      WsFourIndex=min(round(WsFour*NumPts+0.49),NumPts/2+1);
end; %(if MultiBand)

%**********END OF DATA ENTRY PORTION OF CODE *************************
CycgenB;    % This is the routine which will determine the appropriate CPF
            % prefilter for our specifications...Cyclotomic polynomial freq
            % responses are specified for 0 to Fs.  The routine CycgenB
            % passes the list of "Eligibles" back to this routine, which
            % then forms the prefilter approximation.

%DefineCyclo;% if both CycgenB and CycExhB are commented out, then 
            % you must run DefineCyclo to define the L matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS SECTION ONLY VALID IF YOU ALREADY KNOW WHAT PREFILTER
% YOU WANT....
 
%    Eligibles=[1 1 1 1 2 2 3 3 4 4 6 7 8 8 10 12 12 12 13 15 18 20 25 25 30];
%    Eligibles=[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 6 6 ..
%                7 7 7 7 10 10 10 10 10 10 10 10 10 10 12];
%    Eligibles=[2 2 2 5 7 8 10 11 13 14];
%    Eligibles=[1 1 1 2 2 2 3 4 5 5 10 10 12 14 18 24 30 30 66];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(Eligibles)>1,
    Approx=prod(Cfreq(Eligibles,:));
  else
    Approx=Cfreq(Eligibles,:);
  end;
Approx=Approx/max(abs(Approx));
prefilterimpresp=ifft(Approx);
[Prefilter,w]=freqz(prefilterimpresp,1,NumberOfSamples); %from DC to Fs/2
scale=[0.0,0.5,-100,0];axis(scale);
plot(w/(2*pi),20*log10(abs(Prefilter)));
xlabel('Fraction of Sampling Frequency');ylabel('Magnitude in dB');
grid;title('PREFILTER RESPONSE');
%we print out the final prefilter length 
PreLength=sum(L(Eligibles))-(length(Eligibles)-1)

%********* AT THIS POINT THE PREFILTER DESIGN IS COMPLETE ***************
          
%*** THE CODE THAT FOLLOWS DESIGNS THE EQUALIZER ************************

EqLength=AllowedEqLength;       %The length of the equalizer

                                %  (The approximation will have length 
                                %   PreLength+EqLength-1);

% Now we are matching the frequency axis from 0 to Fs/2 to the
% Prefilter response from 0 to Fs/2 in a table lookup fashion...That is,
% the point NumberOfSamples is roughly Fs/2

Resolution=1/(2*NumberOfSamples);
% Now we set up the table lookup for interpolating between frequency
% domain samples
Lookup(:,1)=[0.0:Resolution:0.5].'; 
Lookup(:,2)=[abs(Prefilter)',abs(Prefilter(NumberOfSamples))].';  

if BandPass==1, %***************BANDPASS BLOCK************************
   %Now we redefine indices so the index range goes from 0-Fs/2 rather
   %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2
      WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);
      WsTwoIndex=round(2*WsTwo*NumberOfSamples+0.49);
      WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
      WpTwoIndex=round(2*WpTwo*NumberOfSamples+0.49);

     StopIndRangeOne=[1:WsOneIndex];
     StopIndRangeTwo=[WsTwoIndex:NumberOfSamples];

%    The numbers shown below (e.g. 99) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers, and they can be changed for increased or decreased
%    resolution as required.) 

     SBResOne=WsOne/99;
     SBResTwo=(.5-WsTwo)/99;
     PBRes=(WpTwo-WpOne)/99;
     StopSpecRangeOne=[0.0:SBResOne:WsOne];
     StopSpecRangeTwo=[WsTwo:SBResTwo:0.5];
     PassSpecRange=[WpOne:PBRes:WpTwo];       
     SpecRange=[StopSpecRangeOne PassSpecRange StopSpecRangeTwo];
     PassbandVector=(1.0./table1(Lookup,PassSpecRange)).';
     ESpecband=[ zeros(1:length(StopSpecRangeOne)) ..
                PassbandVector ..
                 zeros(1:length(StopSpecRangeTwo))];
     WtInverse=[1.0./(table1(Lookup,StopSpecRangeOne))' ..
                 PassbandVector ..
                1.0./(table1(Lookup,StopSpecRangeTwo))'];
end; %IF BANDPASS
%******************************MULTIBAND BLOCK ********************************
if MultiBand==1,
     %0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5

     %Now we redefine indices so the index range goes from 0-Fs/2 rather
     %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2
     WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);
     WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
     WpTwoIndex=round(2*WpTwo*NumberOfSamples+0.49);
     WsTwoIndex=round(2*WsTwo*NumberOfSamples+0.49);
     WsThreeIndex=round(2*WsThree*NumberOfSamples+0.49);
     WpThreeIndex=round(2*WpThree*NumberOfSamples+0.49);
     WpFourIndex=min(round(2*WpFour*NumPts+0.49),NumberOfSamples);
     WsFourIndex=min(round(2*WsFour*NumPts+0.49),NumberOfSamples);

%    The numbers shown below (e.g. 99, 199) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers, and they can be changed for increased or decreased
%    resolution as required.) 

     SBResOne=WsOne/99;
     SBResTwo=(WsThree-WsTwo)/99;
     SBResThree=(.5-WsFour)/99;
     PBResOne=(WpTwo-WpOne)/199;
     PBResTwo=(WpFour-WpThree)/199;
     StopSpecRangeOne=[0.0:SBResOne:WsOne];       %100 lower stopband points
     StopSpecRangeTwo=[WsTwo:SBResTwo:WsThree];   %100  middle stopband points
     StopSpecRangeThree=[WsFour:SBResThree:.5];    %100 upper stopband points

     StopIndRangeOne=[1:WsOneIndex];
     StopIndRangeTwo=[WsTwoIndex:WsThreeIndex];
     StopIndRangeThree=[WsFourIndex:NumberOfSamples];
     PassSpecRangeOne=[WpOne:PBResOne:WpTwo];     %200 lower passband points
     PassSpecRangeTwo=[WpThree:PBResTwo:WpFour];  %200 upper passband points
      
     SpecRange=[StopSpecRangeOne PassSpecRangeOne StopSpecRangeTwo ..
                 PassSpecRangeTwo StopSpecRangeThree];
     PassOne=(1.0./table1(Lookup,(PassSpecRangeOne)))';
     PassTwo=(1.0./table1(Lookup,(PassSpecRangeTwo)))';
     ESpecband=[ zeros(1:length(StopSpecRangeOne)) PassOne ..
                zeros(1:length(StopSpecRangeTwo)) PassTwo ..
                zeros(1:length(StopSpecRangeThree))];
     WtInverse=[1.0./(table1(Lookup,(StopSpecRangeOne)))' ..
               PassOne 1.0./(table1(Lookup,(StopSpecRangeTwo)))' .. 
               PassTwo 1.0./(table1(Lookup,(StopSpecRangeThree)))'];

end; %(if MultiBand)***********************************************************

if LowPass==1, %*****************LOWPASS BLOCK****************************
   % 0-Wp1-Ws1-1

   %Now we redefine indices so the index range goes from 0-Fs/2 rather
   %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2

     WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
     WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);

%    The numbers shown below (e.g. 99, 999) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers.) 

     SBRes=(.5-WsOne)/999;    
     PBRes=WpOne/49;
     StopSpecRange=[WsOne:SBRes:.5];     %1000  stopband points 
     PassSpecRange=[0:PBRes:WpOne];       %50 passband points
     StopIndRange=[WsOneIndex:NumberOfSamples];
     PassOne=(1.0./table1(Lookup,(PassSpecRange)))';
     SpecRange=[PassSpecRange StopSpecRange];
     ESpecband=[PassOne zeros(1:length(StopSpecRange))];
     WtInverse=[PassOne ..
                1.0./(table1(Lookup,(StopSpecRange)))'];

end; %IF LOWPASS *************************************************************


%********************These next two routines (DesRemEq and VerRemEq) can form
%                    the basis of an iterative routine for design of the minimum
%                    length equalizer.  As shown in Figure 3 of the paper, if we
%                    fail to meet our desired specification, the relative
%                    passband/stopband weighting must be altered, and/or the
%                    equalizer length must be increased...then these two 
%                    routines, the design and verify algorithms, can be 
%                    run once again.
%%*******************

DesRemEq;       %we design the length EqLength Remez equalizer with 
                %relative passband/stopband weighting of PassStopWt

VerRemEq;       %now we analyze the length EqLength Remez equalizer with 
                %relative passband/stopband weighting of PassStopWt to see
                %if we met specification
 
% ****END OF MAIN ROUTINE****
