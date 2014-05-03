% MATLAB m-file for approximation of fractional delay
% MAIN PROGRAM FOR FIR DESIGN (fdfir2.m)
%
% Input:       Design methods + parameters (all via keyboard)
% Output:      Magnitude response and phase delay plots + impulse responses
% Subroutines: iniheq2.m,inihip2.m,inihsin2.m,hsincw2.m,
%              hsplin2.m,hgls2.m,hlagr2.m,heqrip2.m,hcontro2.m,
%              firfar2.m + Standard MATLAB & SP Toolbox functions
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
% Timo Laakso  23.12.1992 
% This  version: 16.01.1996 by Timo Laakso and Vesa Valimaki
%
disp(' ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('% This MATLAB program designs fractional delay (FD)   %');
disp('% FIR filters and plots their magnitude and phase     %');
disp('% delay responses (see README for details!)           %');
disp('%                                                     %');
disp('% 1996 Timo Laakso and Vesa Valimaki                  %');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
disp('Choose one of the following design methods:');
disp('  1: Sinc windowing');
disp('  2: Spline transition band');
disp('  3: General least-squares');
disp('  4: Lagrange interpolation');
disp('  5: Equiripple (Oetken)');
disp('  6: Upsampling interpolation');
disp('  7: Continuous delay control (sinc)');
disp('  8: Continuous delay control (Farrow)');
disp(' ');
method = input('Give number of design method (1-8): ');
disp(' ');
L= input('Give filter length (ca. 2-50): ');
disp(' ');
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Common parameters
%
N = L-1;             % filter order
Npt = 256;           % number of frequency points for plots
Nfil = 6;            % number of filters (in the range x=0..0.5)
dinc = 0.5/(Nfil-1); % fractional delay increment
w = (0:1:(Npt-1))/Npt; wpi = w*pi;
w2=w(2:Npt); wpi2=wpi(2:Npt); % use to avoid division by zero
h = zeros(1,L);      % impulse response vector
hvec=zeros(Nfil,L);  % impulse response coefficient matrix
magresp = zeros(Nfil,Npt); 
phasdel = zeros(Nfil,Npt-1);
win = zeros(1,L); wp=1.0; 
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Specific parameters for each method
%
if method==1   % 1: Sinc windowing
  wp=1.0; win=ones(1,L); 
  disp('SINC WINDOWING design');
  disp(' ');
  disp('Choose the window:');
  disp('  1: Rectangular');
  disp('  2: Chebyshev'); 
  disp(' ');
  wintype = input('Give number of window type (1-2): ');
  disp(' ');
  if wintype==2
     wrip = input('Give window ripple in dB (ca. 15-50): ');
     disp(' ');
  end % wintype==2
  wp = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');
end; % method==1
%
if method==2   % 2: Spline transition band
  disp('SPLINE TRANSITION BAND design');
  disp(' ');
  P = input('Give spline order (ca. 1-5): ');
  disp(' ');
  wp = input('Give passband edge freq. (0-1.0): ');
  disp(' ');
  ws = input('Give stopband edge freq. (wp-1.0): ');
end; % method==2
%
if method==3   % 3: General least-squares
  disp('GENERAL LEAST SQUARES design');
  disp(' ');
  wp = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');
end; % method==3
%
% method==4 Lagrange interpolation (no extra parameters)
%
if method==5   % 5: Equiripple (Oetken)
  disp('EQUIRIPPLE DESIGN (OETKEN)');
  disp(' ');
  if  (rem(L,2)==1) 
    L=L+1;      % increment L if odd!
    disp(['We set L = ',num2str(L),' (even only possible!)']);
  end  % if rem
  wp = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');
  disp(' Designing prototype filter using Remez...');
  [IP,wprot]=iniheq2(L,wp);
  disp(' ...done!');
end; % method==5
%
if method==6   % 6: Upsampling interpolation
  disp('UPSAMPLING INTERPOLATION design');
  disp(' ');
  wp = input('Give normalized bandwidth (0-1.0): ');
  Q=2*(Nfil-1);        % number of polyphase filters
  disp([' We use Q = ',num2str(Q),' polyphase filters ']);
  disp([' Length of equiripple prototype filter is ',num2str(L*Q)]);
  disp([' Designing prototype filter using Remez...']);
  Hip=inihip2(L,Q,wp); 
  disp(' ...done!');           
end; % method==6
%
if method==7   % 7: Continuous delay control
  disp('CONTINUOUS DELAY CONTROL design');
  disp(' applying sinc shifting');
  disp(' to equiripple approximation.');
  disp(' ');
  if  (rem(L,2)==1) 
    L=L+1;      % increment L if odd!
    disp(['We set L = ',num2str(L),' (even only possible!)']);
  end  % if rem
  wp = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');
  disp(' Designing prototype filter using Remez...');
  [IP,wprot]=iniheq2(L,wp);
  disp(' ...done!');
  hprot=heqrip2(L,0.2,wprot,IP);
end; % method==7
%
if method==8   % 8: General least-squares
  disp('Design of Farrow Structure (with GEN. LS appr.');
  disp(' ');
  wp = input('Give normalized bandwidth (0-1.0): ');
  disp(' ');
  P = input('Give polynomial order for FARROW structure (ca. 1-5): ');
  disp(' ');  
end; % method==8
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Design filters
%
format compact
for ix=1:Nfil
  d=(ix-1)*dinc 
  if d==0 d=0.000001; end; % avoid problems         
% 
  if method==1   % 1: Sinc windowing
    if wintype==2 win=inihsin2(L,wrip,d); end 
    h=hsincw2(L,d,wp,win); 
  end;  % method==1
%
  if method==2  % 2: Spline transition band
    h=hsplin2(L,d,wp,ws,P); h=h';
  end;  % method==2
%
  if method==3  % 3: General least-squares
    h=hgls2(L,d,wp); h=h';
  end;  % method==3
%
  if method==4  % 4: Lagrange interpolation
    h=hlagr2(L,d);
  end;  % method==4
%
  if method==5  % 5: Equiripple (Oetken)
    h=heqrip2(L,d,wprot,IP); h=h';
  end;  % method==5
%
  if method==6  % 6: Upsampling interpolation
    qi=Q-ix+2; if qi>Q qi=qi-Q; end;
    h=Hip(:,qi);     % use index for the polyphase branch
    if qi==1 h=[h(2:L); 0]; end;  % shift /TLa 16.10.95
    h=h';
  end;  % method==6
%
  if method==7  % 7: Continuous delay control via sinc shifting
    h=hcontro2(L,d-0.2,hprot); wrip=40; 
    win=inihsin2(L,wrip,d);  % shifted window design
    h=(h').*win;             % windowing restored /TLa 16.10.95
  end;  % method==7
%
%  Calculate responses:
%
  h = h/sum(h);      % scale response at zero freq. to unity
  hvec(ix,:)= h;     % store designed impulse response vector
  H = freqz(h,1,wpi);
  magresp(ix,:) = abs(H);
  uwphase=-unwrap(angle(H));
  phasdel(ix,:) = uwphase(2:Npt)./wpi2; % avoid divide by zero
end; % for ix=1:Nfil
%
if method==8  % 8: Continuous delay control via Farrow structure
  [magresp,phasdel,hvec]=firfar2(N,P,wp);  
end;  % method==8
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Plot impulse responses
%
figure(1); hold off;
nvec=(1:1:L);
%
for k=1:Nfil
  h=hvec(k,:); plot(nvec,h,'-g'); hold on
end;
h=hvec(1,:); plot(nvec,h,'-r');
xlabel('TIME IN SAMPLES'); ylabel('IMPULSE RESPONSE');
%
if method==1
  if wintype==1 title(['FD FIR / WINDOWING (Rect.win.) L=',num2str(L)]); end  
  if wintype==2 title(['FD FIR / WINDOWING (Cheb.win) L=',num2str(L),' wrip=',num2str(wrip),' wp=',num2str(wp),')']); end;
end; % method==1
if method==2 title(['FD FIR / SPLINE TRANSITION  L=',num2str(L),' P=',num2str(P),', wp=',num2str(wp)]); end; 
if method==3 title(['FD FIR / GEN. LS DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==4 title(['FD FIR / LAGRANGE INTERPOLATION  L=',num2str(L)]); end;  
if method==5 title(['FD FIR / EQUIRIPPLE DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==6 title(['FD FIR / UPSAMPLING INTERP.  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==7 title(['FD FIR / SINC DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==8 title(['FD FIR / FARROW DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
hold off
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Plot magnitude responses
%
figure(2);hold off
plot(w,magresp(1,:),'-r');hold on;
for i = 2:Nfil
  plot(w,magresp(i,:),'-g');
end; % for i
%
xlabel('NORMALIZED FREQUENCY'); ylabel('MAGNITUDE');
%
if method==1
  if wintype==1 title(['FD FIR / WINDOWING (Rect.win.) L=',num2str(L)]); end  
  if wintype==2 title(['FD FIR / WINDOWING (Cheb.win) L=',num2str(L),' wrip=',num2str(wrip),' wp=',num2str(wp),')']); end;
end; % method==1
if method==2 title(['FD FIR / SPLINE TRANSITION  L=',num2str(L),' P=',num2str(P),', wp=',num2str(wp)]); end; 
if method==3 title(['FD FIR / GEN. LS DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==4 title(['FD FIR / LAGRANGE INTERPOLATION  L=',num2str(L)]); end;  
if method==5 title(['FD FIR / EQUIRIPPLE DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==6 title(['FD FIR / UPSAMPLING INTERP.  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==7 title(['FD FIR / SINC DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==8 title(['FD FIR / FARROW DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
hold off
%
%%%%+%%%%1%%%%+%%%%2%%%%+%%%%3%%%%+%%%%4%%%%+%%%%5%%%%+%%%%6%
% Plot phase delay responses
%
D=N/2;
if (D==round(D)) D=D; else D=D-0.5; end;
%
figure(3); hold off;
d = linspace(0,dinc*(Nfil-1)',Nfil);
plot(w2,phasdel(1,:),'-r'); hold on
for i = 2:Nfil
  plot(w2,phasdel(i,:),'-g'); hold on
  text(0.02,d(i)+floor(L/2)-1+0.02,['d = ',num2str(d(i))]);
end; % for i
xlabel('NORMALIZED FREQUENCY'); ylabel('PHASE DELAY');
axis([0 1 D-0.1 D+0.6]);
%
if method==1
  if wintype==1 title(['FD FIR / WINDOWING (Rect.win.) L=',num2str(L)]); end  
  if wintype==2 title(['FD FIR / WINDOWING (Cheb.win) L=',num2str(L),' wrip=',num2str(wrip),' wp=',num2str(wp),')']); end;
end; % method==1
if method==2 title(['FD FIR / SPLINE TRANSITION  L=',num2str(L),' P=',num2str(P),', wp=',num2str(wp)]); end; 
if method==3 title(['FD FIR / GEN. LS DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==4 title(['FD FIR / LAGRANGE INTERPOLATION  L=',num2str(L)]); end;  
if method==5 title(['FD FIR / EQUIRIPPLE DESIGN  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==6 title(['FD FIR / UPSAMPLING INTERP.  L=',num2str(L),' wp=',num2str(wp)]); end;
if method==7 title(['FD FIR / SINC DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
if method==8 title(['FD FIR / FARROW DELAY CONTROL  L=',num2str(L),' wp=',num2str(wp)]); end; 
%hold off;

disp(' ');
disp(' That was it! Thank you for your interest!');
disp(' If you want to design more FD filters, ');
disp(' run fdap2.m or fdfir2.m again!');
disp(' ');
disp('            - o - o -            ');

