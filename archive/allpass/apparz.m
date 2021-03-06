  function [p, delta, W, eb] =  apentwz (bw, Wb, omega, n, tol, Hw, opt,p)
% function [p, delta, W, eb] =  apentwz (bw, Wb, omega, n, tol, Hw, opt,p)
%
% Design of a discrete allpass filter for implementation of a recursive
% filter using a parallel connection of two allpass filters (e.g. allpass +
% delay). The minimization of the weighted phase error 
%      eb(omega) = W(omega) * (ba(omega) - bw(omega))
% is according to the Chebyshev norm. 
%
% Input:
%    bw     desired phase response in the frequency points omega
%    Wb     phase weighting function in the frequency points omega
%    omega  see bw, W
%    n      allpass degree
%    tol    magnitude tolerances in the frequency points omega; only the
%           quotient tol(1)/tol(omega) is approximated 
%    Hw     desired magnitude response
%    opt    contains 'i'   --> initialization by interpolation
%                "   'u'   -->      "         "  overdetermined system of
%                              linear equations
%    p      : initial values for allpass coefficients (optional)
%    
% Output:
%    p      : allpass denominator coeficients
%    delta  : resulting maximal deviation
%    W      : resulting weighting
%
% subroutines getextr.m and phapprl2.m are necessary



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                    I N I T I A L I Z A T I O N                             % 
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bwc = 0;


Startzeit_PRG = cputime;                            % start time of the program
omega = omega(:)';  bw = bw(:)';  W = Wb(:)';
DLINIE = '  ============================================================================\n';
LINIE  = '  ----------------------------------------------------------------------------\n';
TITEL  = '   AllPass PARallel 1.0  *** Approximation of an Allpassphase *** (C) 1993 LNT\n'; 
START  = '\n   DETERMINATION OF AN INITIAL SOLUTION\n'; 
Remez  = '\n   REMEZ - ALGORITHM\n';

clc; fprintf ([DLINIE, TITEL, DLINIE, '\n\n   INITIALIZation . . .\n\n']);
 
flops(0)
N          = length (omega);                      % Zahl der Frequenzstuetzpkte
STOP = 1;                                         % Flags fuer while-Schleifen
RUN  = 0;  
deltaw = 0;
indh = [];
tau0 = 0;  b0 = 0;  ITT = 0;  ITB = 0;
TP = 1 - sign (omega(1));                         % Tiefpassflag 
if omega(N)==pi ; HP = 1; else; HP = 0; end  % Hochpassflag
  

EPSILON = 0.000001;                                 % Abbruchschranke 

stab = 1;
SLA = 1;                                          % Startlsg.Alg. freigeben
SL = 'u';                                         % Startloes. durch Ueb. LGS

W = Wb; 
if (length(W) == 1);                              % Wichtungsvektor ist skalar?
   W = W * ones(1,length(omega));                 %  -> als konstanten Vektor
end;                                              %     erzeugen
Wnew = ones(1,length(omega));

witer = 0;
if exist('tol');                                  % Betragstoleranzen?
  if sum(diff(tol)) == 0;
    witer = 0;
  else
    witer = 1;
    indHu = find(Hw==1);                            % Index fuer Betrag == 1
    indHm = find(Hw<1 & Hw>0);                      %   "    "     "  Zwischenw.
    indHl = find(Hw==0);                            %   "    "     "    == 0
    WH = tol(1) ./tol;                              % Betragsgewichtsfunktion
    if length(indHm) > 0
      bwc = bw(indHm) - 2*acos(Hw(indHm));
    end
  end
end  

if exist('opt') 
  if length(find(opt=='i')) > 0;  SL = 'i';  end
  if length(find(opt=='u')) > 0;  SL = 'u';  end
end

if exist('p');
  
elseif n > 20 | SL == 'i';
  index0 = floor((1:n)*N/(n+1));
  omega0 = omega(index0);                                     % Frequenzpunkte an denen der
%  bwh = .1*rand(1,n).*cumprod(-ones(1,n))+bw(index0);
%  gamma0 = (n*omega(index0) + bwh) / 2;                % Startwerte der %  
  gamma0 = (n*omega(index0) + bw(index0)) / 2;                % Startwerte der %  
  S = sin (omega(index0)'*(0:(n-1))  -  gamma0'*(ones(1,n))); %  Allpasskoeff. 
  b = -sin (n*omega(index0)'- gamma0');                       %  durch be- 
  p = [1.0 rot90(S \ b, 3)];                                  %  stimmtes LGS
else
  p = phapprl2(omega,bw+tau0*omega-b0,n);                     % ueberbest. LGS 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                    R E M E Z  -  A L G O R I T H M U S                     %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Startzeit_REM = clock;                            % Startzeit des Remez-Alg. #

