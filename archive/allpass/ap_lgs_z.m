function[P_VEKTOR,TAU0,B0,stab,iter,EB] = ap_lgs_z(bw,w,omega,n,tau0,b0,typ)

% function[P_VEKTOR,TAU0,B0] = ap_lgs_z(bw,w,omega,n,tau0,b0,typ)
%
% function computes a discrete time allpass filter with the phase response
% (= negative angle response!!)
% ba(omega) = -arg(Ha(exp(j*omega))    minimizing the  phase error
%
%     eb(omega) = w(omega) * (ba(omega) - tau0*omega + b0 - bw(omega)).
%
% the last three input variables (tau0, b0, typ) are optional:
% input: bw     desired phase response
%        w      weighting function (w=1 -> no weighting)
%        omega  corresponding frequency points
%        n      allpass degree
%        tau0   slope of a desired linear phase
%        b0     phase offset
%        typ    string variable 
%               - typ contains 't' --> function improves tau0; if tau0=0
%                                      is given, function chooses an appro-
%                                      priate value
%               - typ contains 'b' --> function improves b0
%               - typ contains 'i' --> use l_infinity norm (l_2 norm otherwise)
%               - typ contains 'o' --> only one iteration step
% output: P_VEKTOR  allpass denominator coefficients
%         TAU0      optimum value for tau0
%         B0        optimum value for b0
%
% Author: Markus Lang  <lang@jazz.rice.edu>, mar-18-1992
%

% method: iterative weighted solution of an overdetermined system of
%         linear equations.
%
% ref.: Markus Lang, Timo Laakso: "Simple and Robust Design of Allpass
% Filters Using Least-Squares Phase Error Criterion", IEEE CASII, vol 41,
% no. 1, pp 40--48 
%
% subroutines isodd, phapprl2 (for an l2 solution) and karmark, kmk (for a
% chebyshev solution) are required!
%
% Copyright: All software, documentation, and related files in this
%            distribution are Copyright (c) 1992 LNT, University of Erlangen
%            Nuernberg, FRG, 1992 
%
% Permission is granted for use and non-profit distribution providing that this
% notice be clearly maintained. The right to distribute any portion for profit
% or as part of any commercial product is specifically reserved for the author.
%
% Since this program is free of charge we provide absolutely no warranty.
% The entire risk as to the quality and the performance of the program is
% with the user. Should it prove defective, the user user assumes the cost
% of all necessary serrvicing, repair or correction. 

% initialization
error = 1;  iter = 0;  continu = 1;  bound = 25; epsilon = 1e-4;
m = n;  l_p = '  2';  ddo = ' a';  stab = 1;  iter = 0;

if exist('typ') == 1 ;  
  if length(find('i'==typ)) > 0;  l_p = 'inf';  end
  if length(find('t'==typ)) > 0;  m = m + 1;   ddo(1) = 't';  end
  if length(find('b'==typ)) > 0;  m = m + 1;   ddo(2) = 'b';  end
  if length(find('o'==typ)) > 0;  iter = bound;  end
end

if exist('tau0') ~= 1;   tau0 = 0;  end;  TAU0 = tau0;
if exist('b0') ~= 1;   b0 = 0;  end;  B0 = b0;

% column vectors
bw = bw(:);  omega = omega(:);  lom = length(omega);
if length(w) == 1;  w = ones(1,lom);  end;  w = w(:);  

  
% constant matrices
NU_VEKTOR = n:-1:0;  NU_OMEGA = omega * NU_VEKTOR;  
  
% initialize TAU0
if tau0 == 0 & ddo(1) == 't';  TAU0 = (n * pi + bw(1) - bw(lom))/...
                                     (omega(lom)-omega(1));  
% initialize B0
if b0 == 0 & ddo(2) == 'b';
  if omega(lom) == pi & omega(1) ~= 0;    % high pass case
    if isodd(n);  B0 = pi;  end           % B0 = pi for odd n
  end
end

% initialize p
TAU0max = TAU0;  end;
WA_VEKTOR = - B0 + TAU0*omega + bw;
if l_p(1:2) ~= 'in' | (l_p(1:2) == 'in'  &  ddo == ' a');
  P_VEKTOR = phapprl2(omega,WA_VEKTOR,n);
elseif ddo(1) == 't' | ddo(2) == 'b';
  clc;  disp(' find initial solution for l_infinity approximation:');  
  disp(' ');
  [P_VEKTOR,TAU0,B0] = ap_lgs_z(bw, w, omega, n, tau0, b0, ddo);
  WA_VEKTOR = - B0 + TAU0*omega + bw;
  disp(' find solution for l_infinity approximation:');
end
W_VEKTOR = -0.5 * ( n * omega + WA_VEKTOR);

% initialize the column corresponding to DELTATAU
TAUGEWVEKTOR = [];
BGEWVEKTOR = [];
TAU0max = [];
if ddo(1) == 't';
  beta_matrix = -0.5*(cos(NU_OMEGA+W_VEKTOR*ones(1,n+1))*P_VEKTOR');
  TAUGEWVEKTOR = beta_matrix.*omega;
end

% initialize the column corresponding to DELTAB
if ddo(2) == 'b';
  if ddo(1) ~= 't';   
    beta_matrix = -0.5*(cos(NU_OMEGA+W_VEKTOR*ones(1,n+1))*P_VEKTOR');
  end
  BGEWVEKTOR = -beta_matrix;
end

% iteration loop
while continu
  % new weighting
  T_VEKTOR = w./abs(polyval(P_VEKTOR,exp(j*omega)));  
  T_VEKTOR = T_VEKTOR(:);

  % compute matrices for the overdetermined linear system of equations
  GRUNDMATRIX = sin(NU_OMEGA + W_VEKTOR * ones(1,n+1));
  T_MATRIX = T_VEKTOR * [ones(1,m+1) ];
  S_MATRIX = T_MATRIX .* [GRUNDMATRIX, TAUGEWVEKTOR, BGEWVEKTOR];
  U_VEKTOR = - S_MATRIX(:,1);
  S_MATRIX = S_MATRIX(:,2:(m+1));

  % solve with minimum equation error
  if l_p ~= 'inf';
    X_VEKTOR = S_MATRIX\U_VEKTOR;        % l_2 norm
  else 
    X_VEKTOR = kmk(S_MATRIX,U_VEKTOR);   % l_infinity norm
  end
 
  % update
  P_OLD = P_VEKTOR;  P_VEKTOR = [1;X_VEKTOR(1:n,1)]';
  error = max(abs((P_OLD-P_VEKTOR)./P_VEKTOR));
  if ddo == 'ta';  DELTATAU = X_VEKTOR(n+1,1);  end;
  if ddo == ' b';  DELTAB = X_VEKTOR(n+1,1);  end;
  if ddo == 'tb';  
    DELTATAU = X_VEKTOR(n+1,1); DELTAB = X_VEKTOR(n+2,1);  
  end;

  if TAU0 > TAU0max;  TAU0 = TAU0max;  end
  if ddo(1) == 't';  TAU0 = TAU0 + DELTATAU;  end;
  if ddo(2) == 'b';  B0 = B0 + DELTAB;  end;

  WA_VEKTOR = -B0 + TAU0*omega + bw;
  W_VEKTOR = -0.5 * ( n * omega + WA_VEKTOR);
 
  % update for the column corresponding to DELTATAU
  if ddo(1) == 't';
    beta_matrix = -0.5*(cos(NU_OMEGA+W_VEKTOR*ones(1,n+1))*P_VEKTOR');
    TAUGEWVEKTOR = beta_matrix.*omega;
  end

  % update for the column corresponding to DELTAB
  if ddo(2) == 'b';
    if ddo(1) ~= 't';   
      beta_matrix = -0.5*(cos(NU_OMEGA+W_VEKTOR*ones(1,n+1))*P_VEKTOR');
    end
    BGEWVEKTOR = -beta_matrix;
  end

  fprintf('tau0 = %e  B0 = %e  epsilon = %e\n', TAU0, B0, error);
  B0 = angle(exp(j*B0));
  iter = iter + 1;
  if iter > bound | error < epsilon;  continu = 0;  end;
end

% compute correct error function
if ddo(2) == 'b';  B0 = B0 - DELTAB;  end;
if ddo(1) == 't';  TAU0 = TAU0 - DELTATAU;  end;
WA_VEKTOR = -B0 + TAU0*omega + bw;
if ddo(1) == 't' | ddo(2) == 'b';
  P_VEKTOR = ap_lgs_z(bw, w, omega, n, TAU0, B0, l_p);
end;
ALLPASS_PH = -angle(freqz(rot90(P_VEKTOR,2),P_VEKTOR,omega));
EB = angle(exp(j*(ALLPASS_PH-WA_VEKTOR)));

% check stability of the allpass filter
r = roots(P_VEKTOR); 
if max(abs(r)) >= 1-1e-12; clc; disp('allpass filter is not stable <RETURN>'); 
   stab = 0; 
end

% plot results
plot(omega/pi,EB,'.');   %title('phase error');  xlabel('Omega/pi -->');
%ylabel('eb -->')

