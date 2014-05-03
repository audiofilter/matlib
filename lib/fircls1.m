function h = fircls1(n,wo,dp,ds,in5,in6)
%
%	h = fircls1(n,wo,dp,ds)
% 	Constrained Least Square FIR filter design for lowpass
%	and highpass filters.
%
% 	input:
%  		n  : filter length
%  		wo : cut-off frequency in (0,1)
%  		dp : maximum passband deviation from 1
%  		ds : maximum stopband deviation from 0
% 	output:
%  		h  : filter of length n
% 
%	h = fircls1(n,wo,dp,ds,'high') designs a high pass filter
%		(length n must be odd for high pass filter)
%
%	Meeting a passband or stopband edge requirement:
%		h = fircls1(n,wo,dp,ds,wt)
%		h = fircls1(n,wo,dp,ds,wt,'high')
%	If wt is in the passband, then the use of this parameter
% 	ensures that |E(wt)| <= dp where E(w) is the error function.
%	Similarly, if wt is in the stopband, then the use of wt
%	ensures that |E(wt)| <= ds.
%		It should be noted that in the design of very narrow
%	band filters with small dp and ds, there may not exist a
%	filter of the given length that meets these specifications. 
%		
%	EXAMPLE
%		n = 61;
%		wo = 0.3;
%		dp = 0.02; ds = 0.008;
%		h = fircls1(n,wo,dp,ds);
%

%  Author : Ivan Selesnick, Rice University
%  subprograms : local_max.m, frefine.m