REMEZ = RUN;  % % % % % % % % % % % % % % % % % % % Beginn d. Remez-Algorithmus
delta_alt = 0;                                    % Startwert von delta 
                                                  %  (->Abbruchkrit.)
kr = 0;                                           % Schleifenzaehler init.
kw = 0;
kr2 = 0;

while (REMEZ == RUN);

   ba = -angle(freqz(rot90(p, 2), p, omega));   % Allpassphase
   ba = ba(:)';
   eb = ba - bw - tau0*omega + b0;                % Phasenfehlerfunktion
   eb = W .* angle (cos(eb)+i*sin(eb));           % unwrappen und wichten
%   plot(omega/pi,eb); 
   indexi = getextr(eb, 1);                       % Indizes der Extrema
   if (TP);                                       
     if indexi(1) == 1;
       indexi(1) = [];                            %  TP-Fall Randextremum bei 
     end
   end;                                           %  omega = 0 entfernen 

   Extrema = length(indexi);                      % Zahl der Extrema

   if (HP);                                       
     if indexi(Extrema) == N;
       indexi(Extrema) = [];                            %  TP-Fall Randextremum bei 
       Extrema = Extrema - 1;
     end
   end;                                           %  omega = 0 entfernen 
   
   if (rem (kr, 4) == 0);                         % Nach jedem 4. Schritt Bild-
      clc; fprintf ([DLINIE, TITEL, DLINIE, Remez, LINIE]); % schirm loeschen  
   end;                                           %  & Titelzeile ausgeben
   kr = kr + 1;                                   % Iterationszaehler erhoehen
   kw = kw + 1;
   fprintf ('   %g. Iteration step: ', kr);    % Naechsten Schritt melden
   fprintf ('\n      (The phase error function has %g extremal points)\n', Extrema);
   
   if (kr == 1);                                  % Im ersten Schritt: Median-
       dummy = sort(abs(eb(indexi))./W(indexi));  % finde die n+1-kleinste 
       if Extrema == n 
         delta = median(abs(eb(indexi)));
       else
         delta = abs(dummy(Extrema-n));             % Extremalstelle,ml, 30.10.1992
       end
      delta = - delta * sign(eb(indexi(1)));                                            %  loesungs-Fehlerfkt. best.

%      delta  = median (abs(eb(indexi)));          %  wert der Extrema d. Start-
      ps    = p;								  % Startwerte des Remez-
      tau0s = tau0;                               %  Algorithmus speichern
      b0s   = b0;
      ebs   = eb;
   end;	  

   % finde Extremalstellen > delta mit alternierendem VZ, ml, 30.10.1992
   indext = find(abs(abs(eb(indexi))-abs(delta))< -1e-8);  indexs = indexi;
   indexi(indext) = [];  
   indexs = getextr(eb(indexi),1);  indexi = indexi(indexs);
   Extrema = length(indexi);


   % Anzahl der ueberschuessigen Extremalst. best. je nach dem, ob tau0 und/oder
   Ueberschuss = length(indexi) - (n+1) - ITT - ITB; % mititeriert wird

   if Ueberschuss > 3; matrix = .1*eye(n+ITT+ITB);  ebmax = 0;  flopsh = flops;
     disp('zuviele Extremalstellen!!!');  stab = 0;  return;  
   end
 
   if (Ueberschuss == 2)|(Ueberschuss==3);        % Bei zwei oder 3 ueberschuessigen
      mini = find (abs(eb(indexi)) == min(abs(eb(indexi)))); % Extremalfre-
      mini = mini(1);  %ml, 10.8.1992, falls mehrere minima
      if (mini == 1);                             %  quenzen: falls Betrags-
         if abs(eb(indexi(Extrema))) < abs(eb(indexi(2)));
           indexi(Extrema) = [];  indexi(1) = [];
         else
           indexi(1:2) = [];                        %  maessig kleinstes Extremum
         end
      elseif (mini == Extrema);                   %  am Rand, dann die zwei
         if abs(eb(indexi(1))) < abs(eb(indexi(Extrema-1))); 
           indexi(Extrema) = [];  indexi(1) = []; %  maessig kleinstes Extremum
         else
           indexi(Extrema-1:Extrema) = [];        %  auessersten Extrema entfernen
         end
      elseif (abs(eb(indexi(mini-1))) <= abs(eb(indexi(mini+1)))); % sonst das 
         indexi(mini-1:mini) = [];               %  kleinste und dessen  Nach-
      else                                        %  barextremum mit dem klei-
         indexi (mini:mini+1) = [];               %  neren Betrag entfernen
      end;
      Extrema = Extrema - 2;
	  Ueberschuss = Ueberschuss - 2;
   end;
   if (Ueberschuss >= 1);                         % Bei einer ueberschuessigen 
      if (abs(eb(indexi(1))) <= abs(eb(indexi(Extrema))));  % Extremalfrequenz 
         indexi(1) = [];                          %  Betragsmaessig kleineres
      else                                        %  Randextremum entfernen
         indexi(Extrema) = [];
      end;
      Extrema = Extrema - 1;
	  Ueberschuss = Ueberschuss - 1;
   end;  
   if (Ueberschuss > 0) | (Ueberschuss < -ITT-ITB-1)  % Programm abbrechen, falls
      dm = 0;  ebmax = 0; return                      %  immer noch zu viele
   else                                               %  Extremalstellen vorhanden
     NEWTON = RUN;
   end;	  	  

