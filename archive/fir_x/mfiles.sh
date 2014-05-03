#!/bin/sh
# This is a shell archive (produced by shar 3.50)
# To extract the files from this archive, save it to a file, remove
# everything above the "!/bin/sh" line above, and type "sh file_name".
#
# made 11/11/1993 23:32 UTC by drea@sierra
# Source directory /export/sierra/drea/Proceedings/hartnett
#
# existing files will NOT be overwritten unless -c is specified
#
# This shar contains:
# length  mode       name
# ------ ---------- ------------------------------------------
#   1071 -rw-rw-rw- ACFgena.m
#   5679 -rw-rw-rw- CycIncreaseB.m
#   9259 -rw-rw-rw- CycgenB.m
#  16291 -rw-rw-rw- CyclotomicBmain.m
#  10377 -rw-rw-rw- DefineCyclo.m
#   3000 -rw-rw-rw- DesRemEq.m
#    158 -rw-rw-rw- ElementOf.m
#    196 -rw-rw-rw- Factorial.m
#   5257 -rw-rw-rw- VerRemEq.m
#    138 -rw-rw-rw- Within.m
#
# ============= ACFgena.m ==============
if test -f 'ACFgena.m' -a X"$1" != X"-c"; then
	echo 'x - skipping ACFgena.m (File already exists)'
else
echo 'x - extracting ACFgena.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'ACFgena.m' &&
function Coefficients=ACFgena(M,N,SlopeOne,SlopeZero);
X
% M controls # deg. of tangency of slope Sigma at (1,1)
% N controls # deg. of tangency of slope Delta at (0,0)
% pass in (M,N,SlopeOne,SlopeZero);
% Example:  ACFgena(1,1,0,0) returns the coefficients
% [-2 3 0], standing for -2x^3 + 3x^2 + 0x^1... (there is no constant term)
X
if(M>0)&(N>0),
X   Constraints=[1 SlopeOne zeros(1:M-1) SlopeZero zeros(1:N-1)].';
end;
if M==0,
X   Constraints=[1 SlopeZero zeros(1:N-1)].';
end;
if N==0,
X    Constraints=[1 SlopeOne zeros(1:M-1)].';
end;
for Row=1:M+1,
X   for Column=1:M+N+1,
X      Test=Factorial(Column+1-Row);
X      if Test>0,
X         A(Row,Column)=Factorial(Column)/Test;
X      else
X         A(Row,Column)=0.0;
X      end;
X   end;
end;
%Now we set the constraints at the origin
for Row=M+2:M+N+1,
X   for Column=1:M+N+1,
X      if((Row-Column)==M+1),
X         A(Row,Column)=Factorial(Column);
X      else
X         A(Row,Column)=0.0;
X      end;
X    end;
end;
A
Coefficients=A\Constraints;
Reversed=Coefficients(length(Coefficients):-1:1);
Coefficients=Reversed;
return;
SHAR_EOF
chmod 0666 ACFgena.m ||
echo 'restore of ACFgena.m failed'
Wc_c="`wc -c < 'ACFgena.m'`"
test 1071 -eq "$Wc_c" ||
	echo 'ACFgena.m: original size 1071, current size' "$Wc_c"
fi
# ============= CycIncreaseB.m ==============
if test -f 'CycIncreaseB.m' -a X"$1" != X"-c"; then
	echo 'x - skipping CycIncreaseB.m (File already exists)'
else
echo 'x - extracting CycIncreaseB.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'CycIncreaseB.m' &&
%**********************************************************************
%  CycIncreaseB
%
%  This routine is the cyclotomic polynomial filter (CPF) "growing"
%  routine described in the paper.
%********************************************************************** 
X
X
X
X
%Add each single polynomial, and calculate which one has the most
%effect on the offending frequency without causing intolerable
%problems elsewhere in the frequency response
X
MostSignificant=[];   %we initialize our decision as to the most significant
X                      %cyclotomic polynomial to the null vector []
MinCostOfAdding=inf;  %just some big number to initialize
X
SaturationDelta=30; %This is the "maximum local improvement factor" in dB we
X                    %will allow in the cost equation.  Otherwise, a zero 
X                    %placed exactly at the frequency of interest would
X                    %cause an infinite improvement in attenuation, and
X                    %would unduly bias our cost equation and require us
X                    %to add this section, regardless of its effect on
X                    %other frequencies in the stopband!!!
X                    %We have obtained good results by using this number,
X                    %but we make no claim as to its optimality.
X
%Now we list the relative costs in the cost equation.  Once again, we
%have obtained good results by using these numbers, but we make no claim
%in regards to their optimality.
X
Alpha=1.0;  % primary determining factor in the cost equation will be
X            % "local stopband attenuation improvement" at the offending
X            % frequency-
Beta=0.1;   %all else being equal, we will favor a filter that helps
X            %other parts of the stopband as well
Gamma=0.1;  %all else being equal, we will be biased toward a shorter filter
X
X            %Sigma is the penalty associated with multiband filters only,
X            %and 
if MultiBand==1,
X   Sigma=0.3;
X  else
X   Sigma=0.0;
end; 
if length(Eligibles)>1,
X   Approx=prod(Cfreq(Eligibles,:));%product of individual cyclotomic
X  else                             %polynomial prefilter frequency responses
X   Approx=Cfreq(Eligibles,:);  %we just have one
end; %product of individual cyclotomic
X                                 
Approx=Approx/max(abs(Approx));  %normalize maximum to 0dB
%**************************************************************
%Now we include a weighting function as a function of frequency
%if appropriate (11/18/91 change)
%
K1=50;
K2=3;
if (LowPass==1)&(ShouldWeight==1),
X   WeightFunction=1+K1*exp(-K2*(1:length(StopIndRegion))/ ..
X                  (length(StopIndRegion)));
X   Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
end;
X
if (BandPass==1)&(ShouldWeight==1),
X   WeightSBOne=1+(K1/exp(K2))*exp(K2*(1:length(1:WsOneIndex))/ ..
X               (length(1:WsOneIndex)));
X   WeightSBTwo=1+K1*exp(-K2*(1:length(WsTwoIndex:NumPts/2+1))/ ..
X               (length(WsTwoIndex:NumPts/2+1)));
X   WeightFunction=[WeightSBOne WeightSBTwo];
X   Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
X   hold off;clg;
X   plot(StopIndRegion,WeightFunction);
end;
X
X
%****************************************************************
X
[MinStopBndAtten,OffendingIndex]=max(20*log10(abs(Approx(StopIndRegion))));
X
%tells which member of StopIndRegion is the offender
OffendingIndex=StopIndRegion(OffendingIndex); %reindexes to frequency axis
MinStopBndAtten=-MinStopBndAtten;
%difference of average passband attenuations (we want it small)
X
X
for Addition=1:length(OriginalEligibles),
X           
X     KeepIndices=[Eligibles OriginalEligibles(Addition)];
X     AddedCfreq=Cfreq(OriginalEligibles(Addition),:);
X 
X     Approx=prod(Cfreq(KeepIndices,:));
X     Approx=Approx/max(abs(Approx));   %normalize to 0dB
%% added 12/1/91
X     if ShouldWeight==1,
X        Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
X     end;
X
X     if MultiBand==1,
X        %difference of average passband attenuations
X        MultiBandDelta=abs(mean(20*log10(abs(Approx(PassRegionOne)))) ..
X                        - mean(20*log10(abs(Approx(PassRegionTwo)))));
X       else
X        MultiBandDelta=0.0;
X     end;
X
X   % now scan over stopband and see what "improvement" we have done
X   % in terms of stopband performance
X     
X     StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));
X     PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
X     SBAforOffendingFreq=-20*log10(abs(Approx(OffendingIndex)));
X
X    %Now, how much did we improve response at the offending frequency?
X
X     OffendFrqDelta=SBAforOffendingFreq-MinStopBndAtten;
X     OffendFrqDelta=min(OffendFrqDelta,SaturationDelta);
X
X    %Now, how much did we improve or degrade the overall stopband??
X
X     StopbandDelta=StopBndAtten-MinStopBndAtten;
X
X     if PassBndAtten<=AllowedPBAtten,   %Don't violate the
X                                        %allowed passband attenuation
X        ApxLength=sum(L(KeepIndices))-(length(KeepIndices)-1);
X        if ApxLength<=AllowedPreLength, %Don't violate the 
X                                        %constraint on our prefilter length
X           %This is the cost in length of adding this polynomial
X           LengthCost=L(OriginalEligibles(Addition));
X           CostOfAdding=-Alpha*OffendFrqDelta-Beta*StopbandDelta ..
X                         +Gamma*LengthCost+Sigma*MultiBandDelta;
X           if CostOfAdding<MinCostOfAdding,
X              MostSignificant=OriginalEligibles(Addition);
X              MinCostOfAdding=CostOfAdding;
X           end; %if
X         end;  %if
X       end;  %if
end;  %for
X           
%Now append the most significant to the vector of eligibles
Eligibles=[Eligibles MostSignificant];
SHAR_EOF
chmod 0666 CycIncreaseB.m ||
echo 'restore of CycIncreaseB.m failed'
Wc_c="`wc -c < 'CycIncreaseB.m'`"
test 5679 -eq "$Wc_c" ||
	echo 'CycIncreaseB.m: original size 5679, current size' "$Wc_c"
