function ap = aplspdi2(Nap,x,wp)
% APLSPDI2
% MATLAB m-file for ALLPASS fractional delay filter design
% usign ITERATIVE (TRUE) LS PHASE DELAY approximation
% Format: ap = aplspdi2(Nap,x,wp)
% Input: Nap = filter order N 
%        x = fractional delay (0 < x <= 1)  
%        wp = passband edge of approximation (0 < wp < 1)
% Output: Filter coefficient vector ap = ap(1)...ap(N+1)
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
wf = [0:dw:wp]+0.0001;      % vector of freq. pts
%
%thP = -(Nap+x)*wf;  % prescribed phase
%
% beta and initializations
%
beta = -0.5*x*wf; beta2=2*beta;
sinB = sin(beta); cosB = cos(beta);
W0=wf+1-wf; W0=W0./(wf.*wf);            % weighting for phase delay design
wc = wf-wf; W = wc;                    % iterative weight vectors
ap = zeros(1,Nap+1); ap(1)=1;          % initial allpass coefficient vector
P3 = zeros(Nap+1);                     % eigenfilter matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute P3:
%
it = 0; lser = 1000; 
Nap1 = Nap-1; k1wf=wf-wf;
while ((lser>1.0E-8)&(it<10))
  it=it+1;
  Hap=freqz(ap,1,wf);   % weight function from the previous solution
  wc=cosB.*real(Hap)-sinB.*imag(Hap);
  W=W0./(wc.^2);
  for k=1:Nap+1
    k1wf = (k-1)*wf;
    cT(k) = numint2(W.*cos(k1wf));
    cH(k) = numint2(W.*cos(beta2-k1wf));
    rH(k) = numint2(W.*cos(beta2-(k+Nap1)*wf));
  end;
  T1 = toeplitz(cT); H1 = hankel(cH,rH);
  P3 = T1-H1; apold = ap;
  ap = eigsolv2(P3,Nap+1);
  dif = apold-ap; lser=dif*dif';
end;  % while loop
%
