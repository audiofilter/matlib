%*******************************************************************
% CycgenB
%
% This routine is the cyclotomic polynomial prefilter design
% routine- This is a separate MATLAB M-File.
%******************************************************************* 
DefineCyclo;  %simply defines matrix C and vector L
              %where row k of matrix C corresponds to the
              %kth cyclotomic polynomial, and the kth element
              %of L corresponds to the length of the polynomial

if LowPass==1,
       
       TransBand=WsOne-WpOne;
       Epsilon=TransBandIntrusion*TransBand;
       ProhibitBandOne=[0.0 WsOne-Epsilon];  %region where we prohibit
                                             %polynomial roots
       ProhibitBandTwo=[inf -inf];   %second prohibit band is non-existent
       StopIndRegion=[WsOneIndex:NumPts/2+1];  
       PassIndRegion=[1:WpOneIndex];
end;
if BandPass==1,
      TransBandOne=WpOne-WsOne;
      TransBandTwo=WsTwo-WpTwo;
      EpsilonOne=TransBandIntrusion*TransBandOne;
      EpsilonTwo=TransBandIntrusion*TransBandTwo;
      ProhibitBandOne=[WsOne+EpsilonOne WsTwo-EpsilonTwo];
      ProhibitBandTwo=[inf -inf];   %second prohibit band is non-existent
      StopIndRegion=[1:WsOneIndex WsTwoIndex:NumPts/2+1];
      PassIndRegion=[WpOneIndex:WpTwoIndex];
end;
if MultiBand==1,  %two passbands for now
      %   0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5
      TransBandOne=WpOne-WsOne; 
      TransBandTwo=WsTwo-WpTwo;
      TransBandThree=WpThree-WsThree; 
      TransBandFour=WsFour-WpFour;
      EpsilonOne=TransBandIntrusion*TransBandOne;
      EpsilonTwo=TransBandIntrusion*TransBandTwo;
      EpsilonThree=TransBandIntrusion*TransBandThree;
      EpsilonFour=TransBandIntrusion*TransBandFour;
      ProhibitBandOne=[WsOne+EpsilonOne WsTwo-EpsilonTwo];
      ProhibitBandTwo=[WsThree+EpsilonThree WsFour-EpsilonFour];

      StopIndRegion=[1:WsOneIndex WsTwoIndex:WsThreeIndex WsFourIndex:NumPts/2+1]; % NumPts/2+1 is Fs/2
      PassRegionOne=[max(WpOneIndex,1):WpTwoIndex];
      PassRegionTwo=[WpThreeIndex:WpFourIndex];
      PassIndRegion=[PassRegionOne PassRegionTwo];
end;

%the reverse index is used to "reverse" the row vector associated with 
%each cyclotomic polynomial prior to calculating the roots.  Otherwise
%we end up with lots of roots at the z-plane origin which do not play
%a part in our design method.

ReverseIndex=length(C(1,:)):-1:1;

% inf is "infinity"
CMOne=inf;CMTwo=inf;CMThree=inf;CMFour=inf;
CPOne=[];CPTwo=[];CPThree=[];CPFour=[];Eligibles=[];

