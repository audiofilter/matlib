function ap = aplsp2(Nap,x,wp)
% APSLP2
% MATLAB m-file for ALLPASS fractional delay filter design
% using ONE-SHOT LS approximation
% format: ap = aplsp2(Nap,x,wp)
% Input: Nap = filter order N 
%        x = fractional delay (0 < x <= 1) 
%        wp = passband edge of approximation (0 < wp < 1)
% Output: Filter coefficient vector ap=ap(1)...ap(N+1)
%         (Note that ap(1)=1 always)
% Subroutines: standard MATLAB & SP Toolbox functions &
%              numint2.m, eigsolv2.m
% Timo Laakso   27.02.1993
% Last revision 15.01.1996

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialization: 
%
dw = wp/200;         % 201-point approximation grid
wf = [0:dw:wp];      % vector of freq. pts
%
%thP = -(Nap+x)*wf;  % prescribed phase
%
% beta and initializations
%
beta = -0.5*x*wf; beta2=2*beta;
ap = zeros(1,Nap+1);      % allpass coefficient vector
P1 = zeros(Nap+1);        % eigenfilter matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute P1:
%
cT = zeros(1,Nap); cH = cT; rH = cT; Nap1 = Nap-1; k1wf=wf-wf;
for k=1:Nap+1
  k1wf = (k-1)*wf;
  cT(k) = numint2(cos(k1wf));          % first column of Toeplitz
  cH(k) = numint2(cos(beta2-k1wf));    % first column of Hankel
  rH(k) = numint2(cos(beta2-(k+Nap1)*wf)); % last row of Hankel
end;
%
T1 = toeplitz(cT); H1 = hankel(cH,rH);
P1 = T1-H1; 
ap = eigsolv2(P1,Nap+1);           % solve the eigenvalue problem