fi
# ============= CycgenB.m ==============
if test -f 'CycgenB.m' -a X"$1" != X"-c"; then
	echo 'x - skipping CycgenB.m (File already exists)'
else
echo 'x - extracting CycgenB.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'CycgenB.m' &&
%*******************************************************************
% CycgenB
%
% This routine is the cyclotomic polynomial prefilter design
% routine- This is a separate MATLAB M-File.
%******************************************************************* 
DefineCyclo;  %simply defines matrix C and vector L
X              %where row k of matrix C corresponds to the
X              %kth cyclotomic polynomial, and the kth element
X              %of L corresponds to the length of the polynomial
X
if LowPass==1,
X       
X       TransBand=WsOne-WpOne;
X       Epsilon=TransBandIntrusion*TransBand;
X       ProhibitBandOne=[0.0 WsOne-Epsilon];  %region where we prohibit
X                                             %polynomial roots
X       ProhibitBandTwo=[inf -inf];   %second prohibit band is non-existent
X       StopIndRegion=[WsOneIndex:NumPts/2+1];  
X       PassIndRegion=[1:WpOneIndex];
end;
if BandPass==1,
X      TransBandOne=WpOne-WsOne;
X      TransBandTwo=WsTwo-WpTwo;
X      EpsilonOne=TransBandIntrusion*TransBandOne;
X      EpsilonTwo=TransBandIntrusion*TransBandTwo;
X      ProhibitBandOne=[WsOne+EpsilonOne WsTwo-EpsilonTwo];
X      ProhibitBandTwo=[inf -inf];   %second prohibit band is non-existent
X      StopIndRegion=[1:WsOneIndex WsTwoIndex:NumPts/2+1];
X      PassIndRegion=[WpOneIndex:WpTwoIndex];
end;
if MultiBand==1,  %two passbands for now
X      %   0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5
X      TransBandOne=WpOne-WsOne; 
X      TransBandTwo=WsTwo-WpTwo;
X      TransBandThree=WpThree-WsThree; 
X      TransBandFour=WsFour-WpFour;
X      EpsilonOne=TransBandIntrusion*TransBandOne;
X      EpsilonTwo=TransBandIntrusion*TransBandTwo;
X      EpsilonThree=TransBandIntrusion*TransBandThree;
X      EpsilonFour=TransBandIntrusion*TransBandFour;
X      ProhibitBandOne=[WsOne+EpsilonOne WsTwo-EpsilonTwo];
X      ProhibitBandTwo=[WsThree+EpsilonThree WsFour-EpsilonFour];
X
X      StopIndRegion=[1:WsOneIndex WsTwoIndex:WsThreeIndex ..
X                     WsFourIndex:NumPts/2+1]; % NumPts/2+1 is Fs/2
X      PassRegionOne=[max(WpOneIndex,1):WpTwoIndex];
X      PassRegionTwo=[WpThreeIndex:WpFourIndex];
X      PassIndRegion=[PassRegionOne PassRegionTwo];
end;
X
%the reverse index is used to "reverse" the row vector associated with 
%each cyclotomic polynomial prior to calculating the roots.  Otherwise
%we end up with lots of roots at the z-plane origin which do not play
%a part in our design method.
X
ReverseIndex=length(C(1,:)):-1:1;
X
% inf is "infinity"
CMOne=inf;CMTwo=inf;CMThree=inf;CMFour=inf;
CPOne=[];CPTwo=[];CPThree=[];CPFour=[];Eligibles=[];
X
for Index=1:104,
X    %ROOT AND FREQUENCY RESPONSE CALCULATION BLOCK****************************
X    %  USE THIS BLOCK ONLY IF YOU ARE INTERESTED IN CALCULATING FREQUENCY    * 
X    %  RESPONSES AND ROOTS FOR THE FIRST TIME FOR THE CYCLOTOMIC             * 
X    %  POLYNOMIALS.  AFTER THE FIRST TIME, WE RECOMMEND YOU SAVE ROOTS       *
X    %  (CycloRoots) AND FREQUENCY RESPONSES (Cfreq) TO EXTERNAL DATA FILE,   * 
X    %  SO YOU DO NOT HAVE TO RECALCULATE THEM EACH TIME.  LOADING THESE DATA *
X    %  FILES SPEEDS EXECUTION
X    %
X       Index  
X       [junk,w]=freqz(C(Index,:),1,NumPts,'whole');
X       Cfreq(Index,:)=(junk.')/max(abs(junk));  %non-conjugate transpose
X       WhichOne=sprintf('Cyclotomic Polynomial %g',Index);
X       plot(0:Res:1-Res,20*log10(abs(Cfreq(Index,:))));
X       title(WhichOne);
X       grid;
X    %   pause;
X    %  (loading from external data file speeds execution considerably!!)
X       ActualRoots=(roots(C(Index,ReverseIndex))).';
X       CycloRoots(Index,:)=[ActualRoots zeros(length(ActualRoots)+1:105)];
X    %END ROOT AND FREQUENCY RESPONSE CALCULATION BLOCK**********************                         
X
X   CycloFracs=angle(CycloRoots(Index,1:L(Index)-1))/(2*pi); %a vector 
X   %in terms of fractions of Fs
X
X   Flag=1;
X   for RootIndex=1:L(Index)-1,
X      if Flag==1,
X         if (Within(CycloFracs(RootIndex),ProhibitBandOne)==1)| ..
X            (Within(CycloFracs(RootIndex),ProhibitBandTwo)==1),
X            Flag=0;
X         end;
X      end;
X    end;
X    if Flag==1, %meaning it is an eligible polynomial
X       sprintf('OK TO CHOOSE Cyclotomic Polynomial %g',Index)
X       Eligibles=[Eligibles Index]; %append Index to the list of Eligibles
X
X       if LowPass==1,
X          RCMeasureOne=min(abs(CycloFracs-WpOne));
X          if RCMeasureOne<CMOne,
X             CMOne=RCMeasureOne;
X             CPOne=Index;
X          end;
X        end;
X        if (BandPass==1)|(MultiBand==1),
X           RCMeasureOne=min(abs(CycloFracs-WpOne));
X           RCMeasureTwo=min(abs(CycloFracs-WpTwo));
X           if RCMeasureOne<CMOne,
X              CMOne=RCMeasureOne;
X              CPOne=Index;
X           end;
X           if RCMeasureTwo<CMTwo,
X              CMTwo=RCMeasureTwo;
X              CPTwo=Index;
X           end;
X        end;
X        if MultiBand==1, %we have possibly 4 critical polynomials
X           RCMeasureThree=min(abs(CycloFracs-WpThree));
X           RCMeasureFour=min(abs(CycloFracs-WpFour));
X           if RCMeasureThree<CMThree,
X              CMThree=RCMeasureThree;
X              CPThree=Index;
X           end;
X           if RCMeasureFour<CMFour,
X              CMFour=RCMeasureFour;
X              CPFour=Index;
X           end;
X        end; %if Multiband....             
X    end; %if Flag==1 (meaning an eligible polynomial
end;  %for Index...
%now we are going to get all criticals, but nothing twice
CriticalPolys=sort([CPOne CPTwo CPThree CPFour])
IndexDelete=[];
for Counter=1:length(CriticalPolys)-1,
X   if CriticalPolys(Counter)==CriticalPolys(Counter+1),
X      IndexDelete=[IndexDelete Counter];  %forming indices for later deletion
X   end;
end;
CriticalSet=CriticalPolys;
CriticalSet(:,IndexDelete)=[];      %now we have everything but
X                                    %nothing twice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This next portion of the code uses a very short function 
% called ElementOf, which I included in my toolbox.  It just takes
% as input parameters some number and some vector, and checks to
% see if that number is an element of the vector.  The function returns
% 1 if it is an element, and 0 if not.  I have duplicated the function
% here for your convenience since it is used below.
%
% function In = ElementOf(Number,Vector)
% In=0;L=Vector(Vector==Number);
% if length(L)>0,
%     In=1;
%  end;
%  return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (LowPass==1)|(BandPass==1),
X   if ElementOf(2,CriticalSet)~=1,  %meaning C(2) not in CriticalSet,
X      CriticalSet=[2 CriticalSet];  %we'll add it!  
X   end;
X   if (BandPass==1),
X     if ElementOf(1,CriticalSet)~=1,  %meaning C(1) not in CriticalSet
X       CriticalSet=[1 CriticalSet];   %we'll add it!  
X      end;
X   end;
end;
X
OriginalEligibles=Eligibles;
if length(Eligibles)>1,
X   Approx=prod(Cfreq(Eligibles,:));%product of individual cyclotomic
X  else                             %polynomial prefilter frequency responses,
X   Approx=Cfreq(Eligibles,:);      %or we just have one
end; %product of individual cyclotomic
Approx=Approx/max(abs(Approx));
PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
%  if we cascade all eligibles and our filter is too long or our 
%  passband attenuation is too large, we'll start building from
%  the critical set
if ((sum(L(Eligibles))-(length(Eligibles)-1))>AllowedPreLength)| ..
X    (PassBndAtten>AllowedPBAtten),
X    Eligibles=CriticalSet;
X    if length(Eligibles)>1,
X      Approx=prod(Cfreq(Eligibles,:));
X    else                             
X      Approx=Cfreq(Eligibles,:);  
X    end; %product of individual cyclotomic
X    Approx=Approx/max(abs(Approx));
X    PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
X    if (PassBndAtten>AllowedPBAtten),
X       if (BandPass==1),
X          CriticalSet=[1 2];
X       end;
X       if LowPass==1,
X          CriticalSet=[2];
X       end;
X    end;
X    Eligibles=CriticalSet;
end;
MostSignificant=99999;  %just any number will do here... 
X
if length(Eligibles)>1,
X   Approx=prod(Cfreq(Eligibles,:));
X  else
X   Approx=Cfreq(Eligibles,:);
end;
Approx=Approx/max(abs(Approx));
hold off;
plot(0:Res:1-Res,20*log10(abs(Approx)));
StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));
X
X % NOW WE ADD TO THE DESIRED LENGTH
X % We will continue to build onto our prefilter until:
X %    1- we exceed the maximum allowed prefilter length, or
X %    2- our "growing" algorithm determines that the best decision
X %       is simply not to add another subsection at all (probably
X %       because at some point in the process, the addition of any
X %       of the eligible CPF subsections would cause a passband 
X %       attenuation violation), or
X %    3- we achieve our desired goal of prefilter stopband attenuation-
X    
X   while ((sum(L(Eligibles))-(length(Eligibles)-1))<AllowedPreLength)& ..
X         (length(MostSignificant)~=0)&(ReqPreSBAtten>StopBndAtten),
X
X      CycIncreaseB;
X      if length(Eligibles)>1,
X         Approx=prod(Cfreq(Eligibles,:));
X      else
X         Approx=Cfreq(Eligibles,:);
X      end;
X      Approx=Approx/max(abs(Approx));
X      StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));
X      hold off;plot(0:Res:1-Res,20*log10(abs(Approx)));
X      Eligibles'     %This just lists the total vector of 
X                     %CP subsections as we continue to build
X   end;
X
X
X
X
X
SHAR_EOF
chmod 0666 CycgenB.m ||
echo 'restore of CycgenB.m failed'
Wc_c="`wc -c < 'CycgenB.m'`"
test 9259 -eq "$Wc_c" ||
	echo 'CycgenB.m: original size 9259, current size' "$Wc_c"
