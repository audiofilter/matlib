function [magresp,phasdel,hvec] = firfar2(N,Np,wp)
% FIRFAR2
% MATLAB m-file for approximation of fractional delay
% CONTINUOUS DELAY CONTROL OF FIR FILTERS
% using Farrow structure with polynomial approximation
% This version: General LS approximation (can be changed)
% Format: [magresp,phasdel,hvec] = firfar2(N,Np,wp)
% Input: N = filter order
%        Np = pol. order
%        wp = cutoff freq.
% Output: magnitude response and phase delay plots
% Subroutines: standard MATLAB functions etc.
%
% NOTE! If you change the parameters below, check
% that they are consistent with those of fdfir2.m
%
% Timo Laakso   14.03.1993
% Last revision 16.01.1996 / Timo Laakso
L = N+1;             % filter length;
Npt = 256;           % no. of frequency points for plots
Nfil = 6;            % no. of filters (in the range x=0..0.5)
xinc=0.5/(Nfil-1);   % fractional delay increment
%
w = (0:1:(Npt-1))/Npt; wpi = w*pi;
w2=w(2:Npt); wpi2=wpi(2:Npt); % use to avoid division by zero
h = zeros(1,(N+1)); 
magresp = zeros(Nfil,Npt); 
phasdel = zeros(Nfil,Npt-1);
%
xvec=zeros(Nfil,1);     % fractional delay vector
hvec=zeros(Nfil,N+1);   % coefficient matrix
C=zeros(Np+1,N+1);      % polynomial coeff. matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design prototype filters (FARROW only!)
%
for i=1:Nfil
  x=(i-1)*xinc+0.0000001;       % add 0.001 to avoid sin(0)/0;
  xvec(i)=x;
  h=hgls2(L,x,wp);         % least-squares phase delay design
                           % CHANGE IF DESIRED!
  hvec(i,:)=h';            % store designed coeff. vector
end % for i  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design polynomial approximation for each coefficient (FARROW only!)
%
for k=1:(N+1)
  cc=polyfit(xvec,hvec(:,k),Np);  
                   % fit Np:th-order polynomial to each coeff set
  C(:,k)=cc';
end % for k
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calculate responses (FARROW):
%
for j=1:Nfil
  x=(j-1)*xinc + 0.0001;     % add 0.001 to avoid sin(0)/0;
  h = C(Np+1,:);             % coeffs. via pol. approximation
  for n=1:Np
    h=h+x^n*C(Np+1-n,:);
  end % for n
%
  h=h/sum(h);                 % scale response at zero freq. to unity
  H = freqz(h,1,wpi);
  magresp(j,:) = abs(H);
  uwphase=-unwrap(angle(H));
  phasdel(j,:) = uwphase(2:Npt)./wpi2; % avoid divide by zero
end % for j   