%   plot(omega/pi,eb); 
  
   % % % % % % % % % % % % % % % % % % % % % % % %% Beginn d. Newton-Verfahrens
   l = 0;                                         % Schleifenzaehler;
   
   while (NEWTON == RUN);

      % Aufstellen der Matrizen und Vektoren zur Loesung des Gleichungssystems
      %              f (i,a(k)) = 0   fuer i = 1 (1) Extrema
      % mit Hilfe des Newton - Verfahrens :
      %              a(k+1) = a(k) - J(a(k))^(-1) * f(a(k))
      % wobei:   a    = [p(0) .. p(n-1) <delta> <tau0> <b0>]
      %          J(a) = [df/dp(0) .. df/dp(n-1) <df/delta> <df/dta0> <df/db0>]
      %               = [         J1               <cd>      <ct>      <cb>  ]

      gammai = ((delta*((-1).^(1:length(indexi))))./W(indexi) + ...
               (n+tau0)*omega(indexi) + bw(indexi) - b0) / 2;
      J1     = sin ((omega(indexi))'*(0:(n-1)) - gammai'*ones(1,n));
      f      = (sin ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1);
      cossum = (cos ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1)/(-2);
      cd     = (((-1).^(1:length (indexi)))./W(indexi))' .* cossum;

      J = [J1 cd];                                % Jakobimatrix aufstellen

      da           = J(:,1:Extrema) \ f;          % Aenderung berechnen
  	  p  = [1.0 (p(2:(n+1)) - rot90(da(1:n), 3))]; 
	    if (Extrema >= (n+1))         delta = delta - da(n+1);  end;
 %    delta mod 2pi, falls wert groesser als 2pi und W=const
      if sum(diff(W))==0; delta = rem(delta,2*pi); end
      l = l+1;                                    % Schleifenzaehler erhoehen
      if ((l == 20) | (max (abs (da)) < EPSILON));% Abbruchkriterium fuer
         NEWTON = STOP;                           %  das Newton-Verfahren
      end;	 
   end; 
   % % % % % % % % % % % % % % % % % % % % % % % % % Ende Newton-Verfahrens

   
   ddelta = abs(1 - delta_alt/delta);             % Rel. Aenderung berechnen 
   fprintf ('\n      delta: %1.2e  ***  tau0: %3.4f  ***  b0: %3.4f', abs(delta), tau0, b0);
   fprintf ('\n      Relative change of delta: %2.6f\n\n', ddelta);
   
   
   if (kr >= 15) ;                                % Abbruchkriterium des 
      REMEZ = STOP;                               %  Remez-Algorithmus
   elseif (ddelta<EPSILON)
     maxeb = max(abs(eb));
     if abs(maxeb-abs(delta))/maxeb<10*EPSILON
       REMEZ = STOP;
     end
   else                                           % Falls kein Abbruch alten
      delta_alt = delta;                          %  'delta'-Wert zwischensp.
   end;                                           
   if kr <= 3; REMEZ = RUN; end;             % Zu fruehen Abbruch verhindern
   
%  Adaption of weighting, if prescribed deviations for magnitude 
   if REMEZ == STOP & witer 
     weps = abs(1 - abs(deltaw/delta)); deltaw = delta;
     kr2 = kr2 + 1; 
%     if (kr2 > 30) | ((kr2 > 3) & kr == 4); REMEZ = STOP; 
     if (kr2 > 30) | (weps < EPSILON); REMEZ = STOP; 
     else
       REMEZ = RUN; kr = 3; 
     end
%    new weighting in stopband
     Wold = W;

%    passband of H1
     Wnew(indHu) = abs(sqrt(48*WH(indHu)./(48+(W(indHu).^(-2)-1)*delta)));
%    band of H1 between 1 and 0
     deltam = tol(indHm)*(1-cos(eb(indexi(1))/2))/tol(indexi(1));
     bw(indHm) = bwc + acos(Hw(indHm)-deltam/2)+acos(Hw(indHm)+deltam/2);
     Wnew(indHm) = abs(1*192*sin(bw(indHm)).*WH(indHm)./...
                  (48*delta+delta^3*(2*W(indHm).^(-2)-1)));
