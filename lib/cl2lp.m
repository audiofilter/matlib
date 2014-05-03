function [h] = cl2lp(m,wo,up,lo,L)
% h = cl2lp(m,wo,up,lo,L)
% Constrained L2 Low Pass FIR filter design
% Author: Ivan Selesnick, Rice University, 1994
% See: Constrained Least Square Design of FIR
% Filters Without Specified Transition Bands
% by I.W.Selesnick, M.Lang, C.S.Burrus
%   h  : 2*m+1 filter coefficients
%   m  : degree of cosine polynomial
%   wo : cut-off frequency in (0,pi)
%   up : [upper bound in passband, stopband]
%   lo : [lower bound in passband, stopband]
%   L  : grid size
% example
%   up = [1.02, 0.02]; lo = [0.98, -0.02];
%   h = cl2lp(30,0.3*pi,up,lo,2^11);

r = sqrt(2);              w = [0:L]'*pi/L;
Z = zeros(2*L-1-2*m,1);   q = round(wo*L/pi);
u = [up(1)*ones(q,1); up(2)*ones(L+1-q,1)];
l = [lo(1)*ones(q,1); lo(2)*ones(L+1-q,1)];
c = 2*[wo/r; [sin(wo*[1:m])./[1:m]]']/pi;
a = c;       % best L2 cosine coefficients
mu = [];     % Lagrange multipliers
SN = 1e-6;   % Small Number

%X = fft([a(1)*r;a(2:m+1);Z;a(m+1:-1:2)]);
%X = real(X(1:L+1))/2;
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
  n1 = length(kmax);         n2 = length(kmin);
  O  = [ones(n1,m+1); -ones(n2,m+1)];
  G  = O .* cos(w([kmax;kmin])*[0:m]);
  G(:,1) = G(:,1)/r;
  d  = [u(kmax); -l(kmin)];
  mu = (G*G')\(G*c-d);
  % ----- remove negative multiplier ----------
  [min_mu,K] = min(mu);
  while min_mu < 0
    G(K,:) = []; d(K) = [];
    mu = (G*G')\(G*c-d);
    [min_mu,K] = min(mu);
  end
  % ----- determine new coefficients ----------
  a = c-G'*mu;
end
h = [a(m+1:-1:2); a(1)*r; a(2:m+1)]/2;


