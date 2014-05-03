function ap = apeqpd2(Nap,x,wp)
% APEQPD2
% MATLAB m-file for ALLPASS fractional delay filter design
% usign EQUIRIPPLE PHASE DELAY approximation
% Format: ap = apeqpd2(Nap,x,wp)
% Input: Nap = filter order N 
%        x = fractional delay (0 < x <= 1) 
%        wp = passband edge of approximation (0 < wp < 1)
% Output: Filter coefficient vector ap=ap(1)...ap(N+1)
% Subroutines: standard MATLAB & SP Toolbox functions &
%              numint2.m, eigsolv2.m, envelop2.m
%
% Timo Laakso 27.02.1993
% Revised 15.01.1996 by Timo Laakso
%         17.01.1996 by Vesa Valimaki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialization: 
%
dw = wp/200;         % 201-point approximation grid
wf = [0:dw:wp]+0.00001;      % vector of freq. pts
%
thP = -(Nap+x)*wf;  % prescribed phase
%
% beta and initializations
%
beta = -0.5*x*wf; beta2=2*beta;
sinB = sin(beta); cosB = cos(beta);
W0=wf+1-wf; W0=W0./(wf.*wf);            % weighting for phase delay design
wc = wf-wf; W = wc;                    % iterative weight vectors
ap = zeros(1,Nap+1); ap(1)=1;          % allpass coefficient vector
P4 = zeros(Nap+1);                     % eigenfilter matrix
Nap1=Nap-1;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute P4:
%
EP = 2;     % initial exponent parameter     
% initial value ap from P1!
lser=1000; it=0;
%while ((lser>1.0E-9)&(it<31));
while ((lser>1.0E-12)&(it<101));  % VPV 9.12.1996
  if (EP<50)
    if (lser<1.0E-5)
      if (EP<4) EP = EP+1;
      elseif (EP<10) EP = EP+2;
      else EP = EP+5;
      end;      % 3rd if
      lser = 1000;
    end         % 2nd if
  end           % 1st if
  it = it+1;  % iteration number 
  Hap = freqz(ap,1,wf);   % weight function from the previous solution
  wc = cosB.*real(Hap) - sinB.*imag(Hap);
  thAP4 = -Nap*wf+2*unwrap(angle(freqz(1,ap,wf)));
  deltaT4 = thP-thAP4;
  deltaT4 = -deltaT4./wf;   % use PHASE DELAY error for envelope!
  wenv = envelop2(deltaT4); % create the envelope for equiripple weighting
  W = (wenv.^EP)./(wc.^2);
  for k=1:Nap+1
    k1wf = (k-1)*wf;
    cT(k) = numint2(W.*cos(k1wf)); 
    cH(k) = numint2(W.*cos(beta2-k1wf));
    rH(k) = numint2(W.*cos(beta2-(k+Nap1)*wf));
  end % for k
  T1 = toeplitz(cT); H1 = hankel(cH,rH);
  P4 = T1-H1; apold = ap;
  ap= eigsolv2(P4,Nap+1);     % solve the eigenvalue problem
  ap = (ap+(EP-1)*apold)/EP;
  dif=apold-ap; lser=dif*dif'/Nap;
end              % while lser,it
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
