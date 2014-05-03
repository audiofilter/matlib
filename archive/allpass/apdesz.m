function [p, tau0, b0, delta] =  apentwz (bw, W, omega, n, tau0, b0, aktion);
%function [p, tau0, b0, delta] = apdesz(bw, W, omega, n, tau0, b0, typ);
%
% function computes a discrete time allpass filter with the phase response
% ba(omega) = arg(Ha(exp(j*omega))    minimizing the  phase error
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
%               - typ contains 'b' --> function improves b0 (for HP or BPn)
% output: p         allpass denominator coefficients
%         tau0      optimum value for tau0
%         b0        optimum value for b0
%         delta     resulting maximum deviation
%
% Author: Markus Lang  <lang@jazz.rice.edu>, mar-18-1992
%

% method: nonlinear Remez-algorithm
%
% ref.: Markus Lang: "Optimal Weighted Phase Equalization according to the 
%       L_oo Norm", EURASIP Signal Processing, vol. 27 (1992), pp87--98. 
%       and
%       M. Lang: "Phase Approximation by Allpass Filters" (in german). PhD
%       thesis. Erlangen, Germany, 1993. 
%
% subroutines getextr and isodd are required!
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                    I N I T I A L I Z A T I O N                             % 
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Startzeit_PRG = cputime;                            % start time of the program
omega = omega(:)';  bw = bw(:)';  W = W(:)';
DLINIE = '  ============================================================================\n';
LINIE  = '  ----------------------------------------------------------------------------\n';
TITEL  = '   AllPass DESign 1.0  *** Approximation of an Allpassphase *** (C) 1992 LNT\n'; 
START  = '\n   DETERMINATION OF AN INITIAL SOLUTION\n'; 
Remez  = '\n   REMEZ - ALGORITHM\n';

clc; fprintf ([DLINIE, TITEL, DLINIE, '\n\n   INITIALIZation . . .\n\n']);
 
flops(0)
N          = length (omega);                      % Zahl der Frequenzstuetzpkte
STOP = 1;                                         % Flags fuer while-Schleifen
RUN  = 0;  

% ml, 31.8.1992
if length(tau0)>1;
  index0 = tau0;
  tau0 = 0;  b0 = 0;
  aktion = 'p';
end
%ml, 31.8.1992

tau0max = tau0;
TP = 1 - sign (omega(1));                         % Tiefpassflag 
if omega(N)==pi & ~TP; HP = 1; else; HP = 0; end  % Hochpassflag

EPSILON = 0.0001;                                 % Abbruchschranke 

Bandbreite = omega(N) - omega(1); 

stab = 1;
ITT = 0;                                          % Iterationsflag - tau0
ITB = 0;                                          % Iterationsflag - b0
SLA = 1;                                          % Startlsg.Alg. freigeben
if (exist('aktion'));                             % Falls 'aktion'-Argument vor-
   if (length (find (aktion == 't')));            %  handen, auswerten ob tau0
      ITT = 1;                                    %  mititeriert werden soll
	  if (tau0 == 0);                             %  und wenn ja gegebenenfalls
	     tau0 = (n*pi - bw(N) + bw(1)) / Bandbreite;   %  Startwert berechen
             tau0max = tau0;
	  end;
	  fprintf ('\n      >>> tau0 is actually iterated !');
   end;
   if length(find (aktion == 'b')) & ~TP;   % auswertung ob b0 mititeriert
     ITB = 1;                               % werden soll (nur ggf. im
  	  fprintf ('\n      >>> b0 is actually iterated !');  %  BP-Fall mititerieren)
     if b0 == 0 & HP & isodd(n);  
        b0 = pi;                             % HP + ungerade --> b0 =pi
     end;    
   end;                                           
   if (length (find (aktion == 'r'))); SLA = 0; end; % Stlsg.Alg unterdruecken
end;

if (TP);                                          % Im Tiefpassfall b0 stets
   b0  = 0;                                       %  null !
end;

if (length(W) == 1);                              % Wichtungsvektor ist skalar?
   W = W * ones(1,length(omega));                 %  -> als konstanten Vektor
end;                                              %     erzeugen

omega0 = omega(1) + (1:n) * Bandbreite	/(n+1);   % Frequenzpunkte an denen der
                                                  %  Fehler null sein soll

% ml, 31.8.1992
index0 = [];                                      % Indizes der Frequenzstuetz-
for x=1:n;                                        %  punkte bestimmen dessen
   index0 = [index0 find((omega(1:length(omega)-1) <= omega0(x)) & ...
                         (omega(2:length(omega))   >  omega0(x)))];
   if (abs(omega(index0(x))-omega0(x)) > (omega(index0(x)+1)-omega0(x)));
      index0(x) = index0(x)+1;                    %  Frequenzen am naechsten
   end;                                           %  zu den geforserten Nst.
end;   	                                          %  liegen
% ml, 31.8.1992

gamma0 = ((n+tau0)*omega(index0) + bw(index0) - b0) / 2;    % Startwerte der 
S = sin (omega(index0)'*(0:(n-1))  -  gamma0'*(ones(1,n))); %  Allpasskoeff. 
b = -sin (n*omega(index0)'- gamma0');                       %  durch be- 
p = [1.0 rot90(S \ b, 3)];                                  %  stimmtes LGS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%   D E T E R M I N A T I O N  O F  I N I T I A L  S O L U T I O N           %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ((ITT | ITB) & (SLA));                         % tau0 und/oder b0 iterieren 
                                                  %  und Stlsg.Alg freigegeben
   Startzeit_SLA = cputime;                         % Startzeit des Stl.-Alg. #
   
   io = find (omega >= ((omega(index0(n))+omega(N))/2)); % Berechnung zusaetz-
   iu = find (omega >= ((omega(1)+omega(index0(1)))/2)); %  licher Nullstellen


   NEWTON = RUN;  
   ks = 0;                                        % Schleifenzaehler 
   
   if (ITT); index0 = [index0 io(1)]; end;        % Indizesvektor der geforder-
   if (ITB); index0 = [iu(1) index0]; end;        %  ten Zahl von Nst. erzeugen
      
   % % % % % % % % % % % % % % % % % % % % % % % %% start of Newton's method
   while (NEWTON == RUN);
      
      if (rem (ks, 6) == 0);                      % Nach jedem 6.Schritt Bild-
         clc; fprintf ([DLINIE, TITEL, DLINIE, START, LINIE]); % schirm loeschen
      end;	                                  % & Titelzeile ausgeben
	 
      ks = ks + 1;                                % Iterationszaehler erhoehen
      fprintf ('   %g. Iteration:', ks);          % Naechsten Schritt melden
 
      gamma0 = ((n+tau0)*omega(index0) + bw(index0) - b0) / 2;
      J      = sin (omega(index0)'*(0:(n-1)) - gamma0'*ones(1,n));
      cossum = (cos (omega(index0)'*(0:n) - gamma0'*ones(1,n+1))) * rot90(p, 1) / (-2);
      f      = (sin (omega(index0)'*(0:n) - gamma0'*ones(1,n+1))) * rot90(p, 1);
      ct     = omega(index0)' .* cossum;
      cb     = - cossum;

      if (ITT) J = [J ct]; end;                   % Jakobimatrix aufstellen
	  if (ITB) J = [J cb]; end;

      da = J \ f;                                  % Aenderung berechnen und
	  p  = [1.0 (p(2:(n+1)) - rot90(da(1:n), 3))]; %  neue Werte berechnen
	  if (ITT); tau0 = tau0 - da(n+1);  end;
	  if (ITB); b0   = b0 - da(n+1+ITT); end;
	  
      fprintf ('\n      Max. change: %2.5f  ***  tau0: %2.5f  ***  b0: %2.5f\n\n',...
	           max (abs (da)), tau0, b0);         % Zwischenergebnis anzeigen

      if ((ks >= 20) | (max (abs (da)) < EPSILON)); % Abbruchkriterium
         NEWTON = STOP;
      end;
      
   end; 
   % % % % % % % % % % % % % % % % % % % % % % % %% Ende des Newton-Verfahren

   Endzeit_SLA = clock;                           % Endzeit der Stl.-Alg. #

end;
if ((ITT | ITB) & (SLA));                         % tau0 und/oder b0 iterieren 
  gamma0 = ((n+tau0)*omega(index0) + bw(index0) - b0) / 2;    % Startwerte der 
  S = sin (omega(index0)'*(0:(n-1))  -  gamma0'*(ones(1,n))); %  Allpasskoeff. 
  b = -sin (n*omega(index0)'- gamma0');                       %  durch ueberbe- 
  p = [1.0 rot90(S \ b, 3)];                                  %  stimmtes GLSyst.
end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                    R E M E Z  -  A L G O R I T H M U S                     %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Startzeit_REM = cputime;                            % Startzeit des Remez-Alg. #

REMEZ = RUN;  % % % % % % % % % % % % % % % % % % % Beginn d. Remez-Algorithmus
delta_alt = 0;                                    % Startwert von delta 
                                                  %  (->Abbruchkrit.)
kr = 0;                                           % Schleifenzaehler init.

while (REMEZ == RUN);

   b0 = angle(exp(i*b0));
   ba = -angle(freqz(rot90(p, 2), p, omega));   % Allpassphase
   ba = ba(:)';
   eb = ba - bw - tau0*omega + b0;                % Phasenfehlerfunktion
   eb = W .* angle (cos(eb)+i*sin(eb));           % unwrappen und wichten
   
   indexi = getextr(eb, 1);                       % Indizes der Extremal-
   if (TP);                                       %  frequenzen bestimmen.Im 
     if indexi(1) == 1;
       indexi(1) = [];                            %  TP-Fall Randextremum bei 
     end
   end;                                           %  omega = 0 entfernen 

   Extrema = length(indexi);                      % Zahl der Extrema
   
   if (rem (kr, 4) == 0);                         % Nach jedem 4. Schritt Bild-
      clc; fprintf ([DLINIE, TITEL, DLINIE, Remez, LINIE]); % schirm loeschen  
   end;                                           %  & Titelzeile ausgeben
   kr = kr + 1;                                   % Iterationszaehler erhoehen
   fprintf ('   %g. Iteration step: ', kr);    % Naechsten Schritt melden
   fprintf ('\n      (The phase error function has %g extremal points)\n', Extrema);
   
   if (kr == 1);                                  % Im ersten Schritt: Median-
      delta  = median (abs(eb(indexi)));          %  wert der Extrema d. Start-
                                                  %  loesungs-Fehlerfkt. best.
      ps    = p;								  % Startwerte des Remez-
      tau0s = tau0;                               %  Algorithmus speichern
      b0s   = b0;
      ebs   = eb;
   end;	  

   % Anzahl der ueberschuessigen Extremalst. best. je nach dem, ob tau0 und/oder
   Ueberschuss = length(indexi) - (n+1) - ITT - ITB; % mititeriert wird

   if Ueberschuss > 3; matrix = .1*eye(n+ITT+ITB);  ebmax = 0;  flopsh = flops;
     disp('Too many extremal points!!!');  stab = 0;  return;  
   end
   if (Ueberschuss == 2)|(Ueberschuss==3);        % Bei 2 oder 3 ueberschuessigen
      mini = find (abs(eb(indexi)) == min(abs(eb(indexi)))); % Extremalfre-
      mini = mini(1);  %ml, 10.8.1992, falls mehrere minima
      if (mini == 1);                             %  quenzen: falls Betrags-
         if abs(eb(indexi(Extrema))) < abs(eb(indexi(2)));
           indexi(Extrema) = [];  indexi(1) = [];
         else
           indexi(1:2) = [];                        %  maessig kleinstes Extremum
         end
      elseif (mini == Extrema);                   %  am Rand, dann die zwei
         if abs(eb(1)) < abs(eb(indexi(Extrema-1))); 
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
   
      
   % % % % % % % % % % % % % % % % % % % % % % % %% Beginn d. Newton-Verfahrens
   l = 0;                                         % Schleifenzaehler;
   
   while (NEWTON == RUN);
      gammai = ((delta*((-1).^(1:length(indexi))))./W(indexi) + ...
               (n+tau0)*omega(indexi) + bw(indexi) - b0) / 2;
      J1     = sin ((omega(indexi))'*(0:(n-1)) - gammai'*ones(1,n));
      cossum = (cos ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1)/(-2);
      f      = (sin ((omega(indexi))'*(0:n) - gammai'*ones(1,n+1))) * rot90(p, 1);
      ct     = omega(indexi)' .* cossum;
      cd     = (((-1).^(1:length (indexi)))./W(indexi))' .* cossum;
      cb     = - cossum;

      J = [J1 cd];                                % Jakobimatrix aufstellen
	  if (ITT) J = [J ct]; end;
	  if (ITB) J = [J cb]; end;

      da           = J(:,1:Extrema) \ f;          % Aenderung berechnen
	  p  = [1.0 (p(2:(n+1)) - rot90(da(1:n), 3))]; 
	  if (Extrema >= (n+1))         delta = delta - da(n+1);  end;
	  if (ITT & (Extrema >= (n+2))) tau0  = tau0  - da(n+2);   end;
	  if (ITB & (Extrema >= (n+2+ITT))) b0 = b0 - da(n+2+ITT); end;

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
       REMEZ = STOP
     end
   else                                           % Falls kein Abbruch alten
      delta_alt = delta;                          %  'delta'-Wert zwischensp.
   end;                                           
   if kr <= 3; REMEZ = RUN; end;             % Zu fruehen Abbruch verhindern

end;  % % % % % % % % % % % % % % % % % % % % % % % Ende des Remez-Algoritmus
flopsh = flops;
Endzeit_REM = clock;                              % Endzeit des Remez-Alg. #

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            %
%                       P O S T P R O C E S S I N G                          %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

om = [(0:(0.01*pi):(omega(1)-(0.01*pi))) omega];  % Neuer Frequenzvektor zur
ba = (-angle (freqz (rot90(p, 2), p, om)));       %  Berechnung der unwrapped-
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

clc;                                              % Ergebnisse des Entwurfs
fprintf ([DLINIE, TITEL, DLINIE, '\n   Results:\n', LINIE]); % ausgeben
fprintf ('\n    Allpass degree : %g', n);
if (exist('ks'));
   SLA_Dauer = Endzeit_SLA -Startzeit_SLA;                    % #
   fprintf ('\n\n    Algorithmus for initial solution: %2g Iterations', ks);
%   fprintf (' %2.2f sec  =  %2.2f sec', SLA_Dauer/ks, SLA_Dauer);   % #
end;
REM_Dauer = Endzeit_REM - Startzeit_REM;                       % #
fprintf ('\n\n    Remez algorithm        : %2g Iterations', kr);
%fprintf (' %2.2f sec  =  %2.2f sec', REM_Dauer/kr, REM_Dauer);      % #
fprintf ('\n\n    delta: %1.2e   ***   tau0: %3.4f   ***   b0: %3.4f', abs(delta), tau0, b0);
if (b00); fprintf (' + (%g*2)', b00); end;
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
