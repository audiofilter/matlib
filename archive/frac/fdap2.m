% MATLAB m-file for approximation of fractional delay
% MAIN PROGRAM FOR ALLPASS DESIGN (fdap2.m)
%
% Input:       Design methods + parameters (all via keyboard)
% Output:      Phase delay plots + impulse responses
% Subroutines: aplsp2.m,aplspi2.m,aplspd2.m,aplspdi2.m,
%              apflat2.m,apeqp2.m,apeqpd2.m,apfar2.m, and
%              bincof2.m,eigsolv2.m,envelop2.m,numint2.m
%              (as their subroutines)
%              + Standard MATLAB & SP Toolbox functions 
%
% This software is being provided to you, the LICENSEE, by Helsinki
% University of Technology (HUT) under the following license. 
% By obtaining, using and/or copying this software, you agree that you 
% have read, understood, and will comply with these terms and conditions:  
%
% Permission to use, copy, modify and distribute, including the right to grant 
% others rights to distribute at any tier, this software and its documentation 
% for any purpose and without fee or royalty is hereby granted, provided that you 
% agree to comply with the following copyright notice and statements, including 
% the disclaimer, and that the same appear on ALL copies of the software and 
% documentation, including modifications that you make for internal use or for 
% distribution:
%
% Copyright 1996 by Helsinki University of Technology (HUT)
% All rights reserved.  
%
% The allpass design package is copyrighted by NOKIA, MIT, and GE (1994).
%
% THIS SOFTWARE IS PROVIDED "AS IS", AND Helsinki University of Technology MAKE NO 
% REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED.  By way of example, but not 
% limitation, Helsinki University of Technology MAKE NO REPRESENTATIONS OR WARRANTIES OF 
% MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THE 
% LICENSED SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY PATENTS, 
% COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.   
%
% The name of the HUT may NOT be used in advertising or publicity pertaining 
% to distribution of the software.  
% Title to copyright in this software and any associated documentation 
% shall at all times remain with the HUT and USER agrees to preserve same.  
%
% Timo Laakso    23.12.1992 (fdalpas.m)
% This  version: 16.01.1996 by Timo Laakso and Vesa Valimaki

