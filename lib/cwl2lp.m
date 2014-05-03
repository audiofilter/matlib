function h = cwl2lp(m,wo,up,lo,wp,ws,K,L)
% h = cwl2lp(m,wo,up,lo,wp,ws,K,L)
% Constrained Weighted L2 Low Pass FIR filter design
% Author: Ivan Selesnick, Rice University, 1995
% See: Constrained Least Square Design of FIR
% Filters Without Specified Transition Bands
% by I.W.Selesnick, M.Lang, C.S.Burrus
%   h  : 2*m+1 filter coefficients
%   m  : degree of cosine polynomial
%   wo : cut-off frequency in (0,pi)
%   up : [upper bound in passband, stopband]
%   lo : [lower bound in passband, stopband]
%   wp : passband edge of L2 weight function
%   ws : stopband edge of L2 weight function
%   K  : stopband L2 weight / passband L2 weight
%   L  : grid size
% need
%   wp <= wo <= ws
% example
%   up = [1.01, 0.01]; lo = [0.99, -0.01];
%   wo = 0.3*pi; wp = 0.28*pi; ws = 0.32*pi;
%   h = cwl2lp(30,wo,up,lo,wp,ws,2,2^11);

r = sqrt(2);              w = [0:L]'*pi/L;
Z = zeros(2*L-1-2*m,1);   q = round(wo*L/pi);
u = [up(1)*ones(q,1); up(2)*ones(L+1-q,1)];
l = [lo(1)*ones(q,1); lo(2)*ones(L+1-q,1)];
c = 2*[wp/r; [sin(wp*[1:m])./[1:m]]']/pi;
% ----- construct R matrix --------------------
v1 = 1:m;                 v2 = m:2*m;
tp = [wp+K*(pi-ws),(sin(v1*wp)-K*sin(v1*ws))./v1]/pi;
hk = ((sin(v2*wp)-K*sin(v2*ws))./v2)/pi;
R = toeplitz(tp,tp) + hankel(tp,hk);
R(1,:) = R(1,:)/r;        R(:,1) = R(:,1)/r;
Ri = inv(R); 
a = Ri*c;    % best L2 cosine coefficients
mu = [];     % Lagrange multipliers
SN = 1e-6;   % Small Number
while 1
  % ----- calculate A -------------------------
  A = fft([a(1)*r;a(2:m+1);Z;a(m+1:-1:2)]);
  A = real(A(1:L+1))/2;
  % ----- find extremals ----------------------
  kmax = local_max(A);    kmin = local_max(-A);
  kmax = kmax( A(kmax) > u(kmax)-10*SN );
  kmin = kmin( A(kmin) < l(kmin)+10*SN );
  % ----- check stopping criterion ------------
  Eup = A(kmax)-u(kmax); Elo = l(kmin)-A(kmin);
  E = max([Eup; Elo; 0]); if E < SN, break, end
  % ----- calculate new multipliers -----------
  n1 = length(kmax);      n2 = length(kmin);
  O  = [ones(n1,m+1); -ones(n2,m+1)];
  G  = O .* cos(w([kmax;kmin])*[0:m]);
  G(:,1) = G(:,1)/r;
  d  = [u(kmax); -l(kmin)];
  mu = (G*Ri*G')\(G*Ri*c-d);
  % ----- remove negative multiplier ----------
  [min_mu,K] = min(mu);
  while min_mu < 0
    G(K,:) = []; d(K) = [];
    mu = (G*Ri*G')\(G*Ri*c-d);
    [min_mu,K] = min(mu);
  end
  % ----- determine new coefficients ----------
  a = Ri*(c-G'*mu);
end
h = [a(m+1:-1:2); a(1)*r; a(2:m+1)]/2;


