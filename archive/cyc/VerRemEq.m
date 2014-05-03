%*******************************************************************
% VerRemEq
%This routine performs a specification verification
% at high frequency domain resolution to see if we met the desired filter
% specification.  This a separate MATLAB M-File that is called from
% the main routine.
%********************************************************************

HugeNumSamples=8192;
[HRPrefilter,w]=freqz(prefilterimpresp,1,HugeNumSamples);
[HRFEqualizer,w]=freqz(Equalizer,1,HugeNumSamples);
if BandPass==1,
      HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
      HRWsTwoIndex=round(2*WsTwo*HugeNumSamples+0.49);
      HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
      HRWpTwoIndex=round(2*WpTwo*HugeNumSamples+0.49);
      HRSIndRangeOne=[1:HRWsOneIndex];
      HRSIndRangeTwo=[HRWsTwoIndex:HugeNumSamples];
      PEMaxPassMagnitude=max(20*log10(abs ..
          (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex) ..
                        .*HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
      PEMinPassMagnitude=min(20*log10(abs ..
          (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
                         HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
      PEPassRipple=PEMaxPassMagnitude-PEMinPassMagnitude;

      PELowMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
                 HRPrefilter(HRSIndRangeOne))));
      PEHiMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeTwo).* ..
                 HRPrefilter(HRSIndRangeTwo))));
      PEMaxStopDev=max(PELowMaxStopDev,PEHiMaxStopDev);

end; %bandpass
if LowPass==1,
      HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
      HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
      HRSIndRangeOne=[HRWsOneIndex:HugeNumSamples];
      PEMaxPassMagnitude=max(20*log10(abs(HRFEqualizer(1:HRWpOneIndex).* ..
                 HRPrefilter(1:HRWpOneIndex))));
      PEMinPassMagnitude=min(20*log10(abs(HRFEqualizer(1:HRWpOneIndex).* ..
                 HRPrefilter(1:HRWpOneIndex))));
      PEPassRipple=PEMaxPassMagnitude-PEMinPassMagnitude;
      PEMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
                 HRPrefilter(HRSIndRangeOne))));
end; %lowpass

if MultiBand==1,
%    0-Ws1-Wp1-Wp2-Ws2-Ws3-Wp3-Wp4-Ws4-0.5      just 2 passbands for now

        HRWsOneIndex=round(2*WsOne*HugeNumSamples+0.49);
        HRWpOneIndex=round(2*WpOne*HugeNumSamples+0.49);
        HRWpTwoIndex=round(2*WpTwo*HugeNumSamples+0.49);
        HRWsTwoIndex=round(2*WsTwo*HugeNumSamples+0.49);
        HRWsThreeIndex=round(2*WsThree*HugeNumSamples+0.49);
        HRWpThreeIndex=round(2*WpThree*HugeNumSamples+0.49);
        HRWpFourIndex=min(round ..
           (2*WpFour*HugeNumSamples+0.49),HugeNumSamples);
        HRWsFourIndex=min(round ..
           (2*WsFour*HugeNumSamples+0.49),HugeNumSamples);

        HRSIndRangeOne=[1:HRWsOneIndex];
        HRSIndRangeTwo=[HRWsTwoIndex:HRWsThreeIndex];
        HRSIndRangeThree=[HRWsFourIndex:HugeNumSamples];


        PEMaxPassMagOne=max(20*log10(abs ..
                 (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
                  HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
        PEMinPassMagOne=min(20*log10(abs ..
                 (HRFEqualizer(HRWpOneIndex:HRWpTwoIndex).* ..
                 HRPrefilter(HRWpOneIndex:HRWpTwoIndex))));
        PEMaxPassMagTwo=max(20*log10(abs ..
                 (HRFEqualizer(HRWpThreeIndex:HRWpFourIndex).* ..
                 HRPrefilter(HRWpThreeIndex:HRWpFourIndex))));
        PEMinPassMagTwo=min(20*log10(abs ..
                 (HRFEqualizer(HRWpThreeIndex:HRWpFourIndex).* ..
                 HRPrefilter(HRWpThreeIndex:HRWpFourIndex))));
        PEPassRippleOne=PEMaxPassMagOne-PEMinPassMagOne;
        PEPassRippleTwo=PEMaxPassMagTwo-PEMinPassMagTwo;
        PEPassRipple=max(PEPassRippleOne,PEPassRippleTwo);


        PELowMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeOne).* ..
                 HRPrefilter(HRSIndRangeOne))));
        PEMidMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeTwo).* ..
                 HRPrefilter(HRSIndRangeTwo))));
        PEHiMaxStopDev=max(20*log10(abs(HRFEqualizer(HRSIndRangeThree).* ..
                 HRPrefilter(HRSIndRangeThree))));
        PEMaxStopDev=max(max(PELowMaxStopDev,PEMidMaxStopDev),PEHiMaxStopDev);

end; %MultiBand
sprintf('Prefilter-Equalizer passband ripple in dB is %g',PEPassRipple)
sprintf('Prefilter-Equalizer stopband attenuation in dB is %g',-PEMaxStopDev)
echo off;
  MsgOne='You FAILED TO MEET YOUR DESIRED SPECIFICATION due to';
  MsgTwo='violation of the PASSBAND RIPPLE constraint!!!';
  MsgThree='violation of the STOPBAND ATTENUATION constraint!!!';
  MsgFour='Please refer to the flowchart in Figure 3 of our paper';
  MsgFive='for recommended action. ';
  MsgSix='You have PASSED both PASSBAND and STOPBAND specifications,';
  MsgSeven='however you may not have a minimal length equalizer.';
  MsgEight='to help decide whether EqLength may be decreased. ';

if PEPassRipple>PassRippleSpec,
  disp(MsgOne);disp(MsgTwo);disp(MsgFour);disp(MsgFive);
end;
if -PEMaxStopDev<StopAttenSpec,
  disp(MsgOne);disp(MsgThree);disp(MsgFour);disp(MsgFive);
end;
if (PassRippleSpec>=PEPassRipple)&(StopAttenSpec<=-PEMaxStopDev),
   disp(MsgSix);disp(MsgSeven);disp(MsgFour);disp(MsgEight);
end;
echo on;