disp(' ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('% This MATLAB program designs fractional delay (FD)   %');
disp('% ALLPASS filters and plots their impulse and phase   %');
disp('% delay responses (see README for details!)           %');
disp('%                                                     %');
disp('% 1996 Timo Laakso and Vesa Valimaki                  %');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
disp('Choose one of the following design methods:');
disp('  1: Noniterative LS phase');
disp('  2: Noniterative LS phase delay');
disp('  3: Iterative LS phase');
disp('  4: Iterative LS phase delay');
disp('  5: Maximally flat (Thiran)');
disp('  6: Equiripple phase (iterative)');
disp('  7: Equiripple phase delay (iterative)');
disp('  8: Farrow structure (for nonit. LS pd appr.)');
method = input('Give number of design method (1-8): ');
disp(' ');
N= input('Give filter order (ca.1-20): ');
disp(' ');
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Common parameters
%
Npt = 256;           % number of frequency points for plots
Nfil = 11;           % number of filters (in the range x=0..0.5)
dinc = 1.0/(Nfil-1); % fractional delay increment
w = (0:1:(Npt-1))/Npt; wpi = w*pi;
w2=w(2:Npt); wpi2=wpi(2:Npt); % use to avoid division by zero
ap = zeros(1,(N+1)); iap = ap;
apvec=zeros(Nfil,N+1);  % allpass coefficient matrix
phasdel = zeros(Nfil,Npt-1);
wpx=1.0; wp=wpx*pi;           % cutoff frequency
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Specific parameters for each method
%
if method~=5   % all methods but Thiran
  disp(' ');
  wpx = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');  
  wp=wpx*pi;
end
if method==8   % Farrow structure
  disp(' ');
  P = input('Give polynomial order for FARROW structure (ca. 1-5): ');
  disp(' ');  
end
disp(' designing... ');
disp(' ');
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Design filters
%
format compact
for i=1:Nfil
  d=-0.5+(i-1)*dinc
  if d==0 d=d+0.000001; end;  % avoid problems
%
  if method==1 ap=aplsp2(N,d,wp);  end;  % nonit. LS phase
  if method==2 ap=aplspd2(N,d,wp); end;  % nonit. LS phase delay
  if method==3 ap=aplspi2(N,d,wp); end;  % it. LS phase
  if method==4 ap=aplspdi2(N,d,wp);end;  % it. LS phase delay
  if method==5 ap=apflat2(N,d);    end;  % max flat (Thiran)
  if method==6 ap=apeqp2(N,d,wp);  end;  % equiripple phase
  if method==7 ap=apeqpd2(N,d,wp); end;  % equiripple phase
  if method==8 i=Nfil+1; end; % no iterations here for Farrow 
%
  apvec(i,:)= ap;         % store designed ap coeff. vector
%
%  Calculate responses:
%
  if method~=8 % all except Farrow
    for k=1:(N+1); iap(k)=ap(N+2-k); end % numerator polynomial
    H = freqz(iap,ap,wpi);
    uwphase=-unwrap(angle(H));
    phasdel(i,:) = uwphase(2:Npt)./wpi2; % avoid divide by zero
  end % method~=8
end % for i
%
if method==8 [phasdel,apvec]=apfar2(N,P,wp); end; % Farrow structure (for 
                                       % LS phase delay appr.)
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Plot impulse responses
%
figure(4); 
Nimp=N+10; invec=zeros(1,Nimp); invec(1)=1; nvec=(1:1:Nimp);
%
for k=1:Nfil
  ap=apvec(k,:); iap=ap(N+1:-1:1);
  h=filter(iap,ap,invec); plot(nvec,h,'-g'); hold on
end;
ap=apvec(6,:); iap=ap(N+1:-1:1);
h=filter(iap,ap,invec);  % compute impulse response
plot(nvec,h,'-r');

xlabel('TIME IN SAMPLES'); ylabel('IMPULSE RESPONSE');
if method==1 title(['FD Allpass / Nonit. LS phase N=',num2str(N)]); end
if method==2 title(['FD Allpass / Nonit. LS phase delay N=',num2str(N)]); end
if method==3 title(['FD Allpass / It. LS phase N=',num2str(N)]); end
if method==4 title(['FD Allpass / It. LS phase delay N=',num2str(N),'P=',num2str(P)]); end
if method==5 title(['FD Allpass / Max. flat (Thiran) N=',num2str(N)]); end
if method==6 title(['FD Allpass / Equiripple phase (it.) N=',num2str(N)]); end
if method==7 title(['FD Allpass / Equiripple phase delay (it.) N=',num2str(N)]); end
if method==8 title(['FD Allpass / Farrow (LS pd appr.) N=',num2str(N)]); end
hold off
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Plot phase delay responses
%
figure(5); 
for k=1:Nfil
  plot(w2,phasdel(k,:),'-g'); hold on,
end;
plot(w2,phasdel(6,:),'-r');
xlabel('NORMALIZED FREQUENCY'); ylabel('PHASE DELAY');
if method==1 title(['FD Allpass / Nonit. LS phase N=',num2str(N)]); end
if method==2 title(['FD Allpass / Nonit. LS phase delay N=',num2str(N)]); end
if method==3 title(['FD Allpass / It. LS phase N=',num2str(N)]); end
if method==4 title(['FD Allpass / It. LS phase delay N=',num2str(N)]); end
if method==5 title(['FD Allpass / Max. flat (Thiran) N=',num2str(N)]); end
if method==6 title(['FD Allpass / Equiripple phase (it.) N=',num2str(N)]); end
if method==7 title(['FD Allpass / Equiripple phase delay (it.) N=',num2str(N)]); end
if method==8 title(['FD Allpass / Farrow (LS pd appr.) N=',num2str(N),'P=',num2str(P)]); end
axis([0 1 (N-.6) (N+.6)])
hold off
%
disp(' ');
disp(' That was it! Thank you for your interest!');
disp(' If you want to design more FD filters, ');
disp(' run fdap2.m or fdfir2.m again!');
disp(' ');
disp('            - o - o -            ');
