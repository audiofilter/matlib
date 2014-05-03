function h = fircls(n,be,mag,up,lo)
%
%	h = fircls(n,f,mag,up,lo)
%	Constrained Least Square FIR filter design for desired frequency
%	responses which are piecewise constant.
%
%	input :
%		n   : filter length
%               f   : vector of band edges
%		mag : vector of magnitudes
%		up  : vector of upper bounds
%		lo  : vector of lower bounds
%	output:
%		h   : filter of length n
%
%	mag is a vector describing the piecewise constant desired frequency
%	response. The length of mag is the number of different bands.
%       up and lo are vectors of the same length of mag. They give the
%	upper and lower bounds for the frequency response in each band.
%	f is a vector of transition frequencies. These frequencies must
%	be in increasing order, must start with 0.0, and must end with 1.0.
%	The length of f should exceed the length of mag by exactly 1. 
%
%	EXAMPLE 
%	n   = 51;
%       f   = [0 0.4 0.8 1];
%	mag = [0 1 0];
%	up  = [ 0.02 1.02  0.01]; 
%	lo  = [-0.02 0.98 -0.01];
%	h   = fircls(n,f,mag,up,lo);
%	
%	note :
%       By setting lo equal to 0 in the stopbands, a nonnegative frequency 
%       response amplitude can be obtained. Such filters can be spectrally
%       factored to obtain minimum phase filters.
%

% Author: Ivan Selesnick, Rice University, 1995
% subprograms : local_max.m, frefine.m

PF = 0;		% PF : print flag

% -------- check input parameters -------------

if nargin < 5
	error('You did not supply enough input parameters.')
else
	lm = length(mag);
	lu = length(up);
	ll = length(lo);
	if (lm ~= lu) | (lm ~= ll) | (lu ~= ll)
		error('Each of mag, up, and lo must have the same length.')
	elseif length(be) ~= (lm+1)
		error('f must have one more element than mag')
	elseif be(1) ~= 0
		error('f must begin with 0')
	elseif be(lm+1) ~= 1
		error('f must end with 1')
	elseif any(diff(be)<=0)
		error('The frequencies in f must be in ascending order.')
	elseif any(up <= lo)
		error('Each element of up must be greater than the corresponding element of lo.')
	elseif any(lo > mag)
		error('Each entry of lo should no greater than the corresponding element of mag.')
	elseif any(up < mag)
		error('Each entry of up should no less than the corresponding element of mag.')
	end
end

if prod(size(n)) > 1
	error('n should be a scalar')
end

L = 2^ceil(log2(3*n));
num_bands = length(mag);

if rem(n,2) == 0
        parity = 0;
	m = n/2;
	if (lo(num_bands) > 0) | (up(num_bands) < 0)
		error('Even length filters must equal 0 at f=1.');
	end
else
        parity = 1;
	m = (n-1)/2;
end

r = sqrt(2);
be = be * pi;
% ----- calculate Fourier coefficients and upper ---
% ----- and lower bound functions ------------------
if parity == 1
   c = zeros(m+1,1);
   Z = zeros(2*L-1-2*m,1);
   v = [0:m];
   tt = 1-1/r;
else
   c = zeros(m,1);
   Z = zeros(4*L,1);
   v = [1:m]-1/2;
   tt = 0;