%    stopband of H1
     Wnew(indHl) = abs(192*WH(indHl)./(48*delta+delta^3*(2*W(indHl).^(-2)-1)));
     indH = [indHu indHm indHl];
     Wchange = (Wnew(indH)./W(indH));
     W(indH) = Wnew(indH);
     indg = find((Wchange) > 10);                        % avoid too large 
     W(indH(indg)) = Wold(indH(indg))*10;              % increase
     indl = find(Wchange < .1);                          % avoid too large
     W(indH(indl)) = Wold(indH(indl))/10;              % decrease

   end
end;  % % % % % % % % % % % % % % % % % % % % % % % Ende des Remez-Algoritmus
flopsh = flops;
Endzeit_REM = clock;                              % Endzeit des Remez-Alg. #

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                         A U S W E R T U N G                                %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gammai = ((delta*((-1).^(1:length(indexi))))./W(indexi) + ...
         (n+tau0)*omega(indexi) + bw(indexi) - b0) / 2;
matrix = exp(-j* gammai'*ones(1,n)) .* exp(j*((omega(indexi))'*(0:(n-1))));
f      = (sin ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1);
      cossum = (cos ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1)/(-2);
cd     = (((-1).^(1:length (indexi)))./W(indexi))' .* cossum;

om = [(0:(0.01*pi):(omega(1)-(0.01*pi))) omega];  % Neuer Frequenzvektor zur
ba = (-angle (freqz (rot90(p, 2), p, om)));%  Berechnung der unwrapped-
ba = ba(:)';
ba = ba(find (om >= omega(1)));                   %  Allpassphase
eb = ba - bw - tau0*omega + b0;                   % Phasenfehlerfunktion
eb = angle(exp(j*eb));
b00 = round (-mean(eb) / (2*pi));                 % Zusaetzlichen Offset best.
eb = W .* (eb + b00*(2*pi));                      % Fehlerfunktion korrigieren
                                                  %  und wichten
ebmax = max(abs(eb));
indexi = getextr(eb, 1);                          % Indizes der  Extremalfreq.
if (sign (omega(1)) == 0);                        % Im Tiefpassfall:
   indexi(1) = [];                                %   Randextremum bei 
end;                                              %   omega = 0 entfernen
Extrema = length (indexi);                        % Zahl der Extrema
%delta = max (abs (eb(indexi)));                   % Max. Approximationsfehler


clc;                                              % Ergebnisse des Entwurfs
fprintf ([DLINIE, TITEL, DLINIE, '\n   Results:\n', LINIE]); % ausgeben
fprintf ('\n    Allpass degree : %g', n);
REM_Dauer = Endzeit_REM - Startzeit_REM;                       % #
fprintf ('\n\n    delta: %1.2e', abs(delta));
fprintf ('\n\n    The phase error function has  %g extremal points.', Extrema);

maxroots = max (abs ( roots (ps)));               % Stabilitaetstest der Start-
fprintf ('\n\n    ==> The initial allpass of degree  %g was ', n); % loesung
if (maxroots >= 1);                                %  Betragsgroesste Nst. des
   fprintf ('NOT stable !!!');                  %  Allpasss-Nennerpolynoms 
else   
   fprintf ('stable.');
end;

maxroots = max (abs ( roots (p)));                % Stabilitaetstest der Opt.-
fprintf ('\n\n    ==> The designed allpass of degree %g is ', n); % loesung
if (maxroots > .99);                                %  Betragsgroesste Nst. des
   fprintf ('NOT stable !!!');                  %  Allpasss-Nennerpolynoms 
    stab = 0;
else   
   fprintf ('stable.');
end;

indexi = getextr(eb,1);  ind = find(eb(indexi)==0);  indexi(ind) = [];
maxi = max(abs(eb(indexi)));  mini = min(abs(eb(indexi)));
vari = abs(maxi-mini)/mini;
if length(indexi) < n+1+ITT+ITB
%  fprintf ('\n\n    No optimal solution since length of alternante < %g',...
%  n+ITB+ITT+1);
elseif vari > EPSILON
  fprintf(['\n\n    Caution, large relative differences between ' ...
          ' extrema (%10.5e)!!'],vari);
end

end;    

delta = abs (delta);

plot (omega/pi, eb, omega/pi, zeros(1,length(eb)));
xlabel ('omega/pi  ->'); ylabel ('eb (omega)  ->'); % Phasenfehlerfunktion
title ('Phase error');                             %  grafisch darstellen
Dauer_PRG = cputime - Startzeit_PRG;            % Dauer des Programms #
fprintf ('\n\n    * Used cpu time: %2.2f sec\n', Dauer_PRG);