PF = 1;                          % flag : Plot Figures (1:plot figs, 0:don't)

% --------- check input paramters ---------

LOW = 0;
HIGH = 1;
pass_type = LOW;
EDGE = 0;

if nargin < 4
	error('You did not supply enough input paramters.')
elseif ( wo <= 0) | ( wo >= 1)
	error('wo must lie between 0 and 1.')
elseif prod([size(n), size(wo), size(dp), size(ds)]) > 1
	error('Each of n, wo, dp, and ds must be a scalar.')
elseif (dp <= 0) | (ds <= 0)
	error('Both dp and ds must be positive.')
elseif nargin == 5
	if isstr(in5)
		if length(in5) == 4
			if in5 == 'high'
				pass_type = HIGH;
			else
				error('You must use the string ''high'' ')
			end
		else
			error('You must use the string ''high'' ')
		end
	else
		wt = in5;
		EDGE = 1;
	end
elseif nargin == 6
	wt = in5;
	EDGE = 1;
	if isstr(in6) & (length(in6) == 4)
		if in6 == 'high'
			pass_type = HIGH;
		else
			error('You must use the string ''high'' ')
		end
	else
		error('You must use the string ''high'' ')
	end
end
PASS = 1;
STOP = 2;
if EDGE
   if prod(size(wt)) > 1
	error('wt must be a scalar')
   elseif (wt <= 0) | (wt >= 1) 
	error('wt must lie between 0 and 1.')
   elseif wt == wo
	error('wt must not equal wo')
   elseif wt < wo
	if pass_type == LOW
		edge_type = PASS;
	else
		edge_type = STOP;
	end
   else
	if pass_type == LOW
		edge_type = STOP;
	else
		edge_type = PASS;
	end
   end
end


if pass_type == LOW
   up = [1+dp  ds]; d1 = dp;
   lo = [1-dp -ds]; d2 = ds;
   mag = [1 0];
else
   up = [ ds 1+dp]; d1 = ds;
   lo = [-ds 1-dp]; d2 = dp;
   mag = [0 1];
end

if rem(n,2) == 1
	parity = 1;
else
	parity = 0;
	if pass_type == HIGH
		error('High pass filters must have ODD lengths.')
	end
end

% --------- start algorithm ---------

wo = wo*pi;
if EDGE, wt = wt*pi; end
L = 2^ceil(log2(5*n));
r = sqrt(2);
w = [0:L]*pi/L;                  % w includes both 0 and pi
q = round(wo*L/pi);
u = [up(1)*ones(q,1); up(2)*ones(L+1-q,1)];
l = [lo(1)*ones(q,1); lo(2)*ones(L+1-q,1)];
if parity  == 1
	m = (n-1)/2;
	c = 2*[wo/r; [sin(wo*[1:m])./[1:m]]']/pi;
	if pass_type == HIGH
		c = -c;
		c(1) = c(1)+r;
	end
	Z = zeros(2*L-n,1);
	v = [0:m];
	tt = 1 - 1/r;
	NP = m+1;	% NP : number of parameters
else
	m = n/2;
        v = [1:m]-1/2;
	% c = [4*((sin(wo*[2*[1:m]-1]/2))./(2*[1:m]-1))/pi]';
        c = [2*sin(wo*v)./(v*pi)]';
	Z = zeros(4*L,1);
	tt = 0;
	NP = m;		% NP : number of parameters
end


a = c;                  % best L2 cosine coefficients
mu = [];                % Lagrange multipliers
SN = 1e-8;              % Small Number
% -------- BEGIN LOOPING --------------
while 1

   % calculate H 
   if parity == 1
      H = fft([a(1)*r; a(2:m+1); Z; a(m+1:-1:2)]); 
      H = real(H(1:L+1)/2);
   else
      Z(2:2:2*m) = a;
      Z(4*L-2*m+2:2:4*L) = a(m:-1:1);
      H = fft(Z);
      H = real(H(1:L+1)/2);
   end

   % find local maxima and minima
   kmax = local_max(H);
   kmin = local_max(-H);
   % if filter length is even, then remove w=pi from constraint set
   if parity == 0
        n1 = length(kmax);
        if kmax(n1) == L+1, kmax(n1) = []; n1 = n1 - 1; end
        n2 = length(kmin);
        if kmin(n2) == L+1, kmin(n2) = []; n2 = n2 - 1; end
   end

   % refine frequencies
   cmax = (kmax-1)*pi/L;      cmin = (kmin-1)*pi/L;
   cmax = frefine(a,v,cmax);  cmin = frefine(a,v,cmin);

   % insert wt into constraint set if neccessary
   if EDGE
   if pass_type == LOW
      if edge_type == PASS
         w_key = max(cmax(cmax<wo));
         if wt > w_key
            kmin = [kmin; 1];
            cmin = [cmin; wt];
         end
      else % edge_type == STOP
         w_key = min(cmin(cmin>wo));
         if wt < w_key
            kmax = [kmax; L];
            cmax = [cmax; wt];
         end
      end
   else % pass_type == HIGH
      if edge_type == PASS
         w_key = min(cmax(cmax>wo));
         if wt < w_key
            kmin = [kmin; L];
            cmin = [cmin; wt];
         end
      else % edge_type == STOP
         w_key = max(cmin(cmin<wo));
         if wt > w_key
            kmax = [kmax; 1];
            cmax = [cmax; wt];
         end
      end
   end
   end

   % evaluate H at refined frequencies
   Hmax = cos(cmax*v)*a - tt*a(1);
   Hmin = cos(cmin*v)*a - tt*a(1);

   % determine new constraint set
   v1   = Hmax > u(kmax)-100*SN;
   v2   = Hmin < l(kmin)+100*SN;
   kmax = kmax(v1); kmin = kmin(v2);
   cmax = cmax(v1); cmin = cmin(v2);
   Hmax = Hmax(v1); Hmin = Hmin(v2);
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
   figure(2)
	subplot(211)
	plot(w/pi,H-mag(1)),
	hold on,
	plot(wv/pi,Hv-mag(1),'o'),
	hold off
	axis([0 wo/pi -2*d1 2*d1])
	subplot(212)
	plot(w/pi,H-mag(2)),
	hold on,
	plot(wv/pi,Hv-mag(2),'o'),
	hold off
	axis([wo/pi 1 -2*d2 2*d2])
   pause(.5)
   end

   % remove a constraint set frequency if neccessary (if otherwise overdetermined)
   if (n1+n2) > NP
        if parity == 1
           H0 =  a(1)/sqrt(2) + sum(a(2:m+1));
           Hpi = a(1)/sqrt(2) + sum(a(3:2:m+1)) - sum(a(2:2:m+1));
           dH0dw = -sum(a(2:m+1)'.*([1:m].^2));
           dHpidw = sum(a(2:2:m+1)'.*([1:2:m].^2)) - sum(a(3:2:m+1)'.*([2:2:m].^2));
           if dH0dw > 0, E0 = lo(1) - H0;
           else, E0 = H0 - up(1); end
           if dHpidw > 0, Epi = lo(2) - Hpi;
           else, Epi = Hpi - up(2); end
        else % parity == 0
		% when length is even, we know that
		%  we must remove w = 0;
		E0 = 0; Epi = 1;
        end
        if E0 > Epi
                % remove w = pi from constraint set
                [temp1, k1] = max(kmin);
                [temp2, k2] = max(kmax);
                if temp1 < temp2
                        % pi is in kmax
                        kmax(k2) = [];
                        cmax(k2) = [];
                        Hmax(k2) = [];
                        n1 = n1 - 1;
                else
                        % pi is in kmin
                        kmin(k1) = [];
                        cmin(k1) = [];
                        Hmin(k1) = [];
                        n2 = n2 - 1;
                end
        else
		% remove w = 0 from constraint set
                [temp1, k1] = min(kmin);
                [temp2, k2] = min(kmax);
                if temp1 < temp2
                        % 0 is in kmin
                        kmin(k1) = []; 
			cmin(k1) = [];
                        Hmin(k1) = [];
                        n2 = n2 - 1;
                else
                        % 0 is in kmax
                        kmax(k2) = [];
                        cmax(k2) = [];
                        Hmax(k2) = [];
                        n1 = n1 - 1;
                end
        end
   end

   % check stopping criterion
   E  = max([Hmax-u(kmax); l(kmin)-Hmin; 0]);
   fprintf(1,'    Bound Violation = %15.13f  \n',E);
   if E < SN
      break
   end

   % calculate new Lagrange multipliers
   if parity == 1
      G = [ones(n1,m+1); -ones(n2,m+1)].*cos([cmax; cmin]*[0:m]);
      G(:,1) = G(:,1)/r;
   else
      G = [ones(n1,m); -ones(n2,m)].*cos([cmax; cmin]*([1:m]-1/2));
   end
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
   a = c-G'*mu;

end

if parity == 1
   h = [a(m+1:-1:2)/2; a(1)/r; a(2:m+1)/2];
else
   h = [a(m:-1:1); a]/2;
end


