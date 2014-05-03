% ##############################################################################
% ##  make_trellis.m: m_file zur Erzeugung des Trellis-Diagramms              ##
% ##############################################################################
%
% Syntax:  [trellis] = make_trellis(g,rek)
%  benoetigt:
%  communication toolbox: de2bi.m, bi2de.m
%--------------------------------------------------------------------------
% Eingabeparameter:
%          g:   Generatormatrix in binaerer oder dezimaler Form
%               Bsp. g = [ 1 1 1
%                          1 0 1 ];
%                    entspricht
%                    g = [7;5];
%          rek: rek=0 zeigt NSC-Code an,
%               rek>0 RSC-Code mit g(rek,:) als rekursives Polynom
%
% Ausgabeparameter:
%          trellis.next: Matrix, jede Zeile repraesentiert einen Zustand
%                        erste Spalte enthaelt Folgezustaende fuer Infobit=0
%                        zweite Spalte enthaelt Folgezustaende fuer Infobit=1
%          trellis.pre:  Matrix, jede Zeile repraesentiert Vorgaenger
%                        eines Zustandes
%          trellis.out:  gleiche Anordnung wie trellis_next,
%                        enthaelt Ausgangswerte als Dezimalzahlen (2 = [0 1])
%
%
function trellis = make_trellis(g,rek)

[n,K]     = size(g);

if (K == 1)                               % dezimale Darstellung
  K = ceil(log2(max(g)));                 % Ermitteln der Einflusslaenge
  g = de2bi(g,K);                         % Konvertierung in binaere Darstellung
end

m         = K - 1;
anz_states = 2^m;

if rek>0                                  % RSC-Code
  vrek = g(rek,:);
  g(rek,:) = [];
end

%--------------------------------------------------------------------------
% Konstruktion des Trellisdiagramms
%--------------------------------------------------------------------------
trellis.out  = zeros(anz_states,2);
trellis.next = zeros(anz_states,2);
trellis.pre  = zeros(anz_states,2);

for state=1:anz_states
  vstate = de2bi( state-1, m );

  vstate = [0 vstate]';                       % Uebergang fuer Infobit d=0
  if rek>0
    vstate(1) = rem(vrek*vstate,2);           % Berechne Wert der Rueckkopplung
    out       = [0 rem(g*vstate,2)];          % Ausgangswort berechnen
  else
    out       = [rem(g*vstate,2)]';           % Ausgangswort berechnen
  end
  trellis.out(state,1)  = bi2de(out);         % dezimale Darstellung abspeichern
  trellis.next(state,1) = bi2de(vstate(1:m)');% Folgezustand bestimmen

  vstate(1) = 1;                              % Uebergang fuer Infobit d=1
  if rek>0
    vstate(1) = rem(vrek*vstate,2);           % Berechne Wert der Rueckkopplung
    out       = [1 rem(g*vstate,2)];          % Ausgangswert berechnen
  else
    out       = [rem(g*vstate,2)]';           % Ausgangswert berechnen
  end
  trellis.out(state,2)  = bi2de(out);         % dezimale Darstellung abspeichern
  trellis.next(state,2) = bi2de(vstate(1:m)');% Folgezustand bestimmen
end

for state=1:anz_states
  [pre_states,info]    = find(trellis.next==state-1);
  trellis.pre(state,:) = pre_states' - 1;
end

% ### EOF ######################################################################