fi
# ============= CyclotomicBmain.m ==============
if test -f 'CyclotomicBmain.m' -a X"$1" != X"-c"; then
	echo 'x - skipping CyclotomicBmain.m (File already exists)'
else
echo 'x - extracting CyclotomicBmain.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'CyclotomicBmain.m' &&
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
X    
%clear;
j=sqrt(-1);echo off;hold off;
X
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
X                    % cyclotomic polynomials                              *
%load CycloRoots;    % stored roots of cyclotomic polynomials             *
%*********END OF DATA FILE LOAD BLOCK**************************************
X
%**********DATA ENTRY PORTION OF CODE **************************************
X
% THESE ARE YOUR FILTER CHOICES*********************************************
X     LowPass=0;           %1 if lowpass, 0 if not
X     BandPass=1;          %1 if bandpass, 0 if not
X     MultiBand=0;         %1 if multiband, 0 if not (2 passbands only, please)
% END FILTER CHOICE SECTION*************************************************
ShouldWeight=0;          % 18 Nov 91 change... do you want the prefilter
X                         % to have more costly errors near the transition band?
X                         % (mainly for IIR equalizers)- put 1 if yes-
X                         % Weighting is done in CycIncreaseB
X
PassRippleSpec=0.15;      % in dB, how much ripple will we allow in the passband
X                          % of the prefilter-equalizer cascade
X
StopAttenSpec=60;         % in dB, what is the minimum stopband attenuation we
X                          % want for the prefilter-equalizer cascade
X
AllowedPreLength=87;      %Maximum allowed prefilter impulse response length
X
AllowedEqLength=10;        %allowed equalizer impulse response length
X
AllowedPBAtten=8;         %how much deviation in dB will we allow for
X                           %our prefilter in the passband?
X                           %For lowpass and bandpass filters, we suggest
X                           %6 to 8 dB is a reasonable number.  For
X                           %multiband filters, this number needs to be
X                           %increased, possibly as high as 15
X
ReqPreSBAtten=80;          %the stopband attenuation we want to achieve
X                            %from our prefilter
X
TransBandIntrusion=0.1;   %allowed intrusion into transition band
X                           %We suggest values in the range of 0.05-0.20
X                           %We have obtained good results using the lower
X                           %part of this range for narrow LPF's, in the middle
X                           %for BPF's, and in the high end for
X                           %multiband filters. 
X
X
PassStopWt=10^(0.9);          % Relative Stopband/Passband weighting used in
X                                % the call to the remez exchange algorithm;
X                                % A weight >1 weights stopband errors more than
X                                % passband errors- It is this passband-stopband
X                                % weighting, together with the length of 
X                                % the equalizer, which are the "unknowns" in
X                                % the design of a minimal length equalizer.
X                                % PassStopWt=10^(1.25) for LPF example
X                                % PassStopWt=10^(0.9) for BPF with 0.15 cf
X                                % PassStopWt=10^(+1.5) for BPF with 0.20 cf
X                                % PassStopWt=10^(+1.5) for Multiband example 
X                                 
X
X
WtThreshold=10^(-4);            % Any weight below this is set to WtThreshold.
X                                % In the Parks-McClellan algorithm, there is a
X                                % division by the weighting function, and this 
X                                % thresholding avoids numerical difficulties.
X                                % For examples used in this paper, we have found
X                                % that this value gives good results.
X
NumPts=1024;               %number of frequency domain points, and
Res=1/NumPts;              %the associated resolution for cyclotomic
X                           %polynomial prefilter calculations
X
NumberOfSamples=NumPts; 
X
%
if LowPass==1,
X  %0-Wp1-Ws1-0.5
X   WpOne=0.15; %PASSband edge in terms of fractions of Fs
X   WsOne=0.195;  %STOPband edge in terms of fractions of Fs
X   WpOneIndex=round(WpOne*NumberOfSamples+0.49);
X   WsOneIndex=round(WsOne*NumberOfSamples+0.49);
end; %(if LowPass) 
X
if BandPass==1,
X     % 0-Ws1-Wp1-Wp2-Ws2-0.5
X
X      WsOne=0.105;  %LOWER STOPband edge in terms of fractions of Fs
X      WpOne=0.14;   %LOWER PASSband edge in terms of fractions of Fs
X      WpTwo=0.16;   %UPPER PASSband edge in terms of fractions of Fs
X      WsTwo=0.195;  %UPPER STOPband edge in terms of fractions of Fs
X
%     WsOne=0.168;    WsOneIndex=round(WsOne*NumberOfSamples+0.49);
%     WsTwo=0.232;    WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
%     WpOne=0.189;    WpOneIndex=round(WpOne*NumberOfSamples+0.49);
%     WpTwo=0.211;    WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);
X
X
X      WsOneIndex=round(WsOne*NumberOfSamples+0.49);
X      WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
X      WpOneIndex=round(WpOne*NumberOfSamples+0.49);
X      WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);
end; %(if BandPass)
X
if MultiBand==1,
X     % 0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5      just 2 passbands for now
X      WsOne=0.165;  %LOWER SB edge in terms of fractions of Fs, region 1 
X      WpOne=0.200;   %LOWER PB edge in terms of fractions of Fs, region 1
X      WpTwo=0.240;   %UPPER PB edge in terms of fractions of Fs, region 1
X      WsTwo=0.275;  %UPPER SB edge in terms of fractions of Fs, region 1
X      WsThree=0.33;      %LOWER SB edge in terms of fractions of Fs, region 2
X      WpThree=0.36;      %LOWER PB edge in terms of fractions of Fs, region 2
X      WpFour=0.39;       %UPPER PB edge in terms of fractions of Fs, region 2
X      WsFour=0.42;       %UPPER SB edge in terms of fractions of Fs, region 2
X      WsOneIndex=round(WsOne*NumberOfSamples+0.49);
X      WpOneIndex=round(WpOne*NumberOfSamples+0.49);
X      WpTwoIndex=round(WpTwo*NumberOfSamples+0.49);
X      WsTwoIndex=round(WsTwo*NumberOfSamples+0.49);
X      WsThreeIndex=round(WsThree*NumberOfSamples+0.49);
X      WpThreeIndex=round(WpThree*NumberOfSamples+0.49);
X      WpFourIndex=min(round(WpFour*NumPts+0.49),NumPts/2+1);
X      WsFourIndex=min(round(WsFour*NumPts+0.49),NumPts/2+1);
end; %(if MultiBand)
X
%**********END OF DATA ENTRY PORTION OF CODE *************************
CycgenB;    % This is the routine which will determine the appropriate CPF
X            % prefilter for our specifications...Cyclotomic polynomial freq
X            % responses are specified for 0 to Fs.  The routine CycgenB
X            % passes the list of "Eligibles" back to this routine, which
X            % then forms the prefilter approximation.
X
%DefineCyclo;% if both CycgenB and CycExhB are commented out, then 
X            % you must run DefineCyclo to define the L matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS SECTION ONLY VALID IF YOU ALREADY KNOW WHAT PREFILTER
% YOU WANT....
X 
%    Eligibles=[1 1 1 1 2 2 3 3 4 4 6 7 8 8 10 12 12 12 13 15 18 20 25 25 30];
%    Eligibles=[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 6 6 ..
%                7 7 7 7 10 10 10 10 10 10 10 10 10 10 12];
%    Eligibles=[2 2 2 5 7 8 10 11 13 14];
%    Eligibles=[1 1 1 2 2 2 3 4 5 5 10 10 12 14 18 24 30 30 66];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X
if length(Eligibles)>1,
X    Approx=prod(Cfreq(Eligibles,:));
X  else
X    Approx=Cfreq(Eligibles,:);
X  end;
Approx=Approx/max(abs(Approx));
prefilterimpresp=ifft(Approx);
[Prefilter,w]=freqz(prefilterimpresp,1,NumberOfSamples); %from DC to Fs/2
scale=[0.0,0.5,-100,0];axis(scale);
plot(w/(2*pi),20*log10(abs(Prefilter)));
xlabel('Fraction of Sampling Frequency');ylabel('Magnitude in dB');
grid;title('PREFILTER RESPONSE');
%we print out the final prefilter length 
PreLength=sum(L(Eligibles))-(length(Eligibles)-1)
X
%********* AT THIS POINT THE PREFILTER DESIGN IS COMPLETE ***************
X          
%*** THE CODE THAT FOLLOWS DESIGNS THE EQUALIZER ************************
X
EqLength=AllowedEqLength;       %The length of the equalizer
X
X                                %  (The approximation will have length 
X                                %   PreLength+EqLength-1);
X
% Now we are matching the frequency axis from 0 to Fs/2 to the
% Prefilter response from 0 to Fs/2 in a table lookup fashion...That is,
% the point NumberOfSamples is roughly Fs/2
X
Resolution=1/(2*NumberOfSamples);
% Now we set up the table lookup for interpolating between frequency
% domain samples
Lookup(:,1)=[0.0:Resolution:0.5].'; 
Lookup(:,2)=[abs(Prefilter)',abs(Prefilter(NumberOfSamples))].';  
X
if BandPass==1, %***************BANDPASS BLOCK************************
X   %Now we redefine indices so the index range goes from 0-Fs/2 rather
X   %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2
X      WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);
X      WsTwoIndex=round(2*WsTwo*NumberOfSamples+0.49);
X      WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
X      WpTwoIndex=round(2*WpTwo*NumberOfSamples+0.49);
X
X     StopIndRangeOne=[1:WsOneIndex];
X     StopIndRangeTwo=[WsTwoIndex:NumberOfSamples];
X
%    The numbers shown below (e.g. 99) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers, and they can be changed for increased or decreased
%    resolution as required.) 
X
X     SBResOne=WsOne/99;
X     SBResTwo=(.5-WsTwo)/99;
X     PBRes=(WpTwo-WpOne)/99;
X     StopSpecRangeOne=[0.0:SBResOne:WsOne];
X     StopSpecRangeTwo=[WsTwo:SBResTwo:0.5];
X     PassSpecRange=[WpOne:PBRes:WpTwo];       
X     SpecRange=[StopSpecRangeOne PassSpecRange StopSpecRangeTwo];
X     PassbandVector=(1.0./table1(Lookup,PassSpecRange)).';
X     ESpecband=[ zeros(1:length(StopSpecRangeOne)) ..
X                PassbandVector ..
X                 zeros(1:length(StopSpecRangeTwo))];
X     WtInverse=[1.0./(table1(Lookup,StopSpecRangeOne))' ..
X                 PassbandVector ..
X                1.0./(table1(Lookup,StopSpecRangeTwo))'];
end; %IF BANDPASS
%******************************MULTIBAND BLOCK ********************************
if MultiBand==1,
X     %0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5
X
X     %Now we redefine indices so the index range goes from 0-Fs/2 rather
X     %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2
X     WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);
X     WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
X     WpTwoIndex=round(2*WpTwo*NumberOfSamples+0.49);
X     WsTwoIndex=round(2*WsTwo*NumberOfSamples+0.49);
X     WsThreeIndex=round(2*WsThree*NumberOfSamples+0.49);
X     WpThreeIndex=round(2*WpThree*NumberOfSamples+0.49);
X     WpFourIndex=min(round(2*WpFour*NumPts+0.49),NumberOfSamples);
X     WsFourIndex=min(round(2*WsFour*NumPts+0.49),NumberOfSamples);
X
%    The numbers shown below (e.g. 99, 199) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers, and they can be changed for increased or decreased
%    resolution as required.) 
X
X     SBResOne=WsOne/99;
X     SBResTwo=(WsThree-WsTwo)/99;
X     SBResThree=(.5-WsFour)/99;
X     PBResOne=(WpTwo-WpOne)/199;
X     PBResTwo=(WpFour-WpThree)/199;
X     StopSpecRangeOne=[0.0:SBResOne:WsOne];       %100 lower stopband points
X     StopSpecRangeTwo=[WsTwo:SBResTwo:WsThree];   %100  middle stopband points
X     StopSpecRangeThree=[WsFour:SBResThree:.5];    %100 upper stopband points
X
X     StopIndRangeOne=[1:WsOneIndex];
X     StopIndRangeTwo=[WsTwoIndex:WsThreeIndex];
X     StopIndRangeThree=[WsFourIndex:NumberOfSamples];
X     PassSpecRangeOne=[WpOne:PBResOne:WpTwo];     %200 lower passband points
X     PassSpecRangeTwo=[WpThree:PBResTwo:WpFour];  %200 upper passband points
X      
X     SpecRange=[StopSpecRangeOne PassSpecRangeOne StopSpecRangeTwo ..
X                 PassSpecRangeTwo StopSpecRangeThree];
X     PassOne=(1.0./table1(Lookup,(PassSpecRangeOne)))';
X     PassTwo=(1.0./table1(Lookup,(PassSpecRangeTwo)))';
X     ESpecband=[ zeros(1:length(StopSpecRangeOne)) PassOne ..
X                zeros(1:length(StopSpecRangeTwo)) PassTwo ..
X                zeros(1:length(StopSpecRangeThree))];
X     WtInverse=[1.0./(table1(Lookup,(StopSpecRangeOne)))' ..
X               PassOne 1.0./(table1(Lookup,(StopSpecRangeTwo)))' .. 
X               PassTwo 1.0./(table1(Lookup,(StopSpecRangeThree)))'];
X
end; %(if MultiBand)***********************************************************
X
if LowPass==1, %*****************LOWPASS BLOCK****************************
X   % 0-Wp1-Ws1-1
X
X   %Now we redefine indices so the index range goes from 0-Fs/2 rather
X   %than 0-Fs since I now have "NumberOfSamples" extending from 0 to Fs/2
X
X     WpOneIndex=round(2*WpOne*NumberOfSamples+0.49);
X     WsOneIndex=round(2*WsOne*NumberOfSamples+0.49);
X
%    The numbers shown below (e.g. 99, 999) are just one less than the number
%    of points at which we wish to specify the magnitude characteristics to
%    the Remez exchange algorithm.  (There is nothing particularly "magic" about
%    these numbers.) 
X
X     SBRes=(.5-WsOne)/999;    
X     PBRes=WpOne/49;
X     StopSpecRange=[WsOne:SBRes:.5];     %1000  stopband points 
X     PassSpecRange=[0:PBRes:WpOne];       %50 passband points
X     StopIndRange=[WsOneIndex:NumberOfSamples];
X     PassOne=(1.0./table1(Lookup,(PassSpecRange)))';
X     SpecRange=[PassSpecRange StopSpecRange];
X     ESpecband=[PassOne zeros(1:length(StopSpecRange))];
X     WtInverse=[PassOne ..
X                1.0./(table1(Lookup,(StopSpecRange)))'];
X
end; %IF LOWPASS *************************************************************
X
X
%********************These next two routines (DesRemEq and VerRemEq) can form
%                    the basis of an iterative routine for design of the minimum
%                    length equalizer.  As shown in Figure 3 of the paper, if we
%                    fail to meet our desired specification, the relative
%                    passband/stopband weighting must be altered, and/or the
%                    equalizer length must be increased...then these two 
%                    routines, the design and verify algorithms, can be 
%                    run once again.
%%*******************
X
DesRemEq;       %we design the length EqLength Remez equalizer with 
X                %relative passband/stopband weighting of PassStopWt
X
VerRemEq;       %now we analyze the length EqLength Remez equalizer with 
X                %relative passband/stopband weighting of PassStopWt to see
X                %if we met specification
X 
% ****END OF MAIN ROUTINE****
SHAR_EOF
chmod 0666 CyclotomicBmain.m ||
echo 'restore of CyclotomicBmain.m failed'
Wc_c="`wc -c < 'CyclotomicBmain.m'`"
test 16291 -eq "$Wc_c" ||
	echo 'CyclotomicBmain.m: original size 16291, current size' "$Wc_c"
fi
# ============= DefineCyclo.m ==============
if test -f 'DefineCyclo.m' -a X"$1" != X"-c"; then
	echo 'x - skipping DefineCyclo.m (File already exists)'
else
echo 'x - extracting DefineCyclo.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'DefineCyclo.m' &&
%**************************************************************
%  SUBROUTINE DefineCyclo - A DESCRIPTION
%
%  This subroutine defines each of the 104 cyclotomic
%  polynomials as derived using their properties.  For instance, 
%  C(8) is 1 + z^(-4) and is represented by the vector [1 0 0 0 1].
%  The vector L is a vector of lengths,i.e. L(k) is the length 
%  of the kth cyclotomic polynomial impulse response, so L(8)=5.
%                     
%***************************************************************
C(1,:)=[1 -1 zeros(3:105)];L(1)=2;
C(2,:)=[1 1 zeros(3:105)];L(2)=2;
C(3,:)=[1 1 1 zeros(4:105)];L(3)=3;
C(4,:)=[1 0 1 zeros(4:105)];L(4)=3;
C(5,:)=[ones(1:5) zeros(6:105)];L(5)=5;
C(6,:)=[1 -1 1 zeros(4:105)];L(6)=3;
C(7,:)=[ones(1:7) zeros(8:105)];L(7)=7;
C(8,:)=[1 0 0 0 1 zeros(6:105)];L(8)=5;
C(9,:)=[1 0 0 1 0 0 1 zeros(8:105)];L(9)=7;
C(10,:)=[1 -1 1 -1 1 zeros(6:105)];L(10)=5;
C(11,:)=[ones(1:11) zeros(12:105)];L(11)=11;
C(12,:)=[1 0 -1 0 1 zeros(6:105)];L(12)=5;
C(13,:)=[ones(1:13) zeros(14:105)];L(13)=13;
C(14,:)=[1 -1 1 -1 1 -1 1 zeros(8:105)];L(14)=7;
C(15,:)=[1 -1 0 1 -1 1 0 -1 1 zeros(10:105)];L(15)=9;
C(16,:)=[1 0 0 0 0 0 0 0 1 zeros(10:105)];L(16)=9;
C(17,:)=[ones(1:17) zeros(18:105)];L(17)=17;
C(18,:)=[1 0 0 -1 0 0 1 zeros(8:105)];L(18)=7;
C(19,:)=[ones(1:19) zeros(20:105)];L(19)=19;
C(20,:)=[1 0 -1 0 1 0 -1 0 1 zeros(10:105)];L(20)=9;
C(21,:)=[1 -1 0 1 -1 0 1 0 -1 1 0 -1 1 zeros(14:105)];L(21)=13;
C(22,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(12:105)];L(22)=11;
C(23,:)=[ones(1:23) zeros(24:105)];L(23)=23;
C(24,:)=[1 0 0 0 -1 0 0 0 1 zeros(10:105)];L(24)=9;
C(25,:)=[1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 zeros(22:105)];
X        L(25)=21;
C(26,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(14:105)];L(26)=13;
C(27,:)=[1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 zeros(20:105)];L(27)=19;
C(28,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 zeros(14:105)];L(28)=13;
C(29,:)=[ones(1:29) zeros(30:105)];L(29)=29;
C(30,:)=[1 1 0 -1 -1 -1  0  1  1 zeros(10:105)];L(30)=9;
C(31,:)=[ones(1:31) zeros(32:105)];L(31)=31;
C(32,:)=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 zeros(18:105)];L(32)=17;
C(33,:)=[1 -1 0 1 -1 0 1 -1 0  1 -1 1 0 -1 1 0 -1 1 0 -1 1 zeros(22:105)];
X        L(33)=21;
C(34,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(18:105)];L(34)=17;
C(35,:)=[1 -1 0 0 0 1 -1 1 -1 0 1 -1 1 -1 1 0 -1 1 -1 1 0 0 0 -1 1 ..
X         zeros(26:105)]; L(35)=25;
C(36,:)=[1 0 0 0 0 0 -1 0 0 0 0 0 1 zeros(14:105)];L(36)=13;
C(37,:)=[ones(1:37) zeros(38:105)];L(37)=37;
C(38,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(20:105)];
X        L(38)=19;
C(39,:)=[1 -1 0 1 -1 0 1 -1 0 1 -1 0 1 0 -1 1 0 -1 1 0 -1 1 0 -1 ..
X         1 zeros(26:105)];L(39)=25;
C(40,:)=[1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 1 zeros(18:105)];L(40)=17;
C(41,:)=[ones(1:41) zeros(42:105)];L(41)=41;
C(42,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(22:105)];
X        L(42)=21;
C(43,:)=[ones(1:43) zeros(44:105)];L(43)=43;
C(44,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 zeros(22:105)];
X        L(44)=21;
C(45,:)=[1 0 0 -1 0 0 0 0 0 1 0 0 -1 0 0 1 0 0 0 0 0 -1 0 0 1 zeros(26:105)];
X        L(45)=25;
C(46,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 ..
X        zeros(24:105)];L(46)=23;
C(47,:)=[ones(1:47) zeros(48:105)];L(47)=47;
C(48,:)=[1 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 1 zeros(18:105)];L(48)=17;
C(49,:)=[1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 ..
X         0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 zeros(44:105)];
X        L(49)=43;
C(50,:)=[1 0 0 0 0 -1 0 0 0 0 1 0 0 0 0 -1 0 0 0 0 1 zeros(22:105)];
X        L(50)=21;
C(51,:)=[ 1 -1 0 1 -1 0 1 -1 0 1 -1 0 1 -1 0 1 -1 1 0 -1 1 0 -1 1 ..
X         0 -1  1  0 -1 1 0 -1 1 zeros(34:105)];
X         L(51)=33;
C(52,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 ..
X         zeros(26:105)];
X         L(52)=25;
C(53,:)=[ones(1:53) zeros(54:105)];L(53)=53;
C(54,:)=[1 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 1 zeros(20:105)];
X         L(54)=19;
C(55,:)=[1 -1 0 0 0 1 -1 0 0 0 1 0 -1 0 0 1 0 -1 0 0 1 0 0 -1 ..
X         0 1 0 0 -1 0 1 0 0 0 -1 1 0 0 0 -1 1 zeros(42:105)];
X         L(55)=41;
C(56,:)=[1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 1 zeros(26:105)];
X         L(56)=25;
C(57,:)=[1 -1  0  1 -1  0  1 -1  0  1 -1  0 1 -1  0  1 -1  0  1  0 -1 ..
X         1  0  -1 1  0 -1  1  0 -1  1  0 -1  1  0 -1 1 zeros(38:105)];
X         L(57)=37;
C(58,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ..
X         1 -1 1 -1 1 -1 1 zeros(30:105)];L(58)=29;
C(59,:)=[ones(1:59) zeros(60:105)];L(59)=59;
C(60,:)=[1 0 1 0 0 0 -1 0 -1 0 -1 0 0 0 1 0 1 zeros(18:105)];L(60)=17;
C(61,:)=[ones(1:61) zeros(62:105)];L(61)=61;
C(62,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ..
X         1 -1 1 -1 1 -1 1 -1 1 zeros(32:105)];L(62)=31;
C(63,:)=[1 0 0 -1 0 0 0 0 0 1 0 0 -1 0 0 0 0 0 1 0 0 0 0 0 -1 ..
X         0 0 1 0 0 0 0 0 -1 0 0 1 zeros(38:105)];L(63)=37;
C(64,:)=[1 zeros(1:31) 1 zeros(34:105)];L(64)=33;
C(65,:)=[1 -1 0 0 0 1 -1 0 0 0 1 -1 ..
X         0 1 -1 1 -1 0 1 -1 1 -1  0 1 ..
X        -1 1 0 -1 1 -1 1 0 -1 1 -1 1 ..
X         0 -1 1 0 0 0 -1 1 0 0 0 -1 ..
X         1  zeros(50:105)];L(65)=49;
X
C(66,:)=[1 1 0 -1 -1 0 1 1 0 -1 -1 -1 ..
X         0 1 1 0 -1 -1 0 1 1  zeros(22:105)];L(66)=21;
C(67,:)=[ones(1:67) zeros(68:105)];L(67)=67;
C(68,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 ..
X         0 1 0 -1 0 1 0 -1 0 1 zeros(34:105)];L(68)=33;
C(69,:)=[1 -1 0 1 -1 0 1 -1 0 1 -1 0 ..
X         1 -1 0 1 -1 0 1 -1 0  1 -1 1 ..
X         0 -1 1 0 -1 1 0 -1 1 0 -1 1 ..
X         0 -1 1 0 -1 1 0 -1 1 zeros(46:105)];L(69)=45;
X
C(70,:)=[1 1 0 0 0 -1 -1 -1 -1 0 1 1 ..
X         1 1 1 0 -1 -1 -1 -1 0 0 0 1 ..
X         1 zeros(26:105)];L(70)=25;
C(71,:)=[ones(1:71) zeros(72:105)];L(71)=71;
C(72,:)=[1 zeros(1:11) -1 zeros(1:11) 1 zeros(26:105)];L(72)=25;
C(73,:)=[ones(1:73) zeros(74:105)];L(73)=73;
C(74,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ..
X         1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(38:105)];L(74)=37;
C(75,:)=[1 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 0 0 0 0 1 0 0 0 0 0 ..
X         0 0 0 0 -1 0 0 0 0 1 zeros(42:105)];L(75)=41;
C(76,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 ..
X         1 0 -1 0 1 0 -1 0 1 zeros(38:105)];L(76)=37;
C(77,:)=[1 -1 0 0 0 0 0 1 -1  0  0  1 ..
X        -1 0 1 -1 0 0 1 -1 0 1 0 -1 ..
X         0 1 -1 0 1 0 -1 0 1 0 -1 1 ..
X         0 -1 0  1  0 -1 1 0 0 -1 1 0 ..
X        -1 1 0 0 -1 1 0 0 0 0 0 -1 ..
X         1 zeros(62:105)];L(77)=61;
X
C(78,:)=[1 1 0 -1 -1 0 1 1 0 -1 -1 0 1 0 -1 -1 0 1 1 0 -1 -1 0 1 ..
X         1 zeros(26:105)];L(78)=25;
C(79,:)=[ones(1:79) zeros(80:105)];L(79)=79;
C(80,:)=[1 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 ..
X        -1 0 0 0 0 0 0 0 1 zeros(34:105)];L(80)=33;
C(81,:)=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 ..
X         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 zeros(56:105)];
X        L(81)=55;
C(82,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ..
X         1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(42:105)];
X         L(82)=41;        
C(83,:)=[ones(1:83) zeros(84:105)];L(83)=83;
C(84,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 ..
X         1 0 -1 0 1 0 -1 0 1 0 -1 0 ..
X         1 0 -1 0 1 0 -1 0 1 0 -1 0 ..
X         1 0 -1 0 1 zeros(42:105)];L(84)=41;
C(85,:)=[1 -1 0 0 0 1 -1 0 0 0 1 -1 ..
X         0 0 0 1 -1 1 -1 0 1 -1 1 -1 ..
X         0 1 -1 1 -1 0 1 -1 1 -1 1 0 ..
X        -1 1 -1 1 0 -1 1 -1 1 0 -1 1 ..
X        -1 1 0 0 0 -1 1 0 0 0 -1 1 ..
X         0 0 0 -1 1 zeros(66:105)];L(85)=65;
C(86,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 ..
X         -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(44:105)];
X         L(86)=43;
C(87,:)=[1 -1 0 1 -1 0 1 -1 0 1 -1 0 ..
X         1 -1 0 1 -1 0 1 -1 0 1 -1 0 ..
X         1 -1 0 1 -1 1 0 -1 1 0 -1 1 ..
X         0 -1 1 0 -1 1 0 -1 1 0 -1 1 ..
X         0 -1 1 0 -1 1 0 -1 1 zeros(58:105)];
X         L(87)=57;
X
C(88,:)=[1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 1 0 0 0 -1 0 0 0 ..
X         1 0 0 0 -1 0 0 0 1 zeros(42:105)];L(88)=41;
C(89,:)=[ones(1:89) zeros(90:105)];L(89)=89;
X        
C(90,:)=[1 0 0 1 0 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 0 1 0 0 1 zeros(26:105)];
X        L(90)=25;
C(91,:)=[1 -1 0 0 0 0 0 1 -1 0 0 0 ..
X         0 1 0 -1 0 0 0 0 1 0 -1 0 ..
X         0 0 1 0 0 -1 0 0 0 1 0 0 ..
X        -1 0 0 1 0 0 0 -1 0 0 1 0 ..
X         0 0 -1 0 1 0 0 0 0 -1 0 1 ..
X         0 0 0 0 -1 1 0 0 0 0 0 -1 ..
X         1 zeros(74:105)];L(91)=73;
X
C(92,:)=[1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 ..
X        -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 1 zeros(46:105)];L(92)=45;
C(93,:)=[1 -1 0 1 -1 0 1 -1 0 1 -1 0 ..
X         1 -1 0 1 -1 0 1 -1 0 1 -1 0 ..
X         1 -1 0 1 -1 0 1 0 -1 1 0 -1 ..
X         1 0 -1 1 0 -1 1 0 -1 1 0 -1 ..
X         1 0 -1 1 0 -1 1 0 -1 1 0 -1 ..
X         1 zeros(62:105)];L(93)=61;
X
C(94,:)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ..
X         1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 zeros(48:105)];
X         L(94)=47;
C(95,:)=[1 -1 0 0 0 1 -1 0 0 0 1 -1 ..
X         0 0 0 1 -1 0 0 1 0 -1 0 0 ..
X         1 0 -1 0 0 1 0 -1 0 0 1 0 ..
X        -1 0 1 0 0 -1 0 1 0 0 -1 0 ..
X         1 0 0 -1 0 1 0 0 -1 1 0 0 ..
X         0 -1 1 0 0 0 -1 1 0 0 0 -1 ..
X         1 zeros(74:105)];L(95)=73;
C(96,:)=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ..
X         zeros(34:105)];L(96)=33;
C(97,:)=[ones(1:97) zeros(98:105)];L(97)=97;
C(98,:)=[1 0 0 0 0 0 0 -1 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 ..
X         0 0 0 0 0 0 1 0 0 0 0 0 0 -1 0 0 0 0 0 0 1 zeros(44:105)];
X         L(98)=43;
C(99,:)=[1 0 0 -1 0 0 0 0 0 1 0 0 ..
X        -1 0 0 0 0 0 1 0 0 -1 0 0 ..
X         0 0 0 1 0 0 -1 0 0 1 0 0 ..
X         0 0 0 -1 0 0 1 0 0 0 0 0 ..
X        -1 0 0 1 0 0 0 0 0 -1 0 0 ..
X         1 zeros(62:105)];L(99)=61;
C(100,:)=[1 0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 -1 ..
X          0 0 0 0 0 0 0 0 0 1 zeros(42:105)];L(100)=41;
C(101,:)=[ones(1:101) zeros(102:105)];L(101)=101;
C(102,:)=[1 1 0 -1 -1 0 1 1 0 -1 -1 0 ..
X          1 1 0 -1 -1 -1 0 1 1 0 -1 -1 ..
X          0 1 1 0 -1 -1  0 1  1 zeros(34:105)];L(102)=33;
C(103,:)=[ones(1:103) zeros(104:105)];L(103)=103;
C(104,:)=[1 0 0 0 -1 0 0 0 1 0 0 0 ..
X         -1 0 0 0 1 0 0 0 -1 0 0 0 ..
X          1 0 0 0 -1 0 0 0 1 0 0 0 ..
X         -1 0 0 0 1 0 0 0 -1 0 0 0 1 zeros(50:105)];L(104)=49;
X
%END OF CYCLOTOMIC POLYNOMIAL DEFINITION BLOCK
SHAR_EOF
chmod 0666 DefineCyclo.m ||
echo 'restore of DefineCyclo.m failed'
Wc_c="`wc -c < 'DefineCyclo.m'`"
test 10377 -eq "$Wc_c" ||
	echo 'DefineCyclo.m: original size 10377, current size' "$Wc_c"
