function [phasdel,apvec] = apfar2(N,Np,wp)
% APFAR2
% MATLAB m-file for approximation of fractional delay
% MAIN PROGRAM FOR CONTINUOUS DELAY CONTROL OF ALLPASS FILTERS
% using Farrow structure with polynomial approximation.
% This version: LS phase delay approximation (can be changed)
% Format: [phasdel,apvec] = apfar2(N,Np,wp)
% Input: N = filter order
%        Np = order of polynomial
%        wp = passband edge of approximation (0 < wp < 1)
%        (edit other parameters in program)
% Output: phasedel = phase delay vector
%         apvec = filter coefficient vector
% Subroutines: standard MATLAB functions
%
% NOTE! If you change the parameters below, check
% that they are consistent with those of fdap2.m
%
% Timo Laakso   14.03.1993
% Last revision 16.01.1996 Timo Laakso
 
Npt = 256;           % no. of frequency points for plots
Nfil = 11;           % no. of filters (in the range x=0..0.5)
xinc=1.0/(Nfil-1);   % fractional delay increment
%
w = (0:1:(Npt-1))/Npt; wpi = w*pi;
w2=w(2:Npt); wpi2=wpi(2:Npt); % use to avoid division by zero
ap = zeros(1,(N+1)); iap = ap; 
phasdel = zeros(Nfil,Npt-1);
%
xvec=zeros(Nfil,1);     % fractional delay vector
apvec=zeros(Nfil,N+1);  % allpass coefficient matrix
C=zeros(Np+1,N+1);      % polynomial coeff. matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design prototype filters (FARROW only!)
%
for i=1:Nfil
  x=-0.5+(i-1)*xinc+0.0000001;           % add 0.001 to avoid sin(0)/0;
  xvec(i)=x;
  ap=aplspd2(N,x,wp);     % least-squares phase delay design
%  ap=apflat2(N,x);
                          % CHANGE IF DESIRED!
  apvec(i,:)= ap;         % store designed ap coeff. vector
end % for i  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design polynomial approximation for each coefficient (FARROW only!)
%
for k=1:(N+1)
  cc=polyfit(xvec,apvec(:,k),Np);  
                   % fit Np:th-order polynomial to each coeff set
  C(:,k)=cc';
end % for k
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calculate responses (FARROW):
%
for j=1:Nfil
  x=-0.5+(j-1)*xinc + 0.0001;     % add 0.001 to avoid sin(0)/0;
  ap = C(Np+1,:);                 % coeffs. via pol. approximation
  for n=1:Np
    ap=ap+x^n*C(Np+1-n,:);
  end % for n
%  
  for k=1:(N+1); iap(k)=ap(N+2-k); end % numerator polynomial
  H = freqz(iap,ap,wpi);
  uwphase=-unwrap(angle(H));
  phasdel(j,:) = uwphase(2:Npt)./wpi2; % avoid divide by zero
end % for j   
