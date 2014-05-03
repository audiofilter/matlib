%**********************************************************************
%  CycIncreaseB
%
%  This routine is the cyclotomic polynomial filter (CPF) "growing"
%  routine described in the paper.
%********************************************************************** 




%Add each single polynomial, and calculate which one has the most
%effect on the offending frequency without causing intolerable
%problems elsewhere in the frequency response

MostSignificant=[];   %we initialize our decision as to the most significant
                      %cyclotomic polynomial to the null vector []
MinCostOfAdding=inf;  %just some big number to initialize

SaturationDelta=30; %This is the "maximum local improvement factor" in dB we
                    %will allow in the cost equation.  Otherwise, a zero 
                    %placed exactly at the frequency of interest would
                    %cause an infinite improvement in attenuation, and
                    %would unduly bias our cost equation and require us
                    %to add this section, regardless of its effect on
                    %other frequencies in the stopband!!!
                    %We have obtained good results by using this number,
                    %but we make no claim as to its optimality.

%Now we list the relative costs in the cost equation.  Once again, we
%have obtained good results by using these numbers, but we make no claim
%in regards to their optimality.

Alpha=1.0;  % primary determining factor in the cost equation will be
            % "local stopband attenuation improvement" at the offending
            % frequency-
Beta=0.1;   %all else being equal, we will favor a filter that helps
            %other parts of the stopband as well
Gamma=0.1;  %all else being equal, we will be biased toward a shorter filter

            %Sigma is the penalty associated with multiband filters only,
            %and 
if MultiBand==1,
   Sigma=0.3;
  else
   Sigma=0.0;
end; 
if length(Eligibles)>1,
   Approx=prod(Cfreq(Eligibles,:));%product of individual cyclotomic
  else                             %polynomial prefilter frequency responses
   Approx=Cfreq(Eligibles,:);  %we just have one
end; %product of individual cyclotomic
                                 
Approx=Approx/max(abs(Approx));  %normalize maximum to 0dB
%**************************************************************
%Now we include a weighting function as a function of frequency
%if appropriate (11/18/91 change)
%
K1=50;
K2=3;
if (LowPass==1)&(ShouldWeight==1),
   WeightFunction=1+K1*exp(-K2*(1:length(StopIndRegion))/ ..
                  (length(StopIndRegion)));
   Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
end;

if (BandPass==1)&(ShouldWeight==1),
   WeightSBOne=1+(K1/exp(K2))*exp(K2*(1:length(1:WsOneIndex))/ ..
               (length(1:WsOneIndex)));
   WeightSBTwo=1+K1*exp(-K2*(1:length(WsTwoIndex:NumPts/2+1))/ ..
               (length(WsTwoIndex:NumPts/2+1)));
   WeightFunction=[WeightSBOne WeightSBTwo];
   Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
   hold off;clg;
   plot(StopIndRegion,WeightFunction);
end;


%****************************************************************

[MinStopBndAtten,OffendingIndex]=max(20*log10(abs(Approx(StopIndRegion))));

%tells which member of StopIndRegion is the offender
OffendingIndex=StopIndRegion(OffendingIndex); %reindexes to frequency axis
MinStopBndAtten=-MinStopBndAtten;
%difference of average passband attenuations (we want it small)


for Addition=1:length(OriginalEligibles),
           
     KeepIndices=[Eligibles OriginalEligibles(Addition)];
     AddedCfreq=Cfreq(OriginalEligibles(Addition),:);
 
     Approx=prod(Cfreq(KeepIndices,:));
     Approx=Approx/max(abs(Approx));   %normalize to 0dB
%% added 12/1/91
     if ShouldWeight==1,
        Approx(StopIndRegion)=WeightFunction.*Approx(StopIndRegion);
     end;

     if MultiBand==1,
        %difference of average passband attenuations
        MultiBandDelta=abs(mean(20*log10(abs(Approx(PassRegionOne)))) ..
                        - mean(20*log10(abs(Approx(PassRegionTwo)))));
       else
        MultiBandDelta=0.0;
     end;

   % now scan over stopband and see what "improvement" we have done
   % in terms of stopband performance
     
     StopBndAtten=-max(20*log10(abs(Approx(StopIndRegion))));
     PassBndAtten=-min(20*log10(abs(Approx(PassIndRegion))));
     SBAforOffendingFreq=-20*log10(abs(Approx(OffendingIndex)));

    %Now, how much did we improve response at the offending frequency?

     OffendFrqDelta=SBAforOffendingFreq-MinStopBndAtten;
     OffendFrqDelta=min(OffendFrqDelta,SaturationDelta);

    %Now, how much did we improve or degrade the overall stopband??

     StopbandDelta=StopBndAtten-MinStopBndAtten;

     if PassBndAtten<=AllowedPBAtten,   %Don't violate the
                                        %allowed passband attenuation
        ApxLength=sum(L(KeepIndices))-(length(KeepIndices)-1);
        if ApxLength<=AllowedPreLength, %Don't violate the 
                                        %constraint on our prefilter length
           %This is the cost in length of adding this polynomial
           LengthCost=L(OriginalEligibles(Addition));
           CostOfAdding=-Alpha*OffendFrqDelta-Beta*StopbandDelta ..
                         +Gamma*LengthCost+Sigma*MultiBandDelta;
           if CostOfAdding<MinCostOfAdding,
              MostSignificant=OriginalEligibles(Addition);
              MinCostOfAdding=CostOfAdding;
           end; %if
         end;  %if
       end;  %if
end;  %for
           
%Now append the most significant to the vector of eligibles
Eligibles=[Eligibles MostSignificant];