fi
# ============= DesRemEq.m ==============
if test -f 'DesRemEq.m' -a X"$1" != X"-c"; then
	echo 'x - skipping DesRemEq.m (File already exists)'
else
echo 'x - extracting DesRemEq.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'DesRemEq.m' &&
%******************************************************************
%**** DesRemEq ****
%****
%**** This routine designs the Remez equalizer, and plots the
%**** prefilter-equalizer responses.  This is a separate 
%**** MATLAB M-File that is called from the main routine.
%******************************************************************
if BandPass,
X   %passband-stopband relative weighting multipliers
X     PSMultiplier=[(1.0/(PassStopWt))*ones(1:length(StopSpecRangeOne)) ..
X                   ones(1:length(PassbandVector)) ..
X                   (1.0/(PassStopWt))*ones(1:length(StopSpecRangeTwo))];
end;
if LowPass,
X     PSMultiplier=[ones(1:length(PassOne)) ..
X                   (1.0/(PassStopWt))*ones(1:length(StopSpecRange))];
end;
if MultiBand,
X  PSMultiplier=[(1.0/(PassStopWt))*ones(1:length(StopSpecRangeOne)) ..
X    ones(1:length(PassOne)) (1.0/(PassStopWt))* ..
X    ones(1:length(StopSpecRangeTwo)) ones(1:length(PassTwo)) ..
X    (1.0/(PassStopWt))*ones(1:length(StopSpecRangeThree))];
end;
X              
%  Now we multiply WtInverse by the relative PB-SB multiplier
%  and then threshold it to some pre-determined threshold
X
X   FinlWtInverse=WtInverse.*PSMultiplier;
X   FinlWtInverse=min(FinlWtInverse,1/WtThreshold);
X
%  This next loop just forces the magnitudes and weights to
%  occur in pairs.  The remez call requires magnitudes in pairs. 
X   for Count=1:2:length(ESpecband)-1,
X      ESpecband(Count)=ESpecband(Count+1);
X      FinlWtInverse(Count)=FinlWtInverse(Count+1);
X   end;
% ...and now we take every other weight since there are half
% as many weights as there are frequency and magnitude points
X   Weights=[(1.0./abs(FinlWtInverse(1:2:length(WtInverse)-1)))];
X
%***********NOW WE'LL DESIGN THE EQUALIZER ************************
X
% We call the remez exchange algorithm, which is included as
% part of the MATLAB Signal Processing Toolbox.  This routine
% is documented on page 1-34 and pages 2-91 through 2-93 in
% the Signal Processing Toolbox User's Guide dated 
% 29 August 1988.  MATLAB is a registered trademark of 
% The MathWorks, Inc.
%  
Equalizer=remez(EqLength-1,2*SpecRange,ESpecband,Weights);
%
% Now we calculate the frequency response from 0-Fs/2
% for the impulse response vector Equalizer
X
[FEqualizer,w]=freqz(Equalizer,1,NumberOfSamples);
X  
% Now let's plot the independent equalizer and prefilter responses,
% then we'll pause until someone hits a key, and then plot the 
% response of the cascade of the prefilter and equalizer
%hold off;
%plot(w/(2*pi),20*log10(abs(FEqualizer)),w/(2*pi),20*log10(abs(Prefilter)));
%xlabel('Fraction of Sampling Frequency');ylabel('Magnitude in dB');
%title('Independent Responses for Equalizer {solid} and Prefilter {dotted}');
%pause;
scale=[0.0,0.5,-100,10];  % a more convenient graph scale for the cascade
axis(scale);
plot(w/(2*pi),20*log10(abs(FEqualizer.*Prefilter)));
xlabel('Fraction of Sampling Frequency');ylabel('Magnitude in dB');
title('Magnitude Response of Prefilter/Equalizer Cascade');
grid;
SHAR_EOF
chmod 0666 DesRemEq.m ||
echo 'restore of DesRemEq.m failed'
Wc_c="`wc -c < 'DesRemEq.m'`"
test 3000 -eq "$Wc_c" ||
	echo 'DesRemEq.m: original size 3000, current size' "$Wc_c"
