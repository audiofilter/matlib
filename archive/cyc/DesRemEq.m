%******************************************************************
%**** DesRemEq ****
%****
%**** This routine designs the Remez equalizer, and plots the
%**** prefilter-equalizer responses.  This is a separate 
%**** MATLAB M-File that is called from the main routine.
%******************************************************************
if BandPass,
   %passband-stopband relative weighting multipliers
     PSMultiplier=[(1.0/(PassStopWt))*ones(1:length(StopSpecRangeOne)) ..
                   ones(1:length(PassbandVector)) ..
                   (1.0/(PassStopWt))*ones(1:length(StopSpecRangeTwo))];
end;
if LowPass,
     PSMultiplier=[ones(1:length(PassOne)) ..
                   (1.0/(PassStopWt))*ones(1:length(StopSpecRange))];
end;
if MultiBand,
  PSMultiplier=[(1.0/(PassStopWt))*ones(1:length(StopSpecRangeOne)) ..
    ones(1:length(PassOne)) (1.0/(PassStopWt))* ..
    ones(1:length(StopSpecRangeTwo)) ones(1:length(PassTwo)) ..
    (1.0/(PassStopWt))*ones(1:length(StopSpecRangeThree))];
end;
              
%  Now we multiply WtInverse by the relative PB-SB multiplier
%  and then threshold it to some pre-determined threshold

   FinlWtInverse=WtInverse.*PSMultiplier;
   FinlWtInverse=min(FinlWtInverse,1/WtThreshold);

%  This next loop just forces the magnitudes and weights to
%  occur in pairs.  The remez call requires magnitudes in pairs. 
   for Count=1:2:length(ESpecband)-1,
      ESpecband(Count)=ESpecband(Count+1);
      FinlWtInverse(Count)=FinlWtInverse(Count+1);
   end;
% ...and now we take every other weight since there are half
% as many weights as there are frequency and magnitude points
   Weights=[(1.0./abs(FinlWtInverse(1:2:length(WtInverse)-1)))];

%***********NOW WE'LL DESIGN THE EQUALIZER ************************

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

[FEqualizer,w]=freqz(Equalizer,1,NumberOfSamples);
  
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