for Index=1:104,
    %ROOT AND FREQUENCY RESPONSE CALCULATION BLOCK****************************
    %  USE THIS BLOCK ONLY IF YOU ARE INTERESTED IN CALCULATING FREQUENCY    * 
    %  RESPONSES AND ROOTS FOR THE FIRST TIME FOR THE CYCLOTOMIC             * 
    %  POLYNOMIALS.  AFTER THE FIRST TIME, WE RECOMMEND YOU SAVE ROOTS       *
    %  (CycloRoots) AND FREQUENCY RESPONSES (Cfreq) TO EXTERNAL DATA FILE,   * 
    %  SO YOU DO NOT HAVE TO RECALCULATE THEM EACH TIME.  LOADING THESE DATA *
    %  FILES SPEEDS EXECUTION
    %
       Index  
       [junk,w]=freqz(C(Index,:),1,NumPts,'whole');
       Cfreq(Index,:)=(junk.')/max(abs(junk));  %non-conjugate transpose
       WhichOne=sprintf('Cyclotomic Polynomial %g',Index);
       plot(0:Res:1-Res,20*log10(abs(Cfreq(Index,:))));
       title(WhichOne);
       grid;
    %   pause;
    %  (loading from external data file speeds execution considerably!!)
       ActualRoots=(roots(C(Index,ReverseIndex))).';
       CycloRoots(Index,:)=[ActualRoots zeros(length(ActualRoots)+1:105)];
    %END ROOT AND FREQUENCY RESPONSE CALCULATION BLOCK**********************                         

   CycloFracs=angle(CycloRoots(Index,1:L(Index)-1))/(2*pi); %a vector 
   %in terms of fractions of Fs

   Flag=1;
   for RootIndex=1:L(Index)-1,
      if Flag==1,
         if (Within(CycloFracs(RootIndex),ProhibitBandOne)==1)| (Within(CycloFracs(RootIndex),ProhibitBandTwo)==1),
            Flag=0;
         end;
      end;
    end;
    if Flag==1, %meaning it is an eligible polynomial
       sprintf('OK TO CHOOSE Cyclotomic Polynomial %g',Index)
       Eligibles=[Eligibles Index]; %append Index to the list of Eligibles

       if LowPass==1,
          RCMeasureOne=min(abs(CycloFracs-WpOne));
          if RCMeasureOne<CMOne,
             CMOne=RCMeasureOne;
             CPOne=Index;
          end;
        end;
        if (BandPass==1)|(MultiBand==1),
           RCMeasureOne=min(abs(CycloFracs-WpOne));
           RCMeasureTwo=min(abs(CycloFracs-WpTwo));
           if RCMeasureOne<CMOne,
              CMOne=RCMeasureOne;
              CPOne=Index;
           end;
           if RCMeasureTwo<CMTwo,
              CMTwo=RCMeasureTwo;
              CPTwo=Index;
           end;
        end;
        if MultiBand==1, %we have possibly 4 critical polynomials
           RCMeasureThree=min(abs(CycloFracs-WpThree));
           RCMeasureFour=min(abs(CycloFracs-WpFour));
           if RCMeasureThree<CMThree,
              CMThree=RCMeasureThree;
              CPThree=Index;
           end;
           if RCMeasureFour<CMFour,
              CMFour=RCMeasureFour;
              CPFour=Index;
           end;
        end; %if Multiband....             
    end; %if Flag==1 (meaning an eligible polynomial
end;  %for Index...
%now we are going to get all criticals, but nothing twice
CriticalPolys=sort([CPOne CPTwo CPThree CPFour])
IndexDelete=[];
for Counter=1:length(CriticalPolys)-1,
   if CriticalPolys(Counter)==CriticalPolys(Counter+1),
      IndexDelete=[IndexDelete Counter];  %forming indices for later deletion
   end;
end;
CriticalSet=CriticalPolys;
CriticalSet(:,IndexDelete)=[];      %now we have everything but
                                    %nothing twice
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
   if ElementOf(2,CriticalSet)~=1,  %meaning C(2) not in CriticalSet,
      CriticalSet=[2 CriticalSet];  %we'll add it!  
   end;
   if (BandPass==1),
     if ElementOf(1,CriticalSet)~=1,  %meaning C(1) not in CriticalSet
       CriticalSet=[1 CriticalSet];   %we'll add it!  
      end;
   end;
end;

OriginalEligibles=Eligibles;
if length(Eligibles)>1,
   Approx=prod(Cfreq(Eligibles,:));%product of individual cyclotomic
  else                             %polynomial prefilter frequency responses,
   Approx=Cfreq(Eligibles,:);      %or we just have one
end; %product of individual cyclotomic
Approx=Approx/max(abs(Approx));
PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
%  if we cascade all eligibles and our filter is too long or our 
%  passband attenuation is too large, we'll start building from
%  the critical set
if ((sum(L(Eligibles))-(length(Eligibles)-1))>AllowedPreLength)| (PassBndAtten>AllowedPBAtten),
    Eligibles=CriticalSet;
    if length(Eligibles)>1,
      Approx=prod(Cfreq(Eligibles,:));
    else                             
      Approx=Cfreq(Eligibles,:);  
    end; %product of individual cyclotomic
    Approx=Approx/max(abs(Approx));
    PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
    if (PassBndAtten>AllowedPBAtten),
       if (BandPass==1),
          CriticalSet=[1 2];
       end;
       if LowPass==1,
          CriticalSet=[2];
       end;
    end;
    Eligibles=CriticalSet;
end;
MostSignificant=99999;  %just any number will do here... 

if length(Eligibles)>1,
   Approx=prod(Cfreq(Eligibles,:));
  else
   Approx=Cfreq(Eligibles,:);
end;
Approx=Approx/max(abs(Approx));
hold off;
plot(0:Res:1-Res,20*log10(abs(Approx)));
StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));

 % NOW WE ADD TO THE DESIRED LENGTH
 % We will continue to build onto our prefilter until:
 %    1- we exceed the maximum allowed prefilter length, or
 %    2- our "growing" algorithm determines that the best decision
 %       is simply not to add another subsection at all (probably
 %       because at some point in the process, the addition of any
 %       of the eligible CPF subsections would cause a passband 
 %       attenuation violation), or
 %    3- we achieve our desired goal of prefilter stopband attenuation-
    
   while ((sum(L(Eligibles))-(length(Eligibles)-1))<AllowedPreLength)& (length(MostSignificant)~=0)&(ReqPreSBAtten>StopBndAtten),

      CycIncreaseB;
      if length(Eligibles)>1,
         Approx=prod(Cfreq(Eligibles,:));
      else
         Approx=Cfreq(Eligibles,:);
      end;
      Approx=Approx/max(abs(Approx));
      StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));
      hold off;plot(0:Res:1-Res,20*log10(abs(Approx)));
      Eligibles'     %This just lists the total vector of 
                     %CP subsections as we continue to build
   end;