fi
# ============= ElementOf.m ==============
if test -f 'ElementOf.m' -a X"$1" != X"-c"; then
	echo 'x - skipping ElementOf.m (File already exists)'
else
echo 'x - extracting ElementOf.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'ElementOf.m' &&
function In = ElementOf(Number,Vector)
% checks to see if Number is an element of Vector
X
In=0;
L=Vector(Vector==Number);
if length(L)>0,
X  In=1;
end;
return
SHAR_EOF
chmod 0666 ElementOf.m ||
echo 'restore of ElementOf.m failed'
Wc_c="`wc -c < 'ElementOf.m'`"
test 158 -eq "$Wc_c" ||
	echo 'ElementOf.m: original size 158, current size' "$Wc_c"
fi
# ============= Factorial.m ==============
if test -f 'Factorial.m' -a X"$1" != X"-c"; then
	echo 'x - skipping Factorial.m (File already exists)'
else
echo 'x - extracting Factorial.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'Factorial.m' &&
function Value=Factorial(G);
%pass in INTEGER G, you get G!
% 0!=1, any neg!=0
X
Vector=[G:-1:1];
if length(Vector)>0,
X   Value=prod(Vector);
elseif G==0,
X   Value=1;
else
X   Value=0;
end;
return;
SHAR_EOF
chmod 0666 Factorial.m ||
echo 'restore of Factorial.m failed'
Wc_c="`wc -c < 'Factorial.m'`"
test 196 -eq "$Wc_c" ||
	echo 'Factorial.m: original size 196, current size' "$Wc_c"