end
u = [];
l = [];
for k = 1:num_bands
   if parity == 1
   	c = c + mag(k) * ...
        	(2*[be(k+1)/r; [sin(be(k+1)*[1:m])./[1:m]]']/pi - ...
         	 2*[be(k)/r;   [sin(be(k)*[1:m])./[1:m]]']/pi);
   else
   	c = c + mag(k) * ...
        	( [4*((sin(be(k+1)*[2*[1:m]-1]/2))./(2*[1:m]-1))/pi]' - ...
          	  [4*((sin(be(k) * [2*[1:m]-1]/2))./(2*[1:m]-1))/pi]' ) ;

   end
   q = round(L*(be(k+1)-be(k))/pi);
   u = [u; up(k)*ones(q,1)];
   l = [l; lo(k)*ones(q,1)];
end
flen = length(u);
if flen < L+1
   ov = ones(L+1-flen,1);
   u(flen+1:L+1) = up(num_bands)*ov;
   l(flen+1:L+1) = lo(num_bands)*ov;
elseif flen > L+1
   u = u(1:L+1);
   l = l(1:L+1);
end

w = [0:L]'*pi/L;
a = c;       % best L2 cosine coefficients
mu = [];     % Lagrange multipliers
SN = 1e-8;   % Small Number
it = 0;
okmax = []; okmin = []; uvo = 0;
ocmax = []; ocmin = []; lvo = 0;
kmax = []; kmin = [];
cmax = []; cmin = [];

while 1

  if (uvo > SN/2) | (lvo > SN/2) 
     % ----- include old extremal ----------------
     if uvo > lvo
        kmax = [kmax; okmax(k1)]; okmax(k1) = [];
        cmax = [cmax; ocmax(k1)]; ocmax(k1) = [];
     else
        kmin = [kmin; okmin(k2)]; okmin(k2) = [];
        cmin = [cmin; ocmin(k2)]; ocmin(k2) = [];
     end
  else
     % ----- calculate A -------------------------
     if parity == 1
        A = fft([a(1)*r;a(2:m+1);Z;a(m+1:-1:2)]);
        A = real(A(1:L+1))/2;
     else
        Z(2:2:2*m) = a;
        Z(4*L-2*m+2:2:4*L) = a(m:-1:1);
        A = fft(Z);
        A = real(A(1:L+1)/2);
     end

     if PF
	cc = [cmax; cmin];
	occ = [ocmax; ocmin];
	if length(cc)>0
	   Acc = cos(cc*v)*a - tt*a(1);
	else
	   Acc = [];
	end
	if length(occ)>0
	   Aocc = cos(occ*v)*a - tt*a(1);
	else
	   Aocc = [];
	end

        figure(1);
        plot(w/pi,A), hold on
        plot(cc/pi,Acc,'o')
        plot(occ/pi,Aocc,'x')
        hold off

        for k = 1:length(be)-1
         figure(k+1);
         plot(w/pi,A), hold on
         plot(cc/pi,Acc,'o')
         plot(occ/pi,Aocc,'x')
         hold off
         axis([be(k)/pi be(k+1)/pi ...
		mag(k)-1.5*(mag(k)-lo(k)) mag(k)+1.5*(up(k)-mag(k))])
        end
    end

     % ----- find extremals ----------------------
     okmax = kmax;              okmin = kmin;
     ocmax = cmax;              ocmin = cmin;
     kmax = local_max(A);       kmin = local_max(-A);
     if parity == 0
        n1 = length(kmax);
        if kmax(n1) == L+1, kmax(n1) = []; end
        n2 = length(kmin);
        if kmin(n2) == L+1, kmin(n2) = []; end
     end
     cmax = (kmax-1)*pi/L;      cmin = (kmin-1)*pi/L;
     cmax = frefine(a,v,cmax);  cmin = frefine(a,v,cmin);

     Amax = cos(cmax*v)*a - tt*a(1);
     Amin = cos(cmin*v)*a - tt*a(1);
     v1 = Amax > u(kmax)-SN;
     v2 = Amin < l(kmin)+SN;
     kmax = kmax(v1); kmin = kmin(v2);
     cmax = cmax(v1); cmin = cmin(v2);
     Amax = Amax(v1); Amin = Amin(v2);

     % ----- check stopping criterion ------------
     Eup = Amax-u(kmax); Elo = l(kmin)-Amin;
     E = max([Eup; Elo]);
     fprintf(1,'  Bound Violation = %15.13f  \n',E);
     if E < SN, break, end
  end

  % ----- calculate new multipliers -----------
  n1 = length(kmax);         n2 = length(kmin);
  if parity == 1
     G = [ones(n1,m+1); -ones(n2,m+1)] .* cos([cmax;cmin]*[0:m]);
     G(:,1) = G(:,1)/r;
  else
     G = [ones(n1,m); -ones(n2,m)] .* cos([cmax;cmin]*v);
  end
  d  = [u(kmax); -l(kmin)];
  mu = (G*G')\(G*c-d);

  % ----- remove negative multiplier ----------
  [min_mu,K] = min(mu);
  while min_mu < 0
    G(K,:) = []; d(K) = [];
    mu = (G*G')\(G*c-d);
    if K > n1
       kmin(K-n1) = [];
       cmin(K-n1) = [];
       % Amin(K-n1) = [];
       n2 = n2 - 1;
    else
       kmax(K) = [];
       cmax(K) = [];
       % Amax(K) = [];
       n1 = n1 - 1;
    end
    [min_mu,K] = min(mu);
  end

  % ----- determine new coefficients ----------
  a = c-G'*mu;

  if length(ocmax)>0
     oAmax = cos(ocmax*v)*a - tt*a(1);
     [uvo,k1] = max([oAmax-u(okmax); 0]);
  else
     uvo = 0;
  end
  if length(ocmin)>0
     oAmin = cos(ocmin*v)*a - tt*a(1);
     [lvo,k2] = max([l(okmin)-oAmin; 0]);
  else
     lvo = 0;
  end

  it = it + 1;
end

if parity == 1
   h = [a(m+1:-1:2); a(1)*r; a(2:m+1)]/2;
else
   h = [a(m:-1:1); a]/2;
end

figure(1); clf; plot(w/pi,A), 


