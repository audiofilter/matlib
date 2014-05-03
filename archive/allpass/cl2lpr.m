function [h,wp,ws,L2E,mL2,it] = cl2lpr(m,wo,up,lo,L)
% Constrained L2 Low Pass FIR filter design with Refinement
% (constraint frequncies are refined with Newton's Method)
% (odd length symmetric FIR filters only)
% Author : Ivan Selesnick, October 94, Rice University
% See : Constrained Least Square Design of FIR Filters without
% Specified Transition Bands, (to appear) in Proc of the IEEE 95
% International Conference on Acoustices, Speech and Signal
% Processing (ICASSP 95)
% input:  
%  m  : degree of cosine polynomial
%  wo : pass band edge in (0,pi)
%  up : [upper bound in pass band, upper bound in stop band]
%  lo : [lower bound in pass band, lower bound in stop band]
%  L  : grid size (optional)
% output:
%  h   : filter of length 2*m+1
%  wp  : passband edge
%  sp  : stopband edge
%  L2E : L2 error
%  mL2 : minimum L2 error achievable (L2 error of best L2 filter)
%  it  : number of iterations
%
% EXAMPLE
%  wo = 0.3*pi;        % the cutoff frequency
%  m  = 30;            % the filter length is 2*m+1
%  dp = 0.03;          % the maximum ripple size in the pass band
%  ds = 0.01;          % the maximum ripple size in the stop band
%  up = [1+dp, ds];    % [upper bound in passband, stopband]
%  lo = [1-dp, -ds];   % [lower bound in passband, stopband]
%  [h,wp,ws,L2E,mL2,it] = cl2lpr(m,wo,up,lo);
%
%  to plot the frequency response, you can use the following commands
%  L = 2^11;
%  H = fft(h,L);
%  H = abs(H(1:L/2+1));
%  plot([0:L/2]*2/L,H)
%  (or you can change the PF (print figures) flag below to 1)

if nargin < 5
   L = 2^ceil(log2(5*m));
end
PF = 0;                          % flag : Plot Figures (1:plot figs, 0:don't)
w = [0:L]*pi/L;                  % w includes both 0 and pi
Z = zeros(2*L-2*m-1,1);
q = round(wo*L/pi);
u = [up(1)*ones(q,1); up(2)*ones(L+1-q,1)];
l = [lo(1)*ones(q,1); lo(2)*ones(L+1-q,1)];
c = 2*[wo/sqrt(2); [sin(wo*[1:m])./[1:m]]']/pi;
mL2 = 2*wo/pi - c'*c;
L2E = mL2;
a = c;                          % best L2 cosine coefficients
mu = [];                        % Lagrange multipliers
SN = 1e-11;                     % Small Number
it = 0;
% BEGIN LOOPING
while 1

   % calculate H 
   H = fft([a(1)*sqrt(2); a(2:m+1); Z; a(m+1:-1:2)]); 
   H = real(H(1:L+1)/2);

   % find local maxima and minima
   kmax = local_max(H);
   kmin = local_max(-H);

   % refine frequencies
   cmax = (kmax-1)*pi/L;
   cmin = (kmin-1)*pi/L;
   cmax = refine(a,cmax);
   cmin = refine(a,cmin);

   % evaluate H at refined frequencies
   Hmax = a(1)/sqrt(2) + cos(cmax*[1:m])*a(2:m+1);
   Hmin = a(1)/sqrt(2) + cos(cmin*[1:m])*a(2:m+1);

   % determine new constraint set
   v1   = Hmax > u(kmax)-10*SN;
   v2   = Hmin < l(kmin)+10*SN;
   kmax = kmax(v1);
   kmin = kmin(v2);
   cmax = cmax(v1);
   cmin = cmin(v2);
   Hmax = Hmax(v1);
   Hmin = Hmin(v2);
   n1   = length(kmax);
   n2   = length(kmin);

   % plot figures
   if PF 
   wv = [cmax; cmin];
   Hv = [Hmax; Hmin];
   figure(1),
	plot(w/pi,H),
	axis([0 1 -.2 1.2])
	hold on,
	plot(wv/pi,Hv,'o'),
	hold off
   figure(3)
	subplot(211)
	plot(w/pi,H-1),
	hold on,
	plot(wv/pi,Hv-1,'o'),
	hold off
	axis([0 wo/pi 2*(lo(1)-1) 2*(up(1)-1)])
	subplot(212)
	plot(w/pi,H),
	hold on,
	plot(wv/pi,Hv,'o'),
	hold off
	axis([wo/pi 1 2*lo(2) 2*up(2)])
   pause(.1)
   end

   % check stopping criterion
   E  = max([Hmax-u(kmax); l(kmin)-Hmin; 0]);
   fprintf(1,'    Bound Violation = %15.13f  L2E = %18.15f\n',E,L2E);
   if E < SN
      fprintf(1,'    I converged in %d iterations\n',it)
      break
   end

   % calculate new Lagrange multipliers
   G = [ones(n1,m+1); -ones(n2,m+1)].*cos([cmax; cmin]*[0:m]);
   G(:,1) = G(:,1)/sqrt(2);
   d = [u(kmax); -l(kmin)];
   mu = (G*G')\(G*c-d);            

   % iteratively remove negative multiplier
   [min_mu,K] = min(mu);
   while min_mu < 0
      G(K,:) = [];
      d(K) = [];
      mu = (G*G')\(G*c-d);            
      [min_mu,K] = min(mu);
   end

   % determine new cosine coefficients
   v   = G'*mu;
   L2E = v'*v + mL2;
   a   = c-v;

   it = it + 1;

end

h = [a(m+1:-1:2)/2; a(1)/sqrt(2); a(2:m+1)/2];

be = fir_fbe([a(1)/sqrt(2); a(2:m+1)],[wo,wo],[lo(1),up(2)]);
wp = be(1);
ws = be(2);