fi
# ============= VerRemEq.m ==============
if test -f 'VerRemEq.m' -a X"$1" != X"-c"; then
	echo 'x - skipping VerRemEq.m (File already exists)'
else
echo 'x - extracting VerRemEq.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'VerRemEq.m' &&
%*******************************************************************
% VerRemEq
%This routine performs a specification verification
% at high frequency domain resolution to see if we met the desired filter
% specification.  This a separate MATLAB M-File that is called from
% the main routine.
%********************************************************************
X
HugeNumSamples=8192;
[HRPrefilter,w]=freqz(prefilterimpresp,1,HugeNumSamples);
[HRFEqualizer,w]=freqz(Equalizer,1,HugeNumSamples);
if BandPass==1,
X      HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
X      HRWsTwoIndex=round(2*WsTwo*HugeNumSamples+0.49);
X      HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
X      HRWpTwoIndex=round(2*WpTwo*HugeNumSamples+0.49);
X      HRSIndRangeOne=[1:HRWsOneIndex];
X      HRSIndRangeTwo=[HRWsTwoIndex:HugeNumSamples];
X      PEMaxPassMagnitude=max(20*log10(abs ..
X          (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex) ..
X                        .*HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
X      PEMinPassMagnitude=min(20*log10(abs ..
X          (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
X                         HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
X      PEPassRipple=PEMaxPassMagnitude-PEMinPassMagnitude;
X
X      PELowMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
X                 HRPrefilter(HRSIndRangeOne))));
X      PEHiMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeTwo).* ..
X                 HRPrefilter(HRSIndRangeTwo))));
X      PEMaxStopDev=max(PELowMaxStopDev,PEHiMaxStopDev);
X
end; %bandpass
if LowPass==1,
X      HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
X      HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
X      HRSIndRangeOne=[HRWsOneIndex:HugeNumSamples];
X      PEMaxPassMagnitude=max(20*log10(abs(HRFEqualizer(1:HRWpOneIndex).* ..
X                 HRPrefilter(1:HRWpOneIndex))));
X      PEMinPassMagnitude=min(20*log10(abs(HRFEqualizer(1:HRWpOneIndex).* ..
X                 HRPrefilter(1:HRWpOneIndex))));
X      PEPassRipple=PEMaxPassMagnitude-PEMinPassMagnitude;
X      PEMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
X                 HRPrefilter(HRSIndRangeOne))));
end; %lowpass
X
if MultiBand==1,
%    0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5      just 2 passbands for now
X
X        HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
X        HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
X        HRWpTwoIndex=round(2*WpTwo*HugeNumSamples+0.49);
X        HRWsTwoIndex=round(2*WsTwo*HugeNumSamples+0.49);
X        HRWsThreeIndex=round(2*WsThree*HugeNumSamples+0.49);
X        HRWpThreeIndex=round(2*WpThree*HugeNumSamples+0.49);
X        HRWpFourIndex=min(round ..
X           (2*WpFour*HugeNumSamples+0.49),HugeNumSamples);
X        HRWsFourIndex=min(round ..
X           (2*WsFour*HugeNumSamples+0.49),HugeNumSamples);
X
X        HRSIndRangeOne=[1:HRWsOneIndex];
X        HRSIndRangeTwo=[HRWsTwoIndex:HRWsThreeIndex];
X        HRSIndRangeThree=[HRWsFourIndex:HugeNumSamples];
X
X
X        PEMaxPassMagOne=max(20*log10(abs ..
X                 (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
X                  HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
X        PEMinPassMagOne=min(20*log10(abs ..
X                 (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
X                 HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
X        PEMaxPassMagTwo=max(20*log10(abs ..
X                 (HRFEqualizer(HRWpThreeIndex:HRWpFourIndex).* ..
X                 HRPrefilter(HRWpThreeIndex:HRWpFourIndex))));
X        PEMinPassMagTwo=min(20*log10(abs ..
X                 (HRFEqualizer(HRWpThreeIndex:HRWpFourIndex).* ..
X                 HRPrefilter(HRWpThreeIndex:HRWpFourIndex))));
X        PEPassRippleOne=PEMaxPassMagOne-PEMinPassMagOne;
X        PEPassRippleTwo=PEMaxPassMagTwo-PEMinPassMagTwo;
X        PEPassRipple=max(PEPassRippleOne,PEPassRippleTwo);
X
X
X        PELowMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
X                 HRPrefilter(HRSIndRangeOne))));
X        PEMidMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeTwo).* ..
X                 HRPrefilter(HRSIndRangeTwo))));
X        PEHiMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeThree).* ..
X                 HRPrefilter(HRSIndRangeThree))));
X        PEMaxStopDev=max(max(PELowMaxStopDev,PEMidMaxStopDev),PEHiMaxStopDev);
X
end; %MultiBand
sprintf('Prefilter-Equalizer passband ripple in dB is %g',PEPassRipple)
sprintf('Prefilter-Equalizer stopband attenuation in dB is %g',-PEMaxStopDev)
echo off;
X  MsgOne='You FAILED TO MEET YOUR DESIRED SPECIFICATION due to';
X  MsgTwo='violation of the PASSBAND RIPPLE constraint!!!';
X  MsgThree='violation of the STOPBAND ATTENUATION constraint!!!';
X  MsgFour='Please refer to the flowchart in Figure 3 of our paper';
X  MsgFive='for recommended action. ';
X  MsgSix='You have PASSED both PASSBAND and STOPBAND specifications,';
X  MsgSeven='however you may not have a minimal length equalizer.';
X  MsgEight='to help decide whether EqLength may be decreased. ';
X
if PEPassRipple>PassRippleSpec,
X  disp(MsgOne);disp(MsgTwo);disp(MsgFour);disp(MsgFive);
end;
if -PEMaxStopDev<StopAttenSpec,
X  disp(MsgOne);disp(MsgThree);disp(MsgFour);disp(MsgFive);
end;
if (PassRippleSpec>=PEPassRipple)&(StopAttenSpec<=-PEMaxStopDev),
X   disp(MsgSix);disp(MsgSeven);disp(MsgFour);disp(MsgEight);
end;
echo on;
X
X
SHAR_EOF
chmod 0666 VerRemEq.m ||
echo 'restore of VerRemEq.m failed'
Wc_c="`wc -c < 'VerRemEq.m'`"
test 5257 -eq "$Wc_c" ||
	echo 'VerRemEq.m: original size 5257, current size' "$Wc_c"
fi
# ============= Within.m ==============
if test -f 'Within.m' -a X"$1" != X"-c"; then
	echo 'x - skipping Within.m (File already exists)'
else
echo 'x - extracting Within.m (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'Within.m' &&
function Number = Within(Value,A)
% Pass in Value,Vector A;
X
if (Value>=A(1))&(Value<=A(2)),
X   Number=1;
X  else
X   Number=0;
end;
return
SHAR_EOF
chmod 0666 Within.m ||
echo 'restore of Within.m failed'
Wc_c="`wc -c < 'Within.m'`"
test 138 -eq "$Wc_c" ||
	echo 'Within.m: original size 138, current size' "$Wc_c"
fi
exit 0
